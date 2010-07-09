Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0GITyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:54:23 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36745 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab0GITyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:54:22 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: john stultz <johnstul@us.ibm.com>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278702134.5102.9.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
	 <1278702134.5102.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 12:54:14 -0700
Message-ID: <1278705254.2349.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 12:02 -0700, Fernando Lopez-Lezcano wrote:
> Ok, I got one! (had to go buy a null modem cable, I thought I had one
> but it has disappeared since the last time I did this :-)

Great! Sorry to make you go shopping! But this points out the problem
nicely.


> Find it below... it keeps spewing stuff every once in a while. Hopefully
> this will be enough. No response from the network or the keyboard or
> mouse at this point, reset is the only way out. 
> 
> I can retest if somebody comes up with a patch...
> Thanks.
> -- Fernando
> 
> localhost login: ------------[ cut here ]------------
> kernel BUG at kernel/rtmutex.c:808!

So that's a double lock deadlock.

> Call Trace:
>  [<facf45e6>] ? nfs_refresh_inode_locked+0x79c/0xa1e [nfs]
>  [<c0465523>] ? rt_spin_lock_fastlock.clone.1+0x26/0x5f
>  [<c07936b6>] ? rt_spin_unlock+0x8/0xa
>  [<c0465559>] ? rt_spin_lock_fastlock.clone.1+0x5c/0x5f
>  [<c07936a2>] ? rt_spin_lock+0x8/0xa
>  [<c04e08d3>] ? d_materialise_unique+0xa9/0x29e
>  [<facf55bc>] ? nfs_fhget+0x492/0x51d [nfs]
>  [<c07936b6>] ? rt_spin_unlock+0x8/0xa
>  [<facf15a0>] ? nfs_do_filldir+0x27b/0x3a9 [nfs]
>  [<c04dda9c>] ? filldir64+0x0/0xcb


Looking at d_materialise_unique, I see:

	/* Is this an anonymous mountpoint that we could splice
	 * into our tree? */
	if (IS_ROOT(alias)) {
		spin_lock(&alias->d_lock);
		__d_materialise_dentry(dentry, alias);
		__d_drop(alias);
		goto found;
	}

The problem being that __d_materialise_dentry then tries to lock
alias->d_lock and we hang.

Not sure if the following is the right fix but it should avoid the
deadlock. Mind testing it to verify things work ok?

Nick: Any race possibility if something catches us between
__d_materialise_dentry and d_drop? Or should this be ok?


Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/fs/dcache.c b/fs/dcache.c
index c9d21ae..d37f6f4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2159,8 +2159,8 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 			/* Is this an anonymous mountpoint that we could splice
 			 * into our tree? */
 			if (IS_ROOT(alias)) {
-				spin_lock(&alias->d_lock);
 				__d_materialise_dentry(dentry, alias);
+				spin_lock(&alias->d_lock);
 				__d_drop(alias);
 				goto found;
 			}


