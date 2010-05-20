Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab0ETUcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 16:32:50 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1770 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab0ETUcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 16:32:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:x-system-of-record;
	b=N4lPHJSQqn6awralUBNYOskgXFMzbebI5Od5Rb3bFvK5aPMoFlI35vP1vtv1S00WU
	FLy2OG/CHKZRBb9CJ0tcQ==
MIME-Version: 1.0
Date: Thu, 20 May 2010 13:32:40 -0700
Message-ID: <AANLkTinUy8Uk8pAom03DKzYTqthdXQ5ADfjGmjbI7jxN@mail.gmail.com>
Subject: A possible sys_wait* bug
From: Salman Qazi <sqazi@google.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of our internal workloads ran into a problem with waitpid.  A
simple repro case is as follows:


#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <assert.h>
#include <sched.h>

#define NUM_CPUS 4

void *thread_code(void *args)
{
        int j;
        int pid2;
        for (j = 0; j < 1000; j++) {
                pid2 = fork();
                if (pid2 == 0)
                        while(1) { sleep(1000); }
        }

        while (1) {
                int status;
                if (waitpid(-1, &status, WNOHANG)) {
                        printf("! %d\n", errno);
                }

        }
        exit(0);

}

/*
 * non-blocking waitpids in tight loop, with many children to go through,
 * done on multiple thread, so that they can "pass the torch" to eachother
 * and eliminate the window that a writer has to get in.
 *
 * This maximizes the holding of the tasklist_lock in read mode, starving
 * any attempts to take the lock in the write mode.
 */
int main(int argc, char **argv)
{
        int i;
        pthread_attr_t attr;
        pthread_t threads[NUM_CPUS];
        for (i = 0; i < NUM_CPUS; i++) {
                assert(!pthread_attr_init(&attr));
                assert(!pthread_create(&threads[i], &attr, thread_code));
        }
        while(1) { sleep(1000);}
        return 0;
}


Basically, it is possibly for readers to continuously hold
tasklist_lock (theoretically forever, as they pass from one to other),
preventing the writer from taking that lock.  This typically causes a
lockup on a CPU where a task is attempting to do a fork() or exit(),
resulting in the NMI watchdog firing.

Yes, WNOHANG is being used.  And I agree that this is an inefficient
use of wait().  However, I think it should be possible to produce the
same effect without WNOHANG on sufficiently large number of threads:
by having it so that at least one thread always has the reader lock.

I think the most direct approach to the problem is to have the
readers-writer locks be writer biased (i.e. as soon as a writer
contends, we do not permit any new readers).  However all suggestions
are welcome.
