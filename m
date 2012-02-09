Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2BIVPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:15:38 -0500
Received: from 2605ds1-ynoe.0.fullrate.dk ([90.184.12.24]:44501 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab2BIVPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:15:37 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Feb 2012 16:15:36 EST
Message-ID: <4F343582.7080007@krogh.cc>
Date: Thu, 09 Feb 2012 22:07:14 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, jk@novozymes.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        yinghai@kernel.org, herrmann.der.user@googlemail.com
Subject: Re: Memory issues with Opteron 6220
References: <20120208143741.GB28486@otto.nzcorp.net> <20120209083315.GA19380@elte.hu>
In-Reply-To: <20120209083315.GA19380@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-09 09:33, Ingo Molnar wrote:
> * Anders Ossowicki<aowi@novozymes.com>  wrote:
>> Hey,
>>
>> We're seeing unexpected slowdowns and other memory issues with a new system.
>> Enough to render it unusable. For example:
>>
>> Error: open3: fork failed: Cannot allocate memory
>>
>> at times where there's no real memory pressure:
>>                     total       used       free     shared    buffers     cached
>>        Mem:     132270720  131942388     328332          0     299768  103334420
>>        -/+ buffers/cache:   28308200  103962520
>>        Swap:      7811068      13760    7797308
>>
>> [...]
Anders' co-worker here..  below C-code (Summary: for -t processes that 
repeatedly
allocates and dallocates 2GB of memory) can excersize the bug
pretty frequently using -t 32 on this machine. On the other 128GB
machine it can run without issues.

It actually ended up toasting the machine:
jk@nysvin:~$ ./foo -t 32
-bash: fork: Cannot allocate memory
jk@nysvin:~$ w
-bash: fork: Cannot allocate memory
jk@nysvin:~$ top
-bash: fork: Cannot allocate memory
jk@nysvin:~$ ls
-bash: fork: Cannot allocate memory

I dont know what to conclude.

jk@nysvin:~$ ./foo -t 32
Upper bound: 1953 MB
malloc(1953) MB failed. iterations: 6
malloc(1953) MB failed. iterations: 2
malloc(1953) MB failed. iterations: 8

foo.c
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <sys/wait.h>

void worker(void)
{
     long long i;
     char *p;
     int action;
     int mult = 500000;
     int size = mult * 4096;
     fprintf(stderr,"Upper bound: %lu MB\n",(long int) (size/1024/1024));
     for (i=0; ; i++) {
         action = i%2;
         switch(action) {
         case 0:
             p = malloc(size);
             if (!p){
                 fprintf(stderr,"malloc(%lu) MB failed. iterations: 
%lli\n", (long int)size/1024/1024,i);
                 exit(1);
             }
             break;
         case 1:
             free(p);
             break;
         }
     }
}

void usage(const char *cmd)
{
     fprintf(stderr,"Usage: %s [-t numthreads]\n", cmd);
     exit(1);
}

int main(int argc, char **argv)
{
     int c, i;
     int nproc = sysconf(_SC_NPROCESSORS_ONLN);


     while ((c = getopt(argc, argv, "t:")) != EOF) {
         switch (c) {
         case 't':
             nproc = strtol(optarg, 0, 0);
             break;
         default:
             usage(argv[0]);
         }
     }

     //printf("forking %d children\n", nproc);
     for (i=0; i < nproc; i++) {
         switch(fork()) {
         case -1:
             fprintf(stderr,"fork: %s\n", strerror(errno));
             exit(1);
         case 0: /* child */
             worker();
             exit(0);
         default: /* parent */
             /* nothing */
             break;
         }
     }

     for (i=0; i < nproc; i++) {
         int x, p;
         p = wait(&x);
     }

     return 0;
}

Can also be found here: http://shrek.krogh.cc/~jesper/foo.c

-- 
Jesper Krogh
