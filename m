Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1LSLXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:23:44 -0500
Received: from info.dorms.msu.net ([93.180.4.5]:53956 "EHLO dorms.msu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1LSLXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:23:41 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Dec 2011 06:23:41 EST
From: =?utf-8?b?0JDRgNGC0LXQvCDQkNC90LjRgdC40LzQvtCy?= 
	<aanisimov@inbox.ru>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Commit 1e5a74059f9 broke utime measurement of ptraced() processes
Date: Mon, 19 Dec 2011 15:19:40 +0300
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc6+; KDE/4.5.95; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112191519.40901.aanisimov@inbox.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

  I have tried running a program that measures utime of another process in two 
different setups: the first time when the child process executes with no 
intervention and the second time when the child is ptrace()d and is stopped at 
every syscall. It turns out that the overhead imposed by ptrace() is approx. 
5% in 2.6.32, but it is 17% in 3.2-rc6. Yet worse is that in 2.6.32 the 
overhead per system call is roughly constant, but in 3.2-rc6 it varies wildly 
depending on number of cycles that the child spends in userspace: in some 
cases increasing "n_cycles_in_userspace / n_syscalls" ratio leads to increase 
of the overhead.

  I have bisected this bug down to commit 1e5a74059f9 which changed behaviour 
of sched.c::check_preempt_curr(). Before 1e5a74059f9 this function would skip 
the clock update depending on test_tsk_need_resched(p), but now it checks for
test_tsk_need_resched(rq->curr). Reverting this change makes utime measurement 
behave as in 2.6.32.

  Could you please have a closer look at check_preempt_curr()? I do not have 
sufficient knowledge of scheduler internals and can not tell which of two 
conditions must be checked to skip clock update of the current process.

  Here are two small programs that I used for testing. By changing N_ARITH_OPS 
in child.c you can control the "n_cycles_in_userspace / n_syscalls" ratio.

  If you answer to this email then please add me to CC: because I am not 
subscribed to lkml.

----- child.c -----
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#define N_ITERATIONS (256*1024)
#define N_ARITH_OPS (4*256)

static void __attribute__((noreturn)) die(const char *msg)
{
    printf("%s, errno=%d\n",msg,errno);
    exit(1);
}

volatile int x;

int main()
{
int fd;
char buf[128];

    fd=open("/proc/self/exe",O_RDONLY);
    if(fd<0)
        die("failed to open file 'foobar'");
    
    for(int i=0;i<N_ITERATIONS;++i)
    {
        pread(fd,buf,128,0);
        for(int j=0;j<N_ARITH_OPS;++j)
            ++x;
    }
    close(fd);
    
    return 0;
}
----- child.c -----

----- time-when-traced.c -----
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/ptrace.h>
#include <time.h>
#include <errno.h>

#define N_RUNS (8)

static void __attribute__((noreturn)) die(const char *msg)
{
    printf("%s, errno=%d\n",msg,errno);
    exit(1);
}

static void child_untraced()
{
char path[1024];
char *c;
char *args[]={NULL,NULL};
char *env[]={NULL};

    if(0>readlink("/proc/self/exe",path,1024))
        die("failed to read link to myself");
    
    c=strrchr(path,'/');
    strcpy(c+1,"child");
    
    args[0]=path;
    execve(path,args,env);
    die("failed to start the child");
}

static void child_traced()
{
    if(0>ptrace(PTRACE_TRACEME,0,NULL,0))
        die("failed to trace myself");
    child_untraced();
}

static inline int timeval_to_musec(const struct timeval *t)
{
    return (t->tv_sec*1000*1000 + t->tv_usec);
}

static int measure_time_untraced()
{
pid_t p;
int status;
struct rusage rusage;

    p=fork();
    if(p<0)
        die("failed to fork");
    if(!p)
        child_untraced();
    
    if(p!=wait4(p,&status,0,&rusage))
        die("failed to wait for child termination");
    
    if(!WIFEXITED(status) || 0!=WEXITSTATUS(status))
        die("child failed");
    
    return timeval_to_musec(&rusage.ru_utime);
}

volatile int x;

static int measure_time_traced()
{
pid_t p;
int status;
struct rusage rusage;
struct timespec cpu_time;

    p=fork();
    if(p<0)
        die("failed to fork");
    if(!p)
        child_traced();
    
    for(;;)
    {
        if(p!=wait4(p,&status,0,&rusage))
            die("failed to wait for child");
        if(WIFSTOPPED(status))
        {
            if(WSTOPSIG(status)!=SIGTRAP)
                die("signal is stopped by signal other than SIGTRAP");
        }
        else if(WIFSIGNALED(status))
            die("child was signaled");
        else if(WIFEXITED(status))
            break;
        else
            die("the child was neither stopped, nor signaled, nor killed?\n");
        
        for(int i=0;i<2*256;++i)
            ++x;
        if(0>ptrace(PTRACE_SYSCALL,p,NULL,0))
            die("failed to resume the child");
    }
    
    return timeval_to_musec(&rusage.ru_utime);
}

int main()
{
int time_untraced;
int time_traced;
long long diff;

    time_untraced=time_traced=0;
    
    {
            /* warm up */
            measure_time_untraced();
            measure_time_traced();
    }
    
    for(int i=0;i<N_RUNS;++i)
    {
            time_untraced+=measure_time_untraced();
            time_traced+=measure_time_traced();
    }
    
    printf("utime (untraced): %d musecs\n",time_untraced/N_RUNS);
    printf("utime (traced): %d musecs\n",time_traced/N_RUNS);
    diff = time_traced-time_untraced;
    printf("diff: %d\n",1000*diff/time_untraced);
    
    return 0;
}
----- time-when-traced.c -----

----- Makefile -----
time-when-traced: time-when-traced.c
	gcc -std=c99 -O2 -o time-when-traced time-when-traced.c

child: child.c
	gcc -std=c99 -O2 -o child child.c
----- Makefile -----
