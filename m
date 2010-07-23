Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab0GWMML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:12:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:43114 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759341Ab0GWMMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:12:08 -0400
Date: Fri, 23 Jul 2010 12:11:38 GMT
From: tip-bot for David Daney <ddaney@caviumnetworks.com>
Cc: lihong.hi@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, wuzhangjin@gmail.com, rostedt@goodmis.org,
        ralf@linux-mips.org, matt@console-pimps.org, ddaney@caviumnetworks.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lihong.hi@gmail.com, wuzhangjin@gmail.com, ralf@linux-mips.org,
        rostedt@goodmis.org, matt@console-pimps.org, ddaney@caviumnetworks.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1278712325-12050-1-git-send-email-ddaney@caviumnetworks.com>
References: <1278712325-12050-1-git-send-email-ddaney@caviumnetworks.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Fix $mcount_regex for MIPS in recordmcount.pl
Message-ID: <tip-a484e54fae891703cbe1c9ec1b536605f11f5482@git.kernel.org>
Git-Commit-ID: a484e54fae891703cbe1c9ec1b536605f11f5482
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 12:11:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a484e54fae891703cbe1c9ec1b536605f11f5482
Gitweb:     http://git.kernel.org/tip/a484e54fae891703cbe1c9ec1b536605f11f5482
Author:     David Daney <ddaney@caviumnetworks.com>
AuthorDate: Fri, 9 Jul 2010 14:52:05 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 22 Jul 2010 14:55:43 -0400

tracing: Fix $mcount_regex for MIPS in recordmcount.pl

I found this issue in a locally patched 2.6.32.x, current kernels have
moved the offending code to an __init function which is skipped by
recordmcount.pl, so the bug is not currently being exercised.
However, I think the patch is still a good idea, to avoid future
problems if _mcount were to ever have its address taken in normal
code.

This is what I originally saw:

    Although arch/mips/kernel/ftrace.c is built without -pg, and thus
    contains no calls to _mcount, it does use the address of _mcount
    in ftrace_make_nop().  This was causing relocations to be emitted
    for _mcount which recordmcount.pl erronously took to be _mcount
    call sites.  The result was that the text of ftrace_make_nop()
    would be patched with garbage leading to a system crash.

In non-module code, all _mcount call sites will have R_MIPS_26
relocations, so we restrict $mcount_regex to only match on these.

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Wu Zhangjin <wuzhangjin@gmail.com>
Signed-off-by: David Daney <ddaney@caviumnetworks.com>
LKML-Reference: <1278712325-12050-1-git-send-email-ddaney@caviumnetworks.com>
Cc: Li Hong <lihong.hi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index f3c9c0a..0171060 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -326,7 +326,7 @@ if ($arch eq "x86_64") {
     #                    14: R_MIPS_NONE *ABS*
     #	 18:   00020021        nop
     if ($is_module eq "0") {
-	    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
+	    $mcount_regex = "^\\s*([0-9a-fA-F]+): R_MIPS_26\\s+_mcount\$";
     } else {
 	    $mcount_regex = "^\\s*([0-9a-fA-F]+): R_MIPS_HI16\\s+_mcount\$";
     }
