Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931Ab2FVBpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 21:45:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760911Ab2FVBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 21:44:59 -0400
Date: Thu, 21 Jun 2012 18:45:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 3.5-rc3] mm, mempolicy: fix mbind() to do synchronous
 migration
Message-Id: <20120621184536.6dd97746.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFzPXMD3N3Oy-om6utDCQYmrBDnDgdqpVC5cgKe-v6uZ3w@mail.gmail.com>
References: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com>
	<20120621164606.4ae1a71d.akpm@linux-foundation.org>
	<CA+55aFzPXMD3N3Oy-om6utDCQYmrBDnDgdqpVC5cgKe-v6uZ3w@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 17:46:52 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jun 21, 2012 at 4:46 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > I can't really do anything with this patch - it's a bug added by
> > Peter's "mm/mpol: Simplify do_mbind()" and added to linux-next via one
> > of Ingo's trees.
> >
> > And I can't cleanly take the patch over as it's all bound up with the
> > other changes for sched/numa balancing.
> 
> I took the patch, it looked obviously correct (passing in a boolean
> was clearly crap).

Ah, OK, the bug was actually "retained" by "mm/mpol: Simplify do_mbind()".

I do still ask what the plans are for that patchset..

> I wonder if I should make sparse warn about any casts to/from enums.
> They tend to always be wrong.

I think it would be worth trying, see how much fallout there is.  Also
casts from "enum a" to "enum b".  We've had a few of those,
unintentionally.

And casts to/from bool, perhaps.  To squish the warning we'd do things
like a_bool = !!a_int.  That generates extra code, but gcc internally
generates extra code for a_bool = a_int anyway, and a quick test here
indicates that the generated code is identical (testl/setne).

It would be nice to find a way of converting an integer which is known
to be 1 or 0 into a bool without generating any code, but I haven't
found a way of tricking the compiler into doing that.  It's all a bit
of a downside to using bool at all.
