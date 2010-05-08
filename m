Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0EHAjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 20:39:21 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49012 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab0EHAjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 20:39:19 -0400
Subject: Re: 2.6.33.3-rt19 kernel BUG's
From: john stultz <johnstul@us.ibm.com>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1273276725.17045.4.camel@localhost.localdomain>
References: <1273197218.6768.10.camel@localhost.localdomain>
	 <alpine.LFD.2.00.1005071240350.3401@localhost.localdomain>
	 <1273275821.2776.3.camel@localhost.localdomain>
	 <1273276725.17045.4.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 17:39:13 -0700
Message-ID: <1273279153.2776.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 23:58 +0000, Fernando Lopez-Lezcano wrote:
> On Fri, 2010-05-07 at 16:43 -0700, john stultz wrote:
> > On Fri, 2010-05-07 at 12:41 +0200, Thomas Gleixner wrote:
> > > On Thu, 6 May 2010, Fernando Lopez-Lezcano wrote:
> > > 
> > > CC'ed John and Nick
> > > 
> > > > See below... just trying to boot (quad core desktop machine).
> > 
> > Ok. Got this to reproduce. Will hopefully have a fix for your soon.
> > 
> > Thanks for the bug report!
> 
> Thanks for looking at it! It had been a while since I had problems with
> rt so I could not understand why I could not login :-) 

Bah! I should have caught this faster. I kept thinking it had to be some
missed unlock of the sbi->fs_lock, but it ends up its just the
autofs4_lock.

Apparently the conversion from using the dcache_lock -> autofs4_lock
forgot that this function already grabs the autofs_lock for a small
moment, so we end up grabbing the lock, then a moment later grab it
again. Splat.

This patch should resolve it.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 5b26088..a7eaa32 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -438,12 +438,10 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 	}
 
 	/* Check for a non-mountpoint directory with no contents */
-	spin_lock(&autofs4_lock);
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
 	    !d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
-		spin_unlock(&autofs4_lock);
 
 		if (autofs4_need_mount(flags) || current->link_count) {
 			int status;





