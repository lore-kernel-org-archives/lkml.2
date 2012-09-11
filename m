Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2IKLNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:13:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37989 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab2IKLNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:13:38 -0400
Date: Tue, 11 Sep 2012 14:13:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: kernel-janitors@vger.kernel.org
Subject: [patch] gcov: cleanup an allocation in new_node()
Message-ID: <20120911111333.GD22259@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) kcalloc(1, ...) can be replaced with kzalloc().
2) There was a small leak if the debugfs_create_dir() fails.
3) I removed a pr_warning("out of memory\n") because kmalloc() already
   prints a more useful failure message in the unlikely case of an
   allocation failure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 9bd0934..132168f 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -437,7 +437,7 @@ static struct gcov_node *new_node(struct gcov_node *parent,
 	if (!node)
 		goto err_nomem;
 	if (info) {
-		node->loaded_info = kcalloc(1, sizeof(struct gcov_info *),
+		node->loaded_info = kzalloc(sizeof(struct gcov_info *),
 					   GFP_KERNEL);
 		if (!node->loaded_info)
 			goto err_nomem;
@@ -451,8 +451,7 @@ static struct gcov_node *new_node(struct gcov_node *parent,
 		node->dentry = debugfs_create_dir(node->name, parent->dentry);
 	if (!node->dentry) {
 		pr_warning("could not create file\n");
-		kfree(node);
-		return NULL;
+		goto err_info;
 	}
 	if (info)
 		add_links(node, parent->dentry);
@@ -461,9 +460,11 @@ static struct gcov_node *new_node(struct gcov_node *parent,
 
 	return node;
 
+err_info:
+	if (info)
+		kfree(node->loaded_info);
 err_nomem:
 	kfree(node);
-	pr_warning("out of memory\n");
 	return NULL;
 }
 
