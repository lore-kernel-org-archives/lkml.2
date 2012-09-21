Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2IUAbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:31:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41738 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab2IUA3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:34 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mimi Zohar <zohar@us.ibm.com>
Date: Thu, 20 Sep 2012 17:28:42 -0700
Message-Id: <1348187330-6616-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ZoPSdpsrdN1x97dLYQlfYN2e8yRcLbig=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1538]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 06/14] userns: Convert EVM to deal with kuids and kgids in it's hmac computation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig                        |    1 -
 security/integrity/evm/evm_crypto.c |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 8450442..96ee3f3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -926,7 +926,6 @@ config UIDGID_CONVERTED
 	# List of kernel pieces that need user namespace work
 	# Features
 	depends on IMA = n
-	depends on EVM = n
 
 	# Networking
 	depends on NET_9P = n
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 49a464f..dfb2691 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -106,8 +106,8 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
 	memset(&hmac_misc, 0, sizeof hmac_misc);
 	hmac_misc.ino = inode->i_ino;
 	hmac_misc.generation = inode->i_generation;
-	hmac_misc.uid = inode->i_uid;
-	hmac_misc.gid = inode->i_gid;
+	hmac_misc.uid = from_kuid(&init_user_ns, inode->i_uid);
+	hmac_misc.gid = from_kgid(&init_user_ns, inode->i_gid);
 	hmac_misc.mode = inode->i_mode;
 	crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof hmac_misc);
 	crypto_shash_final(desc, digest);
-- 
1.7.5.4

