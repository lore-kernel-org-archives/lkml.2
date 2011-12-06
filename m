Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1LFRf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:35:59 -0500
Received: from [205.233.59.134] ([205.233.59.134]:44580 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LFRf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:35:57 -0500
Message-ID: <1323192923.32012.79.camel@twins>
Subject: Re: [PATCH 2/3] sched: Fix compile error for UP,!NOHZ
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Tue, 06 Dec 2011 18:35:23 +0100
In-Reply-To: <20111206172803.473155622@chello.nl>
References: <20111206171534.429636558@chello.nl>
	 <20111206172803.473155622@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gah, wrong patch as nr.2

---
Subject: jump_label: Provide jump_label_key initializers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jul 06 14:20:14 CEST 2011

Provide two initializers for jump_label_key that initialize it enabled
or disabled. Also modify all jump_label code to allow for jump_labels to be
initialized enabled.

Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-p40e3yj21b68y03z1yv825e7@git.kernel.org
---
 include/linux/jump_label.h |    3 +++
 kernel/jump_label.c        |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)
Index: linux-2.6/include/linux/jump_label.h
===================================================================
--- linux-2.6.orig/include/linux/jump_label.h
+++ linux-2.6/include/linux/jump_label.h
@@ -128,4 +128,7 @@ static inline void jump_label_rate_limit
 }
 #endif	/* HAVE_JUMP_LABEL */
 
+#define jump_label_key_enabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(1), })
+#define jump_label_key_disabled	((struct jump_label_key){ .enabled = ATOMIC_INIT(0), })
+
 #endif	/* _LINUX_JUMP_LABEL_H */
Index: linux-2.6/kernel/jump_label.c
===================================================================
--- linux-2.6.orig/kernel/jump_label.c
+++ linux-2.6/kernel/jump_label.c
@@ -248,8 +248,13 @@ void jump_label_apply_nops(struct module
 	if (iter_start == iter_stop)
 		return;
 
-	for (iter = iter_start; iter < iter_stop; iter++)
-		arch_jump_label_transform_static(iter, JUMP_LABEL_DISABLE);
+	for (iter = iter_start; iter < iter_stop; iter++) {
+		struct jump_label_key *iterk;
+
+		iterk = (struct jump_label_key *)(unsigned long)iter->key;
+		arch_jump_label_transform_static(iter, jump_label_enabled(iterk) ?
+				JUMP_LABEL_ENABLE : JUMP_LABEL_DISABLE);
+	}
 }
 
 static int jump_label_add_module(struct module *mod)
@@ -289,8 +294,7 @@ static int jump_label_add_module(struct 
 		key->next = jlm;
 
 		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, iter_stop,
-					    JUMP_LABEL_ENABLE);
+			__jump_label_update(key, iter, iter_stop, JUMP_LABEL_ENABLE);
 	}
 
 	return 0;

