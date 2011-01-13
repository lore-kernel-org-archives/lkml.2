Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab1AMONA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:13:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47851 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab1AMOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:12:59 -0500
Date: Thu, 13 Jan 2011 15:12:50 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
Message-ID: <20110113141250.GR24920@pengutronix.de>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 13, 2011 at 02:54:30PM +0100, Thomas Gleixner wrote:
> The dcache scalability work broke NFS root filesystems.
> 
> "cd /" results in the following problem:
> 
>     link_path_walk("/",...);
> 	jumps to return_reval
> 	need_reval_dot() returns true for NFS
> 	d_revalidate()
> 		dentry->d_op->d_revalidate(dentry, nd);
> 		 	returns -ECHILD due to nd->flags & LOOKUP_RCU
> 		nameidata_dentry_drop_rcu()
> 			spin_lock(&parent->d_lock);
> 			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> 
> 			This deadlocks because dentry == parent
> 
> This problem exists for any filesystem which implements d_revalidate.
> 
> Uwe bisected is down to commit 34286d6(fs: rcu-walk aware d_revalidate
> method), but reverting that patch causes different wreckage to show up.
> 
> Check for parent equal dentry and skip the nested lock to avoid the
> deadlock. I'm sure this is the wrong fix, but at least it "works" :)
> 
> Reported-by: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> Reported-by: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
> Not-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  fs/namei.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/fs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/namei.c
> +++ linux-2.6/fs/namei.c
> @@ -487,6 +487,8 @@ static int nameidata_dentry_drop_rcu(str
>  			goto err_root;
>  	}
>  	spin_lock(&parent->d_lock);
> +	if (parent == dentry)
> +		goto same;
>  	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
>  	if (!__d_rcu_to_refcount(dentry, nd->seq))
>  		goto err;
> @@ -499,6 +501,8 @@ static int nameidata_dentry_drop_rcu(str
>  	BUG_ON(!parent->d_count);
>  	parent->d_count++;
>  	spin_unlock(&dentry->d_lock);
> +
> +same:
>  	spin_unlock(&parent->d_lock);
>  	if (nd->root.mnt) {
>  		path_get(&nd->root);
> 
Note there is a different patch available in the thread here:

	http://thread.gmane.org/gmane.linux.kernel/1087013/focus=1087048

The differences are that it tests for IS_ROOT(dentry) instead of parent ==
dentry (which looks more reasonable IMVHO) and that it increases
parent->d_count even if the test triggered.
(And it doesn't skip the BUG_ONs which hopefully doesn't make a
difference.)

Note I really have no glue about the code below fs/, but I wonder if
the toplevel directories of mounts need some treatment here, too.  (But
I expect that they don't.  So I ask just in case ...)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
