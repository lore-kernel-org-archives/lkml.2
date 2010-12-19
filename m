Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0L2WUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 17:20:08 -0500
Received: from lo.gmane.org ([80.91.229.12]:55965 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab0L2WUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 17:20:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jens Moser <j.mos@gmx.net>
Subject: Re: PROBLEM: pthread-safety bug in write(2) on Linux 2.6.x
Date: Sun, 19 Dec 2010 22:45:43 +0000 (UTC)
Message-ID: <loom.20101219T231520-498@post.gmane.org>
References: <6.2.5.6.2.20060412173852.033dbb90@cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 88.217.154.178 (Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.13) Gecko/20101203 Firefox/3.6.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Bonachea <bonachead <at> comcast.net> writes:

> 
> Hi - I believe I've discovered a thread-safety bug in the Linux 2.6.x kernel 
> implementation of write(2).
> 
> The small C program below the problem - in a nutshell, if multiple threads 
> write() to STDOUT_FILENO, and stdout has been redirected to a file, then some 
> of the output lines get lost. The actual result is non-deterministic (even in 
> a "correct" run) - however the expected correct behavior is 10 lines of output 
> (in some non-deterministic order). However, the test program reproducibly 
> generates some lost output (less than 10 lines of total output) on every run 
> where the output is redirected to a new file. This appears to be a violation 
> of the POSIX spec (POSIX 1003.1-2001:2.9.1 requires thread-safety of write()). 
> 
> The problem does not appear to occur if output goes to the console, or is 
> redirected to append to an existing file, only when stdout is redirected to a 
> new file.
> 
> ---------------------------------------------------------------------------
> /* Instructions:
>   * compile as: gcc write-bug.c -lpthread
>   * run with: ./a.out
>   *   note that lines from all 10 threads are visible
>   * run with: ./a.out > output
>   *   note that lines from several threads are missing from the output file
>   */
> #include <pthread.h>
> #include <stdio.h>
> #include <unistd.h>
> volatile int flag = 0;
> void *start(void *arg) {
>    char msg[255];
>    int res;
>    sprintf(msg,"hi from %i\n",(int)arg);
>    if ((int)arg == 9) flag = 1;
>    while (!flag) ; /* thread barrier */
>    #if 1
>      res = write(STDOUT_FILENO,msg,strlen(msg));
>      if (res != strlen(msg)) fprintf(stderr,"Failure: %i 
> %s\n",res,strerror(res));
>    #else
>      fputs(msg,stdout);
>    #endif
>    #if 1 /* work extra hard to flush output (makes no difference) */
>      fflush(NULL);
>      fsync(STDOUT_FILENO);
>      sync();
>    #endif
>    return NULL;
> }
> int main() {
>    int i;
>    /* create 10 pthreads */
>    pthread_t id[10];
>    for (i =0 ; i < 10; i++) {
>      int ret = pthread_create(&(id[i]),NULL,&start,(void*)i);
>      if (ret) printf("pthread_create: %s\n",strerror(ret));
>    }
>    /* join 10 pthreads */
>    for (i =0 ; i < 10; i++) {
>      pthread_join(id[i], NULL);
>    }
>    sleep(1);
>    return 0;
> }
> ---------------------------------------------------------------------------
> 
> The problem occurs on every Linux 2.6 machine I've tried, including ones with 
> Itanium-2, Athlon, Opteron and Pentium 4 chips, both SMP's and uniprocessors, 
> using a variety of recent gcc versions. The problem does *not* appear to occur 
> on any Linux 2.4 machine I've tried, even if I use the same executable which 
> fails on the Linux 2.6 machine. Finally, replacing write(STDOUT_FILENO) with 
> fputs(stdout) makes the problem disappear (presumably due to locking in libc).
> 
> I don't have administrative access to upgrade the kernel on these machines, 
> however below is the full machine info for the most recent installed kernel 
> version I have access to.
> 
> Any suggestions are appreciated.
> Thanks,
> Dan


Hello all,

it's a long time since above message was posted and I wondered if Linus' patch
found it's way into the mainline kernel. A quick check with Dan Bonachea's test
program below showed that this is probably not the case.

We are currently porting a program to Linux (x86 and x86-64) which suffers from
the exact same problem. In contrast to Dan's scientific program our application
could live with occasional losses of messages as long as the output of different
concurrent write(2)s won't be interleaved.

So if we had a write(2) of "abcdef" and a second concurrent write(2) of "uvwxyz"
it would be tolerable if the output of one of them was lost, but it would be
catastrophic for our application if the output was interleaved, e.g. in the form
"abcuvwdefxyz".

I checked for that case with a modified version of Dan's test program (with
write(2)s of up to 100 MB
per thread) and under no circumstances did I get interleaved output (but only
losses of output).

So my question is, does Linux do any synchronisation to prevent interleaving of
output in conjuction with concurrent write(2)s to the same file descriptor
(regular files only). If not, the test results would be a surprise to me, but
maybe someone with more knowledge in regards to the Linux kernel could shed some
light on that.

Any answers are higly appreciated!

Many thanks in advance,

Jens Moser





