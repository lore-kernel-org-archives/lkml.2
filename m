Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2FRKN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:13:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47133 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2FRKN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:13:27 -0400
Message-ID: <1340014395.15222.25.camel@twins>
Subject: RE: [PATCH] sched: Folding nohz load accounting more accurate
From: Peter Zijlstra <peterz@infradead.org>
To: Doug Smythies <dsmythies@telus.net>
Cc: "'Charles Wang'" <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Charles Wang'" <muming.wq@taobao.com>, "'Tao Ma'" <tm@tao.ma>,
        =?UTF-8?Q?=27=E5=90=AB=E9=BB=9B=27?= <handai.szj@taobao.com>
Date: Mon, 18 Jun 2012 12:13:15 +0200
In-Reply-To: <000101cd49db$b0d92a20$128b7e60$@net>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
				 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com>
			 <1339494970.31548.66.camel@twins> <004701cd4929$200d4600$6027d200$@net>
		 <1339575411.31548.107.camel@twins> <000601cd4979$e1fda7a0$a5f8f6e0$@net>
	 <1339624653.8980.76.camel@twins> <000101cd49db$b0d92a20$128b7e60$@net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 20:13 -0700, Doug Smythies wrote:
> ./waiter 2 900 345912 9444

So we're all simply just trying to burn a particular amount of cpu-time?

I have a little consume.c thing lying about doing something like that.
Its independent of clockspeed, but doesn't really like preemption much,
but it more or less works ;-)

---
#include <sys/time.h>
#include <unistd.h>
#include <stdio.h>

unsigned long long stamp(void)
{
	struct timeval tv;

	gettimeofday(&tv, NULL);

	return (unsigned long long)tv.tv_sec * 1000000 + tv.tv_usec;
}

void consume(int spin, int total)
{
	unsigned long long begin, now;

	begin = stamp();

	for (;;) {
		now = stamp();
		if ((long long)(now - begin) > spin) {
			usleep(total - spin);
			begin += total;
		}
	}
}

int main(int argc, char **argv)
{
	int period = 100000; /* 100ms */
	int frac;

	if (argc < 2) {
		fprintf(stderr, "%s <frac> [<period>]\n"
				"  frac   -- [1-100] %% of time to burn\n"
				"  period -- [usec] period of burn/sleep cycle\n",
				argv[0]);
		return -1;
	}

	frac = atoi(argv[1]);
	if (argc > 2)
		period = atoi(argv[2]);

	if (frac > 100)
		frac = 100;

	if (frac < 1)
		frac = 1;

	consume((period * frac) / 100, period);

	return 0;
}

