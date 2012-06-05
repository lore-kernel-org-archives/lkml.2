Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2FERf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:35:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2FERf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:35:26 -0400
Message-ID: <1338917712.2749.24.camel@twins>
Subject: Re: git bisect and perf
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 05 Jun 2012 19:35:12 +0200
In-Reply-To: <4FCE3DE3.9060805@gmail.com>
References: <4FCE25C6.2080601@gmail.com> <1338912052.2749.2.camel@twins>
	 <1338912312.2749.6.camel@twins> <4FCE3DE3.9060805@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 11:12 -0600, David Ahern wrote:
> On 6/5/12 10:05 AM, Peter Zijlstra wrote:
> > On Tue, 2012-06-05 at 18:00 +0200, Peter Zijlstra wrote:
> >> On Tue, 2012-06-05 at 09:29 -0600, David Ahern wrote:
> >>> I am trying find out when (ie. which commit) the pebs feature
> >>> actually
> >>> started working on a westmere system
> >>
> >> What do you mean with working? The whole cycles:pp thing is magic and
> >> unrelated to 'regular' PEBS stuff.
> 
> :p requires PEBS?

On Intel it does.. On AMD you want IBS for that.

Note that on Intel there's a difference between :p and :pp.

>From perf_event_attr:

        /*
         * precise_ip:
         *
         *  0 - SAMPLE_IP can have arbitrary skid
         *  1 - SAMPLE_IP must have constant skid
         *  2 - SAMPLE_IP requested to have 0 skid
         *  3 - SAMPLE_IP must have 0 skid
         *
         *  See also PERF_RECORD_MISC_EXACT_IP
         */
        precise_ip     :  2, /* skid constraint       */

So 0 being the default (no :p) we use the regular PMI and provide the IP
from the spot that served the exception. This can be a few instructions
_after_ the instruction that triggered the event overflow.

1 (:p) means constant skid, for Intel this maps to regular PEBS and
returns the IP as provided by the PEBS record. This is one instruction
after the instruction that caused the event overflow (because the PEBS
hardware assist triggers when we're executing the instruction that
triggered it, it needs to have already fetched the instruction and
incremented the IP etc..).

2 (:pp) requests 0 skid, since PEBS provides IP + 1 instruction, we need
to rewind the instruction stream. In order to do this we use the LBR in
conjunction with a FREEZE_LBR_ON_PMI feature from DEBUG_CTL and limit
the PEBS buffer to a single entry. So when we get the PEBS buffer full
PMI, we read the LBR, find the start of the most recent basic block (to
address of the last branch) and decode the instruction stream until we
find the current IP. Then we know the IP that caused it is the previous
one. Tada!

We set the PERF_RECORD_MISC_EXACT_IP bit when the rewind worked and we
can guarantee 0 skid (+- hardware bugs, of which there are a few).

3 (:ppp) would require 0 skid, but since the unwind using LBR isn't a
guaranteed thing we don't implement this for Intel (or anybody else for
that matter afaik).


Now not all events the Intel PMU can do are PEBS capable; in fact most
aren't. So the whole cycles thing is about mapping the regular cycles
event to something that is PEBS capable.


