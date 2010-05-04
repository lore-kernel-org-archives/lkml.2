Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab0EDNCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:02:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62583 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0EDNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=GBuQZY038e71dGlwQwnADiV4PzfI9XkWuXKzN+QKRZmeOSE+0AdGY3b6C9Imo82qA3
         xqa2NfE4GGzBkXY7nm9SkBN8HOmjnauRQt1DwEFOwmLK5l6CVRugZTcEmjQivAiYVOXa
         pXPSz4njKRUNLZb3GQjPLtwOzIHN3IFwx7I/U=
Date: Tue, 4 May 2010 22:02:47 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 5/12] x86: introduce __set_bit() like function for
 bitmaps in user space
Message-Id: <20100504220247.2e97ac01.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the work of KVM's dirty page logging optimization, we encountered
the need of manipulating bitmaps in user space efficiantly. To achive this,
we introduce a uaccess function for setting a bit in user space following
Avi's suggestion.

  KVM is now using dirty bitmaps for live-migration and VGA. Although we need
  to update them from kernel side, copying them every time for updating the
  dirty log is a big bottleneck. Especially, we tested that zero-copy bitmap
  manipulation improves responses of GUI manipulations a lot.

We also found one similar need in drivers/vhost/vhost.c in which the author
implemented set_bit_to_user() locally using inefficient functions: see TODO
at the top of that.

Probably, this kind of need would be common for virtualization area.

So we introduce a macro set_bit_user_non_atomic() following the implementation
style of x86's uaccess functions.

Note: there is a one restriction to this macro: bitmaps must be 64-bit
aligned (see the comment in this patch).

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/uaccess.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index abd3e0e..3138e65 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -98,6 +98,45 @@ struct exception_table_entry {
 
 extern int fixup_exception(struct pt_regs *regs);
 
+/**
+ * set_bit_user_non_atomic: - set a bit of a bitmap in user space.
+ * @nr:   Bit offset.
+ * @addr: Base address of a bitmap in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro set a bit of a bitmap in user space.
+ *
+ * Restriction: the bitmap pointed to by @addr must be 64-bit aligned:
+ * the kernel accesses the bitmap by its own word length, so bitmaps
+ * allocated by 32-bit processes may cause fault.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+#define __set_bit_user_non_atomic_asm(nr, addr, err, errret)		\
+	asm volatile("1:	bts %1,%2\n"				\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:	mov %3,%0\n"				\
+		     "	jmp 2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : "=r"(err)					\
+		     : "r" (nr), "m" (__m(addr)), "i" (errret), "0" (err))
+
+#define set_bit_user_non_atomic(nr, addr)				\
+({									\
+	int __ret_sbu;							\
+									\
+	might_fault();							\
+	if (access_ok(VERIFY_WRITE, addr, nr/8 + 1))			\
+		__set_bit_user_non_atomic_asm(nr, addr,	__ret_sbu, -EFAULT);\
+	else								\
+		__ret_sbu = -EFAULT;					\
+									\
+	__ret_sbu;							\
+})
+
 /*
  * These are the main single-value transfer routines.  They automatically
  * use the right size if we just have the right pointer type.
-- 
1.7.0.4

