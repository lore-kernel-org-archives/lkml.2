Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab0GBQW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab0GBQW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:22:27 -0400
Date: Fri, 2 Jul 2010 18:20:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, eric.dumazet@gmail.com,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] time/fs - file's time race with vgettimeofday
Message-ID: <20100702162034.GB31733@redhat.com>
References: <1278056519-5008-1-git-send-email-jolsa@redhat.com> <20100702161422.GA31733@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702161422.GA31733@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Oleg Nesterov wrote:
>
> But, get_seconds() is also used by sys_time(), and we should have the
> same problem with another trivial test-case:
>
> 	#include <stdio.h>
> 	#include <sys/time.h>
> 	#include <time.h>
>
> 	int main(void)
> 	{
> 		struct timeval tv;
> 		int sec;
>
> 		do {
> 			gettimeofday(&tv, NULL);
> 			sec = time(NULL);
> 		} while (tv.tv_sec <= sec);
>
> 		printf("gtod: %ld.%06ld\n", tv.tv_sec, tv.tv_usec);
> 		printf("time: %d.000000\n", sec);
> 		return 0;
> 	}
>
> However, this test-case can't trigger the problem. Confused.

Aha. libc's time() doesn't use sys_time(), it uses __vsyscall(1)
vtime()->do_vgettimeofday().

This one quickly triggers the "time goes backward" case.

	#include <stdio.h>
	#include <sys/time.h>
	#include <time.h>
	#include <unistd.h>
	#include <sys/syscall.h>

	int main(void)
	{
		struct timeval tv;
		int sec;

		do {
			gettimeofday(&tv, NULL);
			sec = syscall(__NR_time, NULL);
		} while (tv.tv_sec <= sec);

		printf("gtod: %ld.%06ld\n", tv.tv_sec, tv.tv_usec);
		printf("time: %d.000000\n", sec);
		return 0;
	}

Not that I think this "problem" should be fixed, just curious.

Oleg.

