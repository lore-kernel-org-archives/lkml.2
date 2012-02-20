Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab2BTGF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:05:28 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56036 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2BTGF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:05:27 -0500
Message-ID: <1329717879.3448.30.camel@ThinkPad-T61>
Subject: [PATCH 1/2 x86] fix page faults by nmi handler in nmi if kmemcheck
 is enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Date: Mon, 20 Feb 2012 14:04:39 +0800
In-Reply-To: <1329717665.3448.28.camel@ThinkPad-T61>
References: <1329717665.3448.28.camel@ThinkPad-T61>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12022006-4790-0000-0000-00000166F26A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to
  change the nmi handler name from a pointer to an array. 
  use __get_free_pages instead of kzalloc if CONFIG_KMEMCHECK is
enabled.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/x86/kernel/nmi.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..84aa03a 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -36,7 +36,7 @@ struct nmiaction {
 	struct list_head list;
 	nmi_handler_t handler;
 	unsigned int flags;
-	char *name;
+	char name[NMI_MAX_NAMELEN];
 };
 
 struct nmi_desc {
@@ -169,16 +169,18 @@ int register_nmi_handler(unsigned int type,
nmi_handler_t handler,
 	if (!handler)
 		return -EINVAL;
 
+#ifdef CONFIG_KMEMCHECK
+	action = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+				get_order(sizeof(*action)));
+#else
 	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
+#endif
 	if (!action)
 		goto fail_action;
 
 	action->handler = handler;
 	action->flags = nmiflags;
-	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
-	if (!action->name)
-		goto fail_action_name;
-
+	strncpy(action->name, devname, sizeof(action->name));
 	retval = __setup_nmi(type, action);
 
 	if (retval)
@@ -187,9 +189,11 @@ int register_nmi_handler(unsigned int type,
nmi_handler_t handler,
 	return retval;
 
 fail_setup_nmi:
-	kfree(action->name);
-fail_action_name:
+#ifdef CONFIG_KMEMCHECK
+	free_pages((unsigned long)action, get_order(sizeof(*action)));
+#else
 	kfree(action);
+#endif
 fail_action:	
 
 	return retval;
@@ -202,8 +206,11 @@ void unregister_nmi_handler(unsigned int type,
const char *name)
 
 	a = __free_nmi(type, name);
 	if (a) {
-		kfree(a->name);
+#ifdef CONFIG_KMEMCHECK
+		free_pages((unsigned long)a, get_order(sizeof(*a)));
+#else
 		kfree(a);
+#endif
 	}
 }
 
-- 
1.7.5.4

