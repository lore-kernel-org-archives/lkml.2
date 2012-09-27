Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2I0Fks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:40:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2I0Fkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:40:45 -0400
Date: Wed, 26 Sep 2012 22:40:13 -0700
From: tip-bot for Markus Trippelsdorf <markus@trippelsdorf.de>
Message-ID: <tip-3ce711a6abc27abce1554e1d671a8762b7187690@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        markus@trippelsdorf.de, vapier@gentoo.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, markus@trippelsdorf.de,
        vapier@gentoo.org, tglx@linutronix.de
In-Reply-To: <20120919072902.GA262@x4>
References: <20120919072902.GA262@x4>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: bfd.h/
 libbfd detection fails with recent binutils
Git-Commit-ID: 3ce711a6abc27abce1554e1d671a8762b7187690
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:40:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ce711a6abc27abce1554e1d671a8762b7187690
Gitweb:     http://git.kernel.org/tip/3ce711a6abc27abce1554e1d671a8762b7187690
Author:     Markus Trippelsdorf <markus@trippelsdorf.de>
AuthorDate: Wed, 19 Sep 2012 09:29:02 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:05:02 -0300

perf tools: bfd.h/libbfd detection fails with recent binutils

With recent binutils I get:

 perf % make
Makefile:668: No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demanglin

That happens because bfd.h now contains:

I've reopened a bug in the hope that this check will be deleted:
http://sourceware.org/bugzilla/show_bug.cgi?id=14243

But in the meantime, the following patch fixes the problem

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mackerras <paulus@samba.org>
Link: http://lkml.kernel.org/r/20120919072902.GA262@x4
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    2 +-
 tools/perf/util/symbol.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3ae6a59..251dcd7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -715,7 +715,7 @@ else
 		EXTLIBS += -liberty
 		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
         else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
+		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
 		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD))
 		ifeq ($(has_bfd),y)
 			EXTLIBS += -lbfd
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 4ff45e3..b441b07 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -34,6 +34,7 @@ static inline char *bfd_demangle(void __maybe_unused *v,
 	return NULL;
 }
 #else
+#define PACKAGE 'perf'
 #include <bfd.h>
 #endif
 #endif
