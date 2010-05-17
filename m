Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab0EQTKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:10:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab0EQTKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:10:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=L23uhvVv1HFB4Og7NYHMkRh+WT4IbkdcffLM2uR3MPwVxMgXAvjjY4xEnL/9Cx8mn
	ebAaxbH5SG6DbCdvMFdwQ==
Message-ID: <4bf194a4.5cebd80a.2e1f.ffffcc32@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 17 May 2010 21:04:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf: fix Makefile check for libdward
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Ubuntu 9.10, the elfutils/libdw package is 0.141, yet it is
not sufficient to compile util/probe-finder.c as it uses a type,
namely Dwarf_CFI, which is introduced sometime after version 0.141.

This patch updates the libdwarf test in the Makefile to check
for the definition of Dwarf_CFI. If is is not there, the test
fails and dwarf support is disabled.

It is not clear to me which version introduces Dwarf_CFI,
thus I adjusted the version message to 0.142, could be more
recent.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a9281cc..992bce7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -508,7 +508,7 @@ PERFLIBS = $(LIB_FILE)
 -include config.mak
 
 ifndef NO_DWARF
-ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo '\#include <version.h>'; echo '\#ifndef _ELFUTILS_PREREQ'; echo '\#error'; echo '\#endif'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo '\#include <version.h>'; echo '\#ifndef _ELFUTILS_PREREQ'; echo '\#error'; echo '\#endif'; echo 'int main(void) { Dwarf *dbg; Dwarf_CFI *cfi; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.142, disables dwarf support. Please install new elfutils-devel/libdw-dev);
 	NO_DWARF := 1
 endif # Dwarf support
