Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2GTV63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:58:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab2GTV60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:58:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/13] UAPI: x86: Fix insn_sanity build failure after UAPI
 split
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Date: Fri, 20 Jul 2012 22:58:11 +0100
Message-ID: <20120720215811.14854.97877.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a build failure in the x86 insn_sanity program after the UAPI split.  The
problem is that insn_sanity.c #includes arch/x86/lib/insn.c - which uses the
kernel string header.  This leads to conflicts for various definitions against
the /usr/include/ headers.

linux/string.h can be replaced with the normal userspace string.h if __KERNEL__
is not specified.

  HOSTCC  arch/x86/tools/insn_sanity
In file included from /data/fs/linux-2.6-hdr/include/linux/string.h:6:0,
                 from /data/fs/linux-2.6-hdr/arch/x86/lib/insn.c:21,
                 from arch/x86/tools/insn_sanity.c:36:
/data/fs/linux-2.6-hdr/include/linux/types.h:14:26: error: conflicting types for 'fd_set'
/usr/include/sys/select.h:76:5: note: previous declaration of 'fd_set' was here
/data/fs/linux-2.6-hdr/include/linux/types.h:15:25: error: conflicting types for 'dev_t'
/usr/include/sys/types.h:61:17: note: previous declaration of 'dev_t' was here
/data/fs/linux-2.6-hdr/include/linux/types.h:25:26: error: conflicting types for 'timer_t'
/usr/include/time.h:104:19: note: previous declaration of 'timer_t' was here
/data/fs/linux-2.6-hdr/include/linux/types.h:45:26: error: conflicting types for 'loff_t'
/usr/include/sys/types.h:45:18: note: previous declaration of 'loff_t' was here
/data/fs/linux-2.6-hdr/include/linux/types.h:112:17: error: conflicting types for 'u_int64_t'
/usr/include/sys/types.h:204:1: note: previous declaration of 'u_int64_t' was here
/data/fs/linux-2.6-hdr/include/linux/types.h:113:17: error: conflicting types for 'int64_t'
/usr/include/sys/types.h:198:1: note: previous declaration of 'int64_t' was here
/data/fs/linux-2.6-hdr/include/linux/types.h:134:23: error: conflicting types for 'blkcnt_t'
/usr/include/sys/types.h:236:20: note: previous declaration of 'blkcnt_t' was here
In file included from /data/fs/linux-2.6-hdr/arch/x86/lib/insn.c:21:0,
                 from arch/x86/tools/insn_sanity.c:36:
/data/fs/linux-2.6-hdr/include/linux/string.h:38:12: error: expected identifier or '(' before '__extension__'
/data/fs/linux-2.6-hdr/include/linux/string.h:38:12: error: expected identifier or '(' before ')' token
/data/fs/linux-2.6-hdr/include/linux/string.h:41:12: error: expected identifier or '(' before '__extension__'
/data/fs/linux-2.6-hdr/include/linux/string.h:53:15: error: expected identifier or '(' before '__extension__'
/data/fs/linux-2.6-hdr/include/linux/string.h:61:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'skip_spaces'
/data/fs/linux-2.6-hdr/include/linux/string.h:65:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'char'
/data/fs/linux-2.6-hdr/include/linux/string.h:83:15: error: expected identifier or '(' before '__extension__'
/data/fs/linux-2.6-hdr/include/linux/string.h:83:15: error: expected identifier or '(' before ')' token
/data/fs/linux-2.6-hdr/include/linux/string.h:86:15: error: expected identifier or '(' before '__extension__'
/data/fs/linux-2.6-hdr/include/linux/string.h:86:15: error: expected identifier or '(' before ')' token
/data/fs/linux-2.6-hdr/include/linux/string.h:89:24: error: expected identifier or '(' before '__extension__'
/data/fs/linux-2.6-hdr/include/linux/string.h:89:24: error: expected identifier or '(' before ')' token
/data/fs/linux-2.6-hdr/include/linux/string.h:92:24: error: expected identifier or '(' before '__extension__'
/data/fs/linux-2.6-hdr/include/linux/string.h:92:24: error: expected identifier or '(' before ')' token

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/lib/insn.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index b1e6c4b..54fcffe 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -18,7 +18,11 @@
  * Copyright (C) IBM Corporation, 2002, 2004, 2009
  */
 
+#ifdef __KERNEL__
 #include <linux/string.h>
+#else
+#include <string.h>
+#endif
 #include <asm/inat.h>
 #include <asm/insn.h>
 

