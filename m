Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2GANmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:42:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36672 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab2GANmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:42:14 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH V2 2/2] staging/comedi/drivers: free allocated priv and release resources if comedi_alloc_subdevices
Date: Sun,  1 Jul 2012 19:12:07 +0530
Message-Id: <1341150127-13162-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as comedi_alloc_subdevices may fail, we leak out the memory allocated by alloc_private,
and also the I/O regions we requested.

free out the private data pointer of the driver, and release the I/O regions.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/comedi/drivers/fl512.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
index 52e6d14..ad64b32 100644
--- a/drivers/staging/comedi/drivers/fl512.c
+++ b/drivers/staging/comedi/drivers/fl512.c
@@ -135,8 +135,11 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 #endif
 
 	ret = comedi_alloc_subdevices(dev, 2);
-	if (ret)
+	if (ret) {
+		kfree(dev->priv);
+		release_region(iobase, FL512_SIZE);
 		return ret;
+	}
 
 	/*
 	 * this if the definitions of the supdevices, 2 have been defined
-- 
1.7.9.5

