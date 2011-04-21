Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1DUChj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:37:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1DUChi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:37:38 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=xItS4qLmMH4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=S0zi-rxDeXiRAQGDYUgA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421022825.535486725@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 22:28:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC][PATCH 00/11] ftrace/recordmcount: Remove useless mcount calls not being traced
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is just a heads up on the changes to recordmcount.

Ftrace function tracer will only trace sections that have been white listed.
A section not in the whitelist will not be traced but if the section
is not denoted with "notrace" it will still have calls to mcount.
On x86_64 mcount is defined simply as:

  mcount:
	retq

But these sections will take a slight overhead for calling the mcount
function and returning. Most of the time we don't care because these are
usually init and exit sections that are not very performance critical.
But it would be nice not to have these calls anyway.

This patch seriers does a few things.

1) various cleanups to recordmcount.c

2) Make the calls (on x86) to mcount that are not being recorded for
   the function tracer into nops at compile time.

3) Add a "RECORDMCOUNT_WARN=1" feature to the make command line that
   will cause recordmcount to warn when a section contains mcount calls
   that is not being traced.

4) Added some "notrace" to section annotations that are not being traced
   as well as whitelisting one.

The reason this does not warn by default is because the developer may
not know if the section should be whitelisted or blacklisted (notrace)

Anyway, this is going out as RFC for now if anyone has any comments,
and I also need to get Acked-by's from the Kconfig maintainer for one
of my modifications.

Steven Rostedt (11):
      ftrace/trivial: Clean up recordmcount.c to use Linux style comparisons
      ftrace/trivial: Clean up record mcount to use Linux switch style
      ftrace: Add .kprobe.text section to whitelist for recordmcount.c
      ftrace/recordmcount: Modify only executable sections
      ftrace/recordmcount: Make ignored mcount calls into nops at compile time
      ftrace/recordmcount: Add warning logic to warn on mcount not recorded
      kbuild/recordmcount: Add RECORDMCOUNT_WARN to warn about mcount callers
      ftrace: Avoid recording mcount on .init sections directly
      ftrace/x86: Do not trace .discard.text section
      ftrace/recordmcount: Remove duplicate code to find mcount symbol
      ftrace/recordmcount: Add helper function get_sym_str_and_relp()

----
 Makefile                     |    1 +
 arch/x86/include/asm/setup.h |    2 +-
 include/linux/init.h         |   14 ++--
 scripts/Makefile.build       |    5 +-
 scripts/recordmcount.c       |  162 +++++++++++++++++++++++++++--------------
 scripts/recordmcount.h       |  165 +++++++++++++++++++++++++++++++++---------
 scripts/recordmcount.pl      |    1 +
 7 files changed, 253 insertions(+), 97 deletions(-)
