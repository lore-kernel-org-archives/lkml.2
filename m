Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2GTV7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2GTV7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:59:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/13] UAPI: x86: Differentiate the generated UAPI and
 internal headers
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Date: Fri, 20 Jul 2012 22:58:53 +0100
Message-ID: <20120720215853.14854.56339.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Differentiate the generated UAPI and internal headers during generation such
that the UAPI headers can be installed elsewhere.

A later patch will use this to move the UAPI headers to:

	arch/x86/include/generated/uapi/asm/

to make them easier to handle.

A previous patch added a -I for this path.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/syscalls/Makefile |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/syscalls/Makefile b/arch/x86/syscalls/Makefile
index 3236aeb..174b032 100644
--- a/arch/x86/syscalls/Makefile
+++ b/arch/x86/syscalls/Makefile
@@ -1,7 +1,9 @@
 out := $(obj)/../include/generated/asm
+uapi := $(obj)/../include/generated/asm
 
 # Create output directory if not already present
-_dummy := $(shell [ -d '$(out)' ] || mkdir -p '$(out)')
+_dummy := $(shell [ -d '$(out)' ] || mkdir -p '$(out)') \
+	  $(shell [ -d '$(uapi)' ] || mkdir -p '$(uapi)')
 
 syscall32 := $(srctree)/$(src)/syscall_32.tbl
 syscall64 := $(srctree)/$(src)/syscall_64.tbl
@@ -18,7 +20,7 @@ quiet_cmd_systbl = SYSTBL  $@
       cmd_systbl = $(CONFIG_SHELL) '$(systbl)' $< $@
 
 syshdr_abi_unistd_32 := i386
-$(out)/unistd_32.h: $(syscall32) $(syshdr)
+$(uapi)/unistd_32.h: $(syscall32) $(syshdr)
 	$(call if_changed,syshdr)
 
 syshdr_abi_unistd_32_ia32 := i386
@@ -28,11 +30,11 @@ $(out)/unistd_32_ia32.h: $(syscall32) $(syshdr)
 
 syshdr_abi_unistd_x32 := common,x32
 syshdr_offset_unistd_x32 := __X32_SYSCALL_BIT
-$(out)/unistd_x32.h: $(syscall64) $(syshdr)
+$(uapi)/unistd_x32.h: $(syscall64) $(syshdr)
 	$(call if_changed,syshdr)
 
 syshdr_abi_unistd_64 := common,64
-$(out)/unistd_64.h: $(syscall64) $(syshdr)
+$(uapi)/unistd_64.h: $(syscall64) $(syshdr)
 	$(call if_changed,syshdr)
 
 syshdr_abi_unistd_64_x32 := x32
@@ -45,11 +47,12 @@ $(out)/syscalls_32.h: $(syscall32) $(systbl)
 $(out)/syscalls_64.h: $(syscall64) $(systbl)
 	$(call if_changed,systbl)
 
-syshdr-y			+= unistd_32.h unistd_64.h unistd_x32.h
+uapisyshdr-y			+= unistd_32.h unistd_64.h unistd_x32.h
 syshdr-y			+= syscalls_32.h
 syshdr-$(CONFIG_X86_64)		+= unistd_32_ia32.h unistd_64_x32.h
 syshdr-$(CONFIG_X86_64)		+= syscalls_64.h
 
-targets	+= $(syshdr-y)
+targets	+= $(uapisyshdr-y) $(syshdr-y)
 
-all: $(addprefix $(out)/,$(targets))
+all: $(addprefix $(uapi)/,$(uapisyshdr-y))
+all: $(addprefix $(out)/,$(syshdr-y))

