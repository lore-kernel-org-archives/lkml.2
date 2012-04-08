Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2DHFVx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:21:53 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:44030 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752479Ab2DHFMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:19 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:10 -0700
Message-Id: <1333862139-31737-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19WKxc3+Ab+V3wMIOjfLYBh1sXNkvwPp+o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
	*  0.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 14/43] userns: Add a Kconfig option to enforce strict kuid and kgid type checks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Make it possible to easily switch between strong mandatory
type checks and relaxed type checks so that the code can
easily be tested with the type checks and then built
with the strong type checks disabled so the resulting
code can be used.

Require strong mandatory type checks when enabling the user namespace.
It is very simple to make a typo and use the wrong type allowing
conversions to/from userspace values to be bypassed by accident,
the strong type checks prevent this.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/uidgid.h |    2 +-
 init/Kconfig           |   12 +++++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index a0addb8..5398568 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -17,7 +17,7 @@
 struct user_namespace;
 extern struct user_namespace init_user_ns;
 
-#if defined(NOTYET)
+#ifdef CONFIG_UIDGID_STRICT_TYPE_CHECKS
 
 typedef struct {
 	uid_t val;
diff --git a/init/Kconfig b/init/Kconfig
index 72f33fa..86cf760 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -828,7 +828,8 @@ config IPC_NS
 config USER_NS
 	bool "User namespace (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	default y
+	select UIDGID_STRICT_TYPE_CHECKS
+	default n
 	help
 	  This allows containers, i.e. vservers, to use user namespaces
 	  to provide different user info for different servers.
@@ -852,6 +853,15 @@ config NET_NS
 
 endif # NAMESPACES
 
+config UIDGID_STRICT_TYPE_CHECKS
+	bool "Require conversions between uid/gids and their internal representation"
+	default n
+	help
+	 While the nececessary conversions are being added to all subsystems this option allows
+	 the code to continue to build for unconverted subsystems.
+
+	 Say Y here if you want the strict type checking enabled
+
 config SCHED_AUTOGROUP
 	bool "Automatic process group scheduling"
 	select EVENTFD
-- 
1.7.2.5

