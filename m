Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1DGKBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:01:14 -0400
Received: from gmmr5.centrum.cz ([90.183.38.152]:55886 "EHLO gmmr5.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1DGKBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:01:13 -0400
To: <linux-kernel@vger.kernel.org>
Subject: Re: Regression from 2.6.36
Date: Thu, 07 Apr 2011 12:01:12 +0200
From: "azurIt" <azurit@pobox.sk>
References: <20110315132527.130FB80018F1@mail1005.cent> <20110317001519.GB18911@kroah.com>
In-Reply-To: <20110317001519.GB18911@kroah.com>
X-Mailer: Centrum Email 5.3
X-Priority: 3
MIME-Version: 1.0
Message-Id: <20110407120112.E08DCA03@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have finally completed bisection, here are the results:



a892e2d7dcdfa6c76e60c50a8c7385c65587a2a6 is first bad commit
commit a892e2d7dcdfa6c76e60c50a8c7385c65587a2a6
Author: Changli Gao <xiaosuo@gmail.com>
Date:   Tue Aug 10 18:01:35 2010 -0700

    vfs: use kmalloc() to allocate fdmem if possible
   
    Use kmalloc() to allocate fdmem if possible.
   
    vmalloc() is used as a fallback solution for fdmem allocation.  A new
    helper function __free_fdtable() is introduced to reduce the lines of
    code.
   
    A potential bug, vfree() a memory allocated by kmalloc(), is fixed.
   
    [akpm@linux-foundation.org: use __GFP_NOWARN, uninline alloc_fdmem() and free_fdmem()]
    Signed-off-by: Changli Gao <xiaosuo@gmail.com>
    Cc: Alexander Viro <viro@zeniv.linux.org.uk>
    Cc: Jiri Slaby <jslaby@suse.cz>
    Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Cc: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Avi Kivity <avi@redhat.com>
    Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 a7b3997bc754f573b4a309cda1a0774ea95c235e 4241a4f2115c60e5c1dc1879c85c9911fa077807 M      fs





 
 ______________________________________________________________
 > Od: "Greg KH" <greg@kroah.com>
 > Komu: azurIt <azurit@pobox.sk>
 > Dátum: 17.03.2011 01:15
 > Predmet: Re: Regression from 2.6.36
 >
 > CC: linux-kernel@vger.kernel.org On Tue, Mar 15, 2011 at 02:25:27PM +0100, azurIt wrote: 
 >  
 > Hi, 
 >  
 > we are successfully running several very busy web servers on 2.6.32.* and 
 > few days ago I decided to upgrade to 2.6.37 (mainly because of blkio cgroup). 
 > I installed 2.6.37.2 on one of the servers and very strange things started to 
 > happen with Apache web server. 
 >  
 > We are using Apache with MPM-ITK ( http://mpm-itk.sesse.net/ ) so it is doing 
 > lots of 'fork' and lots of 'setuid'. I have also noticed that problem is 
 > happening only on very busy servers. 
 >  
 > Everything is ok when Apache is started but as time is passing by, its 'root' 
 > processes (Apache processes running under root) are consuming more and more CPU. 
 > Finally, the whole server becames very unstable and Apache must be restarted. 
 > This is repeating until the load on web sites is much lower (usually on 22:00). 
 > Sometimes it takes 3 hours when restart is needed, sometimes only 1 hour (again, 
 > depends on load on web sites). Here is the graph of CPU utilization showing the 
 > problem (red color), Apache was REstarted at 8:11 and 9:35: 
 > http://watchdog.sk/lkml/cpu-problem.png 
 >  
 > Here is how it looks on htop: 
 > http://watchdog.sk/lkml/htop.jpg 
 >  
 > And finally here is how it looks with older kernels (yes, when i install older 
 > kernel, problem is gone), notice also that I/O wait is much lower and nicer 
 > (blue color): 
 > http://watchdog.sk/lkml/cpu-ok.png 
 >  
 > I was also strace-ing Apache processes which were doing problems, here it is: 
 > http://watchdog.sk/lkml/strace.txt 
 >  
 > I'm not 100% sure but I think that CPU was consumed on 'futex' lines. 
 >  
 > I tried several kernel versions and find out that everything BEFORE 2.6.36 is 
 > NOT affected and everything AFTER 2.6.36 (included) is affected. 
 >  
 > Versions which I tried and were NOT affected by this problem: 
 > 2.6.32.* 
 > 2.6.35.11 
 >  
 > Versions which I tried and were affected by this problem: 
 > 2.6.36 
 > 2.6.36.4 
 > 2.6.37.2 
 > 2.6.37.3 
 > 2.6.38-rc8 (final version was not released yet) 
 >  
 > All tests were made on vanilla kernels on Debian Lenny with this config: 
 > http://watchdog.sk/lkml/config 
 >  
 > Do you need any other information from me ? I'm able to try other versions or 
 > patches but, please, take into account that I have to do this on _production_ 
 > server (I failed to reproduce it in testing environment). Also, I'm able to try 
 > only one kernel per day. 
 
 Ick, one kernel per day might make this a bit difficult, but if there 
 was any way you could use 'git bisect' to try to narrow this down to the 
 patch that caused this problem, it would be great. 
 
 You can mark 2.6.35 as working and 2.6.36 as bad and git will go from 
 there and try to offer you different chances to find the problem. 
 
 thanks, 
 
 greg k-h
