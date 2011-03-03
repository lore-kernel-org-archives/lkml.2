Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab1CCRWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:22:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46157 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503Ab1CCRWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ElJIELp0/xs4YEcXiXd3nKZ8saBwPjndyd0i5clfuQRBOX7QzIu7gQf6dSOQQD09Su
         7qUqN3bb5FoGw+lOzgUCqMz4ySxCSrr4otWh8Lpx01eyycY47sFJaGFE6uyJrbAAe4nl
         Y5GuIK7dqWV+RQOn+cdvX415ooLSAISKTNX58=
Date: Thu, 3 Mar 2011 18:19:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/3] perf script: dump software events and samples from
 hardware-based profiling
Message-ID: <20110303171940.GC1807@nowhere>
References: <1299086960-26964-1-git-send-email-daahern@cisco.com>
 <1299086960-26964-4-git-send-email-daahern@cisco.com>
 <20110303030515.GD1946@nowhere>
 <4D6FA39A.60203@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6FA39A.60203@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 07:20:10AM -0700, David Ahern wrote:
> On 03/02/2011 08:05 PM, Frederic Weisbecker wrote:
> > Hmm, that's a wrong way of walking through callchains. In fact it's not
> > a classical list. node->next can be a ghost entry from a previous callchain
> > that we kept cached in order to optimize allocations.
> > 
> > You need the accessors callchain_cursor_current() and callchain_cursor_advance().
> 
> Ok. I'll look at perf-report's callchain_append again.

Yeah callchain_append() is too much a generic name for something actually
rather specific. In fact callchain_append() adds a callchain, already
resolved, to a histogram in order to produce that statistical tree in the end
that you can have with perf report.

But you don't need those statistical tree of callchains, it's only used
by perf report for now. Instead you rather need to treat every callchains
individually and print each of them.

So you don't even need callchain_append(). All you need in the end is
to use perf_session__resolve_callchain() that resolves the raw struct ip_callchain
(only made of raw ips) into a cursor (list of ips resolved into symbols and so) and
walk through the cursor with the two accessors.

Ah I forgot, you first need to use callchain_cursor_commit() in order to initialize
the position in the cursor.

So:

1) Resolve with perf_session__resolve_callchain()
2) commit with callchain_cursor_commit()
3) iterate with callchain_cursor_current(), callchain_cursor_advance()

Thanks.
