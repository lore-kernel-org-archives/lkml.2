Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0JLJrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:47:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:49848 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab0JLJrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:47:04 -0400
Subject: Re: [PATCH try 3] CFS: Add hierarchical tree-based penalty.
From: Peter Zijlstra <peterz@infradead.org>
To: William Pitcock <nenolod@dereferenced.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <3040100.1691286876066434.JavaMail.root@ifrit.dereferenced.org>
References: <3040100.1691286876066434.JavaMail.root@ifrit.dereferenced.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 11:46:57 +0200
Message-ID: <1286876817.29097.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 13:34 +0400, William Pitcock wrote:
> Yes, this should be a multiplication I believe, not a divide.  My original
> code had this as a multiplication, not a division, as does the new patch.
> 
> However, I think:
> 
>     vruntime >>= tsk->fork_depth;
> 
> would do the job just as well and be faster. 

That's still somewhat iffy as explained, vruntime is the absolute
service level, multiplying that by 2 (or even more) will utterly upset
things.

Imagine two runnable tasks of weight 1, say both have a vruntime of 3
million, seconds (there being two, vruntime will advance at 1/2
wall-time).

Now, suppose you wake a third, it too had a vruntime of around 3 million
seconds (it only slept for a little while), if you then multiply that
with 2 and place it at 6 mil, it will have to wait for 6 mil seconds
before it gets serviced (twice the time of the 3 mil difference in
service time between this new and the old tasks).

So, theory says the fair thing to do is place new tasks at the weighted
average of the existing tasks, but computing that is expensive, so what
we do is place it somewhere near the leftmost task in the tree.

Now, you don't want to push it out too far to the right, otherwise we
get starvation issues and people get upset.

So you have to somehow determine a window in which you want to place
this task and then vary in that depending on your fork_depth.

Simply manipulating the absolute service levels like you propose isn't
going to work.


