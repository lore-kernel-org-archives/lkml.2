Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2IUAm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:42:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56960 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab2IUAlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:41:49 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 20 Sep 2012 17:28:47 -0700
Message-Id: <1348187330-6616-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+us6ZWIdPDeWGgfPfHOZPQ654LFxQCnLc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1929]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 
X-Spam-Combo: ****;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 11/14] userns: Convert s390 getting uid and gid system calls to use kuid and kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Convert getresuid, getresgid, getuid, geteuid, getgid, getegid

Convert struct cred kuids and kgids into userspace uids and gids when
returning them.

These s390 system calls slipped through the cracks in my first
round of converstions :(

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/s390/kernel/compat_linux.c |   36 ++++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index d122508..73995a7 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -131,13 +131,19 @@ asmlinkage long sys32_setresuid16(u16 ruid, u16 euid, u16 suid)
 		low2highuid(suid));
 }
 
-asmlinkage long sys32_getresuid16(u16 __user *ruid, u16 __user *euid, u16 __user *suid)
+asmlinkage long sys32_getresuid16(u16 __user *ruidp, u16 __user *euidp, u16 __user *suidp)
 {
+	const struct cred *cred = current_cred();
 	int retval;
+	u16 ruid, euid, suid;
 
-	if (!(retval = put_user(high2lowuid(current->cred->uid), ruid)) &&
-	    !(retval = put_user(high2lowuid(current->cred->euid), euid)))
-		retval = put_user(high2lowuid(current->cred->suid), suid);
+	ruid = high2lowuid(from_kuid_munged(cred->user_ns, cred->uid));
+	euid = high2lowuid(from_kuid_munged(cred->user_ns, cred->euid));
+	suid = high2lowuid(from_kuid_munged(cred->user_ns, cred->suid));
+
+	if (!(retval   = put_user(ruid, ruidp)) &&
+	    !(retval   = put_user(euid, euidp)))
+		retval = put_user(suid, suidp);
 
 	return retval;
 }
@@ -148,13 +154,19 @@ asmlinkage long sys32_setresgid16(u16 rgid, u16 egid, u16 sgid)
 		low2highgid(sgid));
 }
 
-asmlinkage long sys32_getresgid16(u16 __user *rgid, u16 __user *egid, u16 __user *sgid)
+asmlinkage long sys32_getresgid16(u16 __user *rgidp, u16 __user *egidp, u16 __user *sgidp)
 {
+	const struct cred *cred = current_cred();
 	int retval;
+	u16 rgid, egid, sgid;
+
+	rgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->gid));
+	egid = high2lowgid(from_kgid_munged(cred->user_ns, cred->egid));
+	sgid = high2lowgid(from_kgid_munged(cred->user_ns, cred->sgid));
 
-	if (!(retval = put_user(high2lowgid(current->cred->gid), rgid)) &&
-	    !(retval = put_user(high2lowgid(current->cred->egid), egid)))
-		retval = put_user(high2lowgid(current->cred->sgid), sgid);
+	if (!(retval   = put_user(rgid, rgidp)) &&
+	    !(retval   = put_user(egid, egidp)))
+		retval = put_user(sgid, sgidp);
 
 	return retval;
 }
@@ -258,22 +270,22 @@ asmlinkage long sys32_setgroups16(int gidsetsize, u16 __user *grouplist)
 
 asmlinkage long sys32_getuid16(void)
 {
-	return high2lowuid(current->cred->uid);
+	return high2lowuid(from_kuid_munged(current_user_ns(), current_uid()));
 }
 
 asmlinkage long sys32_geteuid16(void)
 {
-	return high2lowuid(current->cred->euid);
+	return high2lowuid(from_kuid_munged(current_user_ns(), current_euid()));
 }
 
 asmlinkage long sys32_getgid16(void)
 {
-	return high2lowgid(current->cred->gid);
+	return high2lowgid(from_kgid_munged(current_user_ns(), current_gid()));
 }
 
 asmlinkage long sys32_getegid16(void)
 {
-	return high2lowgid(current->cred->egid);
+	return high2lowgid(from_kgid_munged(current_user_ns(), current_egid()));
 }
 
 /*
-- 
1.7.5.4

