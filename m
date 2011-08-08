Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1HHKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 06:25:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:40242 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686Ab1HHKZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 06:25:55 -0400
Subject: Re: avr32: handle_signal() bug?
From: Matt Fleming <matt@console-pimps.org>
To: =?ISO-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 11:25:49 +0100
Message-ID: <1312799149.10579.109.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-07 at 10:20 -0700, Håvard Skinnemoen wrote:
> Hi Matt,
> 
> On Wed, Aug 3, 2011 at 2:04 AM, Matt Fleming <matt@console-pimps.org> wrote:
> > That doesn't look correct to me. Now, if we were unsuccessful in setting
> > up a signal frame, say, ret == -EFAULT, do we really want to block the
> > signal or any of the signals in the handler mask?
> 
> I'm assuming this is a rhetorical question :-)

Sort of. I phrased it as a question so that someone could point out
whether my analysis was correct or not ;-)

> Looks good to me. I'm not sure how to test it though...I can try to
> build a kernel, run it on my board and see if it explodes, but I
> suspect this bug is a lot more subtle than that.

I suspect the best test would be one that makes use of SA_NODEFER.
Something like this,

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void handler(int signum)
{
	sigset_t mask;

	sigprocmask(SIG_BLOCK, NULL, &mask);
	printf("SIGUSR2: %s\n",
	       sigismember(&mask, SIGUSR2) ? "blocked" : "not blocked");
	printf("SIGTERM: %s\n",
	       sigismember(&mask, SIGTERM) ? "blocked" : "not blocked");
}

int main(int argc, char **argv)
{
	pid_t pid;

	pid = fork();
	if (pid == -1) {
		perror("fork");
		exit(EXIT_FAILURE);
	} else if (!pid) {
		struct sigaction act;

		memset(&act, 0, sizeof(act));
		act.sa_handler = handler;
		act.sa_flags = SA_NODEFER;

		sigaddset(&act.sa_mask, SIGUSR2);
		sigaddset(&act.sa_mask, SIGTERM);

		sigaction(SIGUSR1, &act, NULL);

		pause();
	} else {
		int status;

		sleep(3);
		kill(pid, SIGUSR1);
		waitpid(pid, &status, 0);
	}

	return 0;
}

Without the patch applied I would expect this testcase to run the signal
handler without SIGUSR2 or SIGTERM blocked. With the patch I'd hope you
would see the following,

[matt@mfleming-mobl1 signal-tests]$ ./nodefer
SIGUSR2: blocked
SIGTERM: blocked

-- 
Matt Fleming, Intel Open Source Technology Center

