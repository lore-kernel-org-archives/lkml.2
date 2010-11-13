Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0KMR0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 12:26:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1078 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab0KMR0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 12:26:18 -0500
Subject: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
From: Joe Perches <joe@perches.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Eugene Teo <eugeneteo@kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 09:26:16 -0800
Message-ID: <1289669176.16461.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmesg_restrict is guarded by #ifdef CONFIG_PRINTK in kernel.h
Its uses need to be guarded as well.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/sysctl.c      |    2 +-
 security/commoncap.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b65bf63..5abfa15 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -702,7 +702,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
-#endif
 	{
 		.procname	= "dmesg_restrict",
 		.data		= &dmesg_restrict,
@@ -712,6 +711,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
diff --git a/security/commoncap.c b/security/commoncap.c
index 04b80f9..29f2368 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -895,8 +895,10 @@ int cap_syslog(int type, bool from_file)
 {
 	if (type != SYSLOG_ACTION_OPEN && from_file)
 		return 0;
+#ifdef CONFIG_PRINTK
 	if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
+#endif
 	if ((type != SYSLOG_ACTION_READ_ALL &&
 	     type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;


