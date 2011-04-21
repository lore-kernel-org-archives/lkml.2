Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1DUGQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:16:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53484 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1DUGQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:16:49 -0400
Date: Thu, 21 Apr 2011 08:16:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
Message-ID: <20110421061643.GA31388@elte.hu>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Nikhil Rao <ncrao@google.com> wrote:

> Major TODOs:
> - Detect overflow in update shares calculations (time * load), and set load_avg
>   to maximum possible value (~0ULL).
> - tg->task_weight uses an atomic which needs to be updates to 64-bit on 32-bit
>   machines. Might need to add a lock to protect this instead of atomic ops.
> - Check wake-affine math and effective load calculations for overflows.
> - Needs more testing and need to ensure fairness/balancing is not broken.

Please measure micro-costs accurately as well, via perf stat --repeat 10 or so.

For example, on a testsystem doing 200k pipe triggered context switches (100k 
pipe ping-pongs) costs this much:

 $ taskset 1 perf stat --repeat 10 ./pipe-test-100k

        630.908390 task-clock-msecs         #      0.434 CPUs    ( +-   0.499% )
           200,001 context-switches         #      0.317 M/sec   ( +-   0.000% )
                 0 CPU-migrations           #      0.000 M/sec   ( +-  66.667% )
               145 page-faults              #      0.000 M/sec   ( +-   0.253% )
     1,374,978,900 cycles                   #   2179.364 M/sec   ( +-   0.516% )
     1,373,646,429 instructions             #      0.999 IPC     ( +-   0.134% )
       264,223,224 branches                 #    418.798 M/sec   ( +-   0.134% )
        16,613,988 branch-misses            #      6.288 %       ( +-   0.755% )
           204,162 cache-references         #      0.324 M/sec   ( +-  18.805% )
             5,152 cache-misses             #      0.008 M/sec   ( +-  21.280% )

We want to know the delta in the 'instructions' value resulting from the patch 
(this can be measured very accurately) and we also want to see the 'cycles' 
effect - both can be measured pretty accurately.

I've attached the testcase - you might need to increase the --repeat value so 
that noise drops below the level of the effect from these patches. (the effect 
is likely in the 0.01% range)

It would also be nice to see how 'size vmlinux' changes with these patches 
applied, on a 'make defconfig' build.

Thanks,

	Ingo

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pipe-test-100k.c"


#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>
#include <linux/unistd.h>

#define LOOPS 100000

int main (void)
{
	unsigned long long t0, t1;
	int pipe_1[2], pipe_2[2];
	int m = 0, i;

	pipe(pipe_1);
	pipe(pipe_2);

	if (!fork()) {
		for (i = 0; i < LOOPS; i++) {
			read(pipe_1[0], &m, sizeof(int));
			write(pipe_2[1], &m, sizeof(int));
		}
	} else {
		for (i = 0; i < LOOPS; i++) {
			write(pipe_1[1], &m, sizeof(int));
			read(pipe_2[0], &m, sizeof(int));
		}
	}

	return 0;
}


--EVF5PPMfhYS0aIcm--
