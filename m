Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1GQSkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 14:40:53 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20666 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1GQSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 14:40:52 -0400
Date: Sun, 17 Jul 2011 20:40:50 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Tiago Vignatti <vignatti@freedesktop.org>,
        "Paulo R. Zanoni" <przanoni@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Airlie <airlied@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Alex Deucher <alexdeucher@gmail.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH] vga: Fix mem leaks in vga_arb_write()
Message-ID: <alpine.LNX.2.00.1107172037040.32359@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't always free the memory allocated to 'kbuf' - make sure we do
so.
Also, while I was there anyway, remove a unneeded kfree call and instead 
just set ret_val and fall through to the 'done' label. I also made a small 
trivial change to a comment and a small whitespace correction in an 
assignment.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/vga/vgaarb.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

  compile tested.

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 8a1021f..7f41a8d 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -993,14 +993,15 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 				uc = &priv->cards[i];
 		}
 
+		ret_val = -EINVAL;
 		if (!uc)
-			return -EINVAL;
+			goto done;
 
 		if (io_state & VGA_RSRC_LEGACY_IO && uc->io_cnt == 0)
-			return -EINVAL;
+			goto done;
 
 		if (io_state & VGA_RSRC_LEGACY_MEM && uc->mem_cnt == 0)
-			return -EINVAL;
+			goto done;
 
 		vga_put(pdev, io_state);
 
@@ -1115,7 +1116,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 				MAX_USER_CARDS);
 			pci_dev_put(pdev);
 			/* XXX: which value to return? */
-			ret_val =  -ENOMEM;
+			ret_val = -ENOMEM;
 			goto done;
 		}
 
@@ -1143,10 +1144,8 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		ret_val = count;
 		goto done;
 	}
-	/* If we got here, the message written is not part of the protocol! */
-	kfree(kbuf);
-	return -EPROTO;
-
+	/* If we get here, the message written is not part of the protocol! */
+	ret_val = -EPROTO;
 done:
 	kfree(kbuf);
 	return ret_val;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

