Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab2HTRNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:13:32 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49416 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2HTRN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:13:29 -0400
Date: Mon, 20 Aug 2012 13:13:15 -0400 (EDT)
From: Tomas Racek <tracek@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, qemu-devel@nongnu.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, kvm-devel <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-ID: <1466897901.2256382.1345482795440.JavaMail.root@redhat.com>
In-Reply-To: <20120817080956.GC24241@liondog.tnic>
Subject: Re: [Qemu-devel] x86, nops settings result in kernel crash
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.36.7.117]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC20 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On Fri, Aug 17, 2012 at 03:43:56AM -0400, Tomas Racek wrote:
> > Well, I've added some debug statements to the code:
> > 
> > void __init arch_init_ideal_nops(void)
> > {
> >         switch (boot_cpu_data.x86_vendor) {
> >         case X86_VENDOR_INTEL:
> >                 /*
> >                  * Due to a decoder implementation quirk, some
> >                  * specific Intel CPUs actually perform better with
> >                  * the "k8_nops" than with the SDM-recommended
> >                  NOPs.
> >                  */
> >                 if (boot_cpu_data.x86 == 6 &&
> >                     boot_cpu_data.x86_model >= 0x0f &&
> >                     boot_cpu_data.x86_model != 0x1c &&
> >                     boot_cpu_data.x86_model != 0x26 &&
> >                     boot_cpu_data.x86_model != 0x27 &&
> >                     boot_cpu_data.x86_model < 0x30) {
> >                         printk("NOPS: Option 1\n");
> >                         ideal_nops = k8_nops;
> >                 } else if (boot_cpu_has(X86_FEATURE_NOPL)) {
> >                         printk("NOPS: Option 2\n");
> >                            ideal_nops = p6_nops;
> >                 } else {
> >                         printk("NOPS: Option 3\n");
> > #ifdef CONFIG_X86_64
> >                         ideal_nops = k8_nops;
> > #else
> >                         ideal_nops = intel_nops;
> > #endif
> >                 }
> >                 break;
> >         default:
> > #ifdef CONFIG_X86_64
> >                 ideal_nops = k8_nops;
> > #else
> >                 if (boot_cpu_has(X86_FEATURE_K8))
> >                         ideal_nops = k8_nops;
> >                 else if (boot_cpu_has(X86_FEATURE_K7))
> >                         ideal_nops = k7_nops;
> >                 else
> >                         ideal_nops = intel_nops;
> > #endif
> >         }
> > }
> > 
> > This gives me Option 1 with "-cpu host" and Option 2 without.
> 
> This looks like an emulation bug. The interesting thing is that your
> both traces from the bugzilla point to generic_make_request_checks
> but
> it could also be due to timing.
> 
> Decoding the instruction stream in the second trace in the bugzilla
> gives:
> 
> [ 278.595106] Code: 03 48 89 03 48 8b 57 70 48 89 53 10 48 2b 01 8b
> 3f 48 89 45 98 48 8b 82 90 00 00 00 89 7d 94 48 8b 80 60 02 00 00 48
> 89 45 88 ac <17> 00 00 c8 45 85 e4 74 30 48 8b 43 10 48 8b 40 08 48
> 8b 40 48
> All code
> ========
>    0:   03 48 89                add    -0x77(%rax),%ecx
>    3:   03 48 8b                add    -0x75(%rax),%ecx
>    6:   57                      push   %rdi
>    7:   70 48                   jo     0x51
>    9:   89 53 10                mov    %edx,0x10(%rbx)
>    c:   48 2b 01                sub    (%rcx),%rax
>    f:   8b 3f                   mov    (%rdi),%edi
>   11:   48 89 45 98             mov    %rax,-0x68(%rbp)
>   15:   48 8b 82 90 00 00 00    mov    0x90(%rdx),%rax
>   1c:   89 7d 94                mov    %edi,-0x6c(%rbp)
>   1f:   48 8b 80 60 02 00 00    mov    0x260(%rax),%rax
>   26:   48 89 45 88             mov    %rax,-0x78(%rbp)
>   2a:   ac                      lods   %ds:(%rsi),%al
>   2b:*  17                      (bad)       <-- trapping instruction
>   2c:   00 00                   add    %al,(%rax)
>   2e:   c8 45 85 e4             enterq $0x8545,$0xe4
>   32:   74 30                   je     0x64
>   34:   48 8b 43 10             mov    0x10(%rbx),%rax
>   38:   48 8b 40 08             mov    0x8(%rax),%rax
>   3c:   48 8b 40 48             mov    0x48(%rax),%rax
>         ...
> 
> Code starting with the faulting instruction
> ===========================================
>    0:   17                      (bad)
>    1:   00 00                   add    %al,(%rax)
>    3:   c8 45 85 e4             enterq $0x8545,$0xe4
>    7:   74 30                   je     0x39
>    9:   48 8b 43 10             mov    0x10(%rbx),%rax
>    d:   48 8b 40 08             mov    0x8(%rax),%rax
>   11:   48 8b 40 48             mov    0x48(%rax),%rax
> 
> 
> and an instruction with opcode 0x17 in 64-bit mode is, AFAICT,
> invalid (on 32-bit it is "pop %ss" according to this thing:
> http://www.onlinedisassembler.com).

I can provide you with more different traces if it can help. But I thought that maybe it will be more useful for you to try it on your own. So I've prepared some minimal debian installation which you could download here (apx 163M bzipped):

http://fi.muni.cz/~xracek/debian.img.bz2

Password:
root/asdfgh

Here is my config for guest kernel:

http://fi.muni.cz/~xracek/config

I use

qemu-kvm -m 1500 -hda debian.img -kernel linux/arch/x86/boot/bzImage -append "root=/dev/sda1"

After logging in just run "sh runtest.sh". This leads to crash in my case (host: Intel Core i5-2540M, kernel 3.5.2-1.fc17.x86_64, qemu 1.0.1).

Regards,

Tom

> 
> --
> Regards/Gruss,
>     Boris.
> 
