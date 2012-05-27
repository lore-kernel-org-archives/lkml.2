Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2E0A6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:58:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab2E0A6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:58:03 -0400
Message-Id: <20120527002615.948468287@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:27 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [ 14/55] KEYS: Use the compat keyctl() syscall wrapper on Sparc64 for Sparc32 compat
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sparc/Kconfig             |    3 +++
 arch/sparc/kernel/systbls_64.S |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -590,6 +590,9 @@ config SYSVIPC_COMPAT
 	depends on COMPAT && SYSVIPC
 	default y
 
+config KEYS_COMPAT
+	def_bool y if COMPAT && KEYS
+
 endmenu
 
 source "net/Kconfig"
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


