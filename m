Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2AWXqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:46:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab2AWXqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:46:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:42:03 2012
Message-Id: <20120123234203.893583873@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:41:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Rosenberg <drosenberg@vsecurity.com>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Arnd Bergmann <arnd@arndb.de>
Subject: [26/27] score: fix off-by-one index into syscall table
In-Reply-To: <20120123234224.GA19510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit c25a785d6647984505fa165b5cd84cfc9a95970b upstream.

If the provided system call number is equal to __NR_syscalls, the
current check will pass and a function pointer just after the system
call table may be called, since sys_call_table is an array with total
size __NR_syscalls.

Whether or not this is a security bug depends on what the compiler puts
immediately after the system call table.  It's likely that this won't do
anything bad because there is an additional NULL check on the syscall
entry, but if there happens to be a non-NULL value immediately after the
system call table, this may result in local privilege escalation.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/score/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/score/kernel/entry.S
+++ b/arch/score/kernel/entry.S
@@ -408,7 +408,7 @@ ENTRY(handle_sys)
 	sw	r9, [r0, PT_EPC]
 
 	cmpi.c	r27, __NR_syscalls 	# check syscall number
-	bgtu	illegal_syscall
+	bgeu	illegal_syscall
 
 	slli	r8, r27, 2		# get syscall routine
 	la	r11, sys_call_table


