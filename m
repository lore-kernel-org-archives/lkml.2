Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1AYAYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:24:52 -0500
Received: from smtp-out.google.com ([74.125.121.67]:59844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1AYAYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:24:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=JxLU6Sn7ZYt8idIpSfJPIWV2fObhOydadxJhidS9oxruK+9Lx/JrkIVydH9rbig7D
	tmiuhWbb8LD/hz2PvZWaA==
Subject: [PATCH v1 1/6] Add oops notification chain.
To: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
From: Mike Waychison <mikew@google.com>
Cc: San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Date: Mon, 24 Jan 2011 16:24:39 -0800
Message-ID: <20110125002439.12637.8515.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Durbin <adurbin@google.com>

Later firmware patches in this series would like to be able to be
notified whenever an oops occurs on the system, so that it can be
recorded in the boot log.

This patch introduces a notifier_block called "oops_notifier_list"
so that drivers can register to get called whenever an Oops is
triggered.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Signed-off-by: Mike Waychison <mikew@google.com>
---
 include/linux/kernel.h   |    3 +++
 include/linux/notifier.h |    3 +++
 kernel/panic.c           |   15 +++++++++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d07d805..2e56fed 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -183,6 +183,9 @@ extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
 extern int oops_may_print(void);
+struct notifier_block;
+extern int register_oops_notifier(struct notifier_block *nb);
+extern int unregister_oops_notifier(struct notifier_block *nb);
 NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 2026f9e..2a121bb 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -217,6 +217,9 @@ static inline int notifier_to_errno(int ret)
 #define SYS_HALT	0x0002	/* Notify of system halt */
 #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
 
+#define OOPS_ENTER	0x0000	/* Notify OOPs has been entered */
+#define OOPS_EXIT	0x0001	/* Notify OOPs has exited */
+
 #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
 #define CPU_ONLINE		0x0002 /* CPU (unsigned)v is up */
diff --git a/kernel/panic.c b/kernel/panic.c
index 991bb87..45a50bb 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -37,6 +37,7 @@ int panic_timeout;
 EXPORT_SYMBOL_GPL(panic_timeout);
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
+static ATOMIC_NOTIFIER_HEAD(oops_notifier_list);
 
 EXPORT_SYMBOL(panic_notifier_list);
 
@@ -321,6 +322,7 @@ void oops_enter(void)
 	/* can't trust the integrity of the kernel anymore: */
 	debug_locks_off();
 	do_oops_enter_exit();
+	atomic_notifier_call_chain(&oops_notifier_list, OOPS_ENTER, NULL);
 }
 
 /*
@@ -355,6 +357,7 @@ void oops_exit(void)
 	do_oops_enter_exit();
 	print_oops_end_marker();
 	kmsg_dump(KMSG_DUMP_OOPS);
+	atomic_notifier_call_chain(&oops_notifier_list, OOPS_EXIT, NULL);
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
@@ -431,5 +434,17 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 #endif
 
+int register_oops_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&oops_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(register_oops_notifier);
+
+int unregister_oops_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&oops_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_oops_notifier);
+
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);

