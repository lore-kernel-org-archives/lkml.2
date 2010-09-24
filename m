Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0IXJDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 05:03:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab0IXJDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 05:03:07 -0400
Date: Fri, 24 Sep 2010 09:02:41 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
        mingo@elte.hu
In-Reply-To: <20100923034910.867858597@goodmis.org>
References: <20100923034910.867858597@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump label: Fix GCC feature check when distcc is used
Message-ID: <tip-d6dad199a10423ce37b8bfec1f055c380dc4a3d5@git.kernel.org>
Git-Commit-ID: d6dad199a10423ce37b8bfec1f055c380dc4a3d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Sep 2010 09:02:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6dad199a10423ce37b8bfec1f055c380dc4a3d5
Gitweb:     http://git.kernel.org/tip/d6dad199a10423ce37b8bfec1f055c380dc4a3d5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 24 Sep 2010 09:12:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 24 Sep 2010 09:12:25 +0200

jump label: Fix GCC feature check when distcc is used

The following build bug occurs on distcc builds:

   CC      arch/x86/kernel/asm-offsets.s
 In file included from include/linux/module.h:24,
                  from include/linux/crypto.h:22,
                  from arch/x86/kernel/asm-offsets_64.c:9,
                  from arch/x86/kernel/asm-offsets.c:5:
 include/trace/events/module.h: In function 'trace_module_load':
 include/trace/events/module.h:18: error: expected '(' before 'goto'
 include/trace/events/module.h:18: error: expected identifier or '*' before '(' token

It triggers because distcc is invoked by turning $CC into "distcc gcc",
but gcc-goto.sh check script was using $1 not $@ to expand parameters.

Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100923034910.867858597@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 scripts/gcc-goto.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
index 8e82424..520d16b 100644
--- a/scripts/gcc-goto.sh
+++ b/scripts/gcc-goto.sh
@@ -2,4 +2,4 @@
 # Test for gcc 'asm goto' suport
 # Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
 
-echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $1 -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
+echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
