Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0DVQXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:23:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45177 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0DVQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qjV4KT4bzPENvKMCjcXYiao4pvgI7z5YvXYjVofaukC2juZ11Du5ZniG/pG7l4DS1l
         ccplJSPsWUAjJPvEbgonMGb+s/ggt6cuvPz7M4FnqIqGd52gVG9buvsp+gvBqNpxH60L
         sji4K0ZEPCjxbWcUR/CNFMar5alYT+Lfs/Ar4=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Haren Myneni <hbabu@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: [PATCH 1/5] Introduce second memory resource for crash kernel
Date: Thu, 22 Apr 2010 18:23:08 +0200
Message-Id: <1271953392-6324-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently crash kernel uses only one memory region (described by
struct resource). When this region gets enough large, there may appear
a problem to reside this region in a valid addresses range.

This patch introduces second memory region, which may be also used by
crash kernel. First region may be enough small to place only kernel
and initrd images at low addresses, and second region may be placed
almost anywhere.

Second memory resource has another name with aim not to confuse
existing userspace utilities, like kexec.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 include/linux/kexec.h |    1 +
 kernel/kexec.c        |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 03e8e8d..1a3b0a3 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -198,6 +198,7 @@ extern struct kimage *kexec_crash_image;
 /* Location of a reserved region to hold the crash kernel.
  */
 extern struct resource crashk_res;
+extern struct resource crashk_res_hi;
 typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
 extern note_buf_t __percpu *crash_notes;
 extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 87ebe8a..1bd0199 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -49,7 +49,7 @@ u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 
-/* Location of the reserved area for the crash kernel */
+/* Location of the reserved area for the crash kernel in low memory */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
 	.start = 0,
@@ -57,6 +57,14 @@ struct resource crashk_res = {
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
 };
 
+/* Location of the reserved area for the crash kernel in high memory */
+struct resource crashk_res_hi = {
+	.name  = "Crash high memory",
+	.start = 0,
+	.end   = 0,
+	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
 int kexec_should_crash(struct task_struct *p)
 {
 	if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
@@ -1092,6 +1100,7 @@ size_t crash_get_memory_size(void)
 	size_t size;
 	mutex_lock(&kexec_mutex);
 	size = crashk_res.end - crashk_res.start + 1;
+	size += crashk_res_hi.end - crashk_res_hi.start + 1;
 	mutex_unlock(&kexec_mutex);
 	return size;
 }
-- 
1.7.0.1

