Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0DBHcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 03:32:46 -0400
Received: from ozlabs.org ([203.10.76.45]:33530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab0DBHcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 03:32:31 -0400
Date: Fri, 2 Apr 2010 18:27:49 +1100
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] backing-dev: Handle class_create() failure
Message-ID: <20100402072749.GG5594@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I hit this when we had a bug in IDR for a few days. Basically sysfs would
fail to create new inodes since it uses an IDR and therefore class_create would
fail.

While we are unlikely to see this fail we may as well handle it instead of
oopsing.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0e8ca03..f13e067 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -227,6 +227,9 @@ static struct device_attribute bdi_dev_attrs[] = {
 static __init int bdi_class_init(void)
 {
 	bdi_class = class_create(THIS_MODULE, "bdi");
+	if (IS_ERR(bdi_class))
+		return PTR_ERR(bdi_class);
+
 	bdi_class->dev_attrs = bdi_dev_attrs;
 	bdi_debug_init();
 	return 0;
