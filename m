Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161268Ab2COTRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:17:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:42313 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965311Ab2COTRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:17:15 -0400
Date: Thu, 15 Mar 2012 20:17:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 0/5] seqlock consolidation
In-Reply-To: <20120315183940.GE8943@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1203152013030.2466@ionos>
References: <20120314170736.617746873@linutronix.de> <20120315122112.GB8943@ZenIV.linux.org.uk> <alpine.LFD.2.02.1203151322020.2466@ionos> <20120315174305.GD8943@ZenIV.linux.org.uk> <alpine.LFD.2.02.1203151854110.2466@ionos>
 <20120315183940.GE8943@ZenIV.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012, Al Viro wrote:

> On Thu, Mar 15, 2012 at 06:55:18PM +0100, Thomas Gleixner wrote:
> > > If that's it, I suggest to look for a solution that would express just that...
> > > Or do you want something on the reader side as well?
> > 
> > The problem is the reader side. If the reader preempts the writer then
> > the only way to make progress is to take the lock, but therefor I need
> > to know which lock I should take.
> 
> So just make writers non-preemptable in those sections.  Really, the
> worst non-deterministic behaviour you get for d_seq ones is memcpy()
> of up to ->d_name.len bytes.  And on the fs_struct side it's trivial
> to reduce the work done in those sections to several comparisons and
> assignments.  Not even path_get_longterm() needs to be there - see
> below for how it can be done:

Yeah, path_get_longterm() was what worried me due to dget() taking
d_lock, but yeah, I'm happy to avoid all that churn that way.

Thanks a lot!
 
>  		if (fs) {
> +			int hits = 0;
>  			spin_lock(&fs->lock);
>  			write_seqcount_begin(&fs->seq);
> -			if (fs->root.dentry == old_root->dentry
> -			    && fs->root.mnt == old_root->mnt) {
> -				path_get_longterm(new_root);
> -				fs->root = *new_root;
> +			hits += replace_path(&fs->root, old_root, new_root);
> +			hits += replace_path(&fs->pwd, old_root, new_root);

Wouldn't it be simpler to just do: 

+			count += replace_path(&fs->root, old_root, new_root);
+			count += replace_path(&fs->pwd, old_root, new_root);

> +			write_seqcount_end(&fs->seq);
> +			while (hits--) {
>  				count++;

Instead of that loop ?

Thanks,

	tglx
