Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2E1Dyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:54:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162Ab2E1D3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:06 -0400
Message-Id: <20120528031206.199281317@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 024/117] KEYS: Use the compat keyctl() syscall wrapper on Sparc64 for Sparc32
 compat
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 45de6767dc51358a188f75dc4ad9dfddb7fb9480 upstream.

Use the 32-bit compat keyctl() syscall wrapper on Sparc64 for Sparc32 binary
compatibility.

Without this, keyctl(KEYCTL_INSTANTIATE_IOV) is liable to malfunction as it
uses an iovec array read from userspace - though the kernel should survive this
as it checks pointers and sizes anyway.

I think all the other keyctl() function should just work, provided (a) the top
32-bits of each 64-bit argument register are cleared prior to invoking the
syscall routine, and the 32-bit address space is right at the 0-end of the
64-bit address space.  Most of the arguments are 32-bit anyway, and so for
those clearing is not required.

Signed-off-by: David Howells <dhowells@redhat.com
cc: "David S. Miller" <davem@davemloft.net>
cc: sparclinux@vger.kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/Kconfig             |    3 +++
 arch/sparc/kernel/systbls_64.S |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6c0683d..76c7ccf 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -584,6 +584,9 @@ config SYSVIPC_COMPAT
 	depends on COMPAT && SYSVIPC
 	default y
 
+config KEYS_COMPAT
+	def_bool y if COMPAT && KEYS
+
 endmenu
 
 source "net/Kconfig"
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index db86b1a..3a58e0d 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -74,7 +74,7 @@ sys_call_table32:
 	.word sys_timer_delete, compat_sys_timer_create, sys_ni_syscall, compat_sys_io_setup, sys_io_destroy
 /*270*/	.word sys32_io_submit, sys_io_cancel, compat_sys_io_getevents, sys32_mq_open, sys_mq_unlink
 	.word compat_sys_mq_timedsend, compat_sys_mq_timedreceive, compat_sys_mq_notify, compat_sys_mq_getsetattr, compat_sys_waitid
-/*280*/	.word sys32_tee, sys_add_key, sys_request_key, sys_keyctl, compat_sys_openat
+/*280*/	.word sys32_tee, sys_add_key, sys_request_key, compat_sys_keyctl, compat_sys_openat
 	.word sys_mkdirat, sys_mknodat, sys_fchownat, compat_sys_futimesat, compat_sys_fstatat64
 /*290*/	.word sys_unlinkat, sys_renameat, sys_linkat, sys_symlinkat, sys_readlinkat
 	.word sys_fchmodat, sys_faccessat, compat_sys_pselect6, compat_sys_ppoll, sys_unshare


