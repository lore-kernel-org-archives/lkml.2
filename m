Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2IUA3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:29:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41725 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2IUA3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:21 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>
Date: Thu, 20 Sep 2012 17:28:40 -0700
Message-Id: <1348187330-6616-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ggKyqqXOwAYoKZe6ITEnTbpFpfYFpa88=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 04/14] userns: Convert selinux to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 security/selinux/selinuxfs.c   |    6 +++---
 security/selinux/ss/services.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 298e695..55af8c5 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -174,7 +174,7 @@ static ssize_t sel_write_enforce(struct file *file, const char __user *buf,
 		audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_STATUS,
 			"enforcing=%d old_enforcing=%d auid=%u ses=%u",
 			new_value, selinux_enforcing,
-			audit_get_loginuid(current),
+			from_kuid(&init_user_ns, audit_get_loginuid(current)),
 			audit_get_sessionid(current));
 		selinux_enforcing = new_value;
 		if (selinux_enforcing)
@@ -305,7 +305,7 @@ static ssize_t sel_write_disable(struct file *file, const char __user *buf,
 			goto out;
 		audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_STATUS,
 			"selinux=0 auid=%u ses=%u",
-			audit_get_loginuid(current),
+			from_kuid(&init_user_ns, audit_get_loginuid(current)),
 			audit_get_sessionid(current));
 	}
 
@@ -551,7 +551,7 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 out1:
 	audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
 		"policy loaded auid=%u ses=%u",
-		audit_get_loginuid(current),
+		from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		audit_get_sessionid(current));
 out:
 	mutex_unlock(&sel_mutex);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 4321b8f..b4feecc 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2440,7 +2440,7 @@ int security_set_bools(int len, int *values)
 				sym_name(&policydb, SYM_BOOLS, i),
 				!!values[i],
 				policydb.bool_val_to_struct[i]->state,
-				audit_get_loginuid(current),
+				from_kuid(&init_user_ns, audit_get_loginuid(current)),
 				audit_get_sessionid(current));
 		}
 		if (values[i])
-- 
1.7.5.4

