Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab1JRMYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:24:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34242 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1JRMYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:24:10 -0400
Message-ID: <1318940665.2657.60.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Tue, 18 Oct 2011 14:24:25 +0200
In-Reply-To: <20111018111422.GA1979@schottelius.org>
References: <20111018111422.GA1979@schottelius.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 octobre 2011 à 13:14 +0200, Nico Schottelius a écrit :
> Dear LKML,
> 
> there is a rather nasty bug in all recent kernels (probably older as
> well):
> 
> If wpa_supplicant looses the connection to an AP, all network calls
> hang, uninterruptle.
> 
> This is a snippet of running fetchmail after the problem started:
> 
> socket(PF_NETLINK, SOCK_RAW, 0)         = 4
> bind(4, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
> getsockname(4, {sa_family=AF_NETLINK, pid=9734, groups=00000000}, [12]) = 0
> sendto(4, "\24\0\0\0\26\0\1\3\225\\\235N\0\0\0\0\0\0\0\0", 20, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12
> 
> [12:59] brief:linux-2.6% ps aux | grep fetchmail
> nico      9063  0.0  0.0  20652  1492 pts/3    D+   12:55   0:00 fetchmail
> nico      9564  0.0  0.0  20652  1496 pts/15   D+   13:01   0:00 fetchmail
> nico      9731  0.0  0.0   4288   724 pts/34   S+   13:01   0:00 strace -fF fetchmail
> nico      9734  0.0  0.0  20652  1492 pts/34   D+   13:01   0:00 fetchmail
> 
> This is particular nasty, because even calling "sudo -i" does a sendto() call
> and thus hangs, as well as trying to send this mail with sendmail makes mutt hang.
> 
> I've seen that on stock Archlinux kernel (linux 3.0.6-2),
> latest from Linus (v3.1-rc9-93-ga84a79e), merged trees from Keith and Jiri
> (3.1.0-rc6-gbee709a).
> 
> Listing of hanging processes:
> 
> [13:05] brief:linux-2.6% ps aux | grep D        
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root      9056  0.2  0.0      0     0 ?        D    12:54   0:02 [kworker/u:0]
> nico      9063  0.0  0.0  20652  1492 pts/3    D+   12:55   0:00 fetchmail
> nico      9066  0.0  0.0  16548  1180 ?        D    12:56   0:00 sendmail -oem -oi -f ME@inf.ethz.ch -- RECIPIENT
> root      9067  0.0  0.0   6060   320 pts/14   DN   12:56   0:00 ip r
> root      9124  0.0  0.0   6060   320 pts/14   DN   12:57   0:00 ip r add 192.168.42.1/24 dev lo
> root      9390  0.0  0.0  11996   784 pts/12   D+   13:01   0:00 sudo -i
> nico      9564  0.0  0.0  20652  1496 pts/15   D+   13:01   0:00 fetchmail
> nico      9734  0.0  0.0  20652  1492 pts/34   D+   13:01   0:00 fetchmail
> root     12304  0.0  0.0  28624  2228 ?        Ds   09:16   0:00 wpa_supplicant -B -P /run/wpa_supplicant_wlan0.pid -i wlan0 -D nl80211,wext -c /run/network//wpa.wlan0/wpa.conf
> [13:07] brief:linux-2.6% 
> 
> The hardware is again the (in)famous MacBook Air 4,2, so I imagine this may be
> related to brcmsmac.
> 
> Attached are config, dmesg, lsmod.


Must be a mutex_unlock(some_mltex) missing somewhere.

Then later, a process holding RTNL is blocking on mutex_lock(some_mutex)

Try a "CONFIG_LOCKDEP=y" enabled build




