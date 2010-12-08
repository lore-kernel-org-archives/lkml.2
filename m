Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0LHHkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:40:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:40044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0LHHka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:40:30 -0500
Date: Wed, 8 Dec 2010 07:39:53 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        imunsie@au1.ibm.com, tglx@linutronix.de, tom.leiming@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        imunsie@au1.ibm.com, tglx@linutronix.de, tom.leiming@gmail.com,
        mingo@elte.hu
In-Reply-To: <1290991642-sup-5890@au1.ibm.com>
References: <1290991642-sup-5890@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf makefile: Allow strong and weak functions in LIB_OBJS
Message-ID: <tip-b38aa89600be39b3e10c5b6529aed2e66518598e@git.kernel.org>
Git-Commit-ID: b38aa89600be39b3e10c5b6529aed2e66518598e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 07:39:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b38aa89600be39b3e10c5b6529aed2e66518598e
Gitweb:     http://git.kernel.org/tip/b38aa89600be39b3e10c5b6529aed2e66518598e
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Mon, 29 Nov 2010 11:53:07 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 7 Dec 2010 11:58:50 -0200

perf makefile: Allow strong and weak functions in LIB_OBJS

When we build perf we place all of the .o files from the library files
(util, arch/x/util, etc) into libperf.a which is then linked into perf.

The problem is that the linker will by default only consider .o files
within the .a archive if they are necessary to satisfy an unresolved
symbol. As weak functions are not unresolved, it will not consider a .o
file from the archive containing the strong versions of weak functions
unless it requires it for another reason.

This patch adds the --whole-archive flags to the linker when passing in
the libperf.a file to ensure that it will consider every .o file in the
archive, not just what it believes that it needs. The end result is that
weak functions can now be overridden by strong variants of them in the
libperf.a file.

Cc: "tom.leiming" <tom.leiming@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290991642-sup-5890@au1.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d88137a..ac6692c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -901,7 +901,7 @@ prefix_SQ = $(subst ','\'',$(prefix))
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 PERL_PATH_SQ = $(subst ','\'',$(PERL_PATH))
 
-LIBS = $(PERFLIBS) $(EXTLIBS)
+LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive $(EXTLIBS)
 
 BASIC_CFLAGS += -DSHA1_HEADER='$(SHA1_HEADER_SQ)' \
 	$(COMPAT_CFLAGS)
