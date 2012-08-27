Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2H0REM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:04:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2H0REK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:04:10 -0400
Date: Mon, 27 Aug 2012 10:03:33 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-48bb5dc6cd9d30fe0d594947563da1f8bd9abada@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, rostedt@goodmis.org, srostedt@redhat.com,
        jreiser@bitwagon.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, rostedt@goodmis.org, srostedt@redhat.com,
        jreiser@bitwagon.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20120807194058.990674363@goodmis.org>
References: <20120807194058.990674363@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace: Make recordmcount.c handle __fentry__
Git-Commit-ID: 48bb5dc6cd9d30fe0d594947563da1f8bd9abada
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 10:03:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48bb5dc6cd9d30fe0d594947563da1f8bd9abada
Gitweb:     http://git.kernel.org/tip/48bb5dc6cd9d30fe0d594947563da1f8bd9abada
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 9 Feb 2011 13:13:23 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Aug 2012 11:24:43 -0400

ftrace: Make recordmcount.c handle __fentry__

With gcc 4.6.0 the -mfentry feature places the function profiling
call at the start of the function. When this is used, the call is
to __fentry__ and not mcount.

Change recordmcount.c to record both callers to __fentry__ and
mcount.

Link: http://lkml.kernel.org/r/20120807194058.990674363@goodmis.org

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: John Reiser <jreiser@bitwagon.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 54e35c1..9d1421e 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -261,11 +261,13 @@ static unsigned get_mcountsym(Elf_Sym const *const sym0,
 		&sym0[Elf_r_sym(relp)];
 	char const *symname = &str0[w(symp->st_name)];
 	char const *mcount = gpfx == '_' ? "_mcount" : "mcount";
+	char const *fentry = "__fentry__";
 
 	if (symname[0] == '.')
 		++symname;  /* ppc64 hack */
 	if (strcmp(mcount, symname) == 0 ||
-	    (altmcount && strcmp(altmcount, symname) == 0))
+	    (altmcount && strcmp(altmcount, symname) == 0) ||
+	    (strcmp(fentry, symname) == 0))
 		mcountsym = Elf_r_sym(relp);
 
 	return mcountsym;
