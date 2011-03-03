Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1CCR36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:29:58 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:31005 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab1CCR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:29:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG9eb02rRN+J/2dsb2JhbACmZXSiUpwfhWEEhRqHEoNC
X-IronPort-AV: E=Sophos;i="4.62,259,1297036800"; 
   d="scan'208";a="411954728"
Message-ID: <4D6FD027.3080704@cisco.com>
Date: Thu, 03 Mar 2011 10:30:15 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/3] perf script: dump software events and samples from
 hardware-based profiling
References: <1299086960-26964-1-git-send-email-daahern@cisco.com> <1299086960-26964-4-git-send-email-daahern@cisco.com> <20110303030515.GD1946@nowhere> <4D6FA39A.60203@cisco.com> <20110303171940.GC1807@nowhere>
In-Reply-To: <20110303171940.GC1807@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/03/11 10:19, Frederic Weisbecker wrote:
> On Thu, Mar 03, 2011 at 07:20:10AM -0700, David Ahern wrote:
>> On 03/02/2011 08:05 PM, Frederic Weisbecker wrote:
>>> Hmm, that's a wrong way of walking through callchains. In fact it's not
>>> a classical list. node->next can be a ghost entry from a previous callchain
>>> that we kept cached in order to optimize allocations.
>>>
>>> You need the accessors callchain_cursor_current() and callchain_cursor_advance().
>>
>> Ok. I'll look at perf-report's callchain_append again.
> 
> Yeah callchain_append() is too much a generic name for something actually
> rather specific. In fact callchain_append() adds a callchain, already
> resolved, to a histogram in order to produce that statistical tree in the end
> that you can have with perf report.
> 
> But you don't need those statistical tree of callchains, it's only used
> by perf report for now. Instead you rather need to treat every callchains
> individually and print each of them.
> 
> So you don't even need callchain_append(). All you need in the end is

Right, just using that as an example of how callchains are handled.

> to use perf_session__resolve_callchain() that resolves the raw struct ip_callchain
> (only made of raw ips) into a cursor (list of ips resolved into symbols and so) and
> walk through the cursor with the two accessors.
> 
> Ah I forgot, you first need to use callchain_cursor_commit() in order to initialize
> the position in the cursor.
> 
> So:
> 
> 1) Resolve with perf_session__resolve_callchain()
> 2) commit with callchain_cursor_commit()
> 3) iterate with callchain_cursor_current(), callchain_cursor_advance()

yes, I figured out the missing commit, and I changed the loop to:
while (1) {
    node = callchain_cursor_current(cursor);
    if (!node)
        break;

      ... (print chain)

    callchain_cursor_advance(cursor);
}

Thanks for the comments.

What about the python and perl engines? Right now they are tracepoint
specific. I do not have a sufficient background in either to expand to
other sample types.

David

> 
> Thanks.
