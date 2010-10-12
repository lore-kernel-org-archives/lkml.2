Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0JLKDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:03:04 -0400
Received: from ifrit.dereferenced.org ([66.212.21.15]:55171 "EHLO
	ifrit.dereferenced.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab0JLKDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:03:02 -0400
Date: Tue, 12 Oct 2010 14:02:56 +0400 (MSD)
From: William Pitcock <nenolod@dereferenced.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Message-ID: <87939.1771286877776896.JavaMail.root@ifrit.dereferenced.org>
In-Reply-To: <31330936.1751286877737150.JavaMail.root@ifrit.dereferenced.org>
Subject: Re: [PATCH try 3] CFS: Add hierarchical tree-based penalty.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.202.104.35]
X-Mailer: Zimbra 6.0.0_BETA2_1547.UBUNTU8 (ZimbraWebClient - FF3.0 (Linux)/6.0.0_BETA2_1547.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- "Peter Zijlstra" <peterz@infradead.org> wrote:

> On Tue, 2010-10-12 at 13:34 +0400, William Pitcock wrote:
> > Yes, this should be a multiplication I believe, not a divide.  My
> original
> > code had this as a multiplication, not a division, as does the new
> patch.
> > 
> > However, I think:
> > 
> >     vruntime >>= tsk->fork_depth;
> > 
> > would do the job just as well and be faster. 
> 
> That's still somewhat iffy as explained, vruntime is the absolute
> service level, multiplying that by 2 (or even more) will utterly
> upset
> things.
> 

Yes, this is why I thought that doing a division would be better.

> Imagine two runnable tasks of weight 1, say both have a vruntime of 3
> million, seconds (there being two, vruntime will advance at 1/2
> wall-time).
> 
> Now, suppose you wake a third, it too had a vruntime of around 3
> million
> seconds (it only slept for a little while), if you then multiply that
> with 2 and place it at 6 mil, it will have to wait for 6 mil seconds
> before it gets serviced (twice the time of the 3 mil difference in
> service time between this new and the old tasks).
> 
> So, theory says the fair thing to do is place new tasks at the
> weighted
> average of the existing tasks, but computing that is expensive, so
> what
> we do is place it somewhere near the leftmost task in the tree.
> 
> Now, you don't want to push it out too far to the right, otherwise we
> get starvation issues and people get upset.
> 
> So you have to somehow determine a window in which you want to place
> this task and then vary in that depending on your fork_depth.
> 
> Simply manipulating the absolute service levels like you propose
> isn't
> going to work.

I think I have a solution to this.  Presently waiting on a kernel rebuild
on my laptop so I can test.

William
