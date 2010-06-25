Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab0FYJUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:20:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab0FYJUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:20:52 -0400
Message-ID: <4C2474EF.4050902@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 17:20:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers
 for cpufeature index
References: <tip-*@git.kernel.org> <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
In-Reply-To: <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for H. Peter Anvin wrote:
> Commit-ID:  f88731e3068f9d1392ba71cc9f50f035d26a0d4f
> Gitweb:     http://git.kernel.org/tip/f88731e3068f9d1392ba71cc9f50f035d26a0d4f
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Wed, 9 Jun 2010 16:03:09 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 9 Jun 2010 16:03:09 -0700
> 
> x86, alternatives: Use 16-bit numbers for cpufeature index
> 
> We already have cpufeature indicies above 255, so use a 16-bit number
> for the alternatives index.  This consumes a padding field and so
> doesn't add any size, but it means that abusing the padding field to
> create assembly errors on overflow no longer works.  We can retain the
> test simply by redirecting it to the .discard section, however.
> 

My machine hits "invalid opcode" at *prepare_to_copy+0x79,
and it can't boot up.

(gdb) l *prepare_to_copy+0x79
0xc0101789 is in prepare_to_copy (/home/njubee/work/linux-2.6-tip/arch/x86/include/asm/xsave.h:118).
113
114     static inline void fpu_xsave(struct fpu *fpu)
115     {
116             /* This, however, we can work around by forcing the compiler to select
117                an addressing mode that doesn't require extended registers. */
118             __asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
119                                  : : "D" (&(fpu->state->xsave)),
120                                      "a" (-1), "d"(-1) : "memory");
121     }
122     #endif

It can boot up if this patch is reverted.
Does this patch change the return value of "use_xsave()"

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) D CPU 2.80GHz
stepping        : 8
cpu MHz         : 2800.120
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss constant_tsc pebs bts tsc_reliable pni ds_cpl
bogomips        : 5600.24
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) D CPU 2.80GHz
stepping        : 8
cpu MHz         : 2800.120
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss constant_tsc pebs bts tsc_reliable pni ds_cpl
bogomips        : 5574.36
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:
