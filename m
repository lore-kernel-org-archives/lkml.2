Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1EFAZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:40 -0400
Received: from kroah.org ([198.145.64.141]:37068 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab1EFAZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:14 2011
Message-Id: <20110506002214.551996155@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>, paulus@samba.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [095/143] perf tools: Display better error messages on missing packages
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit 1abc7f5500fff8422f34826a006648d8741d83d3 upstream.

Check for libelf headers and glibc headers separately so that
the error message correctly identifies which package
installation is missing/needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: paulus@samba.org
Cc: a.p.zijlstra@chello.nl
Cc: efault@gmx.de
Cc: fweisbec@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <4ADBCCE8.3060300@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
[bwh: Backport to 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 tools/perf/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -423,12 +423,16 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]);
+endif
+
 ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
 	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
 		BASIC_CFLAGS += -DLIBELF_NO_MMAP
 	endif
 else
-	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
+	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
 endif
 
 ifdef NO_DEMANGLE


