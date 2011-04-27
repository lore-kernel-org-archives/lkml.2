Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab1D0Qcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:32:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44854 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1D0Qce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gPlZGBahdUrEqLdS2OBzJ5+QsaSR7WVXNsqnIyC2RBvAQpwPfz7LJ/67jgYaDupkRo
         p7myD/wJ2jVwRSyLk/IwByBMQriVrrxIkFnBVxAZfL92QIieIGDm6hQZ3YtMXYmL8L5B
         J7xaIt6hD+S/rLlRnCqPIivDlVSzs+7tOEerk=
Subject: Re: [RFC][PATCH 1/4] clock_rtoffset: new syscall
From: Kay Sievers <kay.sievers@vrfy.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <alpine.LFD.2.02.1104271359580.3323@ionos>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>
	 <1303901023-11568-1-git-send-email-virtuoso@slind.org>
	 <alpine.LFD.2.02.1104271359580.3323@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 22:55:55 +0200
Message-ID: <1303937755.1065.8.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 16:02 +0200, Thomas Gleixner wrote:
> On Wed, 27 Apr 2011, Alexander Shishkin wrote:
> 
> > In order to keep track of system time changes, we introduce a new
> > syscall which returns the offset of CLOCK_MONOTONIC clock against
> > CLOCK_REALTIME. The caller is to store this value and use it in
> > system calls (like clock_nanosleep or timerfd_settime) that will
> > compare it against the effective offset in order to ensure that
> > the caller's notion of the system time corresponds to the effective
> > system time at the moment of the action being carried out. If it
> > has changed, these system calls will return an error and the caller
> > will have to obtain this offset again.
> 
> No, we do not expose kernel internals like this to user space. The
> kernel internal representation of time is subject to change.

> The completely untested patch below should solve the same problem in a
> sane way. Restricted to timerfd, but that really should be sufficient.

> Subject: timerfd: Allow timers to be cancelled when clock was set
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 27 Apr 2011 14:16:42 +0200

Seems to work fine for me here for the weird "cron timer" case, or the
simple "desktop clock" use-case -- where we want to rely on the timer to
let the process sleep as long as possible, but wake it up to recalculate
the next wakeup in case anything has changed in the meantime.

Tested-By: Kay Sievers <kay.sievers@vrfy.org>

The simple test program, that has two timerfds, and watches them is
below. Changing the system time from wakes up only the timerfd with
TFD_TIMER_CANCELON_SET set.

Thanks,
Kay


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdint.h>
#include <sys/poll.h>
#include <sys/timerfd.h>

#ifndef TFD_TIMER_CANCELON_SET
#define TFD_TIMER_CANCELON_SET (1 << 1)
#endif

int main(int argc, char *argv[])
{
	struct itimerspec its;
	struct pollfd pollfd[2];

	pollfd[0].fd = timerfd_create(CLOCK_REALTIME, TFD_NONBLOCK|TFD_CLOEXEC);
	if (pollfd[0].fd < 0) {
		printf("create error 1: %m\n");
		_exit(2);
	}
	pollfd[0].events = POLLIN;

	pollfd[1].fd = timerfd_create(CLOCK_REALTIME, TFD_NONBLOCK|TFD_CLOEXEC);
	if (pollfd[1].fd < 0) {
		printf("create error 2: %m\n");
		_exit(2);
	}
	pollfd[1].events = POLLIN;

	for (;;) {
		printf("\n");

		memset(&its, 0, sizeof(struct itimerspec));
		clock_gettime(CLOCK_REALTIME, &its.it_value);
		its.it_value.tv_sec += 10;

		if (timerfd_settime(pollfd[0].fd, TFD_TIMER_ABSTIME, &its, NULL) < 0) {
			printf("settime error 1: %m\n");
			_exit(3);
		} else {
			printf("settime +10s 1\n");
		}

		if (timerfd_settime(pollfd[1].fd, TFD_TIMER_ABSTIME|TFD_TIMER_CANCELON_SET, &its, NULL) < 0) {
			printf("settime error: 2: %m\n");
			_exit(3);
		} else {
			printf("settime +10s 2\n");
		}

		printf("poll\n");
		if (poll(pollfd, 2, -1) < 0) {
			if (errno == EAGAIN || errno == EINTR)
				continue;
			_exit(4);
		}

		if (pollfd[0].revents) {
			uint64_t count;

			if (read(pollfd[0].fd, &count, sizeof(uint64_t)) < 0)
				printf("read error 1: %m\n");
			else
				printf("read 1: %u\n", (unsigned int)count);

			printf("wakeup 1\n");
		}

		if (pollfd[1].revents) {
			uint64_t count;

			if (read(pollfd[1].fd, &count, sizeof(uint64_t)) < 0)
				printf("read error 2: %m\n");
			else
				printf("read 2: %u\n", (unsigned int)count);

			printf("wakeup 2\n");
		}
	}

	return EXIT_SUCCESS;
}


