Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0J3Qre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 12:47:34 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27889 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab0J3Qrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:47:33 -0400
Date: Sat, 30 Oct 2010 18:37:16 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ralf Baechle <ralf@linux-mips.org>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Check vmalloc return value in vpe_open
Message-ID: <alpine.LNX.2.00.1010301823350.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that the return value of the 
vmalloc() call in arch/mips/kernel/vpe.c::vpe_open() is not checked, so we 
potentially store a null pointer in v->pbuffer. As far as I can tell this 
will be a problem. However, I don't know the mips code at all, so there 
may be something, somewhere where I did not look, that handles this in a 
safe manner but I couldn't find it.

To me it looks like we should do what the patch below implements and check 
for a null return and then return -ENOMEM in that case. Comments?

Please CC me on replies as I'm not subscribed to linux-mips.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 vpe.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 3eb3cde..22b79f6 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1092,6 +1092,10 @@ static int vpe_open(struct inode *inode, struct file *filp)
 
 	/* this of-course trashes what was there before... */
 	v->pbuffer = vmalloc(P_SIZE);
+	if (!v->pbuffer) {
+		pr_warning("VPE loader: unable to allocate memory\n");
+		return -ENOMEM;
+	}
 	v->plen = P_SIZE;
 	v->load_addr = NULL;
 	v->len = 0;


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

