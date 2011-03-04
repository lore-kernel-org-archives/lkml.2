Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab1CDOVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:21:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64903 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab1CDOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tU/xYH+2aqYNjhfuztrAD1q0wDLOFZRFlH+LXDcDW1EL+gfL+5HQP0H0kdw7nv/Rhm
         bj+1c5JaCewYGDFU3ZWH+JsN28RZx85Nkvjl46gnI6zvslwIRJiegFdwCwkX1l7BooRY
         reGsjuLgsKZnpoRpm19dnsXmVMD02z0tK8PX0=
Date: Fri, 4 Mar 2011 15:21:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: clean the options for perf record
Message-ID: <20110304142113.GC1972@nowhere>
References: <1298389415.2217.243.camel@twins>
 <20110222182206.GB1799@nowhere>
 <4D648A65.2040107@dcl.info.waseda.ac.jp>
 <4D667D60.5010903@dcl.info.waseda.ac.jp>
 <20110224165014.GB1840@nowhere>
 <4D67E286.8010907@dcl.info.waseda.ac.jp>
 <AANLkTikUGO=Obm7Ue4VzEueQ7DERPiwci1VV9NmKZf1u@mail.gmail.com>
 <4D70B3E1.8020108@dcl.info.waseda.ac.jp>
 <20110304135635.GB1972@nowhere>
 <1299247099.24454.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299247099.24454.3.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 02:58:19PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-03-04 at 14:56 +0100, Frederic Weisbecker wrote:
> > lockstat is a global measurement since the boot.
> 
> You can reset lockstat at any given time.

Event though, that's still a global profiling. You can't have a per
process or thread granularity.

Or even more precise context for some future feature in perf that
I have in mind and would like to implement soon, like counting/sampling
an event only between two others. More exactly having two lists for
each event:

* activate
* deactivate

Those on the first list activate the target event when they overflow. (->start() )
Those on the second list deactivate .... (->stop() )

With events in activate and deactivate in the same context than the target,
locking and permissions should be kept simple. Locking especially shouldn't be
needed in the fast path. Then if that's needed we could think about a cross
context things later.

Plus an attr->start_state that decides if the first ->add() made is made
with PERF_EF_STAT or not. (We then need to keep track of some activated/deactivated
state across schedules).

That's in fact the exclude_irq and exclude_softirq idea extended to any kind
of existing event.
