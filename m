Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab2HSEML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 00:12:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58948 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2HSEMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 00:12:06 -0400
Date: Sat, 18 Aug 2012 21:11:40 -0700
From: tip-bot for Mike Frysinger <vapier@gentoo.org>
Message-ID: <tip-515c7af85ed92696c311c53d53cb4898ff32d784@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org, mads@ab3.no,
        vapier@gentoo.org, tglx@linutronix.de, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mads@ab3.no, vapier@gentoo.org, tglx@linutronix.de,
        hjl.tools@gmail.com
In-Reply-To: <1345320697-15713-1-git-send-email-vapier@gentoo.org>
References: <1345320697-15713-1-git-send-email-vapier@gentoo.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x32: Use compat shims for {g,s}etsockopt
Git-Commit-ID: 515c7af85ed92696c311c53d53cb4898ff32d784
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 18 Aug 2012 21:11:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  515c7af85ed92696c311c53d53cb4898ff32d784
Gitweb:     http://git.kernel.org/tip/515c7af85ed92696c311c53d53cb4898ff32d784
Author:     Mike Frysinger <vapier@gentoo.org>
AuthorDate: Sat, 18 Aug 2012 16:11:37 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 18 Aug 2012 14:15:39 -0700

x32: Use compat shims for {g,s}etsockopt

Some of the arguments to {g,s}etsockopt are passed in userland pointers.
If we try to use the 64bit entry point, we end up sometimes failing.

For example, dhcpcd doesn't run in x32:
	# dhcpcd eth0
	dhcpcd[1979]: version 5.5.6 starting
	dhcpcd[1979]: eth0: broadcasting for a lease
	dhcpcd[1979]: eth0: open_socket: Invalid argument
	dhcpcd[1979]: eth0: send_raw_packet: Bad file descriptor

The code in particular is getting back EINVAL when doing:
	struct sock_fprog pf;
	setsockopt(s, SOL_SOCKET, SO_ATTACH_FILTER, &pf, sizeof(pf));

Diving into the kernel code, we can see:
include/linux/filter.h:
	struct sock_fprog {
		unsigned short len;
		struct sock_filter __user *filter;
	};

net/core/sock.c:
	case SO_ATTACH_FILTER:
		ret = -EINVAL;
		if (optlen == sizeof(struct sock_fprog)) {
			struct sock_fprog fprog;

			ret = -EFAULT;
			if (copy_from_user(&fprog, optval, sizeof(fprog)))
				break;

			ret = sk_attach_filter(&fprog, sk);
		}
		break;

arch/x86/syscalls/syscall_64.tbl:
	54 common setsockopt sys_setsockopt
	55 common getsockopt sys_getsockopt

So for x64, sizeof(sock_fprog) is 16 bytes.  For x86/x32, it's 8 bytes.
This comes down to the pointer being 32bit for x32, which means we need
to do structure size translation.  But since x32 comes in directly to
sys_setsockopt, it doesn't get translated like x86.

After changing the syscall table and rebuilding glibc with the new kernel
headers, dhcp runs fine in an x32 userland.

Oddly, it seems like Linus noted the same thing during the initial port,
but I guess that was missed/lost along the way:
	https://lkml.org/lkml/2011/8/26/452

[ hpa: tagging for -stable since this is an ABI fix. ]

Bugzilla: https://bugs.gentoo.org/423649
Reported-by: Mads <mads@ab3.no>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Link: http://lkml.kernel.org/r/1345320697-15713-1-git-send-email-vapier@gentoo.org
Cc: H. J. Lu <hjl.tools@gmail.com>
Cc: <stable@vger.kernel.org> v3.4..v3.5
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/syscalls/syscall_64.tbl |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 29aed7a..a582bfe 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -60,8 +60,8 @@
 51	common	getsockname		sys_getsockname
 52	common	getpeername		sys_getpeername
 53	common	socketpair		sys_socketpair
-54	common	setsockopt		sys_setsockopt
-55	common	getsockopt		sys_getsockopt
+54	64	setsockopt		sys_setsockopt
+55	64	getsockopt		sys_getsockopt
 56	common	clone			stub_clone
 57	common	fork			stub_fork
 58	common	vfork			stub_vfork
@@ -353,3 +353,5 @@
 538	x32	sendmmsg		compat_sys_sendmmsg
 539	x32	process_vm_readv	compat_sys_process_vm_readv
 540	x32	process_vm_writev	compat_sys_process_vm_writev
+541	x32	setsockopt		compat_sys_setsockopt
+542	x32	getsockopt		compat_sys_getsockopt
