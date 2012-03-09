Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030744Ab2CITr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:47:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030663Ab2CITrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:55 -0500
Message-Id: <20120309190205.165271653@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Prashanth K Nageshappa <prashanth@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [ 35/95] kprobes: return proper error code from register_kprobe()
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

commit f986a499ef6f317d906e6f6f281be966e1237a10 upstream.

register_kprobe() aborts if the address of the new request falls in a
prohibited area (such as ftrace pouch, __kprobes annotated functions,
non-kernel text addresses, jump label text).  We however don't return the
right error on this abort, resulting in a silent failure - incorrect
adding/reporting of kprobes ('perf probe do_fork+18' or 'perf probe
mcount' for instance).

In V2 we are incorporating Masami Hiramatsu's  feedback.

This patch fixes it by returning -EINVAL upon failure.

While we are here, rename the label used for exit to be more appropriate.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Prashanth K Nageshappa <prashanth@linux.vnet.ibm.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
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
@@ -1409,7 +1411,7 @@ out:
 
 	return ret;
 
-fail_with_jump_label:
+cannot_probe:
 	preempt_enable();
 	jump_label_unlock();
 	return ret;


