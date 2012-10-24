Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808Ab2JXWKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:10:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41275 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161408Ab2JXWJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:09:45 -0400
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Victor Manuel Jaquez Leal <vjaquez@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH 5/6] staging: tidspbridge: ioremap physical address of the stack segment in shm
Date: Wed, 24 Oct 2012 17:09:19 -0500
Message-Id: <1351116560-6918-6-git-send-email-omar.ramirez@copitl.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
References: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to data type change, readl can no longer receive a u32.

Signed-off-by: Omar Ramirez Luna <omar.ramirez@copitl.com>
---

Intended for 3.7 due to code changes during rc1.

 drivers/staging/tidspbridge/rmgr/node.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index c2fc613..294e9b4 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -304,8 +304,7 @@ int node_allocate(struct proc_object *hprocessor,
 	u32 pul_value;
 	u32 dynext_base;
 	u32 off_set = 0;
-	u32 ul_stack_seg_addr, ul_stack_seg_val;
-	u32 ul_gpp_mem_base;
+	u32 ul_stack_seg_val;
 	struct cfg_hostres *host_res;
 	struct bridge_dev_context *pbridge_context;
 	u32 mapped_addr = 0;
@@ -581,6 +580,9 @@ func_cont:
 		if (strcmp((char *)
 			   pnode->dcd_props.obj_data.node_obj.ndb_props.
 			   stack_seg_name, STACKSEGLABEL) == 0) {
+			void __iomem *stack_seg;
+			u32 stack_seg_pa;
+
 			status =
 			    hnode_mgr->nldr_fxns.
 			    get_fxn_addr(pnode->nldr_node_obj, "DYNEXT_BEG",
@@ -608,14 +610,21 @@ func_cont:
 				goto func_end;
 			}
 
-			ul_gpp_mem_base = (u32) host_res->mem_base[1];
 			off_set = pul_value - dynext_base;
-			ul_stack_seg_addr = ul_gpp_mem_base + off_set;
-			ul_stack_seg_val = readl(ul_stack_seg_addr);
+			stack_seg_pa = host_res->mem_phys[1] + off_set;
+			stack_seg = ioremap(stack_seg_pa, SZ_32);
+			if (!stack_seg) {
+				status = -ENOMEM;
+				goto func_end;
+			}
+
+			ul_stack_seg_val = readl(stack_seg);
+
+			iounmap(stack_seg);
 
 			dev_dbg(bridge, "%s: StackSegVal = 0x%x, StackSegAddr ="
 				" 0x%x\n", __func__, ul_stack_seg_val,
-				ul_stack_seg_addr);
+				host_res->mem_base[1] + off_set);
 
 			pnode->create_args.asa.task_arg_obj.stack_seg =
 			    ul_stack_seg_val;
-- 
1.7.9.5

