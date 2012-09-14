Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab2INGwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:52:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31702 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2INGwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:52:12 -0400
Date: Fri, 14 Sep 2012 09:52:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] gcov: add a kfree() on error to new_node()
Message-ID: <20120914065203.GB11886@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051D4D4.7060906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should free "node->loaded_info" on this error path.  We'd never care
in real life but it makes the static checkers happy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: some style changes.

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 9bd0934..7ba47f7 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
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
@@ -461,6 +460,8 @@ static struct gcov_node *new_node(struct gcov_node *parent,
 
 	return node;
 
+err_info:
+	kfree(node->loaded_info);
 err_nomem:
 	kfree(node);
 	pr_warning("out of memory\n");
