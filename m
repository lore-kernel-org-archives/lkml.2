Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1B0R12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 12:27:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54528 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1B0R10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 12:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=b2f97vU9zDGrl3sf7245gaDtcFb6VMp9YrhQ8DsFWWCHdekoxunzWSyojZJdHJE5sS
         kf1mZpI6RXtZsKAcpf8lKF6krIQUZZnnFf7OSbM4d3gi7k7iVPUe8jw6L6Kk5Q0sUqn7
         i0j8xEcnccd/QlQncrrhBEvQxBoCzJgInQPNU=
Subject: Re: Fat64 / exFat fs and Linux
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 18:27:23 +0100
Message-ID: <1298827643.14482.7.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch makes the exFAT driver compatible with Linux 2.6.36.

-Tobias

diff -urN a/exfat/exfat.h b/exfat/exfat.h
--- a/exfat/exfat.h     2009-02-08 00:21:25.000000000 +0100
+++ b/exfat/exfat.h     2010-11-23 16:16:28.000000000 +0100
@@ -8,6 +8,7 @@
 
 #include <linux/fs.h>
 #include <linux/nls.h>
+#include <linux/slab.h>
 #include "exfat_fs.h"
 
 /* FIXME: remove this */
diff -urN a/exfat/super.c b/exfat/super.c
--- a/exfat/super.c     2009-02-08 00:20:52.000000000 +0100
+++ b/exfat/super.c     2010-12-08 13:41:51.000000000 +0100
@@ -58,8 +58,11 @@
        kmem_cache_free(exfat_inode_cachep, EXFAT_I(inode));
 }
 
-static void exfat_clear_inode(struct inode *inode)
+static void exfat_evict_inode(struct inode *inode)
 {
+       truncate_inode_pages(&inode->i_data, 0);
+       invalidate_inode_buffers(inode);
+       end_writeback(inode);
        exfat_cache_inval(inode);
        exfat_detach(inode);
 }
@@ -268,8 +271,7 @@
        .alloc_inode    = exfat_alloc_inode,
        .destroy_inode  = exfat_destroy_inode,
 //     .write_inode    = ext4_write_inode,
-//     .delete_inode   = ext4_delete_inode,
-       .clear_inode    = exfat_clear_inode,
+       .evict_inode    = exfat_evict_inode,
        .put_super      = exfat_put_super,
 //     .write_super    = ext4_write_super,
        .statfs         = exfat_statfs,

