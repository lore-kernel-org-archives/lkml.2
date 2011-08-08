Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1HHLS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 07:18:27 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53604 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1HHLSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 07:18:17 -0400
From: Julia Lawall <julia@diku.dk>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: kernel-janitors@vger.kernel.org, Andy Grover <agrover@redhat.com>,
        Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] drivers/target/iscsi/iscsi_target_parameters.c: add missing kfree
Date: Mon,  8 Aug 2011 13:18:01 +0200
Message-Id: <1312802283-9107-7-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

At this point, the new_param that has just been allocated has not been
stored in the list, so it and new_param->name, once it is defined, have to
be freed separately.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@exists@
local idexpression x;
statement S,S1;
expression E;
identifier fl;
expression *ptr != NULL;
@@

x = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...kfree(x)...+> }
     when any
     when != true x == NULL
x->fl
...>
(
if (x == NULL) S1
|
if (...) { ... when != x
               when forall
(
 return \(0\|<+...x...+>\|ptr\);
|
* return ...;
)
}
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/target/iscsi/iscsi_target_parameters.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 252e246..b8dbe44 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -584,6 +584,7 @@ int iscsi_copy_param_list(
 		if (!new_param->name) {
 			pr_err("Unable to allocate memory for"
 				" parameter name.\n");
+			kfree(new_param);
 			goto err_out;
 		}
 
@@ -592,6 +593,8 @@ int iscsi_copy_param_list(
 		if (!new_param->value) {
 			pr_err("Unable to allocate memory for"
 				" parameter value.\n");
+			kfree(new_param->name);
+			kfree(new_param);
 			goto err_out;
 		}
 

