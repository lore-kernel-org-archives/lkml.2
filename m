Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1BWKIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:08:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1BWKIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:08:37 -0500
Subject: Re: [PATCH] jump label: introduce static_branch() interface
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: hpa@zytor.com, mathieu.desnoyers@polymtl.ca, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
References: <201102222228.p1MMSxnT016454@int-mx10.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 11:08:04 +0100
Message-ID: <1298455684.2217.352.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 17:28 -0500, Jason Baron wrote:
> 
> Define:
> 
>         struct jump_label_key jump_key;
> 
> Can be used as:
> 
>         if (static_branch(&jump_key))
>                 do unlikely code
> 
> enable/disale via:
> 
>         jump_label_enable(&jump_key);
>         jump_label_disable(&jump_key);
> 
> that's it! 

I think you'll find jump_label_{inc,dec}() works better ;-)

Also the below cleans up a comment, flips a conditional so that we dno't
evaluate kernel_text_address() for entries we already know are dead and
uses notifier_from_errno() so as not to confuse the notifier code.

---
Index: linux-2.6/kernel/jump_label.c
===================================================================
--- linux-2.6.orig/kernel/jump_label.c
+++ linux-2.6/kernel/jump_label.c
@@ -108,10 +108,12 @@ static void __jump_label_update(struct j
 		struct jump_entry *entry, int enable)
 {
 	for (; entry->key == (jump_label_t)(unsigned long)key; entry++) {
-		/* entry->code set to 0 invalidates module init text sections
-		 * kernel_text_address() verifies we are not in core kernel init
-		 * code */
-		if (kernel_text_address(entry->code) && entry->code)
+		/* 
+		 * entry->code set to 0 invalidates module init text sections
+		 * kernel_text_address() verifies we are not in core kernel
+		 * init code, see jump_label_invalidate_module_init().
+		 */
+		if (entry->code && kernel_text_address(entry->code))
 			arch_jump_label_transform(entry, enable);
 	}
 }
@@ -315,7 +317,8 @@ jump_label_module_notify(struct notifier
 		jump_label_unlock();
 		break;
 	}
-	return ret;
+
+	return notifier_from_errno(ret);
 }
 
 struct notifier_block jump_label_module_nb = {

