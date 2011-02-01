Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1BAWCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1BAWCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:02:48 -0500
Date: Tue, 1 Feb 2011 16:45:07 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Christoph Hellwig <hch@tuxera.com>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 3/4] hfsplus: Clear volume header pointers on failure
Message-ID: <20110201164507.3e642bb3@katamari>
In-Reply-To: <20110201162802.2dd07201@katamari>
References: <20110201162802.2dd07201@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfsplus: Clear volume header pointers on failure

The next patch will use NULL volume header to determine whether
to flush the superblock. Also fix two failure cases so they
clear the headers before exiting.

Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>

--- vanilla-2.6.38-rc2-git9.orig/fs/hfsplus/wrapper.c
+++ vanilla-2.6.38-rc2-git9/fs/hfsplus/wrapper.c
@@ -167,7 +167,7 @@ reread:
 		break;
 	case cpu_to_be16(HFSP_WRAP_MAGIC):
 		if (!hfsplus_read_mdb(sbi->s_vhdr, &wd))
-			goto out;
+			goto out_free_backup_vhdr;
 		wd.ablk_size >>= HFSPLUS_SECTOR_SHIFT;
 		part_start += wd.ablk_start + wd.embed_start * wd.ablk_size;
 		part_size = wd.embed_count * wd.ablk_size;
@@ -179,7 +179,7 @@ reread:
 		 * (should do this only for cdrom/loop though)
 		 */
 		if (hfs_part_find(sb, &part_start, &part_size))
-			goto out;
+			goto out_free_backup_vhdr;
 		goto reread;
 	}
 
@@ -230,8 +230,10 @@ reread:
 
 out_free_backup_vhdr:
 	kfree(sbi->s_backup_vhdr);
+	sbi->s_backup_vhdr = NULL;
 out_free_vhdr:
 	kfree(sbi->s_vhdr);
+	sbi->s_vhdr = NULL;
 out:
 	return error;
 }
