Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2KSUQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:16:12 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54848 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2KSUQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:16:11 -0500
MIME-Version: 1.0
From: Ronny Meeus <ronny.meeus@gmail.com>
Date: Mon, 19 Nov 2012 21:15:50 +0100
Message-ID: <CAMJ=MEdyKaTFhON6aWujmzWTn8vmyoChVSOxfL5iYqQobdxVxg@mail.gmail.com>
Subject: Question about idle time in /proc/stat
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I have an created an application that measures the cpuload consumed by
the tasks within a process.
For this I use the file /proc/stat and /proc/<pid>/tasks/<tid>/stat

The cpuload monitor is a very simple application that just executes in
a loop a sleep command, followed by retrieving the information about
all the tasks belonging to the process.
What I observe is that there is a big difference in the idle time
available in the /proc/stat file.

This is the Linux version I use:
Linux version 2.6.36.4 (meeusr@devws156) (gcc version 4.4.3
(crosstool-NG 1.15.2 - buildroot 2012.05-hga35945e88d23) ) #1 SMP
PREEMPT Wed Oct 10 08:41:17 CEST 2012
Please note that this is a kernel that contains patches of FreeScale.

The application is running on a P4040:
platform        : P4080 DS
model           : fsl,P4080DS
Memory          : 2016 MB

I do not know whether it is relevant but I'm using a tickless kernel

I created a small test program that contains the essence of the problem:

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

void utime_delay_micro_seconds(unsigned long useconds )
{
  struct timespec req;
  req.tv_sec = useconds / 1000000;
  req.tv_nsec = (useconds - (req.tv_sec * 1000000)) * 1000;
  nanosleep(&req, NULL);
}

int main(void)
{
  unsigned long
delta,user=0,niceuser=0,system=0,idleload=0,user1,niceuser1,system1,idleload1;

  while (1)
  {
    struct timeval tp,tp1;
    FILE *statfile;

    utime_delay_micro_seconds(1000000);

    gettimeofday(&tp,NULL);

    statfile = fopen("/proc/stat", "r+");
    fscanf(statfile,"cpu %ld %ld %ld
%ld",&user1,&niceuser1,&system1,&idleload1);
    fclose(statfile);

    gettimeofday(&tp1,NULL);
    delta = (tp1.tv_sec - tp.tv_sec) + (tp1.tv_usec - tp.tv_usec);

    printf("%ld:%ld Delta=%ld User=%ld NiceUser=%ld System=%ld
Idle=%ld\n",tp.tv_sec,tp.tv_usec,delta,
           user1-user,niceuser1-niceuser,system1-system,idleload1-idleload);

    user=user1;
    niceuser=niceuser1;
    system=system1;
    idleload=idleload1;
  }
  return 0;
}

The output is the following (I skipped a few lines since the initial
measurement is not correct):

2181820:130777 Delta=889 User=39 NiceUser=0 System=5 Idle=356
2181821:131720 Delta=875 User=39 NiceUser=0 System=6 Idle=356
2181822:132650 Delta=892 User=40 NiceUser=0 System=5 Idle=356
2181823:133598 Delta=874 User=38 NiceUser=0 System=6 Idle=357
2181824:134527 Delta=880 User=38 NiceUser=0 System=6 Idle=356
2181825:135460 Delta=876 User=39 NiceUser=0 System=5 Idle=356
2181826:136390 Delta=882 User=39 NiceUser=0 System=5 Idle=356
2181827:137333 Delta=909 User=40 NiceUser=0 System=9 Idle=396
2181828:138303 Delta=895 User=39 NiceUser=0 System=5 Idle=256
2181829:139255 Delta=893 User=39 NiceUser=0 System=5 Idle=256
2181830:140206 Delta=893 User=39 NiceUser=0 System=5 Idle=256
2181831:141155 Delta=891 User=38 NiceUser=0 System=6 Idle=256
2181832:142103 Delta=869 User=39 NiceUser=0 System=5 Idle=257
2181833:143051 Delta=868 User=39 NiceUser=0 System=5 Idle=256
2181834:143976 Delta=886 User=38 NiceUser=0 System=6 Idle=256
2181835:144919 Delta=890 User=39 NiceUser=0 System=5 Idle=256
2181836:145866 Delta=887 User=38 NiceUser=0 System=6 Idle=256
2181837:146814 Delta=906 User=41 NiceUser=0 System=8 Idle=1254
2181838:147782 Delta=891 User=38 NiceUser=0 System=6 Idle=256
2181839:148729 Delta=892 User=39 NiceUser=0 System=5 Idle=256
2181840:149678 Delta=891 User=39 NiceUser=0 System=5 Idle=256
2181841:150626 Delta=888 User=38 NiceUser=0 System=6 Idle=256
2181842:151571 Delta=889 User=39 NiceUser=0 System=5 Idle=257
2181843:152515 Delta=885 User=39 NiceUser=0 System=5 Idle=256
2181844:153457 Delta=890 User=38 NiceUser=0 System=6 Idle=256
2181845:154403 Delta=885 User=39 NiceUser=0 System=5 Idle=256
2181846:155343 Delta=886 User=39 NiceUser=0 System=5 Idle=256
2181847:156288 Delta=907 User=40 NiceUser=0 System=9 Idle=1253
2181848:157257 Delta=891 User=39 NiceUser=0 System=5 Idle=256
2181849:158204 Delta=888 User=39 NiceUser=0 System=6 Idle=256
2181850:159150 Delta=895 User=38 NiceUser=0 System=6 Idle=256
2181851:160102 Delta=871 User=39 NiceUser=0 System=4 Idle=257
2181852:161054 Delta=876 User=39 NiceUser=0 System=6 Idle=255
2181853:161989 Delta=883 User=39 NiceUser=0 System=5 Idle=257
2181854:162932 Delta=891 User=39 NiceUser=0 System=5 Idle=267
2181855:163878 Delta=887 User=39 NiceUser=0 System=6 Idle=245
2181856:164821 Delta=889 User=39 NiceUser=0 System=5 Idle=256
2181857:165769 Delta=910 User=40 NiceUser=0 System=9 Idle=1253
2181858:166740 Delta=890 User=39 NiceUser=0 System=5 Idle=256
2181859:167686 Delta=884 User=38 NiceUser=0 System=5 Idle=256
2181860:168627 Delta=888 User=39 NiceUser=0 System=6 Idle=263


The first column is the timestamp returned by gettimeofday. This is
nicely incrementing 1 second at a time.
The Delta shows how long it took to execute the processing of the stat file.

Since this is a 4 core machine, I would expect that the sum of
User,NiceUser,System and Idle is 400 (100 Ticks per core).
In some samples this is correct, while in other samples, the sum is
only something like 300 while in one of the next samples the idle time
suddenly increases to 1253.
So it looks like the time it has lost before is recovered in that one sample.

Can somebody explain what the issue is and how it can be resolved?

Thanks

---
Ronny
