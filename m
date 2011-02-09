Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1BIUKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:10:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60676 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1BIUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:10:32 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=djIzH_HHj2UA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=WfulkdPnAAAA:8 a=meVymXHHAAAA:8 a=P8yBEFi5bX9sc2Qf0NAA:9 a=8uWH6BiUNdV2ngzBPSe24vhfvDAA:4 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110209201029.428186009@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 09 Feb 2011 15:02:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        John Reiser <jreiser@bitwagon.com>
Subject: [RFC][PATCH 1/4] ftrace: Make recordmcount.c handle __fentry__
References: <20110209200249.111932716@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Make-recordmcount.c-handle-__fentry__.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With gcc 4.6.0 the -mfentry feature places the function profiling
call at the start of the function. When this is used, the call is
to __fentry__ and not mcount.

Change recordmcount.c to record both callers to __fentry__ and
mcount.

Cc: John Reiser <jreiser@bitwagon.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index baf187b..e75ff44 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -276,11 +276,13 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 				&sym0[Elf_r_sym(relp)];
 			char const *symname = &str0[w(symp->st_name)];
 			char const *mcount = '_' == gpfx ? "_mcount" : "mcount";
+			char const *fentry = "__fentry__";
 
 			if ('.' == symname[0])
 				++symname;  /* ppc64 hack */
 			if (0 == strcmp(mcount, symname) ||
-			    (altmcount && 0 == strcmp(altmcount, symname)))
+			    (altmcount && 0 == strcmp(altmcount, symname)) ||
+			    (0 == strcmp(fentry, symname)))
 				mcountsym = Elf_r_sym(relp);
 		}
 
-- 
1.7.2.3


