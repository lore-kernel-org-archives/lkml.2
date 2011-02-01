Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1BAWCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:02:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab1BAWCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:02:32 -0500
Date: Tue, 1 Feb 2011 16:41:00 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Christoph Hellwig <hch@tuxera.com>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 2/4] hfsplus: Skip cleanup on early mount failures
Message-ID: <20110201164100.1c2908a4@katamari>
In-Reply-To: <20110201162802.2dd07201@katamari>
References: <20110201162802.2dd07201@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfsplus: Skip cleanup on early mount failures

If we don't assign s_fs_info until later we can skip cleanup code
when handling very early failures.

Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>

--- vanilla-2.6.38-rc2-git9.orig/fs/hfsplus/super.c
+++ vanilla-2.6.38-rc2-git9/fs/hfsplus/super.c
@@ -344,14 +344,13 @@ static int hfsplus_fill_super(struct sup
 	if (!sbi)
 		return -ENOMEM;
 
-	sb->s_fs_info = sbi;
 	mutex_init(&sbi->alloc_mutex);
 	mutex_init(&sbi->vh_mutex);
 	hfsplus_fill_defaults(sbi);
 	if (!hfsplus_parse_options(data, sbi)) {
 		printk(KERN_ERR "hfs: unable to parse mount options\n");
-		err = -EINVAL;
-		goto cleanup;
+		kfree(sbi);
+		return -EINVAL;
 	}
 
 	/* temporarily use utf8 to correctly find the hidden dir below */
@@ -359,10 +358,12 @@ static int hfsplus_fill_super(struct sup
 	sbi->nls = load_nls("utf8");
 	if (!sbi->nls) {
 		printk(KERN_ERR "hfs: unable to load nls for utf8\n");
-		err = -EINVAL;
-		goto cleanup;
+		kfree(sbi);
+		return -EINVAL;
 	}
 
+	sb->s_fs_info = sbi;
+
 	/* Grab the volume header */
 	if (hfsplus_read_wrapper(sb)) {
 		if (!silent)
