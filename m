Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0CUWpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 18:45:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51404 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0CUWpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 18:45:30 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/1] sched: defer idle accounting till after load update period
Date: Sun, 21 Mar 2010 18:45:23 -0400
Message-Id: <1269211524-29332-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes a load avg calculation bug. Details are included with
the patch. Essentially, a task that often runs for less than 10 ticks at a time
is likely to be left out of the load avg calculation. A test case is provided
below. If you run the test case on a near zero-load system you will find top
report 90% cpu usage while the load avg stays at or near 0.00. With the patch,
the load avg is calculated correctly to be at least 0.90.

--

#include <asm/param.h>
#include <sys/time.h>
#include <time.h>

int main() {
	struct timespec ts;
	ts.tv_sec = 0;
	ts.tv_nsec = 1000000000 / HZ;

	/*
	 * Run gettimeofday in a tight loop 9 ticks, then sleep for 1 tick
	 */
	while (1) {
		struct timeval tv;

		do {
			gettimeofday(&tv, NULL);
		} while ((tv.tv_usec * HZ / 1000000) % 10 != 0);

		nanosleep(&ts, NULL);
	}
	return 0;
}
