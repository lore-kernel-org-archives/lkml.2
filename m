Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2LLQcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:32:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:43313 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab2LLQce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:32:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,267,1355126400"; 
   d="scan'208";a="261183066"
Date: Wed, 12 Dec 2012 18:32:28 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH] x86: Add support for 64bit get_user() on x86-32
Message-ID: <20121212163228.GC29018@intel.com>
References: <1355312043-11467-1-git-send-email-ville.syrjala@linux.intel.com>
 <f29a1b87-4154-4cd5-b17e-d269851fef6c@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f29a1b87-4154-4cd5-b17e-d269851fef6c@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 08:15:12AM -0800, H. Peter Anvin wrote:
> Can we worry about this after the merge window?

Sure. The only use I have for this is in my drm/kms atomic
modeset/pageflip patch set, and that's not 3.8 material.

> 
> ville.syrjala@linux.intel.com wrote:
> 
> >From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >
> >Implement __get_user_8() for x86-32. It will return the
> >64bit result in edx:eax register pair, and ecx is used
> >to pass in the address and return the error value.
> >
> >For consistency, change the register assignment for all
> >other __get_user_x() variants, so that address is passed in
> >ecx/rcx, the error value is returned in ecx/rcx, and eax/rax
> >contains the actual value.
> >
> >This is a partial refresh of a patch [1] by Jamie Lokier from
> >2004. Only the minimal changes to implement 64bit get_user()
> >were picked from the original patch.
> >
> >[1] http://article.gmane.org/gmane.linux.kernel/198823
> >
> >Cc: Jamie Lokier <jamie@shareable.org>
> >Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >---
> > arch/x86/include/asm/uaccess.h  |   17 ++++++--
> > arch/x86/kernel/i386_ksyms_32.c |    1 +
> >arch/x86/lib/getuser.S          |   82
> >++++++++++++++++++++++++++------------
> > 3 files changed, 69 insertions(+), 31 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/uaccess.h
> >b/arch/x86/include/asm/uaccess.h
> >index 7ccf8d1..3f4387e 100644
> >--- a/arch/x86/include/asm/uaccess.h
> >+++ b/arch/x86/include/asm/uaccess.h
> >@@ -127,7 +127,7 @@ extern int __get_user_bad(void);
> > 
> > #define __get_user_x(size, ret, x, ptr)		      \
> > 	asm volatile("call __get_user_" #size	      \
> >-		     : "=a" (ret), "=d" (x)	      \
> >+		     : "=c" (ret), "=a" (x)	      \
> > 		     : "0" (ptr))		      \
> > 
> > /* Careful: we have to cast the result to the type of the pointer
> >@@ -151,8 +151,11 @@ extern int __get_user_bad(void);
> >  * On error, the variable @x is set to zero.
> >  */
> > #ifdef CONFIG_X86_32
> >-#define __get_user_8(__ret_gu, __val_gu, ptr)				\
> >-		__get_user_x(X, __ret_gu, __val_gu, ptr)
> >+#define __get_user_8(ret, x, ptr)		      \
> >+	asm volatile("call __get_user_8"	      \
> >+		     : "=c" (ret), "=A" (x)	      \
> >+		     : "0" (ptr))		      \
> >+
> > #else
> > #define __get_user_8(__ret_gu, __val_gu, ptr)				\
> > 		__get_user_x(8, __ret_gu, __val_gu, ptr)
> >@@ -162,6 +165,7 @@ extern int __get_user_bad(void);
> > ({									\
> > 	int __ret_gu;							\
> > 	unsigned long __val_gu;						\
> >+	unsigned long long __val_gu8;					\
> > 	__chk_user_ptr(ptr);						\
> > 	might_fault();							\
> > 	switch (sizeof(*(ptr))) {					\
> >@@ -175,13 +179,16 @@ extern int __get_user_bad(void);
> > 		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
> > 		break;							\
> > 	case 8:								\
> >-		__get_user_8(__ret_gu, __val_gu, ptr);			\
> >+		__get_user_8(__ret_gu, __val_gu8, ptr);			\
> > 		break;							\
> > 	default:							\
> > 		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
> > 		break;							\
> > 	}								\
> >-	(x) = (__typeof__(*(ptr)))__val_gu;				\
> >+	if (sizeof(*(ptr)) == 8)					\
> >+		(x) = (__typeof__(*(ptr)))__val_gu8;			\
> >+	else								\
> >+		(x) = (__typeof__(*(ptr)))__val_gu;			\
> > 	__ret_gu;							\
> > })
> > 
> >diff --git a/arch/x86/kernel/i386_ksyms_32.c
> >b/arch/x86/kernel/i386_ksyms_32.c
> >index 9c3bd4a..0fa6912 100644
> >--- a/arch/x86/kernel/i386_ksyms_32.c
> >+++ b/arch/x86/kernel/i386_ksyms_32.c
> >@@ -26,6 +26,7 @@ EXPORT_SYMBOL(csum_partial_copy_generic);
> > EXPORT_SYMBOL(__get_user_1);
> > EXPORT_SYMBOL(__get_user_2);
> > EXPORT_SYMBOL(__get_user_4);
> >+EXPORT_SYMBOL(__get_user_8);
> > 
> > EXPORT_SYMBOL(__put_user_1);
> > EXPORT_SYMBOL(__put_user_2);
> >diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
> >index 156b9c8..38afef0 100644
> >--- a/arch/x86/lib/getuser.S
> >+++ b/arch/x86/lib/getuser.S
> >@@ -14,12 +14,11 @@
> > /*
> >  * __get_user_X
> >  *
> >- * Inputs:	%[r|e]ax contains the address.
> >- *		The register is modified, but all changes are undone
> >- *		before returning because the C code doesn't know about it.
> >+ * Inputs:	%[r|e]cx contains the address.
> >  *
> >- * Outputs:	%[r|e]ax is error code (0 or -EFAULT)
> >- *		%[r|e]dx contains zero-extended value
> >+ * Outputs:	%[r|e]cx is error code (0 or -EFAULT)
> >+ *		%[r|e]ax contains zero-extended value
> >+ *		%edx contains the high bits of the value for __get_user_8 on
> >x86-32
> >  *
> >  *
> >  * These functions should not modify any other registers,
> >@@ -38,12 +37,12 @@
> > 	.text
> > ENTRY(__get_user_1)
> > 	CFI_STARTPROC
> >-	GET_THREAD_INFO(%_ASM_DX)
> >-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
> >+	GET_THREAD_INFO(%_ASM_AX)
> >+	cmp TI_addr_limit(%_ASM_AX),%_ASM_CX
> > 	jae bad_get_user
> > 	ASM_STAC
> >-1:	movzb (%_ASM_AX),%edx
> >-	xor %eax,%eax
> >+1:	movzb (%_ASM_CX),%eax
> >+	xor %ecx,%ecx
> > 	ASM_CLAC
> > 	ret
> > 	CFI_ENDPROC
> >@@ -51,14 +50,14 @@ ENDPROC(__get_user_1)
> > 
> > ENTRY(__get_user_2)
> > 	CFI_STARTPROC
> >-	add $1,%_ASM_AX
> >+	add $1,%_ASM_CX
> > 	jc bad_get_user
> >-	GET_THREAD_INFO(%_ASM_DX)
> >-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
> >+	GET_THREAD_INFO(%_ASM_AX)
> >+	cmp TI_addr_limit(%_ASM_AX),%_ASM_CX
> > 	jae bad_get_user
> > 	ASM_STAC
> >-2:	movzwl -1(%_ASM_AX),%edx
> >-	xor %eax,%eax
> >+2:	movzwl -1(%_ASM_CX),%eax
> >+	xor %ecx,%ecx
> > 	ASM_CLAC
> > 	ret
> > 	CFI_ENDPROC
> >@@ -66,14 +65,14 @@ ENDPROC(__get_user_2)
> > 
> > ENTRY(__get_user_4)
> > 	CFI_STARTPROC
> >-	add $3,%_ASM_AX
> >+	add $3,%_ASM_CX
> > 	jc bad_get_user
> >-	GET_THREAD_INFO(%_ASM_DX)
> >-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
> >+	GET_THREAD_INFO(%_ASM_AX)
> >+	cmp TI_addr_limit(%_ASM_AX),%_ASM_CX
> > 	jae bad_get_user
> > 	ASM_STAC
> >-3:	mov -3(%_ASM_AX),%edx
> >-	xor %eax,%eax
> >+3:	mov -3(%_ASM_CX),%eax
> >+	xor %ecx,%ecx
> > 	ASM_CLAC
> > 	ret
> > 	CFI_ENDPROC
> >@@ -82,14 +81,30 @@ ENDPROC(__get_user_4)
> > #ifdef CONFIG_X86_64
> > ENTRY(__get_user_8)
> > 	CFI_STARTPROC
> >-	add $7,%_ASM_AX
> >+	add $7,%_ASM_CX
> > 	jc bad_get_user
> >-	GET_THREAD_INFO(%_ASM_DX)
> >-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
> >+	GET_THREAD_INFO(%_ASM_AX)
> >+	cmp TI_addr_limit(%_ASM_AX),%_ASM_CX
> > 	jae	bad_get_user
> > 	ASM_STAC
> >-4:	movq -7(%_ASM_AX),%_ASM_DX
> >-	xor %eax,%eax
> >+4:	movq -7(%_ASM_CX),%_ASM_AX
> >+	xor %ecx,%ecx
> >+	ASM_CLAC
> >+	ret
> >+	CFI_ENDPROC
> >+ENDPROC(__get_user_8)
> >+#else
> >+ENTRY(__get_user_8)
> >+	CFI_STARTPROC
> >+	add $7,%_ASM_CX
> >+	jc bad_get_user_8
> >+	GET_THREAD_INFO(%_ASM_AX)
> >+	cmp TI_addr_limit(%_ASM_AX),%_ASM_CX
> >+	jae	bad_get_user_8
> >+	ASM_STAC
> >+4:	mov -7(%_ASM_CX),%eax
> >+5:	mov -3(%_ASM_CX),%edx
> >+	xor %ecx,%ecx
> > 	ASM_CLAC
> > 	ret
> > 	CFI_ENDPROC
> >@@ -98,16 +113,31 @@ ENDPROC(__get_user_8)
> > 
> > bad_get_user:
> > 	CFI_STARTPROC
> >-	xor %edx,%edx
> >-	mov $(-EFAULT),%_ASM_AX
> >+	xor %eax,%eax
> >+	mov $(-EFAULT),%_ASM_CX
> > 	ASM_CLAC
> > 	ret
> > 	CFI_ENDPROC
> > END(bad_get_user)
> > 
> >+#ifdef CONFIG_X86_32
> >+bad_get_user_8:
> >+	CFI_STARTPROC
> >+	xor %eax,%eax
> >+	xor %edx,%edx
> >+	mov $(-EFAULT),%_ASM_CX
> >+	ASM_CLAC
> >+	ret
> >+	CFI_ENDPROC
> >+END(bad_get_user_8)
> >+#endif
> >+
> > 	_ASM_EXTABLE(1b,bad_get_user)
> > 	_ASM_EXTABLE(2b,bad_get_user)
> > 	_ASM_EXTABLE(3b,bad_get_user)
> > #ifdef CONFIG_X86_64
> > 	_ASM_EXTABLE(4b,bad_get_user)
> >+#else
> >+	_ASM_EXTABLE(4b,bad_get_user_8)
> >+	_ASM_EXTABLE(5b,bad_get_user_8)
> > #endif
> 
> -- 
> Sent from my mobile phone. Please excuse brevity and lack of formatting.

-- 
Ville Syrjälä
Intel OTC
