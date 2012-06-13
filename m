Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2FMJde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:33:34 -0400
Received: from mail.osso.nl ([91.194.224.40]:33361 "EHLO mail.osso.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab2FMJdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:33:33 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2012 05:33:33 EDT
Message-ID: <4FD85C60.9010104@osso.nl>
Date: Wed, 13 Jun 2012 11:24:48 +0200
From: Walter Doekes <wjdoekes@osso.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: wjdoekes@osso.nl, dohardgopro@gmail.com
Subject: Re: [utime/stime times have stalled]
References: <CAAW1UO_8orU0eUuRy7pBpZAL5GKKvoDmZYAat6m5kOyRhqU5_A@mail.gmail.com>
In-Reply-To: <CAAW1UO_8orU0eUuRy7pBpZAL5GKKvoDmZYAat6m5kOyRhqU5_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(I hope this lands in the right thread, since I had to set the 
In-Reply-To by hand. Further, I'm not subscribed, so I'd like replies to 
go to me to.)

Azat Khuzhin writes that his process-specific utime/stime times are 
zero. So are mine.


On a normal system, we have this for a basic 1 billion increment:

   $ time ./manyops
   real	0m2.343s
   user	0m2.340s
   sys	0m0.000s

On the system where I have issues, it looks like this:

   # time ./manyops
   real	0m2.936s
   user	0m0.000s <-- 0 ??
   sys	0m0.000s

Like Azat also writes, the CPU times in /proc/stat are ok. There is CPU 
usage. And when I run an infinite loop, I see 100% cpu on one of the cores.

But the process specific utime/stime/cutime/cstime found in 
/proc/<pid>/stat have *all* *stalled*.

Today is 13th of June. The latest processes that still have any utime at 
all were started a month ago. No times are increasing anywhere.

   # for x in /proc/[0-9]* ; do
      l=`cat $x/stat`
      num=`echo $l|cut -d' ' -f14`
      [ $num == 0 ] && continue
      pid=`echo $l|cut -d' ' -f1`
      nam=`echo $l|cut -d' ' -f2`
      jif=`echo $l|cut -d' ' -f22`
      printf "%-15s %d (pid=%s)\n" $nam $jif $pid
    done | sort
   ...
   (cron)          37188 (pid=3932)
   (events/0)      145 (pid=51)
   (events/11)     145 (pid=62)
   ...
   (events/9)      145 (pid=60)
   (init)          2 (pid=1)
   (kblockd/0)     146 (pid=90)
   ...
   (ntpd)          1779238631 (pid=18489)
   (rsyslogd)      36487 (pid=3436)
   (saslauthd)     36520 (pid=3474)
   ...
   (sshd)          1778081256 (pid=15197)
   (supervisord)   37404 (pid=4088)
   ...

   # ps faxu | egrep ' (18489|15197) ' | awk '{print $9 " " $11}'
   May14 /usr/sbin/sshd
   May14 /usr/sbin/ntpd

The next-oldest process is from May21, and that one has the times set to 
zero:

   # cat /proc/14396/stat
   14396 (nrpe) S 1 14396 14396 0 -1 4202816 110426 2933382 0 8663 0 0 0 
0 20 0 1 0 1839481161 25292800 165 18446744073709551615 4194304 4228372 
140735909835936 140735909828360 139786175811971 0 0 0 16389 0 0 0 17 4 0 
0 2008199 0 0


I haven't tested what happens when we reboot. The customer hasn't given 
us the permission to do so yet. But it wouldn't surprise me if the 
counters started to work again, like for Azat.

Can anyone think of any reason why the utime/stime counters fail to work 
after a while?


System specs:

   CPU:    16 core(?) "Intel(R) Xeon(R) CPU E5620  @ 2.40GHz"
   Mem:    16GB
   Kernel: 2.6.32-5-amd64 (debian squeeze 2.6.32-45)
   Uptime: 11:14:35 up 235 days, 20:54

Are there any other relevant details you might need.


Kind regards,
Walter Doekes
OSSO B.V.

P.S. The cluster of applications on the system is suffering from 
unexplained slowness. It is probably unrelated to the problem, but 
without the utime/stime it is hard to track down where the bottleneck is.
