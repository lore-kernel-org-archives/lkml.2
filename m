Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030929Ab2HQIKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:10:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53505 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030893Ab2HQIKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:10:01 -0400
Date: Fri, 17 Aug 2012 10:09:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomas Racek <tracek@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, qemu-devel@nongnu.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, kvm-devel <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Qemu-devel] x86, nops settings result in kernel crash
Message-ID: <20120817080956.GC24241@liondog.tnic>
Reply-To: Borislav Petkov <borislav.petkov@amd.com>
Mail-Followup-To: Borislav Petkov <borislav.petkov@amd.com>,
	Tomas Racek <tracek@redhat.com>,
	Anthony Liguori <anthony@codemonkey.ws>, qemu-devel@nongnu.org,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
	kvm-devel <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <87393msdxp.fsf@codemonkey.ws>
 <579203853.1924367.1345189436257.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <579203853.1924367.1345189436257.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 03:43:56AM -0400, Tomas Racek wrote:
> Well, I've added some debug statements to the code:
> 
> void __init arch_init_ideal_nops(void)
> {
>         switch (boot_cpu_data.x86_vendor) {
>         case X86_VENDOR_INTEL:
>                 /*
>                  * Due to a decoder implementation quirk, some
>                  * specific Intel CPUs actually perform better with
>                  * the "k8_nops" than with the SDM-recommended NOPs.
>                  */
>                 if (boot_cpu_data.x86 == 6 &&
>                     boot_cpu_data.x86_model >= 0x0f &&
>                     boot_cpu_data.x86_model != 0x1c &&
>                     boot_cpu_data.x86_model != 0x26 &&
>                     boot_cpu_data.x86_model != 0x27 &&
>                     boot_cpu_data.x86_model < 0x30) {
>                         printk("NOPS: Option 1\n");
>                         ideal_nops = k8_nops;
>                 } else if (boot_cpu_has(X86_FEATURE_NOPL)) {
>                         printk("NOPS: Option 2\n");
>                            ideal_nops = p6_nops;
>                 } else {
>                         printk("NOPS: Option 3\n");
> #ifdef CONFIG_X86_64
>                         ideal_nops = k8_nops;
> #else
>                         ideal_nops = intel_nops;
> #endif
>                 }
>                 break;
>         default:
> #ifdef CONFIG_X86_64
>                 ideal_nops = k8_nops;
> #else
>                 if (boot_cpu_has(X86_FEATURE_K8))
>                         ideal_nops = k8_nops;
>                 else if (boot_cpu_has(X86_FEATURE_K7))
>                         ideal_nops = k7_nops;
>                 else
>                         ideal_nops = intel_nops;
> #endif
>         }
> }
> 
> This gives me Option 1 with "-cpu host" and Option 2 without.

This looks like an emulation bug. The interesting thing is that your
both traces from the bugzilla point to generic_make_request_checks but
it could also be due to timing.

Decoding the instruction stream in the second trace in the bugzilla gives:

[ 278.595106] Code: 03 48 89 03 48 8b 57 70 48 89 53 10 48 2b 01 8b 3f 48 89 45 98 48 8b 82 90 00 00 00 89 7d 94 48 8b 80 60 02 00 00 48 89 45 88 ac <17> 00 00 c8 45 85 e4 74 30 48 8b 43 10 48 8b 40 08 48 8b 40 48 
All code
========
   0:   03 48 89                add    -0x77(%rax),%ecx
   3:   03 48 8b                add    -0x75(%rax),%ecx
   6:   57                      push   %rdi
   7:   70 48                   jo     0x51
   9:   89 53 10                mov    %edx,0x10(%rbx)
   c:   48 2b 01                sub    (%rcx),%rax
   f:   8b 3f                   mov    (%rdi),%edi
  11:   48 89 45 98             mov    %rax,-0x68(%rbp)
  15:   48 8b 82 90 00 00 00    mov    0x90(%rdx),%rax
  1c:   89 7d 94                mov    %edi,-0x6c(%rbp)
  1f:   48 8b 80 60 02 00 00    mov    0x260(%rax),%rax
  26:   48 89 45 88             mov    %rax,-0x78(%rbp)
  2a:   ac                      lods   %ds:(%rsi),%al
  2b:*  17                      (bad)       <-- trapping instruction
  2c:   00 00                   add    %al,(%rax)
  2e:   c8 45 85 e4             enterq $0x8545,$0xe4
  32:   74 30                   je     0x64
  34:   48 8b 43 10             mov    0x10(%rbx),%rax
  38:   48 8b 40 08             mov    0x8(%rax),%rax
  3c:   48 8b 40 48             mov    0x48(%rax),%rax
        ...

Code starting with the faulting instruction
===========================================
   0:   17                      (bad)  
   1:   00 00                   add    %al,(%rax)
   3:   c8 45 85 e4             enterq $0x8545,$0xe4
   7:   74 30                   je     0x39
   9:   48 8b 43 10             mov    0x10(%rbx),%rax
   d:   48 8b 40 08             mov    0x8(%rax),%rax
  11:   48 8b 40 48             mov    0x48(%rax),%rax


and an instruction with opcode 0x17 in 64-bit mode is, AFAICT,
invalid (on 32-bit it is "pop %ss" according to this thing:
http://www.onlinedisassembler.com).

-- 
Regards/Gruss,
    Boris.
