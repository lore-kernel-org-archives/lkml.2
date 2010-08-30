Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0H3Rti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:49:38 -0400
Received: from mother.openwall.net ([195.42.179.200]:50917 "HELO
	mother.openwall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756298Ab0H3Rth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:49:37 -0400
Date: Mon, 30 Aug 2010 21:49:20 +0400
From: Solar Designer <solar@openwall.com>
To: Roland McGrath <roland@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        oss-security@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec argument expansion can inappropriately trigger OOM-killer
Message-ID: <20100830174920.GA25091@openwall.com>
References: <20100827220258.GF4703@outflux.net> <20100830005648.431B7400D9@magilla.sf.frob.com> <20100830032331.GA22773@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100830032331.GA22773@openwall.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 07:23:31AM +0400, Solar Designer wrote:
> Additionally, 64bit_dos.c mentions that "it triggers a BUG() as the
> stack tries to expand around the address space when shifted".
[...]
> which is likely part of a fix (but not the entire fix) for what the
> comment in 64bit_dos.c refers to.  However, I was not able to trigger
> the BUG_ON() on RHEL5'ish kernels by simply running the 64bit_dos
> program (64-bit to 32-bit exec) on two systems, one with 2 GB RAM, the
> other with 4 GB.  Of course, I set "ulimit -s unlimited" first.

I am finally able to trigger the BUG by replacing "/bin/sh" with
"/bin/false" in 64bit_dos.c, relying on our library-free implementation
of /bin/false on Owl:

owl!solar:~$ objdump -d /bin/false

/bin/false:     file format elf32-i386

Disassembly of section .text:

08048074 <.text>:
 8048074:       b8 01 00 00 00          mov    $0x1,%eax
 8048079:       bb 01 00 00 00          mov    $0x1,%ebx
 804807e:       cd 80                   int    $0x80

owl!solar:~$ file 64bit_dos
64bit_dos: ELF 64-bit LSB executable, AMD x86-64, version 1 (SYSV), for GNU/Linux 2.4.0, statically linked, for GNU/Linux 2.4.0, stripped

(the "exploit" is statically-linked since I brought it from another
machine, I don't think this matters).

After looping in the kernel for about 10 seconds, I got:

Kernel BUG at fs/exec.c:535
[...]
Call Trace:
 [<ffffffff8007c44c>] load_elf32_binary+0x7f9/0x1702
 [<ffffffff800c193f>] expand_stack+0x7f/0xad
 [<ffffffff8003e39b>] search_binary_handler+0x94/0x1e2
 [<ffffffff8003da2f>] do_execve+0x18e/0x1f2
 [<ffffffff800542cc>] sys_execve+0x34/0x51
 [<ffffffff8005e523>] stub_execve+0x67/0xb0
[...]
Code: 0f 0b 68 fe 93 3e 80 c2 17 02 48 8b 7c 24 08 4c 89 fe e8 da 
RIP  [<ffffffff8002dc90>] setup_arg_pages+0x151/0x2d3

The kernel is a revision and custom build of 2.6.18-128.2.1.el5
(whatever I happened to readily have installed on a test system).
I think the problem should be reproducible with current RHEL5 kernels
and likely with latest mainstream kernels as well.

The process is stuck:

solar    28754  2.8 77.8 3142276 3142276 pts/0 D+   10:34   0:13 [false]

(uninterruptible)

3 GB memory is still taken.

Alexander
