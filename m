Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2KNGec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:34:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2KNGea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:34:30 -0500
Date: Tue, 13 Nov 2012 22:34:08 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-am6yp6phvxyjmyndxogpunjv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Handle --version string generation on machines without git
Git-Commit-ID: 688b2c2f17943d48bccbaad4c43430ee68c4c1cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:34:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  688b2c2f17943d48bccbaad4c43430ee68c4c1cd
Gitweb:     http://git.kernel.org/tip/688b2c2f17943d48bccbaad4c43430ee68c4c1cd
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 30 Oct 2012 13:44:40 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 12:17:49 -0200

perf tools: Handle --version string generation on machines without git

If git is installed we'll have a 'perf --version' output of this form:

$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
$ perf --version
perf version 3.7.rc3.g3afad6

Now on a machine without git installed:

$ mv  /home/acme/bin/git /home/acme/bin/git.OFF
$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
$ perf --version
perf version 3.7.0-rc2

That is, no error message due to git not being installed will appear on the
screen and instead the version string in the top level Makefile will be
used.

Requested-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-am6yp6phvxyjmyndxogpunjv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/PERF-VERSION-GEN |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index ac418a1..6aa34e5 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -14,8 +14,9 @@ LF='
 # otherwise try to get the version from the kernel Makefile
 #
 if test -d ../../.git -o -f ../../.git &&
-	VN=$(echo $(git tag -l "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null)
+	VN=$(git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*")
 then
+	VN=$(echo $VN"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD))
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
 	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
