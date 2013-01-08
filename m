Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3AHCJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:09:16 -0500
Received: from nm23.access.bullet.mail.sp2.yahoo.com ([98.139.44.150]:35936
	"EHLO nm23.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094Ab3AHCJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:12 -0500
X-Yahoo-Newman-Id: 6774.70330.bm@smtp102.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 78yRTuUVM1nCnfkdFt7l1M3bZC9z7oUPM6irPfMKGz5mrM2
 2JaPKQ6tbt3bc8Yl7QxntVoHCM3t6qJU4pXhrIVwWqpZW2BqLFrSm2axI8_Z
 RFiPfCiQyxzCOfy2AdCnjo9o6k78ONx45eYLskvCMv82wNPNSdRCv8QOs6OO
 eTVd5dIifMT9F52DpvkkSf.NmScKRuHSB7cF1UDJwKV1pfjHoSqzX6.fMtRL
 hi9GdFHJ0YZW4Abn2ikxshodCK8N.jBLzmQt_9VxXsY9P3N6pL2RxAkLif8n
 DGHMCF.uN8zanLSmEhbUPyIYilhmC7G9Prgu.qDNb8LY3_PFf6Tr8TCTKsD5
 61VVC95MkzpX8q5JkubtnPCJoz4.zXaw5Q8sy0ZfHPMQ.8QF0wrXWerl0VlH
 RPQ5jxk6SDOSS2Av2uj3w8TEXS7bot7lqSHHsXVyDEfbmjWL0iduwqXGpU6u
 thKN7
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB7FD6.7070207@schaufler-ca.com>
Date: Mon, 07 Jan 2013 18:09:26 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v12 5/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com>
In-Reply-To: <50EB7C50.3070605@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH v12 5/9] LSM: Multiple concurrent LSMs

Change the infrastructure for Linux Security Modules (LSM)s
from a single vector of hook handlers to a list based method
for handling multiple concurrent modules. 

Add per-LSM interfaces in /proc/*/attr as it is infeasible
to share them when more than one LSM is active.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 fs/proc/base.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9b43ff77..458422b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2216,12 +2216,28 @@ static const struct file_operations proc_pid_attr_operations = {
 };
 
 static const struct pid_entry attr_dir_stuff[] = {
-	REG("current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("prev",       S_IRUGO,	   proc_pid_attr_operations),
-	REG("exec",       S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
-	REG("sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("current",            S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("prev",               S_IRUGO,	   proc_pid_attr_operations),
+	REG("exec",               S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("fscreate",           S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("keycreate",          S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("sockcreate",         S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#ifdef CONFIG_SECURITY_SELINUX
+	REG("selinux.current",    S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.prev",       S_IRUGO,	   proc_pid_attr_operations),
+	REG("selinux.exec",       S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.fscreate",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.keycreate",  S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("selinux.sockcreate", S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
+#ifdef CONFIG_SECURITY_SMACK
+	REG("smack.current",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
+#ifdef CONFIG_SECURITY_APPARMOR
+	REG("apparmor.current",   S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+	REG("apparmor.prev",      S_IRUGO,	   proc_pid_attr_operations),
+	REG("apparmor.exec",      S_IRUGO|S_IWUGO, proc_pid_attr_operations),
+#endif
 };
 
 static int proc_attr_dir_readdir(struct file * filp,

