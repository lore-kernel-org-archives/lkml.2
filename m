Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab2GFKRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:17:02 -0400
Received: from aristotle.killerwolves.net ([182.160.128.151]:47729 "EHLO
	aristotle.killerwolves.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694Ab2GFKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:17:00 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 06:17:00 EDT
From: Ben Peddell <klightspeed@killerwolves.net>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] initramfs: handle trailing junk after valid image
Message-Id: <20120706101203.7EFC677A0D@aristotle.killerwolves.net>
Date: Fri,  6 Jul 2012 20:12:03 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initramfs handling since commit df37bd15 has been rejecting
valid images that have garbage after them.  For example, on an
architecture where the initramfs address and size are specified
as a kernel parameter (specifically unicore32 and arm), specifying
e.g. initrd=0x01000000,4M will not work unless the image is padded
with nulls to 4MiB.  This is unlikely to occur if the user is using
this parameter to work around a bug in the bootloader.

---
 init/initramfs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 84c6bf1..26c2cb1 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -467,6 +467,9 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
 					 compress_name);
 				message = msg_buf;
 			}
+		} else if (state == Reset) {
+			my_inptr = len;
+			pr_warn("%s: junk at end of compressed archive\n", __func__);
 		} else
 			error("junk in compressed archive");
 		if (state != Reset)
-- 
1.7.3.4

