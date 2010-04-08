Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab0DHJ2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:28:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:47234 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab0DHJ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:28:45 -0400
Date: Thu, 8 Apr 2010 11:28:50 +0200
From: Jan Kara <jack@suse.cz>
To: Denys Fedorysychenko <nuclearcat@nuclearcat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100408092850.GA20488@quack.suse.cz>
References: <201003311907.31342.nuclearcat@nuclearcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003311907.31342.nuclearcat@nuclearcat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Wed 31-03-10 19:07:31, Denys Fedorysychenko wrote:
> I have a proxy server with "loaded" squid. On some moment i did sync, and 
> expecting it to finish in reasonable time. Waited more than 30 minutes, still 
> "sync". Can be reproduced easily.
> 
> Here is some stats and info:
> 
> Linux SUPERPROXY 2.6.33.1-build-0051 #16 SMP Wed Mar 31 17:23:28 EEST 2010 
> i686 GNU/Linux
> 
> SUPERPROXY ~ # iostat -k -x -d 30
> Linux 2.6.33.1-build-0051 (SUPERPROXY)  03/31/10        _i686_  (4 CPU)
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
> avgqu-sz   await  svctm  %util
> sda               0.16     0.01    0.08    0.03     3.62     1.33    88.94     
> 0.15 1389.89  59.15   0.66
> sdb               4.14    61.25    6.22   25.55    44.52   347.21    24.66     
> 2.24   70.60   2.36   7.49
> sdc               4.37   421.28    9.95   98.31   318.27  2081.95    44.34    
> 20.93  193.21   2.31  24.96
> sdd               2.34   339.90    3.97  117.47    95.48  1829.52    31.70     
> 1.73   14.23   8.09  98.20
> sde               2.29    71.40    2.34   27.97    22.56   397.81    27.74     
> 2.34   77.34   1.66   5.04
> dm-0              0.00     0.00    0.19    0.02     3.48     0.02    32.96     
> 0.05  252.11  28.05   0.60
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
> avgqu-sz   await  svctm  %util
> sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     
> 0.00    0.00   0.00   0.00
> sdb               0.00    54.67    2.93   26.87    12.27   326.13    22.71     
> 2.19   73.49   1.91   5.68
> sdc               0.00   420.50    3.43  110.53   126.40  2127.73    39.56    
> 23.82  209.00   2.06  23.44
> sdd               0.00   319.63    2.30  122.03   121.87  1765.87    30.37     
> 1.72   13.83   7.99  99.37
> sde               0.00    71.67    0.83   30.63     6.93   409.33    26.46     
> 2.66   84.68   1.51   4.76
> dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     
> 0.00    0.00   0.00   0.00
> 
> 
> CPU:  8.4% usr  7.7% sys  0.0% nic 50.7% idle 27.7% io  0.6% irq  4.7% sirq
> Load average: 5.57 4.82 4.46 2/243 2032
>   PID  PPID USER     STAT   VSZ %MEM CPU %CPU COMMAND
>  1769  1552 squid    R     668m  8.3   3 11.7 /usr/sbin/squid -N
>  1546  1545 root     R    10800  0.1   2  6.0 /config/globax 
> /config/globax.conf
>  1549  1548 root     S    43264  0.5   2  1.5 /config/globax /config/globax-
> dld.conf
>  1531     2 root     DW       0  0.0   0  0.3 [jbd2/sdd1-8]
>  1418     1 root     S     2500  0.0   3  0.0 /sbin/syslogd -R 80.83.17.2
>  1524     2 root     SW       0  0.0   0  0.0 [flush-8:32]
>  1525     2 root     SW       0  0.0   1  0.0 [jbd2/sdc1-8]
>  1604     2 root     DW       0  0.0   0  0.0 [flush-8:48]
>  1537     2 root     SW       0  0.0   1  0.0 [jbd2/sde1-8]
>    18     2 root     SW       0  0.0   3  0.0 [events/3]
>  1545     1 root     S     3576  0.0   1  0.0 /config/globax 
> /config/globax.conf
>  1548     1 root     S     3576  0.0   0  0.0 /config/globax /config/globax-
> dld.conf
>  1918     1 ntp      S     3316  0.0   3  0.0 /usr/sbin/ntpd -s
>  1919     1 root     S     3268  0.0   3  0.0 /usr/sbin/ntpd -s
>     1     0 root     S     2504  0.0   0  0.0 /bin/sh /init trynew trynew 
> trynew trynew
>  1923  1257 root     S     2504  0.0   1  0.0 /sbin/getty 38400 tty1
>  1924  1257 root     S     2504  0.0   0  0.0 /sbin/getty 38400 tty2
>  1927  1257 root     S     2504  0.0   0  0.0 /sbin/getty 38400 tty3
>  2015  2014 root     S     2504  0.0   1  0.0 -ash
>  2032  2015 root     R     2504  0.0   3  0.0 top
>  1584     1 root     S     2500  0.0   1  0.0 /usr/bin/ifplugd -i eth0 -a -r 
> /etc/startup/rc.ifup -t 1 -u 1 -d 1
>  1592     1 root     S     2500  0.0   1  0.0 /usr/bin/ifplugd -i eth2 -a -r 
> /etc/startup/rc.ifup -t 1 -u 1 -d 1
>  1587     1 root     S     2500  0.0   1  0.0 /usr/bin/ifplugd -i eth1 -a -r 
> /etc/startup/rc.ifup -t 1 -u 1 -d 1
>  1595     1 root     S     2500  0.0   1  0.0 /usr/bin/ifplugd -i eth3 -a -r 
> /etc/startup/rc.ifup -t 1 -u 1 -d 1
>  1257     1 root     S     2500  0.0   0  0.0 init
>  1420     1 root     S     2500  0.0   1  0.0 /sbin/klogd
>  1432     1 root     S     2500  0.0   3  0.0 /usr/sbin/telnetd -f 
> /etc/issue.telnet
>  1552     1 root     S     2500  0.0   1  0.0 /bin/sh /bin/squidloop
>  1743  1742 root     S     2500  0.0   3  0.0 ash -c gs newkernel
>  1744  1743 root     S     2500  0.0   0  0.0 /bin/sh /bin/gs newkernel
>  1753  1744 root     D     2368  0.0   0  0.0 sync
> 
> 
> SUPERPROXY ~ # cat /proc/1753/stack
> [<c019a93c>] bdi_sched_wait+0x8/0xc
> [<c019a807>] wait_on_bit+0x20/0x2c
> [<c019a9af>] sync_inodes_sb+0x6f/0x10a
> [<c019dd53>] __sync_filesystem+0x28/0x49
> [<c019ddf3>] sync_filesystems+0x7f/0xc0
> [<c019de7a>] sys_sync+0x1b/0x2d
> [<c02f7a25>] syscall_call+0x7/0xb
> [<ffffffff>] 0xffffffff
  Hmm, I guess you are observing the problem reported in
https://bugzilla.kernel.org/show_bug.cgi?id=14830
  There seem to be several issues in the per-bdi writeback code that
cause sync on a busy filesystem to last almost forever. To that bug are
attached two patches that fix two issues but apparently it's not all.
I'm still looking into it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
