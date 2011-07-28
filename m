Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1G1XrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:47:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:29735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1G1Xot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="33352136"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: segoon@openwall.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [44/50] staging: comedi: fix infoleak to userspace
Message-Id: <20110728234449.185B32403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

[ upstream commit 819cbb120eaec7e014e5abd029260db1ca8c5735 ]

driver_name and board_name are pointers to strings, not buffers of size
COMEDI_NAMELEN.  Copying COMEDI_NAMELEN bytes of a string containing
less than COMEDI_NAMELEN-1 bytes would leak some unrelated bytes.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/staging/comedi/comedi_fops.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/comedi/comedi_fops.c
+++ linux-2.6.35.y/drivers/staging/comedi/comedi_fops.c
@@ -383,8 +383,8 @@ static int do_devinfo_ioctl(struct comed
 	/* fill devinfo structure */
 	devinfo.version_code = COMEDI_VERSION_CODE;
 	devinfo.n_subdevs = dev->n_subdevices;
-	memcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
-	memcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
 
 	if (read_subdev)
 		devinfo.read_subdevice = read_subdev - dev->subdevices;
