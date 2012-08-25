Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2HYX7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 19:59:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33039 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2HYX7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 19:59:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>
References: <87lih2h6i4.fsf@xmission.com>
Date: Sat, 25 Aug 2012 16:59:04 -0700
In-Reply-To: <87lih2h6i4.fsf@xmission.com> (Eric W. Biederman's message of
	"Sat, 25 Aug 2012 16:54:59 -0700")
Message-ID: <877gsmh6bb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/913tLnU1li8OxoHL8YiDK0buDyyeaC0g=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 02/15] userns: Make credential debugging user namespace safe.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig  |    1 -
 kernel/cred.c |   10 ++++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 448b701..fdabc51 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -936,7 +936,6 @@ config UIDGID_CONVERTED
 	depends on FS_POSIX_ACL = n
 	depends on QUOTA = n
 	depends on QUOTACTL = n
-	depends on DEBUG_CREDENTIALS = n
 	depends on BSD_PROCESS_ACCT = n
 	depends on DRM = n
 	depends on PROC_EVENTS = n
diff --git a/kernel/cred.c b/kernel/cred.c
index de728ac..48cea3d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -799,9 +799,15 @@ static void dump_invalid_creds(const struct cred *cred, const char *label,
 	       atomic_read(&cred->usage),
 	       read_cred_subscribers(cred));
 	printk(KERN_ERR "CRED: ->*uid = { %d,%d,%d,%d }\n",
-	       cred->uid, cred->euid, cred->suid, cred->fsuid);
+		from_kuid_munged(&init_user_ns, cred->uid),
+		from_kuid_munged(&init_user_ns, cred->euid),
+		from_kuid_munged(&init_user_ns, cred->suid),
+		from_kuid_munged(&init_user_ns, cred->fsuid));
 	printk(KERN_ERR "CRED: ->*gid = { %d,%d,%d,%d }\n",
-	       cred->gid, cred->egid, cred->sgid, cred->fsgid);
+		from_kgid_munged(&init_user_ns, cred->gid),
+		from_kgid_munged(&init_user_ns, cred->egid),
+		from_kgid_munged(&init_user_ns, cred->sgid),
+		from_kgid_munged(&init_user_ns, cred->fsgid));
 #ifdef CONFIG_SECURITY
 	printk(KERN_ERR "CRED: ->security is %p\n", cred->security);
 	if ((unsigned long) cred->security >= PAGE_SIZE &&
-- 
1.7.5.4

