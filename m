Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0J3TYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:24:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33557 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab0J3TYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:24:22 -0400
Date: Sat, 30 Oct 2010 21:23:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        "Ma Ling:" <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] perf bench: add x86-64 specific benchmarks to perf
 bench mem memcpy
Message-ID: <20101030192357.GC26503@elte.hu>
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1288368098-26121-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288368098-26121-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
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

> This patch adds new file: mem-memcpy-x86-64-asm.S
> for x86-64 specific memcpy() benchmarking.
> Added new benchmarks are,
>  x86-64-rep:      memcpy() implemented with rep instruction
>  x86-64-unrolled: unrolled memcpy()
> 
> Original idea of including the source files of kernel
> for benchmarking is suggested by Ingo Molnar.
> This is more effective than write-once programs for quantitative
> evaluation of in-kernel, little and leaf functions called high frequently.
> Because perf bench is in kernel source tree and executing it
> on various hardwares, especially new model CPUs, is easy.
> 
> This way can also be used for other functions of kernel e.g. checksum functions.
> 
> Example of usage on Core i3 M330:
> 
> | % ./perf bench mem memcpy -l 500MB
> | # Running mem/memcpy benchmark...
> | # Copying 500MB Bytes from 0x7f911f94c010 to 0x7f913ed4d010 ...
> |
> |      578.732506 MB/Sec
> | % ./perf bench mem memcpy -l 500MB -r x86-64-rep
> | # Running mem/memcpy benchmark...
> | # Copying 500MB Bytes from 0x7fb4b6fe4010 to 0x7fb4d63e5010 ...
> |
> |      738.184980 MB/Sec
> | % ./perf bench mem memcpy -l 500MB -r x86-64-unrolled
> | # Running mem/memcpy benchmark...
> | # Copying 500MB Bytes from 0x7f6f2e668010 to 0x7f6f4da69010 ...
> |
> |      767.483269 MB/Sec
> 
> This shows clearly that unrolled memcpy() is efficient
> than rep version and glibc's one :)

Hey, really cool output :-)

Might also make sense to measure Ma Ling's patched version?

> # checkpatch.pl warns about two externs in bench/mem-memcpy.c
> # added by this patch. But I think it is no problem.

You should put these:

 +#ifdef ARCH_X86_64
 +extern void *memcpy_x86_64_unrolled(void *to, const void *from, size_t len);
 +extern void *memcpy_x86_64_rep(void *to, const void *from, size_t len);
 +#endif

into a .h file - a new one if needed.

That will make both checkpatch and me happier ;-)

Thanks,

	Ingo
