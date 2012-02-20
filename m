Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2BTBEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:04:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:53402 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2BTBED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:04:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.92.229 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <12996.1329699216@neuling.org>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <12996.1329699216@neuling.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Feb 2012 17:03:42 -0800
X-Google-Sender-Auth: T9JCw8DKpYDCHOkyyIjvzC7TH4o
Message-ID: <CA+55aFwHGUB7R6kpNPc7vDYF8dhYCKm4Riso-rpS2Fiqjg8hQg@mail.gmail.com>
Subject: Re: [PATCH 0/2] More i387 state save/restore work
To: Michael Neuling <mikey@neuling.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, anton@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 4:53 PM, Michael Neuling <mikey@neuling.org> wrote:
>
> Does "2476844 loops in 2 seconds" imply 2476844 context switches in 2
> sec?  With Anton's context_switch [1] benchmark, we don't even hit 100K
> context switches per sec.
>
> Do you have this test program anywhere?

Here. No guarantees that this is at all sane, it's special-cased code
literally for testing only this one issue. The only indication I have
that this works at all is that the numbers did change roughly as
expected, and the kernel profile changes made sense.

You may have to do something else than just do some FP calculation to
force it to use VSX on PPC, obviously.

                       Linus
---
[torvalds@i5 ~]$ cat fp-switch.c
#define _GNU_SOURCE
#include <sched.h>
#include <stdlib.h>

#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <sys/time.h>

#define SECONDS (2)
unsigned long loops = 0, child;

static void use_math(void)
{
	double x = 0;
	asm volatile("":"+m" (x));
	x += 1;
	asm volatile("":"+m" (x));
}

static void end(int signr)
{
	printf("%d loops in %d seconds\n", loops, SECONDS);
	kill(child, SIGKILL);
	exit(0);
}

int main(int argc, char **argv)
{
	cpu_set_t cpuset;

	CPU_ZERO(&cpuset);
	CPU_SET(0, &cpuset);

	sched_setaffinity(0, sizeof(cpu_set_t), &cpuset);

	child = fork();
	if (!child) {
		for (;;)
			sched_yield();
	}

	signal(SIGALRM, end);
	alarm(SECONDS);

	for (;;) {
		use_math();
		sched_yield();
		loops++;
	}
}
