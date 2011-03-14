Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1CNLHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:07:32 -0400
Received: from nm17.bullet.mail.ne1.yahoo.com ([98.138.90.80]:33218 "HELO
	nm17.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753223Ab1CNLH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:27 -0400
X-Yahoo-Newman-Id: 658017.21361.bm@omp1017.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Jq2w3t8VM1k6EhvuCfmLYvwwRahyqsLLmefb4NcOGyRrP3w
 ylCtprL.LR0YoJGFw7Y_oV0S5QNR5z.ZtbvDQt0gTLUXM_DgTjONKlR09mCm
 bh5H6TcEkT9oDY45CpDoimomvJsRFIQCg1BjI7np6RysLNBOXBpseTysZ1yB
 _ehkut9lAMLbJ.mn1.mjdGKM06mt.paMO39eIjkSGKpuT4V5a2aEr2o6Yl98
 1dOLiAXb8Cq0qdzGBztu2CYc6FA6Lyq2S8oxT1O13YNVnVMb0Wiwv_k_alKV
 u.xuMxCoNm0z5nFMZ77P1SrMnr.LCNwbFSYmLJHX2lfXO_ZAzDYKnNnFJCcE
 W1CTiBOyPsh0kp2OiOkjr7vPPVgQ8LtQs.pjGI8V3k_YW7wGnw.Jw2rzfsR2
 nK8SYEN3HFUJfRONHjI1LircNHYfmFqvRRScc9va4gxgTB9ks1A9ElQRfKAX
 SI4WgKO5mdnAGI3lJmzRJIpigXRcUP6Lh3N6vJm.V0.nMdkD4ZIFt1.tqZ_B
 fXQa0OFGCaaHVuRsXUZIU4OKFhTqv.FPG
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Fubo Chen <fubo.chen@gmail.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 13/21] target: Fix generated *_drop_nodeacl() handler in tcm_mod_builder.py
Date: Mon, 14 Mar 2011 04:06:07 -0700
Message-Id: <1300100775-10012-14-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fubo Chen <fubo.chen@gmail.com>

This patch adds the missing core_tpg_del_initiator_node_acl() call required
by fabric modules for struct se_node_acl->acl_group context shutdown via

	target_core_fabric_configfs.c:target_fabric_nacl_base_release() ->

		struct target_core_fabric_ops->fabric_drop_nodeacl()

for tcm_mod_builder.py generated $FABRIC_MOD_configfs.c skeleton code.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 Documentation/target/tcm_mod_builder.py |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 89af6c7..7ef9b84 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -289,6 +289,7 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "{\n"
 	buf += "	struct " + fabric_mod_name + "_nacl *nacl = container_of(se_acl,\n"
 	buf += "				struct " + fabric_mod_name + "_nacl, se_node_acl);\n"
+	buf += "	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);\n"
 	buf += "	kfree(nacl);\n"
 	buf += "}\n\n"
 
-- 
1.7.4.1

