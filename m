Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab2FGHrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:47:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59739 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2FGHrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:47:15 -0400
Subject: Re: vmsplice triggering bug in kfree.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
        Tom Herbert <therbert@google.com>
In-Reply-To: <1339048365.26966.89.camel@edumazet-glaptop>
References: <20120607025117.GA28261@redhat.com>
	 <1339043263.26966.79.camel@edumazet-glaptop>
	 <1339044013.26966.80.camel@edumazet-glaptop>
	 <1339048365.26966.89.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 09:47:08 +0200
Message-ID: <1339055228.26966.103.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 07:52 +0200, Eric Dumazet wrote:
> On Thu, 2012-06-07 at 06:40 +0200, Eric Dumazet wrote:
> > On Thu, 2012-06-07 at 06:27 +0200, Eric Dumazet wrote:
> > 
> > > Thanks Dave, I'll take a look today on this report.
> > > 
> > 
> > OK, trivial bug, I am testing a fix, thanks again.
> > 
> 
> Not sure if you can reproduce this bug easily, if so could you test
> following patch ?

By the way, following program triggers the bug instantly :

#define __USE_GNU 1
#define _GNU_SOURCE
#include <fcntl.h>
#include <pthread.h>
#include <sys/types.h>

#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

int pfd[2];

void *worker(void *arg)
{
	unsigned int page_size = 4096;

	while (1) {
		fcntl(pfd[1], F_SETPIPE_SZ, 16 * page_size);
		fcntl(pfd[1], F_SETPIPE_SZ, 64 * page_size);
	}
}

char buffer[1024*1024];

int main(int argc, char *argv[])
{
	pthread_t tid;
	int res, fdnull = open("/dev/null", O_WRONLY);

	if (pipe(pfd) == -1) {
		perror("pipe");
		return 1;
	}
	res = pthread_create(&tid, NULL, worker, NULL);
	if (res) {
		errno = res;
		perror("pthread_create");
		return 1;
	}

	while (1) {
		struct iovec iov[1];
		int wr;

		iov[0].iov_base = buffer;
		iov[0].iov_len = 1024*1024;
		wr = vmsplice(pfd[1], iov, 1, SPLICE_F_GIFT);
		if (wr > 0) {
			wr = splice(pfd[0], NULL,
				    fdnull, NULL,
				    wr, SPLICE_F_MOVE | SPLICE_F_MORE);
		}
	}
}


