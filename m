Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1FDDyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 23:54:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab1FDDyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 23:54:31 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=UdQhNBrHRs4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=05HgdSqNbJUaxQvjLWEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] mm: Fix wrong kunmap_atomic() pointer
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1307158665.3667.86.camel@gandalf.stny.rr.com>
References: <1307158665.3667.86.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Jun 2011 23:54:29 -0400
Message-ID: <1307159669.31814.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 23:37 -0400, Steven Rostedt wrote:

> The problem came in d16dfc55 where it introduced a "break;" from the
> while loop. This alone did not seem to easily trigger the bug. But the
> modifications made by e303297e6 caused that "break;" to be hit on the
> first iteration, before the pte++.
> 
> The pte not being incremented will now cause pte_unmap_unlock(pte - 1)
> to be pointing to the previous page. This will cause the wrong page to
> be unmapped, and also trigger the warning above.

Note, just to prove this was the case, by adding a few trace_printks()
and a tracing_off() when the bug hit, I found the following:

           <...>-93    [000]    65.630994: unmap_vmas: enter addr=0xa00000 end=0xa53000
           <...>-93    [000]    65.630995: unmap_vmas: pte=fffb9000
           <...>-93    [000]    65.630996: unmap_vmas: loop pte=fffb9000 addr=0xa00000
           <...>-93    [000]    65.630996: unmap_vmas: force flush!
           <...>-93    [000]    65.630997: unmap_vmas: end loop pte=fffb9000
           <...>-93    [000]    65.630997: unmap_vmas: unlock pte-1=fffb8ff8

-- Steve

