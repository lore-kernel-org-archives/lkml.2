Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab2JKSxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2JKSxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:53:36 -0400
Message-ID: <5077157A.7060401@redhat.com>
Date: Thu, 11 Oct 2012 14:52:42 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        paulmck@linux.vnet.ibm.com
Subject: RCU NOHZ, tsc, and clock_gettime
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been tracking an odd bug that may involve the RCU NOHZ code and
just want to know if you have any ideas on debugging and/or what might be
wrong.  Note the bug happens on *BOTH* upstream and the current RHEL6 tree.
The data in this email is from running on RHEL6 because that's what I happen
to be running ATM.  The result, however, is _identical_ to that of linux.git
latest.

The attached program compares userspace TSC reads to the time returned from
the REALTIME_CLOCK[1].  The test does the following

read tsc1
get REALTIME_CLOCK value
read tsc2

and then does a comparison between the tsc read and the REALTIME_CLOCK value
to see if they are in sync with each other.

[I'm leaving out the guts of the analysis here.  It is sufficient to show
examples of "good" data and "bad" data IMO.]

On a good run, we see little variance in between the values:

    0   144       0.1
    1   138       1.8
    2   147      -2.9
    3   138       0.6
    4   141       0.2
    5   138      -1.2
    6   147      -0.4
    7   144       0.4
    8   144      -0.6
    9   144      -0.9
   10   144       2.1
   11   138      -0.7
   12   144      -0.4
   13   144       0.5
   14   144       0.6
   15   144      -0.8
   16   141       1.5
   17   147       1.9
   18   141      -0.1
   19   141       0.7
   20   144       0.3
   21   144      -0.4
   22   138       0.2
   23   141      -2.1
   24   144      -1.0
   25   141       1.2
   26   141      -0.5
   27   144      -0.2
   28   138       0.7
   29   144      -0.6
n: 30, slope: 0.50 (1.99 GHz), dev: 1.1 ns, max: 2.9 ns


On a bad run, there is a lot of variance between the values:

    0   144    -346.0
    1   138    1410.8
    2   138    -806.9
    3   141    4006.6
    4   147   -3996.1
    5   138    -255.8
    6   144     -22.2
    7   138     -22.4
    8   144     102.7
    9   141     218.0
   10   138     -11.6
   11   138      -4.9
   12   138     -26.2
   13   138     -51.2
   14   141    -280.0
   15   144   -1120.5
   16   144     -13.8
   17   138     -15.9
   18   144     -46.2
   19   138     -46.7
   20   138    -453.4
   21   138    2062.7
   22   141    -125.4
   23   138    -453.4
   24   138    1050.1
   25   138    -643.6
   26   138      14.3
   27   138       7.7
   28   138     -80.6
   29   141     -50.3
n: 30, slope: 0.50 (1.99 GHz), dev: 1231.4 ns, max: 4006.6 ns


It was noted by the bug reporter that specifying "nohz=off" resolved the
problem.  I tested with "nohz=off" and AFAICT it fixes the issue.  I started
out debugging by assuming that delays in the c-state transitions were not being
properly accounted for in the timing calculations.

I ran a baseline test on an unmodified kernel (with no extra boot options) and
confirmed that powertop shows the CPUs entering deep c-states while the test was
running for 300 runs.

I then instrumented the PM QoS and the power management code (specifically
cpuidle).  I put in a large # of printk's to monitor the CPU transitions, and
monitored the power states via powertop in order to verify that the system was
behaving correctly wrt PM QoS.

If you modify the tstsc script to run 300 times with this modified kernel, and
run powertop in the middle of the script, you will see that the processors do
NOT enter deep c-states.  **This means that PM QoS is doing its job correctly**.

After this I decided to use "idle=poll" as a boot parameter.  This kernel
argument forces a kernel polling loop on each cpu that should prevent the
cpu from entering a deep c-state.

When running with idle=poll, powertop indicates that the processors NEVER
enter a deep c-state (or at least AFAICS).  Running the tstsc test again
results in the *SAME* failure as with the regular kernel.

So this means, IMO, that the problem lies within some other aspect of the
NOHZ code.  I started backing out some pieces of the NOHZ code trying to
see what caused the problems with the test, and finally got to the RCU NOHZ
code.  (Yeah ... this wasn't the best thing to do ... and it results in a
almost nonfunctional kernel, especially with filesystems ...)

When I do that, surprisingly the problem goes away.  That is, the test
functions like it should.  I do not see any problems in the calculations and
at the sametime I can confirm that I'm seeing c-state transitions via
powertop.

I've narrowed down a brute-force code removal to code in
dyntick_save_progress_counter()
and rcu_implicit_dynticks_qs() but don't have enough knowledge of NOHZ RCU to
get my hands around the problem.  Admittedly I'm still trying to wrap my head
around dynticks and its usage by reading the code.  I was wondering if anyone
might have an idea of what could be wrong?  I'm certainly willing to continue to
debug.

P.

[1]  Please note that switching to the MONOTONIC, or MONOTONIC_RAW clocks
also result in the same problem.



/* gcc tstsc.c -o tstsc -lrt -lm */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <limits.h>
#include <math.h>
#include <inttypes.h>
#include <sched.h>

#define SAMPLES 30
#define SAMPLES_PER_SEC 10
#define SAMPLE_LOOPS 40

struct sample {
	uint64_t tsc;
	uint64_t ts;
	int delay;
};

static uint64_t rdtsc() {
#if 1
	uint32_t a, d;
	__asm__ __volatile__("rdtsc" : "=a" (a), "=d" (d));
	return (uint64_t)d << 32 | a;
#else
	return __builtin_ia32_rdtsc();
#endif
}


static void get_sample(struct sample *sample) {
	int i, delay, mindelay;
	struct timespec ts = {0, 0}, ts1;
	uint64_t tsc = 0, tsc1, tsc2;

	for (i = 0, mindelay = INT_MAX; i < SAMPLE_LOOPS; i++) {
		tsc1 = rdtsc();
		clock_gettime(CLOCK_REALTIME, &ts1);
		tsc2 = rdtsc();
		delay = tsc2 - tsc1;
		if (delay <= mindelay) {
			ts = ts1;
			tsc = (tsc1 + tsc2) / 2;
			mindelay = delay;
		}
	}

	sample->tsc = tsc; /* the current time read directly from tsc */
	/* the kernel's representation of time */
	sample->ts = (uint64_t)ts.tv_sec * 1000000000 + ts.tv_nsec;
	sample->delay = mindelay;
}

/* taken/modified from chrony/regress.c */
void
regress
(double *x,                     /* independent variable */
 double *y,                     /* measured data */
 int n,                         /* number of data points */

 /* And now the results */

 double *b0,                    /* estimated y axis intercept */
 double *b1,                    /* estimated slope */
 double *s2

 /* Could add correlation stuff later if required */
)
{
  double P, Q, U, V, W;
  double diff;
  double u, ui;
  int i;

  assert(n >= 3);

  W = U = 0;
  for (i=0; i<n; i++) {
    U += x[i];
    W += 1.0;
  }

  u = U / W;

  /* Calculate statistics from data */
  P = Q = V = 0.0;
  for (i=0; i<n; i++) {
    ui = x[i] - u;
    P += y[i];
    Q += y[i] * ui;
    V += ui   * ui;
  }

  *b1 = Q / V;
  *b0 = (P / W) - (*b1) * u;

  *s2 = 0.0;
  for (i=0; i<n; i++) {
    diff = y[i] - *b0 - *b1*x[i];
    *s2 += diff*diff;
  }

  *s2 /= (double)(n-2);
}

char buf[2] = {'0', '\n'} ;

int main() {
	struct sample samples[SAMPLES];
	double x[SAMPLES], y[SAMPLES], slope, intercept, offset, variance, max_offset;
	int i;
	FILE *fd = NULL;
	uint32_t retval;
	struct sched_param param;

/* change this to 0 if you want to avoid using PM QoS */
#if 1
	param.sched_priority = sched_get_priority_max(SCHED_RR);
	if( sched_setscheduler( 0, SCHED_RR, &param ) == -1 )
	{
		printf("sched_setscheduler error");
	}

	fd = fopen("/dev/cpu_dma_latency", "w+");

	if (!fd)
		printf("Cannot open /dev/cpu_dma_latency ... test may be skewed!\n");
	/* write a binary zero and keep the file descriptor */
	retval = fwrite(buf, sizeof(buf), 1, fd);
	fflush(fd);
#endif

#if 1
	usleep(100000);
#endif
	for (i = 0; i < SAMPLES; i++) {
		printf("getting data for sample set %d\n", i);
		get_sample(samples + i);
#if 0
		usleep(rand() % 2000000 / SAMPLES_PER_SEC);
#else
		usleep(1000000 / SAMPLES_PER_SEC);
#endif
	}

	for (i = 0; i < SAMPLES; i++) {
		x[i] = samples[i].tsc - samples[0].tsc;
		y[i] = samples[i].ts - samples[0].ts;
	}

	/* x = average_tsc[i]-average_tsc[0], y = ts[i]-ts[0] */
	regress(x, y, SAMPLES, &intercept, &slope, &variance);
	max_offset = 0.0;

	for (i = 0; i < SAMPLES; i++) {
		offset = x[i] * slope + intercept - y[i];
		if (fabs(offset) > max_offset)
			max_offset = fabs(offset);
		/* delay = delta(tsc2 - tsc1),
		 * offset = (average_tsc - ts) in ns
		 */
		printf("%5d %5d %9.1f\n", i, samples[i].delay, offset);
	}

	printf("n: %d, slope: %.2f (%.2f GHz), dev: %.1f ns, max: %.1f ns\n", SAMPLES,
slope, 1.0 / slope, sqrt(variance), max_offset);
	if (fd)
		fclose(fd);
	return 0;
}
