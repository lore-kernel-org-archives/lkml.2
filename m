Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab1HCXnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:43:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab1HCX0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:47 2011
Message-Id: <20110803221247.697916450@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [037/102] perf tools, x86: Fix 32-bit compile on 64-bit system
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Ahern <dsahern@gmail.com>

commit 08a4a43fc407d780bdde36d98f89c0dbb2a6be6b upstream.

Builds for 32-bit perf binaries on a 64-bit host currently fail
with this error:

 [...]
 bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
 bench/../../../arch/x86/lib/memcpy_64.S:29: Error: bad register name `%rdi'
 bench/../../../arch/x86/lib/memcpy_64.S:34: Error: invalid instruction suffix for `movs'
 bench/../../../arch/x86/lib/memcpy_64.S:50: Error: bad register name `%rdi'
 bench/../../../arch/x86/lib/memcpy_64.S:61: Error: bad register name `%rdi'
 ...

The problem is the detection of the host arch without considering passed in
flags. This change fixes 32-bit builds via:

make EXTRA_CFLAGS=-m32

and 64-bit builds still reference the memcpy_64.S.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1310420304-21452-1-git-send-email-dsahern@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -52,7 +52,10 @@ ifeq ($(ARCH),i386)
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH := x86
-	IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	IS_X86_64 := 0
+	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
+		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+	endif
 	ifeq (${IS_X86_64}, 1)
 		RAW_ARCH := x86_64
 		ARCH_CFLAGS := -DARCH_X86_64


