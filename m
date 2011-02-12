Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1BLO2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 09:28:34 -0500
Received: from fallback6.mail.ru ([94.100.176.134]:38962 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752870Ab1BLO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 09:28:28 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Feb 2011 09:28:28 EST
From: =?utf-8?b?0JDRgNGC0LXQvCDQkNC90LjRgdC40LzQvtCy?= 
	<aanisimov@inbox.ru>
To: linux-kernel@vger.kernel.org
Subject: On interaction between user time accounting and tracing with ptrace()
Date: Sat, 12 Feb 2011 17:31:28 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.37lockdep; KDE/4.5.95; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102121731.28851.aanisimov@inbox.ru>
X-Mras: Ok
X-MR-Warn: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

  I've tried to measure utime of a program when it is not ptrace()d and when 
it is. User times reported in these two cases differ significantly and I do 
not know the reason for this difference. I'd like to ask you whether it is a 
bug in time accounting in kernel or a bug in my test program.

  Let us start with description of the test setup. The source code can be 
found at the end of this email.

  A program being traced essentially makes a considerable number of syscalls 
and makes N_ARITH_OPS simple arithmetic operations and memory accesses between 
two consequent syscalls; changing N_ARITH_OPS will later be used to obtain 
some interesting results.

  Now let us pass to the main program, which runs the child and measures its 
utime in two different ways. First, it simply invokes the child, waits for its 
completion and collects resource usage stats. Then, the child is started with 
ptrace enabled and it is stopped at every invocation of a syscall; after 
running the child in this ptrace()d mode its resource usage stats are 
collected.

  During the tests cpu frequency governor was set to 'performance' so that cpu 
frequency scaling does not get in the way.

  Here are some numbers that I get when running my test on single-core i386 
CPU (Pentium M Dothan @ 2.0GHz).

N_ARITH_OPS=0*256                |  N_ARITH_OPS=2*256
                                 |
utime (untraced): 31001 musecs   |  utime (untraced): 461528 musecs
utime (traced): 60503 musecs     |  utime (traced): 557034 musecs

  As one can see, utime is consistently higher when the child is ptraced().

  Here are some numbers that I get when running my test on dual-core x86_64 
CPU (Intel E5500 @ 2.8GHz).

N_ARITH_OPS=0*256                |  N_ARITH_OPS=2*256
                                 |
utime (untraced): 9873 musecs    |  utime (untraced): 298579 musecs
utime (traced): 1249 musecs      |  utime (traced): 659274 musecs

  The case of N_ARITH_OPS=0*256 seems very strange here because in all other 
cases utime of traced process in higher than utime of untraced process (traced 
process' utime is also higher with N_ARITH_OPS=4*256, which is not listed 
here).

  Both test machines were running linux 2.6.37.

  Could you please explain why utime of a traced process is almost always 
higher than utime of standalone process? The process being traced does not 
change between two invocations so the increase of utime is certainly a bug. 
Also I'd like to know if there is a way to measure utime reliably.

  Please CC me when replying to this message because I am not subscribed to 
linux-kernel.

----- child.c -----
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#define N_ITERATIONS (256*1024)
#define N_ARITH_OPS (2*256)

static void __attribute__((noreturn)) die(const char *msg)
{
        printf("%s, errno=%d\n",msg,errno);
        exit(1);
}

/* don't let GCC optimize away a loop that does some work in user space */
volatile int x;

int main()
{
int fd;
char buf[128];

        fd=open("/proc/self/exe",O_RDONLY);
        if(fd<0)
                die("failed to open file");
        
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

static int measure_time_traced()
{
pid_t p;
int status;
struct rusage rusage;

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
                                die("stopped by signal other than SIGTRAP");
                }
                else if(WIFSIGNALED(status))
                        die("child was signaled");
                else if(WIFEXITED(status))
                        break;
                else
                        die("neither stopped, nor signaled, nor killed?\n");
                
                if(0>ptrace(PTRACE_SYSCALL,p,NULL,0))
                        die("failed to resume the child");
        }
        
        return timeval_to_musec(&rusage.ru_utime);
}

int main()
{
int time_untraced;
int time_traced;

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
        
        return 0;
}
----- time-when-traced.c -----
