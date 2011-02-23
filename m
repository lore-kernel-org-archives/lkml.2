Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1BWWqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:46:24 -0500
Received: from ozlabs.org ([203.10.76.45]:34626 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab1BWWqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:46:20 -0500
Date: Thu, 24 Feb 2011 09:46:16 +1100
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, msm@freescale.com, john.a.livingston@boeing.com,
        Kyle.D.Moffett@boeing.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: powerpc/kexec: Restore ppc_md.machine_kexec
Message-ID: <20110224094616.3e498154@kryten>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kyle Moffett points out that mpc85xx has started using the
ppc_md.machine_kexec hook. As such, revert patch c94868788cf2
(powerpc/kexec: Remove ppc_md.machine_kexec).

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 991d599..fe56a23 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -240,6 +240,12 @@ struct machdep_calls {
 	 * claims to support kexec.
 	 */
 	int (*machine_kexec_prepare)(struct kimage *image);
+
+	/* Called to perform the _real_ kexec.
+	 * Do NOT allocate memory or fail here. We are past the point of
+	 * no return.
+	 */
+	void (*machine_kexec)(struct kimage *image);
 #endif /* CONFIG_KEXEC */
 
 #ifdef CONFIG_SUSPEND
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index 49a170a..a5f8672 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -87,7 +87,10 @@ void machine_kexec(struct kimage *image)
 
 	save_ftrace_enabled = __ftrace_enabled_save();
 
-	default_machine_kexec(image);
+	if (ppc_md.machine_kexec)
+		ppc_md.machine_kexec(image);
+	else
+		default_machine_kexec(image);
 
 	__ftrace_enabled_restore(save_ftrace_enabled);
 
