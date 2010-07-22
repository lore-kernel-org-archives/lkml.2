Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0GVUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:25:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48992 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0GVUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:24:57 -0400
X-Authority-Analysis: v=1.1 cv=Bg1eF82PU/BBLXqN4uYnzFVuDnL6ar87Ns1E9VhfbEo= c=1 sm=0 a=xKYUO_2jHO0A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=enOvQawGAAAA:8 a=WPyIoOwQAAAA:8 a=pGLkceISAAAA:8 a=fLbG0_AyAAAA:8 a=meVymXHHAAAA:8 a=j7j6NMG5F4d0Jw0iwMwA:9 a=hxaG5BG0ehaiKvBQvcgA:7 a=OTcmGBdFoc7V7R4b2HIaMfARw8wA:4 a=89-mdWWwHc4A:10 a=EVmJrYHqZUIA:10 a=bkT6KWdcy0IA:10 a=1DbiqZag68YA:10 a=MSl-tDqOz04A:10 a=CO1XcZHhRtcA:10 a=jeBq3FmKZ4MA:10 a=PgQN9zC1h_4fLspr:21 a=AWVyL6HR4pWRB0YV:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100722202453.556957214@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 16:24:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Wu Zhangjin <wuzhangjin@gmail.com>,
        David Daney <ddaney@caviumnetworks.com>, Li Hong <lihong.hi@gmail.com>,
        Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 6/7] tracing: Fix $mcount_regex for MIPS in recordmcount.pl
References: <20100722202411.920807480@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Fix-mcount_regex-for-MIPS-in-recordmcount.pl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

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
-- 
1.7.1


