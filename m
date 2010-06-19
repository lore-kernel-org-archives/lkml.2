Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0FSTOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:14:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34118 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab0FSTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:14:08 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <20100619132235.GA24200@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 19 Jun 2010 12:13:56 -0700
In-Reply-To: <20100619132235.GA24200@basil.fritz.box> (Andi Kleen's message of "Sat\, 19 Jun 2010 15\:22\:35 +0200")
Message-ID: <m1y6eau96z.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: andi@firstfloor.org, sam@ravnborg.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 0; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: ; sa07 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: _RELAYCOUNTRY_
Subject: Re: [PATCH] Export kexec.h
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Export kexec.h
>     
> kexec_load is a system call and it needs a header
> file with its input arguments.
>
> Export the parts of kexec.h needed for this.
>
> Cc: ebiederm@xmission.com
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Is there a corresponding patch for /sbin/kexec ?
What is the reason for wanting to export a currently kernel only header?

Not that I am really opposed but without a bit more context I can't
make a reasonable review of these patches.

Eric


> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index 2fc8e14..8fd5d09 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -389,3 +389,5 @@ unifdef-y += xfrm.h
>  objhdr-y += version.h
>  header-y += wimax.h
>  header-y += wimax/
> +
> +unifdef-y += kexec.h
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 03e8e8d..f4c5a0e 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -1,8 +1,46 @@
>  #ifndef LINUX_KEXEC_H
>  #define LINUX_KEXEC_H
>  
> -#ifdef CONFIG_KEXEC
> +/* Kexec: one kernel loading another */
> +
> +#ifdef __KERNEL__
> +#include <linux/compiler.h>
>  #include <linux/types.h>
> +#endif
> +
> +#define KEXEC_ON_CRASH		0x00000001
> +#define KEXEC_PRESERVE_CONTEXT	0x00000002
> +#define KEXEC_ARCH_MASK		0xffff0000
> +
> +/* These values match the ELF architecture values.
> + * Unless there is a good reason that should continue to be the case.
> + */
> +#define KEXEC_ARCH_DEFAULT ( 0 << 16)
> +#define KEXEC_ARCH_386     ( 3 << 16)
> +#define KEXEC_ARCH_X86_64  (62 << 16)
> +#define KEXEC_ARCH_PPC     (20 << 16)
> +#define KEXEC_ARCH_PPC64   (21 << 16)
> +#define KEXEC_ARCH_IA_64   (50 << 16)
> +#define KEXEC_ARCH_ARM     (40 << 16)
> +#define KEXEC_ARCH_S390    (22 << 16)
> +#define KEXEC_ARCH_SH      (42 << 16)
> +#define KEXEC_ARCH_MIPS_LE (10 << 16)
> +#define KEXEC_ARCH_MIPS    ( 8 << 16)
> +
> +#define KEXEC_SEGMENT_MAX 16
> +struct kexec_segment {
> +	void __user *buf;
> +	size_t bufsz;
> +#ifdef __KERNEL__
> +	unsigned long mem;	/* User space sees this as a (void *) ... */
> +#else
> +	void *mem;
> +#endif
> +	size_t memsz;
> +};
> +
> +#ifdef __KERNEL__
> +#ifdef CONFIG_KEXEC
>  #include <linux/list.h>
>  #include <linux/linkage.h>
>  #include <linux/compat.h>
> @@ -57,14 +95,6 @@ typedef unsigned long kimage_entry_t;
>  #define IND_DONE         0x4
>  #define IND_SOURCE       0x8
>  
> -#define KEXEC_SEGMENT_MAX 16
> -struct kexec_segment {
> -	void __user *buf;
> -	size_t bufsz;
> -	unsigned long mem;	/* User space sees this as a (void *) ... */
> -	size_t memsz;
> -};
> -
>  #ifdef CONFIG_COMPAT
>  struct compat_kexec_segment {
>  	compat_uptr_t buf;
> @@ -163,25 +193,6 @@ extern struct kimage *kexec_crash_image;
>  #define kexec_flush_icache_page(page)
>  #endif
>  
> -#define KEXEC_ON_CRASH		0x00000001
> -#define KEXEC_PRESERVE_CONTEXT	0x00000002
> -#define KEXEC_ARCH_MASK		0xffff0000
> -
> -/* These values match the ELF architecture values.
> - * Unless there is a good reason that should continue to be the case.
> - */
> -#define KEXEC_ARCH_DEFAULT ( 0 << 16)
> -#define KEXEC_ARCH_386     ( 3 << 16)
> -#define KEXEC_ARCH_X86_64  (62 << 16)
> -#define KEXEC_ARCH_PPC     (20 << 16)
> -#define KEXEC_ARCH_PPC64   (21 << 16)
> -#define KEXEC_ARCH_IA_64   (50 << 16)
> -#define KEXEC_ARCH_ARM     (40 << 16)
> -#define KEXEC_ARCH_S390    (22 << 16)
> -#define KEXEC_ARCH_SH      (42 << 16)
> -#define KEXEC_ARCH_MIPS_LE (10 << 16)
> -#define KEXEC_ARCH_MIPS    ( 8 << 16)
> -
>  /* List of defined/legal kexec flags */
>  #ifndef CONFIG_KEXEC_JUMP
>  #define KEXEC_FLAGS    KEXEC_ON_CRASH
> @@ -215,4 +226,5 @@ struct task_struct;
>  static inline void crash_kexec(struct pt_regs *regs) { }
>  static inline int kexec_should_crash(struct task_struct *p) { return 0; }
>  #endif /* CONFIG_KEXEC */
> +#endif
>  #endif /* LINUX_KEXEC_H */
