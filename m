Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab0ELRtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:49:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876Ab0ELRtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:49:06 -0400
Date: Wed, 12 May 2010 10:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH -mm] cpuset,mm: fix no node to alloc memory when
 changing cpuset's mems - fix2
Message-Id: <20100512104817.beeee3b5.akpm@linux-foundation.org>
In-Reply-To: <4BEA6E3D.10503@cn.fujitsu.com>
References: <4BEA56D3.6040705@cn.fujitsu.com>
	<20100512003246.9f0ee03c.akpm@linux-foundation.org>
	<4BEA6E3D.10503@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 17:00:45 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> on 2010-5-12 12:32, Andrew Morton wrote:
> > On Wed, 12 May 2010 15:20:51 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:
> > 
> >> @@ -985,6 +984,7 @@ repeat:
> >>  	 * for the read-side.
> >>  	 */
> >>  	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
> >> +		task_unlock(tsk);
> >>  		if (!task_curr(tsk))
> >>  			yield();
> >>  		goto repeat;
> > 
> > Oh, I meant to mention that.  No yield()s, please.  Their duration is
> > highly unpredictable.  Can we do something more deterministic here?
> 
> Maybe we can use wait_for_completion().

That would work.

> > 
> > Did you consider doing all this with locking?  get_mems_allowed() does
> > mutex_lock(current->lock)?
> 
> do you means using a real lock(such as: mutex) to protect mempolicy and mem_allowed?

yes.

> It may cause the performance regression, so I do my best to abstain from using a real
> lock.

Well, the code as-is is pretty exotic with lots of open-coded tricky
barriers - it's best to avoid inventing new primitives if possible. 
For example, there's no lockdep support for this new "lock".

mutex_lock() is pretty quick - basically a simgle atomic op.  How
frequently do these operations occur?

The code you have at present is fairly similar to sequence locks.  I
wonder if there's some way of (ab)using sequence locks for this. 
seqlocks don't have lockdep support either...

