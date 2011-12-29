Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab1L2KES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 05:04:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab1L2KEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 05:04:14 -0500
Message-ID: <4EFC3B17.1040601@redhat.com>
Date: Thu, 29 Dec 2011 12:04:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stephan_B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: KVM guest-kernel panics double fault
References: <4EFBC973.1040905@tu-ilmenau.de>
In-Reply-To: <4EFBC973.1040905@tu-ilmenau.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2011 03:59 AM, Stephan Bärwolf wrote:
> Hello guys,
>
> I am sorry to disturb you this short before New Year, but I think this
> shouldn't wait until next year.
>
> After experiencing crashes in virtual maschines and considering kernel /
> qemu / kvm / cpu -bugs, I discovered the following (see patch) issue.
> Because unpriviledged users can crash VMs, I think it is a serious one
> and needs short-term attention.
>
> The patch I wrote is against 3.2-rc7 but I always tested with linux 3.1.6.
> Hopfully it solve the problems to your satisfaction.


Thanks for the report and patch.


> Subject: [PATCH] KVM: fix missing "illegal instruction"-trap in guests
> within non-64bit protected modes
>
> On hosts without this patch, 32bit guests will crash for
> example by simply executing following nasm-demo-application:
>
>         [bits 32]
>         global _start
>         SECTION .text
>         _start: syscall
>
> (I am not sure if this can be exploited in more worse ways,
> like breaking out of VMs in more complex szenarios?
> But I tested it with win32 and linux - both always crashed)
>
>         Disassembly of section .text:
>
>         00000000 <_start>:
>            0:   0f 05                   syscall
>
> The reason seems a missing "invalid opcode"-trap (int6) for the
> syscall opcode "0f05", which is not available on 32bit cpus.
> Intel's "Intel 64 and IA-32 Architecture Software Developers
> Manual" (http://www.intel.com/content/dam/doc/manual/
> 64-ia-32-architectures-software-developer-manual-325462.pdf)
> documents on page 1804 (4-586) "syscall" is only available
> in 64bit longmode. So "syscall" must trap in real- and
> virtual 8086 -mode, as also in all non-64bit protected-modes.

However, 'syscall' is available in compatibility mode on 32-bit cpus.

> 0001-KVM-fix-missing-illegal-instruction-trap-in-guests-w.patch
>  	/* syscall is not available in real mode */
> +	/* 
> +	   "0f05" is also not available in
> +	   all non-64-bit protected modes (16&
> +	   32bit) or virtual 8086 mode		 
> +	   Only 64bit longmode supports this opcode
> +	*/
>  	if (ctxt->mode == X86EMUL_MODE_REAL ||
> +	    ctxt->mode == X86EMUL_MODE_PROT16 ||
> +	    ctxt->mode == X86EMUL_MODE_PROT32 ||
>  	    ctxt->mode == X86EMUL_MODE_VM86)
>  		return emulate_ud(ctxt);
>  
>

The PROT32 check should be qualifed by a checking the the guest cpuid
vendor is not AMD.  Otherwise a guest that was migrated from an AMD host
to an Intel host (this is what this emulation was written for in the
first place) will #UD unexpectedly.

-- 
error compiling committee.c: too many arguments to function

