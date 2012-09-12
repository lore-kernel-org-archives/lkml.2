Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab2IMAYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:24:01 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50843 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab2ILXfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:35:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Mads <mads@ab3.no>,
        Mike Frysinger <vapier@gentoo.org>, "H. J. Lu" <hjl.tools@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 066/108] x32: Use compat shims for {g,s}etsockopt
Date: Wed, 12 Sep 2012 16:29:04 -0700
Message-Id: <20120912232457.449549342@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 515c7af85ed92696c311c53d53cb4898ff32d784 upstream.

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
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/syscalls/syscall_64.tbl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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


