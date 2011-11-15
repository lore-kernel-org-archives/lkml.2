Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1KOBPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 20:15:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:49896 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1KOBPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 20:15:54 -0500
Date: Tue, 15 Nov 2011 02:15:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.2-rc1-rt2
Message-ID: <alpine.LFD.2.02.1111150050590.4902@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.2-rc1-rt2 release.

Changes vs. 3.2-rc1-rt2:

  * Add missing softirq export (John Kacur)

  * Fix rcu macro substitution (John Kacur)

  * Fix device mapper BUG_ON (Reported by Luis Claudio)

  * Fix x86 aesni (crypto) preemption problem (Peter Zijlstra,
    reported by Carsten Emde)

  * Fix UP (tiny) RCU build issues (Reported by Tim Sanders)


3.2-rc1-rt2 is not against 3.2-rc1 - it's against the post rc1
commit 52e4c2a05256cb83cda12f3c2137ab1533344edb.

   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=52e4c2a05256cb83cda12f3c2137ab1533344edb


For non git users conveniance I uploaded a delta patch against
3.2-rc1:

   https://tglx.de/~tglx/rt/3.2/base/patch-3.2-rc1-52e4c2a05.patch.gz

to get the base kernel on which the RT patch applies.


The incremental patch against 3.2-rc1-rt1 can be found here:

    https://tglx.de/~tglx/rt/3.2/incr/patch-3.2-rc1-52e4c2a05-rt1-rt2.patch.gz

and is also appended below.


The RT patch against 3.2-rc1-52e4c2a05 can be found here:

   https://tglx.de/~tglx/rt/3.2/patch-3.2-rc1-52e4c2a05-rt2.patch.gz


The split quilt queue is available at:

   https://tglx.de/~tglx/rt/3.2/patches-3.2-rc1-52e4c2a05-rt2.tar.gz


I got several private (sigh) questions about the signature files which
can be found beside the release files.

 The signature file is a gpg detached signature signed with my signing
 key against the _uncompressed_ file.

 In order to verify the signature, download both the release file and
 the signature file (which has ".sig" appended to the release file),
 e.g.:

  wget https://tglx.de/~tglx/rt/3.2/incr/patch-3.2-rc1-52e4c2a05-rt1-rt2.patch.gz
  wget https://tglx.de/~tglx/rt/3.2/incr/patch-3.2-rc1-52e4c2a05-rt1-rt2.patch.sign

 Now decompress the release file:

  gunzip patch-3.2-rc1-52e4c2a05-rt1-rt2.patch.gz

 Make sure that you have my gpg key in your gpg keyring

  gpg --recv-keys 06FF0B14

 Now verify against the signature:

  gpg --verify patch-3.2-rc1-52e4c2a05-rt1-rt2.patch.sign patch-3.2-rc1-52e4c2a05-rt1-rt2.patch.gz

 That should give you something like

  gpg: Signature made Tue 15 Nov 2011 12:47:24 AM CET using RSA key ID 0D7498A1
  gpg: Good signature from "Thomas Gleixner <tglx@linutronix.de>"
  gpg:                 aka "Thomas Gleixner <tglx@glx-um.de>"
  gpg:                 aka "Thomas Gleixner <tglx@tglx.de>"
  gpg: WARNING: This key is not certified with a trusted signature!
  gpg:          There is no indication that the signature belongs to the owner.

 The last two lines are because you do not trust my key when you
 downloaded it, but that's your decision to make :)

Enjoy,

	tglx
---
Index: linux-3.2/include/linux/rcutree.h
===================================================================
--- linux-3.2.orig/include/linux/rcutree.h
+++ linux-3.2/include/linux/rcutree.h
@@ -60,7 +60,7 @@ static inline void exit_rcu(void)
 #ifndef CONFIG_PREEMPT_RT_FULL
 extern void synchronize_rcu_bh(void);
 #else
-# define synchronize_rcu_bh()	synchronize_rcu()
+# define synchronize_rcu_bh	synchronize_rcu
 #endif
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
Index: linux-3.2/init/Kconfig
===================================================================
--- linux-3.2.orig/init/Kconfig
+++ linux-3.2/init/Kconfig
@@ -410,7 +410,7 @@ config TINY_RCU
 
 config TINY_PREEMPT_RCU
 	bool "Preemptible UP-only small-memory-footprint RCU"
-	depends on PREEMPT && !SMP && !PREEMPT_RT_FULL
+	depends on PREEMPT && !SMP
 	help
 	  This option selects the RCU implementation that is designed
 	  for real-time UP systems.  This option greatly reduces the
Index: linux-3.2/kernel/softirq.c
===================================================================
--- linux-3.2.orig/kernel/softirq.c
+++ linux-3.2/kernel/softirq.c
@@ -447,6 +447,7 @@ int in_serving_softirq(void)
 	preempt_enable();
 	return res;
 }
+EXPORT_SYMBOL(in_serving_softirq);
 
 /*
  * Called with bh and local interrupts disabled. For full RT cpu must
Index: linux-3.2/localversion-rt
===================================================================
--- linux-3.2.orig/localversion-rt
+++ linux-3.2/localversion-rt
@@ -1 +1 @@
--rt1
+-rt2
Index: linux-3.2/include/linux/sysctl.h
===================================================================
--- linux-3.2.orig/include/linux/sysctl.h
+++ linux-3.2/include/linux/sysctl.h
@@ -932,6 +932,7 @@ enum
 #include <linux/list.h>
 #include <linux/rcupdate.h>
 #include <linux/wait.h>
+#include <linux/atomic.h>
 
 /* For the /proc/sys support */
 struct ctl_table;
Index: linux-3.2/kernel/rcutiny.c
===================================================================
--- linux-3.2.orig/kernel/rcutiny.c
+++ linux-3.2/kernel/rcutiny.c
@@ -243,6 +243,7 @@ void call_rcu_sched(struct rcu_head *hea
 }
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * Post an RCU bottom-half callback to be invoked after any subsequent
  * quiescent state.
@@ -252,3 +253,4 @@ void call_rcu_bh(struct rcu_head *head, 
 	__call_rcu(head, func, &rcu_bh_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
+#endif
Index: linux-3.2/arch/x86/crypto/aesni-intel_glue.c
===================================================================
--- linux-3.2.orig/arch/x86/crypto/aesni-intel_glue.c
+++ linux-3.2/arch/x86/crypto/aesni-intel_glue.c
@@ -289,14 +289,14 @@ static int ecb_encrypt(struct blkcipher_
 	err = blkcipher_walk_virt(desc, &walk);
 	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK);
+				nbytes & AES_BLOCK_MASK);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
@@ -313,14 +313,14 @@ static int ecb_decrypt(struct blkcipher_
 	err = blkcipher_walk_virt(desc, &walk);
 	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_ecb_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
@@ -359,14 +359,14 @@ static int cbc_encrypt(struct blkcipher_
 	err = blkcipher_walk_virt(desc, &walk);
 	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
@@ -383,14 +383,14 @@ static int cbc_decrypt(struct blkcipher_
 	err = blkcipher_walk_virt(desc, &walk);
 	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
@@ -445,18 +445,20 @@ static int ctr_crypt(struct blkcipher_de
 	err = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
 	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+		kernel_fpu_begin();
 		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 	if (walk.nbytes) {
+		kernel_fpu_begin();
 		ctr_crypt_final(ctx, &walk);
+		kernel_fpu_end();
 		err = blkcipher_walk_done(desc, &walk, 0);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
Index: linux-3.2/drivers/md/dm.c
===================================================================
--- linux-3.2.orig/drivers/md/dm.c
+++ linux-3.2/drivers/md/dm.c
@@ -1648,14 +1648,14 @@ static void dm_request_fn(struct request
 		if (map_request(ti, clone, md))
 			goto requeued;
 
-		BUG_ON(!irqs_disabled());
+		BUG_ON_NORT(!irqs_disabled());
 		spin_lock(q->queue_lock);
 	}
 
 	goto out;
 
 requeued:
-	BUG_ON(!irqs_disabled());
+	BUG_ON_NORT(!irqs_disabled());
 	spin_lock(q->queue_lock);
 
 delay_and_out:
