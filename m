Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0DVNpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 09:45:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26301 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0DVNo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 09:44:59 -0400
Date: Thu, 22 Apr 2010 06:43:09 -0700
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: Frontswap [PATCH 1/4] (was Transcendent Memory): swap data
	structure changes
Message-ID: <20100422134309.GA2994@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BD052BD.00B3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frontswap [PATCH 1/4] (was Transcendent Memory): swap data structure changes

Core swap data structures are needed by frontswap.c but we don't
need to expose them to the dozens of files that include swap.h
so create a new swapfile.h just to extern-ify these.

Add frontswap-related elements to swap_info_struct.  Don't tie
these to CONFIG_FRONTSWAP to avoid unnecessary clutter around
various frontswap hooks.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Diffstat:
 swap.h                                   |    2 ++
 swapfile.h                               |   13 +++++++++++++
 2 files changed, 15 insertions(+)

--- linux-2.6.34-rc5/include/linux/swapfile.h	1969-12-31 17:00:00.000000000 -0700
+++ linux-2.6.34-rc5-frontswap/include/linux/swapfile.h	2010-04-21 08:59:36.000000000 -0600
@@ -0,0 +1,13 @@
+#ifndef _LINUX_SWAPFILE_H
+#define _LINUX_SWAPFILE_H
+
+/*
+ * these were static in swapfile.c but frontswap.c needs them and we don't
+ * want to expose them to the dozens of source files that include swap.h
+ */
+extern spinlock_t swap_lock;
+extern struct swap_list_t swap_list;
+extern struct swap_info_struct *swap_info[];
+extern int try_to_unuse(unsigned int, bool, unsigned long);
+
+#endif /* _LINUX_SWAPFILE_H */
--- linux-2.6.34-rc5/include/linux/swap.h	2010-04-19 17:29:56.000000000 -0600
+++ linux-2.6.34-rc5-frontswap/include/linux/swap.h	2010-04-21 08:59:36.000000000 -0600
@@ -182,6 +182,8 @@ struct swap_info_struct {
 	struct block_device *bdev;	/* swap device or bdev of swap file */
 	struct file *swap_file;		/* seldom referenced */
 	unsigned int old_block_size;	/* seldom referenced */
+	unsigned long *frontswap_map;	/* frontswap in-use, one bit per page */
+	unsigned int frontswap_pages;	/* frontswap pages in-use counter */
 };
 
 struct swap_list_t {
