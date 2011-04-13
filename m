Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab1DMHEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:04:47 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:38404 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab1DMHEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:04:45 -0400
Message-ID: <4DA54B0A.4090206@secunet.com>
Date: Wed, 13 Apr 2011 09:04:42 +0200
From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, tsmith201104@yahoo.com
Subject: [futex] Regression in 2.6.38 regarding FLAGS_HAS_TIMEOUT
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------090201080403090803060800"
X-OriginalArrivalTime: 13 Apr 2011 07:04:43.0249 (UTC) FILETIME=[108A7610:01CBF9A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090201080403090803060800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

I noticed that the behaviour of FUTEX_WAIT changed between 2.6.37 and
2.6.38. The error was initially found in a java program where a
Thread.sleep never returned after resuming from a suspend to ram.
Thread.sleep is implemented using pthread_cond_timedwait which itself
uses futex with the op FUTEX_WAIT.

The error can also be triggered with a simple test program (attached as
test-futex.c) which calls FUTEX_WAIT with a timeout of 200ms in a loop.
While running the test program the machine is suspended using "echo mem
> /sys/power/state".

After resume the futex syscall never returns. The return can be provoked
by sending the process a combination of SIGSTOP and SIGCONT.

The bug didn't occur in 2.6.37.

I found this bug report

https://bugzilla.kernel.org/show_bug.cgi?id=32922

which describes a related problem and presented a patch. This patch
(adding the FLAGS_HAS_TIMEOUT in futex_wait to the restart_block) fixes
the problem for my initial java problem and the test program.

I found the following pull request which probably introduced the
problem: https://lkml.org/lkml/2011/1/6/62

Thanks,

	Torsten



--------------090201080403090803060800
Content-Type: text/x-csrc;
 name="test-futex.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="test-futex.c"

#include <errno.h>
#include <linux/futex.h>
#include <stdio.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <unistd.h>

static inline int futex(int *uaddr, int op, int val,
			const struct timespec *timeout,
			int *uaddr2, int val3)
{
	return syscall(SYS_futex, uaddr, op, val,
		       timeout, uaddr2, val3);
}

static void futex_sleep(int ms)
{
	static int round;
	struct timespec ts;
	int condition = 0;
	int rc;
	fprintf(stderr, "Before sleep %d\n", ++round);
	ts.tv_sec = 0;
	ts.tv_nsec = ms * 1000L * 1000L;
	rc = futex(&condition, FUTEX_WAIT, condition, &ts, NULL, 0);
	fprintf(stderr, "After sleep (error: %s)\n",
		(rc < 0 ? strerror(errno) : "none"));
}

int main()
{
	while(1) {
		futex_sleep(200);
	}
	return 0;
}

--------------090201080403090803060800--
