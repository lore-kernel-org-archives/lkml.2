Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1BBAsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:48:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:58271 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab1BBApP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418448"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: zohar@linux.vnet.ibm.com, zohar@us.ibm.com, ak@linux.intel.com,
        jmorris@namei.org, serge.hallyn@canonical.com, safford@watson.ibm.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [126/139] ima: fix add LSM rule bug
Message-Id: <20110202004525.9AF3F3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 867c20265459d30a01b021a9c1e81fb4c5832aa9 upstream.

If security_filter_rule_init() doesn't return a rule, then not everything
is as fine as the return code implies.

This bug only occurs when the LSM (eg. SELinux) is disabled at runtime.

Adding an empty LSM rule causes ima_match_rules() to always succeed,
ignoring any remaining rules.

 default IMA TCB policy:
  # PROC_SUPER_MAGIC
  dont_measure fsmagic=0x9fa0
  # SYSFS_MAGIC
  dont_measure fsmagic=0x62656572
  # DEBUGFS_MAGIC
  dont_measure fsmagic=0x64626720
  # TMPFS_MAGIC
  dont_measure fsmagic=0x01021994
  # SECURITYFS_MAGIC
  dont_measure fsmagic=0x73636673

  < LSM specific rule >
  dont_measure obj_type=var_log_t

  measure func=BPRM_CHECK
  measure func=FILE_MMAP mask=MAY_EXEC
  measure func=FILE_CHECK mask=MAY_READ uid=0

Thus without the patch, with the boot parameters 'tcb selinux=0', adding
the above 'dont_measure obj_type=var_log_t' rule to the default IMA TCB
measurement policy, would result in nothing being measured.  The patch
prevents the default TCB policy from being replaced.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: David Safford <safford@watson.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_policy.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/security/integrity/ima/ima_policy.c
===================================================================
--- linux-2.6.35.y.orig/security/integrity/ima/ima_policy.c
+++ linux-2.6.35.y/security/integrity/ima/ima_policy.c
@@ -253,6 +253,8 @@ static int ima_lsm_rule_init(struct ima_
 	result = security_filter_rule_init(entry->lsm[lsm_rule].type,
 					   Audit_equal, args,
 					   &entry->lsm[lsm_rule].rule);
+	if (!entry->lsm[lsm_rule].rule)
+		return -EINVAL;
 	return result;
 }
 
