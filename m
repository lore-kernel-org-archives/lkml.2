Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1BAWCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:02:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1BAWCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:02:52 -0500
Date: Tue, 1 Feb 2011 16:56:46 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Christoph Hellwig <hch@tuxera.com>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 4/4] hfsplus: Check for NULL volume header in put_super()
Message-ID: <20110201165646.008dce36@katamari>
In-Reply-To: <20110201162802.2dd07201@katamari>
References: <20110201162802.2dd07201@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfsplus: Check for NULL volume header in put_super()

If volume header is null there is not much to do in put_super().

Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>

--- vanilla-2.6.38-rc2-git9.orig/fs/hfsplus/super.c
+++ vanilla-2.6.38-rc2-git9/fs/hfsplus/super.c
@@ -237,7 +237,10 @@ static void hfsplus_put_super(struct sup
 	if (!sb->s_fs_info)
 		return;
 
-	if (!(sb->s_flags & MS_RDONLY) && sbi->s_vhdr) {
+	if (!sbi->s_vhdr)
+		goto out_unload_nls;
+
+	if (!(sb->s_flags & MS_RDONLY)) {
 		struct hfsplus_vh *vhdr = sbi->s_vhdr;
 
 		vhdr->modify_date = hfsp_now2mt();
@@ -253,6 +256,7 @@ static void hfsplus_put_super(struct sup
 	iput(sbi->hidden_dir);
 	kfree(sbi->s_vhdr);
 	kfree(sbi->s_backup_vhdr);
+out_unload_nls:
 	unload_nls(sbi->nls);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
