Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab0C2NlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:41:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45227 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0C2NlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:41:18 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [REGRESSION 2.6.30][PATCH 0/1] sched: defer idle accounting till after load update period
Date: Mon, 29 Mar 2010 09:41:11 -0400
Message-Id: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes a load avg calculation bug. Details are included with
the patch. Essentially, a task that often runs for less than 10 ticks at a time
is likely to be left out of the load avg calculation. A test case is provided
below. If you run the test case on a near zero-load system you will find top
report 90% cpu usage while the load avg stays at or near 0.00. With the patch,
the load avg is calculated correctly to be at least 0.90.

This is a regression since 2.6.30. The offending commit is:
dce48a84adf1806676319f6f480e30a6daa012f9.

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
