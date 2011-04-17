Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1DQSRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:17:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40247 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1DQSRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=GaFYAIUDVfSceOPnZly5rGnn8wRtZInYusjjJO5vpPkGy4vnKN6bB1YEhormxCU0vH
         2bLuS7TvmP2uNbG/N+0Fns3kRrLqvTqJmF6llH4aRV2ktgsJQdnU35QpijrDM1RMNWlQ
         p9flfNnQWTCl2OT9swpLDu0zUFxdReKOvuyD4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: [Regression,bisected] 2.6.39-rc3 ceph client write hangs
Date: Sun, 17 Apr 2011 20:17:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc3; KDE/4.4.5; i686; ; )
Cc: dchinner@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <4DA879CA.8060305@sandia.gov>
In-Reply-To: <4DA879CA.8060305@sandia.gov>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104172017.15090.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33452
for your bug report, please add your address to the CC list in there, thanks!

On piątek, 15 kwietnia 2011 o 19:00:58 Jim Schutt wrote:
> Hi,
> 
> This command is hanging on 2.6.39-rc3, where /mnt/ceph is
> a ceph file system:
>    dd conv=fdatasync if=/dev/zero of=/mnt/ceph/zero.`hostname -s` bs=4k
> count=4k
> 
> It works on 2.6.38.  As of commit e38f5b745075 in Linus'
> tree it still doesn't work.
> 
> I bisected this to:
> 
> 250df6ed274d767da844a5d9f05720b804240197 is the first bad commit
> commit 250df6ed274d767da844a5d9f05720b804240197
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Tue Mar 22 22:23:36 2011 +1100
> 
>      fs: protect inode->i_state with inode->i_lock
> 
> In the early stages of the bisection, bad commits would show this
> in dmesg:
> 
> [  137.004963] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
> [  137.056431] ceph: loaded (mds proto 32)
> [  137.063213] libceph: client4283 fsid
> 950217ad-499e-eab1-03f7-f6d245f42751 [  137.063826] libceph: mon0
> 172.17.40.34:6789 session established [  219.658002] INFO: rcu_sched_state
> detected stall on CPU 0 (t=60000 jiffies)
> 
> For the last couple of bad commits during the bisection, the
> client box would just hang and I'd have to power-cycle it.
> 
> When I reboot/remount after a hang, the file I was trying
> to write is there, with size and date both zero:
> 
> # ls -l --time-style=+%s /mnt/ceph/zero.an1024
> -rw-r--r-- 1 jaschut jaschut 0 0 /mnt/ceph/zero.an1024
> 
> strace suggests it's the write that hangs:
> 
> close(3)                                = 0
> close(0)                                = 0
> open("/dev/zero", O_RDONLY)             = 0
> lseek(0, 0, SEEK_CUR)                   = 0
> close(1)                                = 0
> open("/mnt/ceph/zero.an1024", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 1
> rt_sigaction(SIGUSR1, NULL, {SIG_DFL, [], 0}, 8) = 0
> rt_sigaction(SIGINT, NULL, {SIG_DFL, [], 0}, 8) = 0
> rt_sigaction(SIGUSR1, {0x401a20, [INT USR1], SA_RESTORER, 0x7f3a97f292d0},
> NULL, 8) = 0 rt_sigaction(SIGINT, {0x401a10, [INT USR1],
> SA_RESTORER|SA_NODEFER|SA_RESETHAND, 0x7f3a97f292d0}, NULL, 8) = 0
> clock_gettime(CLOCK_MONOTONIC, {216, 671807533}) = 0
> read(0,
> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> 4096) = 4096 write(1,
> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> 4096
> 
> Let me know if I can do anything else to help sort this out.
> 
> -- Jim
> 
> (Please Cc: me as I am not subscribed to lkml.)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
