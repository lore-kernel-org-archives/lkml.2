Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0GIVwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:52:41 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15335 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab0GIVwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:52:40 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       David Daney <ddaney@caviumnetworks.com>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] tracing: recordmcount.pl: Fix $mcount_regex for MIPS.
Date: Fri,  9 Jul 2010 14:52:05 -0700
Message-Id: <1278712325-12050-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.6.1
X-OriginalArrivalTime: 09 Jul 2010 21:52:39.0815 (UTC) FILETIME=[0D02C970:01CB1FB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Hong <lihong.hi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
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
-- 
1.6.6.1

