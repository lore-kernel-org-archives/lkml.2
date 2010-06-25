Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0FYNeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:34:10 -0400
Received: from mail2.picochip.com ([82.111.145.34]:43895 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755913Ab0FYNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:34:08 -0400
Message-ID: <4C24B03B.8090504@picochip.com>
Date: Fri, 25 Jun 2010 14:33:47 +0100
From: Jamie Iles <jamie.iles@picochip.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: allow cross compiling with DWARF support
References: <1277462318-6516-1-git-send-email-jamie.iles@picochip.com> <4C249027.1060304@hitachi.com> <20100625114150.GE4510@wear.picochip.com> <4C249B16.2090209@hitachi.com>
In-Reply-To: <4C249B16.2090209@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 25 Jun 2010 14:33:59 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 01:03 PM, Masami Hiramatsu wrote:
> Jamie Iles wrote:
>> On Fri, Jun 25, 2010 at 08:16:55PM +0900, Masami Hiramatsu wrote:
>>> Jamie Iles wrote:
>>>> The path to elfutils was previously hardcoded as /usr/include/elfutils
>>>> which does not work with cross compilers. If CROSS_COMPILE is set, try
>>>> to set an include path from GCC's sysroot if GCC was built with sysroot
>>>> support, if sysroot support isn't enabled, don't specify a path for
>>>> elfutils allowing the user to set it with EXTRA_CFLAGS.
[...]
> 
> It seems that $ELFUTILS_INCLUDE become "" without sysroot support.
> In that case, I guess that user have to set the elfutils header
> path to  EXTRA_CFLAGS and, make will just show "No libdw.h found
> or old libdw.h found ..." message. (I just guess, not so familier
> with cross compile...)
> 
> So, I just like to suggest adding a message like as;
> "No sysroot support. Please set elfutils include path in EXTRA_CFLAGS."
> Doesn't it make easier to find a problem?
> 
> Other parts are OK for me.

Ok, how about this revised patch?

From: Jamie Iles <jamie.iles@picochip.com>
Date: Fri, 25 Jun 2010 13:59:44 +0100
Subject: [PATCHv2] perf tools: allow cross compiling with DWARF support

The path to elfutils was previously hardcoded as /usr/include/elfutils
which does not work with cross compilers. If CROSS_COMPILE is set, try
to set an include path from GCC's sysroot if GCC was built with sysroot
support, if sysroot support isn't enabled, don't specify a path for
elfutils allowing the user to set it with EXTRA_CFLAGS.

v2: if we can't find libdw.h and there is no sysroot support but it
would be useful, warn the user.

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/Makefile |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6aa2fe3..1c08b7b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -503,9 +503,24 @@ PERFLIBS = $(LIB_FILE)
 -include config.mak.autogen
 -include config.mak
 
+ifndef CROSS_COMPILE
+	ELFUTILS_INCLUDE = -I/usr/include/elfutils
+else
+	# See if the compiler has been built with sysroot support
+	SYSROOT_PATH = $(shell $(CC) -print-sysroot 2> /dev/null || echo "")
+	ifneq ($(SYSROOT_PATH),)
+		ELFUTILS_INCLUDE := -I$(SYSROOT_PATH)/usr/include/elfutils
+	else
+		NO_SYSROOT := y
+	endif
+endif
+
 ifndef NO_DWARF
-FLAGS_DWARF=$(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
+FLAGS_DWARF=$(ALL_CFLAGS) $(ELFUTILS_INCLUDE) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
 ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
+	ifdef NO_SYSROOT
+		msg := $(warning No sysroot support. Set elfutils include path in EXTRA_CFLAGS for dwarf support)
+	endif
 	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
 	NO_DWARF := 1
 endif # Dwarf support
@@ -551,7 +566,7 @@ ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
 else
-	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
+	BASIC_CFLAGS += $(ELFUTILS_INCLUDE) -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += $(OUTPUT)util/probe-finder.o
 endif # PERF_HAVE_DWARF_REGS
-- 
1.7.0.1

