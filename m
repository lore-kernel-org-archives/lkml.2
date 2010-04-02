Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab0DBHch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 03:32:37 -0400
Received: from ozlabs.org ([203.10.76.45]:33531 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab0DBHcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 03:32:31 -0400
Date: Fri, 2 Apr 2010 18:29:20 +1100
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] devmem: Handle class_create() failure
Message-ID: <20100402072920.GH5594@kryten>
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

Index: linux-2.6/drivers/char/mem.c
===================================================================
--- linux-2.6.orig/drivers/char/mem.c	2010-02-02 22:18:02.000000000 -0600
+++ linux-2.6/drivers/char/mem.c	2010-02-02 22:18:15.000000000 -0600
@@ -901,6 +901,9 @@ static int __init chr_dev_init(void)
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
 
 	mem_class = class_create(THIS_MODULE, "mem");
+	if (IS_ERR(mem_class))
+		return PTR_ERR(mem_class);
+
 	mem_class->devnode = mem_devnode;
 	for (minor = 1; minor < ARRAY_SIZE(devlist); minor++) {
 		if (!devlist[minor].name)
