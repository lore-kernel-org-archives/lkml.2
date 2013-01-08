Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3AHXhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:37:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:63542 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3AHXhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tim Blechmann <tim@klingt.org>, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 24/77] ALSA: lx6464es - fix device communication via command bus
Date: Tue, 8 Jan 2013 18:35:03 -0500
Message-ID: <1357688156-25387-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Blechmann <tim@klingt.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a29878553a9a7b4c06f93c7e383527cf014d4ceb upstream.

commit 6175ddf06b6172046a329e3abfd9c901a43efd2e optimized the mem*io
functions that have been used to send commands to the device. these
optimizations somehow corrupted the communication with the lx6464es,
that resulted the device to be unusable with kernels after 2.6.33.

this patch emulates the memcpy_*_io functions via a loop to avoid these
problems.

Signed-off-by: Tim Blechmann <tim@klingt.org>
LKML-Reference: <4ECB5257.4040600@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/lx6464es/lx_core.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/sound/pci/lx6464es/lx_core.c b/sound/pci/lx6464es/lx_core.c
index 3086b75..2313a51 100644
--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -80,8 +80,12 @@ unsigned long lx_dsp_reg_read(struct lx6464es *chip, int port)
 
 void lx_dsp_reg_readbuf(struct lx6464es *chip, int port, u32 *data, u32 len)
 {
-	void __iomem *address = lx_dsp_register(chip, port);
-	memcpy_fromio(data, address, len*sizeof(u32));
+	u32 __iomem *address = lx_dsp_register(chip, port);
+	int i;
+
+	/* we cannot use memcpy_fromio */
+	for (i = 0; i != len; ++i)
+		data[i] = ioread32(address + i);
 }
 
 
@@ -94,8 +98,12 @@ void lx_dsp_reg_write(struct lx6464es *chip, int port, unsigned data)
 void lx_dsp_reg_writebuf(struct lx6464es *chip, int port, const u32 *data,
 			 u32 len)
 {
-	void __iomem *address = lx_dsp_register(chip, port);
-	memcpy_toio(address, data, len*sizeof(u32));
+	u32 __iomem *address = lx_dsp_register(chip, port);
+	int i;
+
+	/* we cannot use memcpy_to */
+	for (i = 0; i != len; ++i)
+		iowrite32(data[i], address + i);
 }
 
 
-- 
1.7.12.1

