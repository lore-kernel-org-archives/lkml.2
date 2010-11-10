Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab0KJJaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 04:30:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab0KJJaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 04:30:00 -0500
Date: Wed, 10 Nov 2010 10:29:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] perf bench: add --prefault option for causing page
 faults before benchmark
Message-ID: <20101110092945.GD12238@elte.hu>
References: <1288976785-15857-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288976785-15857-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> This patch adds --prefault option to perf bench mem memcpy.
> If user specify this option to perf bench mem memcpy, overhead of
> page faults will be removed from the score of memcpy().
> 
> Example of usage:
> | % ./perf bench mem memcpy -l 500MB
> | # Running mem/memcpy benchmark...
> | # Copying 500MB Bytes from 0x7fc036749010 to 0x7fc055b4a010 ...
> |
> |      628.526821 MB/Sec
> | mitake@X201i:~/linux/.../tools/perf% ./perf bench mem memcpy -l 500MB --prefault
> | # Running mem/memcpy benchmark...
> | # Copying 500MB Bytes from 0x7ff1b45e2010 to 0x7ff1d39e3010 ...
> |
> |        4.849256 GB/Sec

Ok, looks rather useful.

We are rather close to being able to apply these bits. We need a resolution for the 
arch/x86/lib/memcpy_64.S details. The ugliest are these kinds of #ifdefs:

+#ifndef PERF_BENCH
 .Lmemcpy_e:
        .previous
+#endif

What happens if we keep that label in place?

This:

+#ifndef PERF_BENCH
 ENTRY(__memcpy)
 ENTRY(memcpy)
        CFI_STARTPROC
+#else
+	.globl  memcpy_x86_64_unrolled
+memcpy_x86_64_unrolled:
+#endif

Could be removed if you defined an ENTRY() macro in perf, right?

This:

+#ifndef PERF_BENCH
+
        CFI_ENDPROC
 ENDPROC(memcpy)
 ENDPROC(__memcpy)

Could be solved by defining ENDPROC()/etc. macros in perf, right?

We could remove this #ifdef:

+#ifndef PERF_BENCH
+
 #include <linux/linkage.h>

 #include <asm/cpufeature.h>
 #include <asm/dwarf2.h>

+#endif /* PERF_BENCH */

if you added empty linkage.h, cpufeature.h and dwarf2.h files as 
tools/perf/util/include/linux/linkage.h, tools/perf/util/include/asm/cpufeature.h.

That linkage.h file could even contain a short perf version of the ENTRY() macro, 
etc.

That way we can avoid having to touch arch/x86/lib/memcpy_64.S altogether.

Thanks,

	Ingo
