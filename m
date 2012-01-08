Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2AHKVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 05:21:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab2AHKVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 05:21:35 -0500
Message-ID: <4F096E26.4090201@redhat.com>
Date: Sun, 08 Jan 2012 12:21:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: stephan.baerwolf@tu-ilmenau.de
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: KVM guest-kernel panics double fault
References: <4EFBC973.1040905@tu-ilmenau.de> <4EFC3B17.1040601@redhat.com> <4F09001D.1050701@tu-ilmenau.de>
In-Reply-To: <4F09001D.1050701@tu-ilmenau.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2012 04:31 AM, Stephan Bärwolf wrote:
> Hello, it is me again...
>
> I improved the patch, so it is now working on bases of guest's pretends.
> (For AMD and INTEL CPUs)
> If anybody needs it, I can also publish my test-VM - just ask me...

Please post patches separately, not as attachments to a single email. 
See Documentation/SubmittingPatches.

> On 12/29/11 11:04, Avi Kivity wrote:
>> > The PROT32 check should be qualifed by a checking the the guest cpuid
>> > vendor is not AMD.  Otherwise a guest that was migrated from an AMD host
>> > to an Intel host (this is what this emulation was written for in the
>> > first place) will #UD unexpectedly.
>> >
> There are strange AMDs out there, where also again legacy-mode
> syscalls are not available - or even syscall at all is not available.
> The implemented (according to doku) tests should now cover all
> cases.
>
> I also think I ovserved some strange behaviour according to cpuid after
> migration (change from Intel to AMD - see picture:
> http://matrixstorm.com/software/linux/kvm/20111229/cpuidmagic.jpg )
> But it is possible it is "only" an qemu-kvm (0.14.1-r2) bug ...

You need to start qemu with -cpu ...,vendor=blah to preserve the vendor
ID after live migration.

>
> The patch I wrote is against 3.2, but I always tested with linux 3.1.7.
> Hopfully it solve the problems to your satisfaction this time.
>
>
> regards Stephan
>
>
> In order to take advantage of "emul_to_vpu" in other
> C-files, this makro has been moved to the headerfile.
>
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4c938da..ac949ba 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -64,9 +64,6 @@
>  #define KVM_MAX_MCE_BANKS 32
>  #define KVM_MCE_CAP_SUPPORTED (MCG_CTL_P | MCG_SER_P)
>  
> -#define emul_to_vcpu(ctxt) \
> -	container_of(ctxt, struct kvm_vcpu, arch.emulate_ctxt)
> -
>  /* EFER defaults:
>   * - enable syscall per default because its emulated by KVM
>   * - enable LME and LMA per default on 64 bit KVM
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index d36fe23..644c843 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -4,6 +4,9 @@
>  #include <linux/kvm_host.h>
>  #include "kvm_cache_regs.h"
>  
> +#define emul_to_vcpu(ctxt) \
> +	container_of(ctxt, struct kvm_vcpu, arch.emulate_ctxt)
> +
>  static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.exception.pending = false;

The emulator is written to be independent of the rest of kvm, using
emul_to_vcpu() undoes that.  If you need access to more vpcu internals,
add more function pointers to struct x86_emulate_ops.

>
>
> From 027d609f885c1f7d46afc0f68eab33c006fa57c6 Mon Sep 17 00:00:00 2001
> From: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
> Date: Sun, 8 Jan 2012 02:03:47 +0000
> Subject: [PATCH 2/2] KVM: fix missing "illegal instruction"-trap in protected modes
>
> On hosts without this patch, 32bit guests will crash
> (and 64bit guests may behave in a wrong way) for
> example by simply executing following nasm-demo-application:
>
> 	[bits 32]
> 	global _start
> 	SECTION .text
> 	_start: syscall
>
> (I tested it with winxp and linux - both always crashed)
>
> 	Disassembly of section .text:
>
> 	00000000 <_start>:
> 	   0:   0f 05                   syscall
>
> The reason seems a missing "invalid opcode"-trap (int6) for the
> syscall opcode "0f05", which is not available on Intel CPUs
> within non-longmodes, as also on some AMD CPUs within legacy-mode.
> (depending on CPU vendor, MSR_EFER and cpuid)
>
> Because previous mentioned OSs may not engage corresponding
> syscall target-registers (STAR, LSTAR, CSTAR), they remain
> NULL and (non trapping) syscalls are leading to multiple
> faults and finally crashs.
>
> Depending on the architecture (AMD or Intel) pretended by
> guests, various checks according to vendor's documentation
> are implemented to overcome the current issue and behave
> like the CPUs physical counterparts.
>
> (Therefore using Intel's "Intel 64 and IA-32 Architecture Software
> Developers Manual" http://www.intel.com/content/dam/doc/manual/
> 64-ia-32-architectures-software-developer-manual-325462.pdf
> and AMD's "AMD64 Architecture Programmer's Manual Volume 3:
> General-Purpose and System Instructions"
> http://support.amd.com/us/Processor_TechDocs/APM_V3_24594.pdf )
>
> Screenshots of an i686 testing VM (CORE i5 host) before
> and after applying this patch are available under:
>
> http://matrixstorm.com/software/linux/kvm/20111229/before.jpg
> http://matrixstorm.com/software/linux/kvm/20111229/after.jpg
>
> Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
> ---
>  arch/x86/include/asm/kvm_emulate.h |   15 +++++++++
>  arch/x86/kvm/emulate.c             |   57 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 72 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> index a026507..2a86ff9 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -297,6 +297,21 @@ struct x86_emulate_ctxt {
>  #define X86EMUL_MODE_PROT     (X86EMUL_MODE_PROT16|X86EMUL_MODE_PROT32| \
>  			       X86EMUL_MODE_PROT64)
>  
> +/* CPUID vendors */
> +#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx 0x68747541
> +#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx 0x444d4163
> +#define X86EMUL_CPUID_VENDOR_AuthenticAMD_edx 0x69746e65
> +
> +#define X86EMUL_CPUID_VENDOR_AMDisbetter_ebx 0x69444d41
> +#define X86EMUL_CPUID_VENDOR_AMDisbetter_ecx 0x21726574
> +#define X86EMUL_CPUID_VENDOR_AMDisbetter_edx 0x74656273
> +
> +#define X86EMUL_CPUID_VENDOR_GenuineIntel_ebx 0x756e6547
> +#define X86EMUL_CPUID_VENDOR_GenuineIntel_ecx 0x6c65746e
> +#define X86EMUL_CPUID_VENDOR_GenuineIntel_edx 0x49656e69
> +
> +
> +
>  enum x86_intercept_stage {
>  	X86_ICTP_NONE = 0,   /* Allow zero-init to not match anything */
>  	X86_ICPT_PRE_EXCEPT,
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f1e3be1..78edb66 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1891,6 +1891,63 @@ static int em_syscall(struct x86_emulate_ctxt *ctxt)
>  		return emulate_ud(ctxt);
>  
>  	ops->get_msr(ctxt, MSR_EFER, &efer);
> +	// check - if guestOS is aware of syscall (0x0f05)
> +	if ((efer & EFER_SCE) == 0) return emulate_ud(ctxt);

'return' on its own line; don't use C++ style comments.  Use tabs for
indents.  Please read Documentation/CodingStyle.

> +	else {
> +	  // ok, at this point it becomes vendor-specific
> +	  // so first get us an cpuid
> +	  struct kvm_cpuid_entry2 *vendor;
> +
> +	  // eax = 0x00000000, ebx = 0x00000000 ==> cpu-vendor
> +	  vendor = kvm_find_cpuid_entry(emul_to_vcpu(ctxt), 0, 0);

The third parameter is actually ecx

> +
> +	  if (likely(vendor)) {
> +	    // AMD (AuthenticAMD)/(AMDisbetter!)
> +	    if ((vendor->ebx==X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx &&

spaces around ==

> +	         vendor->ecx==X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx &&
> +	         vendor->edx==X86EMUL_CPUID_VENDOR_AuthenticAMD_edx) ||
> +	        (vendor->ebx==X86EMUL_CPUID_VENDOR_AMDisbetter_ebx &&
> +	         vendor->ecx==X86EMUL_CPUID_VENDOR_AMDisbetter_ecx &&
> +	         vendor->edx==X86EMUL_CPUID_VENDOR_AMDisbetter_edx)) {
> +
> +	          // if cpu is not in longmode...
> +	          // ...check edx bit11 of cpuid 0x80000001
> +		  if (ctxt->mode != X86EMUL_MODE_PROT64) {
> +	            vendor= kvm_find_cpuid_entry(emul_to_vcpu(ctxt), 0x80000001, 0);
> +	            if (likely(vendor)) {
> +	             if (unlikely(((vendor->edx >> 11) & 0x1) == 0)) return emulate_ud(ctxt);
> +	            } else return emulate_ud(ctxt); // assuming there is no bit 11
> +	          }
> +	          goto __em_syscall_vendor_processed;
> +	    } // end "AMD"
> +
> +	    // Intel (GenuineIntel)
> +	    // remarks: Intel CPUs only support "syscall" in 64bit longmode
> +	    //          Also an 64bit guest within an 32bit compat-app running
> +	    //          will #UD !!
> +	    //          While this behaviour can be fixed (by emulating) into
> +	    //          an AMD response - CPUs of AMD can't behave like Intel
> +	    //          because without an hardware-raised #UD there is no
> +	    //          call into emulation-mode (see x86_emulate_instruction(...)) !
> +	    // TODO: make AMD-behaviour configurable
> +	    if (vendor->ebx==X86EMUL_CPUID_VENDOR_GenuineIntel_ebx &&
> +	        vendor->ecx==X86EMUL_CPUID_VENDOR_GenuineIntel_ecx &&
> +	        vendor->edx==X86EMUL_CPUID_VENDOR_GenuineIntel_edx) {
> +	          if (ctxt->mode != X86EMUL_MODE_PROT64) return emulate_ud(ctxt);
> +	          goto __em_syscall_vendor_processed;
> +	    } // end "Intel"
> +	  } //end "likely(vendor)"
> +
> +	  // default:	  
> +	  // this code wasn't able to process vendor
> +	  // so apply  Intels stricter rules...
> +	  pr_unimpl(emul_to_vcpu(ctxt), "unknown vendor of cpu - assuming intel\n");
> +	  if (ctxt->mode != X86EMUL_MODE_PROT64) return emulate_ud(ctxt);
> +
> +	 __em_syscall_vendor_processed:
> +	 vendor=NULL;
> +	}
Please move all these checks into a separate function, returning whether to allow emulation or #UD.



-- 
error compiling committee.c: too many arguments to function

