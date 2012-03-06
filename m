Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311Ab2CFKJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:09:58 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40766 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813Ab2CFKJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:09:55 -0500
Message-ID: <1331028583.15778.3.camel@ThinkPad-T61>
Subject: Re: [PATCH v3 x86 1/2]  fix page faults by nmiaction in nmi if
 kmemcheck is enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net,
        Vegard Nossum <vegardno@ifi.uio.no>, tony.luck@intel.com, bp@amd64.org,
        robert.richter@amd.com, lenb@kernel.org, minyard@acm.org,
        wim@iguana.be, linux-edac@vger.kernel.org, oprofile-list@lists.sf.net,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        linux-watchdog@vger.kernel.org
Date: Tue, 06 Mar 2012 18:09:43 +0800
In-Reply-To: <20120305214545.GH3083@redhat.com>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
	 <1329819437.2293.382.camel@twins> <1329990828.19165.36.camel@ThinkPad-T61>
	 <1330340324.11248.60.camel@twins> <1330941917.24353.63.camel@ThinkPad-T61>
	 <1330969747.11248.250.camel@twins> <20120305214545.GH3083@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12030601-3568-0000-0000-000001520A7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to fix the problem of page fault exception caused by
accessing nmiaction structure in nmi if kmemcheck is enabled. 

If kmemcheck is enabled, the memory allocated through slab are in pages
that are marked non-present, so that some checks could be done in the
page fault handling code ( e.g. whether the memory is read before
written to ). 
As nmiaction is allocated in this way, so it resides in a non-present
page. Then there is a page fault while the nmi code accessing the
nmiaction structure, which would then cause a warning by
WARN_ON_ONCE(in_nmi()) in kmemcheck_fault(), called by do_page_fault().

v2: as Peter suggested, changed the nmiaction to use static storage.

v3: as Peter suggested, use macro to shorten the codes. Also keep the
original usage of register_nmi_handler, so users of this call doesn't
need change. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/nmi.h |   19 ++++++++++++++-
 arch/x86/kernel/nmi.c      |   52
++++++--------------------------------------
 2 files changed, 24 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index fd3f9f1..5a2b2c6 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -35,8 +35,23 @@ enum {
 
 typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 
-int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
-			 const char *);
+struct nmiaction {
+	struct list_head list;
+	nmi_handler_t handler;
+	unsigned int flags;
+	const char *name;
+};
+
+#define register_nmi_handler(t, fn, fg, n)		\
+({							\
+	static struct nmiaction fn##_na = {		\
+		.handler = (fn),			\
+		.name = (n),				\
+	};						\
+	__register_nmi_handler((t), (fg), &fn##_na);	\
+})
+
+int __register_nmi_handler(unsigned int, unsigned int, struct nmiaction
*);
 
 void unregister_nmi_handler(unsigned int, const char *);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..a097559 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -31,14 +31,6 @@
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
 
-#define NMI_MAX_NAMELEN	16
-struct nmiaction {
-	struct list_head list;
-	nmi_handler_t handler;
-	unsigned int flags;
-	char *name;
-};
-
 struct nmi_desc {
 	spinlock_t lock;
 	struct list_head head;
@@ -160,51 +152,21 @@ static struct nmiaction *__free_nmi(unsigned int
type, const char *name)
 	return (n);
 }
 
-int register_nmi_handler(unsigned int type, nmi_handler_t handler,
-			unsigned long nmiflags, const char *devname)
+int __register_nmi_handler(unsigned int type, unsigned int nmiflags,
+						struct nmiaction *na)
 {
-	struct nmiaction *action;
-	int retval = -ENOMEM;
-
-	if (!handler)
+	if (!na->handler)
 		return -EINVAL;
 
-	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
-	if (!action)
-		goto fail_action;
-
-	action->handler = handler;
-	action->flags = nmiflags;
-	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
-	if (!action->name)
-		goto fail_action_name;
-
-	retval = __setup_nmi(type, action);
-
-	if (retval)
-		goto fail_setup_nmi;
+	na->flags = nmiflags;
 
-	return retval;
-
-fail_setup_nmi:
-	kfree(action->name);
-fail_action_name:
-	kfree(action);
-fail_action:	
-
-	return retval;
+	return __setup_nmi(type, na);
 }
-EXPORT_SYMBOL_GPL(register_nmi_handler);
+EXPORT_SYMBOL_GPL(__register_nmi_handler);
 
 void unregister_nmi_handler(unsigned int type, const char *name)
 {
-	struct nmiaction *a;
-
-	a = __free_nmi(type, name);
-	if (a) {
-		kfree(a->name);
-		kfree(a);
-	}
+	__free_nmi(type, name);
 }
 
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
-- 
1.7.1

