Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2BOHUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 02:20:51 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44362 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2BOHUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 02:20:49 -0500
Message-ID: <4F3B5BB3.9030907@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 12:46:03 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
CC: jbaron@redhat.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        stable@vger.kernel.org
Subject: [PATCH v2] Return proper error code from register_kprobe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021507-7282-0000-0000-000006867D60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed lkml in my previous posting, hence resending....

register_kprobe() aborts if the address of the new request falls in a
prohibited area (such as ftrace pouch, __kprobes annotated functions,
non-kernel text addresses, jump label text). We however don't return the
right error on this abort, resulting in a silent failure - incorrect 
adding/reporting of kprobes ('perf probe do_fork+18' or
'perf probe mcount' for instance).

In V2 we are incorporating Masami Hiramatsu's  feedback.

This patch fixes it by returning -EINVAL upon failure.

While we are here, rename the label used for exit to be more appropriate.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Prashanth K Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/kprobes.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-14feb/kernel/kprobes.c
===================================================================
--- linux-14feb.orig/kernel/kprobes.c
+++ linux-14feb/kernel/kprobes.c
@@ -1334,8 +1334,10 @@ int __kprobes register_kprobe(struct kpr
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
 	    ftrace_text_reserved(p->addr, p->addr) ||
-	    jump_label_text_reserved(p->addr, p->addr))
-		goto fail_with_jump_label;
+	    jump_label_text_reserved(p->addr, p->addr)) {
+		ret = -EINVAL;
+		goto cannot_probe;
+	}

 	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
 	p->flags &= KPROBE_FLAG_DISABLED;
@@ -1352,7 +1354,7 @@ int __kprobes register_kprobe(struct kpr
 		 * its code to prohibit unexpected unloading.
 		 */
 		if (unlikely(!try_module_get(probed_mod)))
-			goto fail_with_jump_label;
+			goto cannot_probe;

 		/*
 		 * If the module freed .init.text, we couldn't insert
@@ -1361,7 +1363,7 @@ int __kprobes register_kprobe(struct kpr
 		if (within_module_init((unsigned long)p->addr, probed_mod) &&
 		    probed_mod->state != MODULE_STATE_COMING) {
 			module_put(probed_mod);
-			goto fail_with_jump_label;
+			goto cannot_probe;
 		}
 		/* ret will be updated by following code */
 	}
@@ -1409,7 +1411,7 @@ int __kprobes register_kprobe(struct kpr

 	return ret;

-fail_with_jump_label:
+cannot_probe:
 	preempt_enable();
 	jump_label_unlock();
 	return ret;

