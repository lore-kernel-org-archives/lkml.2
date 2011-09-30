Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab1I3LMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 07:12:54 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34953 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab1I3LMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 07:12:53 -0400
Date: Fri, 30 Sep 2011 20:09:38 +0900
From: Minoru Usui <usui@mxm.nes.nec.co.jp>
To: linux-kernel@vger.kernel.org
Cc: matthew@wil.cx, viro@zeniv.linux.org.uk
Subject: flock(2) cannot block other process which try to get same flock?
Message-Id: <20110930200938.aaf0a897.usui@mxm.nes.nec.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I faced strange behaviour of flock(2) in upstream kernel(3.1.0-rc8+).
It seems flock cannot block other processes which try to get same flock.
If someone know the cause of this behaviour, please let me know.

My test is very very simple.
It tries to get flock against same file by 5 processes.
The result is following.

-----------------------------------------------------------------
# ./flock.sh
lock(pid:2384)
# unlock(pid:2384)
lock(pid:2385)   --- lock(a)
lock(pid:2384)   --- lock(b)
unlock(pid:2385) --- unlock(a)
unlock(pid:2384) --- unlock(b)
   :
-----------------------------------------------------------------

I setup auditd and check audit.log, it indicated same behaviour.

-----------------------------------------------------------------
type=SYSCALL msg=audit(1317375911.187:105): arch=c000003e syscall=73 success=yes exit=0 a0=0 a1=2 a2=0 a3=7fffe664f920 items=0 ppid=2382 pid=2384 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=1 comm="flock" exe="/home/usui/devel/tp/flock" key=(null)

type=SYSCALL msg=audit(1317375912.187:106): arch=c000003e syscall=73 success=yes exit=0 a0=0 a1=8 a2=0 a3=8 items=0 ppid=1 pid=2384 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=1 comm="flock" exe="/home/usui/devel/tp/flock" key=(null)

type=SYSCALL msg=audit(1317375911.187:107): arch=c000003e syscall=73 success=yes exit=0 a0=0 a1=2 a2=0 a3=7fffdc2e2c70 items=0 ppid=1 pid=2385 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=1 comm="flock" exe="/home/usui/devel/tp/flock" key=(null)
  -> lock(a) (pid=2385, a1=2)

type=SYSCALL msg=audit(1317375912.187:108): arch=c000003e syscall=73 success=yes exit=0 a0=0 a1=2 a2=0 a3=7fffe664f920 items=0 ppid=1 pid=2384 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=1 comm="flock" exe="/home/usui/devel/tp/flock" key=(null)
  -> lock(b) (pid=2384, a1=2)

type=SYSCALL msg=audit(1317375913.187:109): arch=c000003e syscall=73 success=yes exit=0 a0=0 a1=8 a2=0 a3=8 items=0 ppid=1 pid=2384 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=1 comm="flock" exe="/home/usui/devel/tp/flock" key=(null)
  -> unlock(a) (pid=2385, a1=8)

type=SYSCALL msg=audit(1317375913.187:110): arch=c000003e syscall=73 success=yes exit=0 a0=0 a1=8 a2=0 a3=8 items=0 ppid=1 pid=2385 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=1 comm="flock" exe="/home/usui/devel/tp/flock" key=(null)
  -> unlock(b) (pid=2384, a1=8)
-----------------------------------------------------------------



Test programs are following.
-----------------------------------------------------------------
# cat -n flock.sh
     1  #! /bin/sh
     2  
     3  CNT=5
     4  
     5  if [ $# -ne 0 ]
     6  then
     7    CNT=$1
     8  fi
     9  
    10  for i in `seq 1 $CNT`
    11  do
    12          ./flock &
    13  done

# cat -n flock.c
     1  #include <stdio.h>
     2  #include <sys/file.h>
     3  #include <sys/types.h>
     4  #include <sys/stat.h>
     5  #include <fcntl.h>
     6  #include <errno.h>
     7  #include <unistd.h>
     8  #include <stdlib.h>
     9  
    10  #define LOCKFILE "/tmp/flocktest"
    11  int main(void)
    12  {
    13          int fd;
    14          int ret;
    15          int pid = getpid();
    16  
    17          while(1) {
    18                  if ((fd = open(LOCKFILE, O_RDONLY) < 0)) {
    19                                  perror("open()");
    20                                  exit(1);
    21                  }
    22  
    23                  if (ret = flock(fd, LOCK_EX) < 0) {
    24                          perror("flock(LOCK_EX)");
    25                          exit(1);
    26                  }
    27                  printf("lock(pid:%d)\n", pid);
    28                  fflush(stdout);
    29  
    30                  sleep(1);
    31  
    32                  printf("unlock(pid:%d)\n", pid);
    33                  fflush(stdout);
    34                  if (ret = flock(fd, LOCK_UN) < 0) {
    35                          perror("flock(LOCK_UN)");
    36                          exit(1);
    37                  }
    38  
    39                  if (close(fd) < 0) {
    40                          perror("flock(LOCK_UN)");
    41                          exit(1);
    42                  }
    43          }
    44  
    45          return 0;
    46  }
-----------------------------------------------------------------
-- 
Minoru Usui <usui@mxm.nes.nec.co.jp>
