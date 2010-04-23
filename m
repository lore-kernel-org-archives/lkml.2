Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab0DWREx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 13:04:53 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:36360
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230Ab0DWREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 13:04:52 -0400
X-IronPort-AV: E=Sophos;i="4.52,262,1270418400"; 
   d="c'?scan'208";a="61202962"
Date: Fri, 23 Apr 2010 19:04:49 +0200
From: Samuel Thibault <samuel.thibault@labri.fr>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       olivier.aumage@inria.fr, yannick.martin@inria.fr
Subject: X86_64 BUG: missing FS/GS LDT reload on fork()
Message-ID: <20100423170449.GV4997@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@labri.fr>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, olivier.aumage@inria.fr, yannick.martin@inria.fr
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I have an issue with FS/GS LDT reload in the child of fork(). The
attached testcase fails quite often.  It sets an LDT entry up, uses
prctl to set gs's base to a 64bit value, then loads gs with the LDT
entry. The LDT entry is now in effect. After a fork call, the LDT entry
is not in effect any more, the 64bit base is back!

It can be noticed that setting a 32bit base doesn't hurt, and enabling a
small nanosleep makes it work (I guess due to the induced save/restore
cycle).

I guess there's something bogus in the context save/load cycle across
fork().

This is vanilla 2.6.33 with the cpu below, but it also fails with a
2.6.32, 2.6.30, 2.6.27, and a 2.6.18 on various 64bit CPUs.

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz
stepping	: 13
cpu MHz		: 800.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 2660.22
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz
stepping	: 13
cpu MHz		: 800.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm tpr_shadow vnmi flexpriority
bogomips	: 2660.03
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


Samuel

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="test.c"

#define _GNU_SOURCE
#include <stdio.h>
#include <sys/syscall.h>
#include <asm/prctl.h>
#include <asm/ldt.h>
#include <sys/types.h>
#include <stdint.h>
#include <stdlib.h>

int var = 9;
int status = 0;

void print_base(char *who) {
	unsigned long base;
	int val;
	syscall(SYS_arch_prctl, ARCH_GET_GS, &base);
	asm("movl %%gs:0,%0":"=r"(val));
	printf("%s:\tbase %16lx val %d var %p\n", who, base, val, &var);
	if (val != var)
		status = 1;
}

int main(int argc, char *argv[]) {
	unsigned short entry = 1;
	unsigned short selector = (entry*8) | 0x4;
	struct user_desc desc = {
		.entry_number = entry,
		.base_addr = (unsigned) (uintptr_t) &var,
		.limit = 0xfffffffful,
		.contents = MODIFY_LDT_CONTENTS_DATA,
		.read_exec_only = 0,
		.limit_in_pages = 1,
		.seg_not_present = 0,
		.useable = 1,
	};
	pid_t pid;
	int i;

	if (syscall(SYS_modify_ldt, 0x11, &desc, sizeof(desc)))
		perror("modify_ldt");

#if 1
	syscall(SYS_arch_prctl, ARCH_SET_GS, &argc);
#else
	syscall(SYS_arch_prctl, ARCH_SET_GS, &status);
#endif
	asm volatile("movw %w0,%%gs"::"q"(selector));
	print_base("parent");

#if 0
	{
		struct timespec ts = {0, 1000000};
		nanosleep(&ts, NULL);
	}
#endif
	pid = syscall(SYS_fork);
	print_base(pid ? "parent" : "child");
	asm volatile("movw %w0,%%gs"::"q"(selector));
	print_base(pid ? "parent" : "child");
	if (pid)
		waitpid(pid, &status, 0);
	return status != 0;
}

--mP3DRpeJDSE+ciuQ--
