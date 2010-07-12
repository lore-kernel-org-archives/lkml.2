Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0GLXyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:54:04 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52594 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0GLXyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:54:01 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: john stultz <johnstul@us.ibm.com>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278977858.6489.52.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
	 <1278702134.5102.9.camel@localhost.localdomain>
	 <1278705254.2349.14.camel@localhost.localdomain>
	 <1278713600.7122.22.camel@localhost.localdomain>
	 <1278716222.2349.20.camel@localhost.localdomain>
	 <1278977858.6489.52.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 16:53:54 -0700
Message-ID: <1278978834.2404.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 16:37 -0700, Fernando Lopez-Lezcano wrote:
> On Fri, 2010-07-09 at 15:57 -0700, john stultz wrote:
> > So looking over it, I'm not easily seeing what else could be off.
> > 
> > So Lets see if we can cut some of the guess work out of this...
> > 
> > >  [<c04e08e9>] ? d_materialise_unique+0xbf/0x29e
> > 
> > I'm curious exactly where that is in d_materialise_unique. To find out,
> > can you find the vmlinux image in the base of the directory you built
> > the kernel you triggered this in?
> > 
> > Then run:
> > # gdb ./vmlinux
> > 
> > Once gdb loads:
> > (gdb) list *0xc04e08e9
> > 
> > That should point to exactly where in the function we are trying to
> > acquire a previously locked lock.
> 
> Finally... I did a local build in my desktop machine so I now have
> access to the full patched/compiled source tree. I confirmed that the
> patch you sent is there (moving a spin_lock one line down). 
> 
> This is from a different kernel (non-PAE) so the exact address is
> different from the previous report:
> 
> (gdb) list *0xc04d82dd
> 0xc04d82dd is in d_materialise_unique (fs/dcache.c:2100).
> 2095		spin_lock(&aparent->d_lock);
> 2096		spin_lock(&dparent->d_lock);
> 2097		spin_lock(&dentry->d_lock);
> 2098		spin_lock(&anon->d_lock);
> 2099	
> 2100		dentry->d_parent = (aparent == anon) ? dentry : aparent;
> 2101		list_del(&dentry->d_u.d_child);
> 2102		if (!IS_ROOT(dentry))
> 2103			list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
> 2104		else
> 
> See below for the full dump of the BUG through the serial console in
> this particular occurrence. 

Huh. I'm still baffled. Since we're blowing out on line 2098, the anon
pointer points to the alias pointer we passed in to 
__d_materialise_dentry(). So that means the anon dentry is already
locked, and we've moved the obviously wrong lock operation down so it
shouldn't be held.

Hrm. Ok.. I think the line 2100 above gives us a hint: (aparent == anon)
So if that were the case, we would have already locked aparent and that
would explain the blowup.

How does it do with the following change?

thanks
-john



diff --git a/fs/dcache.c b/fs/dcache.c
index c9d21ae..8d68504 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2099,7 +2099,8 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	aparent = anon->d_parent;
 
 	/* XXX: hack */
-	spin_lock(&aparent->d_lock);
+	if (aparent != anon)
+		spin_lock(&aparent->d_lock);
 	spin_lock(&dparent->d_lock);
 	spin_lock(&dentry->d_lock);
 	spin_lock(&anon->d_lock);
@@ -2121,7 +2122,8 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	spin_unlock(&anon->d_lock);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dparent->d_lock);
-	spin_unlock(&aparent->d_lock);
+	if (aparent != anon)
+		spin_unlock(&aparent->d_lock);
 
 	anon->d_flags &= ~DCACHE_DISCONNECTED;
 }
@@ -2159,8 +2161,8 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 			/* Is this an anonymous mountpoint that we could splice
 			 * into our tree? */
 			if (IS_ROOT(alias)) {
-				spin_lock(&alias->d_lock);
 				__d_materialise_dentry(dentry, alias);
+				spin_lock(&alias->d_lock);
 				__d_drop(alias);
 				goto found;
 			}


