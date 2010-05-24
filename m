Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0EXWQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:16:09 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:36736 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0EXWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:16:08 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+3aIibppu0283ogF9SEP3jBthh6QSMg==
X-RZG-CLASS-ID: mo00
Date: Tue, 25 May 2010 00:04:28 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH RT] fix undefined references to kernel_sem
Message-ID: <20100524220428.GA17771@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

protect kernel_sem access with CONFIG_LOCK_KERNEL
lib/kernel_lock.c is compiled conditionally.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 init/main.c      |    4 ++++
 kernel/lockdep.c |    2 ++
 2 files changed, 6 insertions(+)

--- linux-2.6.33-rt.orig/init/main.c
+++ linux-2.6.33-rt/init/main.c
@@ -629,9 +629,13 @@ asmlinkage void __init start_kernel(void
 		 * the lockdep state, so release the one known lock and
 		 * acquire it again after the self-test is done.
 		 */
+#ifdef CONFIG_LOCK_KERNEL
 		mutex_release(&kernel_sem.dep_map, 1, _THIS_IP_);
+#endif
 		locking_selftest();
+#ifdef CONFIG_LOCK_KERNEL
 		mutex_acquire(&kernel_sem.dep_map, 0, 0, _THIS_IP_);
+#endif
 	}
 
 #ifdef CONFIG_BLK_DEV_INITRD
--- linux-2.6.33-rt.orig/kernel/lockdep.c
+++ linux-2.6.33-rt/kernel/lockdep.c
@@ -3608,8 +3608,10 @@ void lockdep_init(void)
 	for (i = 0; i < CHAINHASH_SIZE; i++)
 		INIT_LIST_HEAD(chainhash_table + i);
 
+#ifdef CONFIG_LOCK_KERNEL
 	/* Hack alert ! */
 	lockdep_set_novalidate_class(&kernel_sem);
+#endif
 
 	lockdep_initialized = 1;
 }
