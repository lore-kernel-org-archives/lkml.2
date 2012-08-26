Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2HZADR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 20:03:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33330 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2HZADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 20:03:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Miller <davem@davemloft.net>
References: <87lih2h6i4.fsf@xmission.com>
Date: Sat, 25 Aug 2012 17:02:59 -0700
In-Reply-To: <87lih2h6i4.fsf@xmission.com> (Eric W. Biederman's message of
	"Sat, 25 Aug 2012 16:54:59 -0700")
Message-ID: <877gsmfrkc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19xSlGNxocmE0TxftYu1pWhaIXqDeSQvxQ=
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
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 09/15] userns: Convert process event connector to handle kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Only allow asking for events from the initial user and pid namespace,
  where we generate the events in.

- Convert kuids and kgids into the initial user namespace to report
  them via the process event connector.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Miller <davem@davemloft.net>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/connector/cn_proc.c |   18 ++++++++++++++----
 init/Kconfig                |    1 -
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 3e92b7d..fce2000 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -30,6 +30,7 @@
 #include <linux/gfp.h>
 #include <linux/ptrace.h>
 #include <linux/atomic.h>
+#include <linux/pid_namespace.h>
 
 #include <asm/unaligned.h>
 
@@ -127,11 +128,11 @@ void proc_id_connector(struct task_struct *task, int which_id)
 	rcu_read_lock();
 	cred = __task_cred(task);
 	if (which_id == PROC_EVENT_UID) {
-		ev->event_data.id.r.ruid = cred->uid;
-		ev->event_data.id.e.euid = cred->euid;
+		ev->event_data.id.r.ruid = from_kuid_munged(&init_user_ns, cred->uid);
+		ev->event_data.id.e.euid = from_kuid_munged(&init_user_ns, cred->euid);
 	} else if (which_id == PROC_EVENT_GID) {
-		ev->event_data.id.r.rgid = cred->gid;
-		ev->event_data.id.e.egid = cred->egid;
+		ev->event_data.id.r.rgid = from_kgid_munged(&init_user_ns, cred->gid);
+		ev->event_data.id.e.egid = from_kgid_munged(&init_user_ns, cred->egid);
 	} else {
 		rcu_read_unlock();
 		return;
@@ -303,6 +304,15 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 	if (msg->len != sizeof(*mc_op))
 		return;
 
+	/* 
+	 * Events are reported with respect to the initial pid
+	 * and user namespaces so ignore requestors from
+	 * other namespaces.
+	 */
+	if ((current_user_ns() != &init_user_ns) ||
+	    (task_active_pid_ns(current) != &init_pid_ns))
+		return;
+
 	mc_op = (enum proc_cn_mcast_op *)msg->data;
 	switch (*mc_op) {
 	case PROC_CN_MCAST_LISTEN:
diff --git a/init/Kconfig b/init/Kconfig
index 6c9d004..7327869 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -932,7 +932,6 @@ config UIDGID_CONVERTED
 	depends on QUOTA = n
 	depends on QUOTACTL = n
 	depends on DRM = n
-	depends on PROC_EVENTS = n
 
 	# Networking
 	depends on NET_9P = n
-- 
1.7.5.4

