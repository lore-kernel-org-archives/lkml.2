Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1DRQKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:10:33 -0400
Received: from sentry-three.sandia.gov ([132.175.109.17]:53331 "EHLO
	sentry-three.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab1DRQK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:10:28 -0400
X-WSS-ID: 0LJUVLC-0C-34U-02
X-M-MSG: 
X-Server-Uuid: 6BFC7783-7E22-49B4-B610-66D6BE496C0E
Message-ID: <4DAC6255.6010509@sandia.gov>
Date: Mon, 18 Apr 2011 10:09:57 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Thunderbird 2.0.0.24 (X11/20110128)
MIME-Version: 1.0
To: "Sage Weil" <sage@newdream.net>
cc: "Maciej Rutecki" <maciej.rutecki@gmail.com>, dchinner@redhat.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [Regression,bisected] 2.6.39-rc3 ceph client write hangs
References: <4DA879CA.8060305@sandia.gov>
 <201104172017.15090.maciej.rutecki@gmail.com>
 <Pine.LNX.4.64.1104172249540.18433@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.1104172249540.18433@cobra.newdream.net>
X-Originating-IP: [134.253.95.179]
X-TMWD-Spam-Summary: TS=20110418161003; ID=1; SEV=2.3.1;
 DFV=B2011041816; IFV=NA; AIF=B2011041816; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230342E34444143363235422E303045362C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAADADrBBQCbCiIAiMIFAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2011041816_5.03.0010
X-WSS-ID: 61B2BDD12K41553327-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil wrote:
> This was a simple s/igrab/ihold/ fix.  See
> 
> 283a85dc6e670083adb1e5437bd93d163f4f801a
> 
> in the for-linus branch of ceph-client.git. 

This works for me.

Thanks - Jim

  I'll push to Linus in the
> next few days.
> 
> Thanks!
> sage
> 
> 
> 
> 
> On Sun, 17 Apr 2011, Maciej Rutecki wrote:
> 
>> I created a Bugzilla entry at 
>> https://bugzilla.kernel.org/show_bug.cgi?id=33452
>> for your bug report, please add your address to the CC list in there, thanks!
>>
>> On piÿÿtek, 15 kwietnia 2011 o 19:00:58 Jim Schutt wrote:
>>> Hi,
>>>
>>> This command is hanging on 2.6.39-rc3, where /mnt/ceph is
>>> a ceph file system:
>>>    dd conv=fdatasync if=/dev/zero of=/mnt/ceph/zero.`hostname -s` bs=4k
>>> count=4k
>>>
>>> It works on 2.6.38.  As of commit e38f5b745075 in Linus'
>>> tree it still doesn't work.
>>>
>>> I bisected this to:
>>>
>>> 250df6ed274d767da844a5d9f05720b804240197 is the first bad commit
>>> commit 250df6ed274d767da844a5d9f05720b804240197
>>> Author: Dave Chinner <dchinner@redhat.com>
>>> Date:   Tue Mar 22 22:23:36 2011 +1100
>>>
>>>      fs: protect inode->i_state with inode->i_lock
>>>
>>> In the early stages of the bisection, bad commits would show this
>>> in dmesg:
>>>
>>> [  137.004963] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
>>> [  137.056431] ceph: loaded (mds proto 32)
>>> [  137.063213] libceph: client4283 fsid
>>> 950217ad-499e-eab1-03f7-f6d245f42751 [  137.063826] libceph: mon0
>>> 172.17.40.34:6789 session established [  219.658002] INFO: rcu_sched_state
>>> detected stall on CPU 0 (t=60000 jiffies)
>>>
>>> For the last couple of bad commits during the bisection, the
>>> client box would just hang and I'd have to power-cycle it.
>>>
>>> When I reboot/remount after a hang, the file I was trying
>>> to write is there, with size and date both zero:
>>>
>>> # ls -l --time-style=+%s /mnt/ceph/zero.an1024
>>> -rw-r--r-- 1 jaschut jaschut 0 0 /mnt/ceph/zero.an1024
>>>
>>> strace suggests it's the write that hangs:
>>>
>>> close(3)                                = 0
>>> close(0)                                = 0
>>> open("/dev/zero", O_RDONLY)             = 0
>>> lseek(0, 0, SEEK_CUR)                   = 0
>>> close(1)                                = 0
>>> open("/mnt/ceph/zero.an1024", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 1
>>> rt_sigaction(SIGUSR1, NULL, {SIG_DFL, [], 0}, 8) = 0
>>> rt_sigaction(SIGINT, NULL, {SIG_DFL, [], 0}, 8) = 0
>>> rt_sigaction(SIGUSR1, {0x401a20, [INT USR1], SA_RESTORER, 0x7f3a97f292d0},
>>> NULL, 8) = 0 rt_sigaction(SIGINT, {0x401a10, [INT USR1],
>>> SA_RESTORER|SA_NODEFER|SA_RESETHAND, 0x7f3a97f292d0}, NULL, 8) = 0
>>> clock_gettime(CLOCK_MONOTONIC, {216, 671807533}) = 0
>>> read(0,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
>>> 4096) = 4096 write(1,
>>> "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
>>> 4096
>>>
>>> Let me know if I can do anything else to help sort this out.
>>>
>>> -- Jim
>>>
>>> (Please Cc: me as I am not subscribed to lkml.)
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>> -- 
>> Maciej Rutecki
>> http://www.maciek.unixy.pl
>> --
>> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


