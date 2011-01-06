Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1AFAe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:34:59 -0500
Received: from kroah.org ([198.145.64.141]:36111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab1AFAbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:49 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:09 2011
Message-Id: <20110106002309.860164713@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        David Safford <safford@watson.ibm.com>
Subject: [140/152] ima: fix add LSM rule bug
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Cc: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: David Safford <safford@watson.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/integrity/ima/ima_policy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -253,6 +253,8 @@ static int ima_lsm_rule_init(struct ima_
 	result = security_filter_rule_init(entry->lsm[lsm_rule].type,
 					   Audit_equal, args,
 					   &entry->lsm[lsm_rule].rule);
+	if (!entry->lsm[lsm_rule].rule)
+		return -EINVAL;
 	return result;
 }
 


