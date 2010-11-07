Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab0KGS7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:59:44 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20684 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KGS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:59:43 -0500
Date: Sun, 7 Nov 2010 19:48:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Ralf Baechle <ralf@linux-mips.org>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS VPE support module: don't deref potentially null pbuffer
 and don't do pointless null check before vfree
In-Reply-To: <20101107142933.GA7999@linux-mips.org>
Message-ID: <alpine.LNX.2.00.1011071943460.26247@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301823350.1572@swampdragon.chaosbits.net> <20101107142933.GA7999@linux-mips.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Ralf Baechle wrote:

> On Sat, Oct 30, 2010 at 06:37:16PM +0200, Jesper Juhl wrote:
> 
> > I noticed that the return value of the 
> > vmalloc() call in arch/mips/kernel/vpe.c::vpe_open() is not checked, so we 
> > potentially store a null pointer in v->pbuffer. As far as I can tell this 
> > will be a problem. However, I don't know the mips code at all, so there 
> > may be something, somewhere where I did not look, that handles this in a 
> > safe manner but I couldn't find it.
> > 
> > To me it looks like we should do what the patch below implements and check 
> > for a null return and then return -ENOMEM in that case. Comments?
> 
> All users check if the buffer was successfully allocated so the code is
> safe wrt. to that.
> 
> Doesn't mean that it's not a pukeogenic piece of code.  Look at the use of
> v->pbuffer in vpe_release for example.  First use it the vmalloc'ed memory
> then carefully check the pointer for being non-NULL before calling vfree.
> If the pointer could actually be non-NULL that's too late and vfree does
> that check itself anyway.  And more such gems, general uglyness and
> freedom of concept.  It used to be even worse.
> 
Thanks for looking at the patch and commenting.

I've taken a second look. I still have no way at all to test this, so 
please take a close look before potentially applying it, but how does this 
look to you?


Don't dereference pbuffer before ttesting it for null.
Don't do pointless check of pointer passed to vfree for null as vfree does 
this itself.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 vpe.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 3eb3cde..e22f258 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -854,6 +854,9 @@ static int vpe_elfload(struct vpe * v)
 	strcpy(mod.name, "VPE loader");
 
 	hdr = (Elf_Ehdr *) v->pbuffer;
+	if (!hdr)
+		return -ENOMEM;
+
 	len = v->plen;
 
 	/* Sanity checks against insmoding binaries or wrong arch,
@@ -1129,6 +1132,10 @@ static int vpe_release(struct inode *inode, struct file *filp)
 		return -ENODEV;
 
 	hdr = (Elf_Ehdr *) v->pbuffer;
+	if (!hdr) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) == 0) {
 		if (vpe_elfload(v) >= 0) {
 			vpe_run(v);
@@ -1141,6 +1148,7 @@ static int vpe_release(struct inode *inode, struct file *filp)
 		ret = -ENOEXEC;
 	}
 
+ out:
 	/* It's good to be able to run the SP and if it chokes have a look at
 	   the /dev/rt?. But if we reset the pointer to the shared struct we
 	   lose what has happened. So perhaps if garbage is sent to the vpe
@@ -1150,8 +1158,7 @@ static int vpe_release(struct inode *inode, struct file *filp)
 		v->shared_ptr = NULL;
 
 	// cleanup any temp buffers
-	if (v->pbuffer)
-		vfree(v->pbuffer);
+	vfree(v->pbuffer);
 	v->plen = 0;
 	return ret;
 }




-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

