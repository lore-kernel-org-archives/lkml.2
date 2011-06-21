Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1FUWcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:32:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:61500 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1FUWcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:32:17 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1308695488!9055035!49
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mike Frysinger <vapier@gentoo.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "mikpe@it.uu.se" <mikpe@it.uu.se>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>
Date: Tue, 21 Jun 2011 17:32:04 -0500
Subject: RE: [PATCH] ARM: quiet sparse noise due to
 __ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND)
Thread-Topic: [PATCH] ARM: quiet sparse noise due to
 __ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND)
Thread-Index: AcwwSdn7kwMZxo4HT3er/augjch+wwAGIRYg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F38227C321@AUSP01VMBX24.collaborationhost.net>
References: <201106211209.46462.hartleys@visionengravers.com>
 <BANLkTi=8mstQAWKxBBBFH_+byGoXr8ieRg@mail.gmail.com>
In-Reply-To: <BANLkTi=8mstQAWKxBBBFH_+byGoXr8ieRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 21, 2011 12:31 PM, Mike Frysinger wrote:
> On Tue, Jun 21, 2011 at 15:09, H Hartley Sweeten wrote:
>> --- a/arch/arm/include/asm/unistd.h
>> +++ b/arch/arm/include/asm/unistd.h
>> @@ -467,6 +467,20 @@
>> +#ifndef __ASSEMBLY__
>> +
>> +#include <linux/types.h>
>> +#include <linux/linkage.h>
>> +#include <linux/compiler.h>
>> +#include <linux/signal.h>
>> +
>> +asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
>> +                                struct sigaction __user *oact,
>> +                                size_t sigsetsize);
>> +asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
>> +
>> +#endif /* !__ASSEMBLY__ */
>
> yikes ... this really the only way to fix the sparse warning ?

Not sure...

Russell's patch to add an asm/syscalls.h fixes the other system call
sparse warnings in arm/arm/kernel/* but it doesn't fix the ones in
kernel/signal.c.  This patch does but, as Russell said, asm/unistd.h
is exported to it's a bit ugly.

BTW, arch/ia64 does something very similar:


#if !defined(__ASSEMBLY__) && !defined(ASSEMBLER)

#include <linux/types.h>
#include <linux/linkage.h>
#include <linux/compiler.h>

extern long __ia64_syscall (long a0, long a1, long a2, long a3, long a4, long nr);

asmlinkage unsigned long sys_mmap(
				unsigned long addr, unsigned long len,
				int prot, int flags,
				int fd, long off);
asmlinkage unsigned long sys_mmap2(
				unsigned long addr, unsigned long len,
				int prot, int flags,
				int fd, long pgoff);
struct pt_regs;
struct sigaction;
asmlinkage long sys_ia64_pipe(void);
asmlinkage long sys_rt_sigaction(int sig,
				 const struct sigaction __user *act,
				 struct sigaction __user *oact,
				 size_t sigsetsize);

Regards,
Hartley