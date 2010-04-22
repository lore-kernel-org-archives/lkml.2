Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab0DVO5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:57:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40436 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab0DVO5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:57:47 -0400
Message-ID: <4BD063E4.5030400@us.ibm.com>
Date: Thu, 22 Apr 2010 07:57:40 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang@windriver.com>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Lockdep usage
References: <4BCFEBFF.4090505@us.ibm.com> <20100422070625.GA17515@windriver.com>
In-Reply-To: <20100422070625.GA17515@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> On Wed, Apr 21, 2010 at 11:26:07PM -0700, Darren Hart wrote:
>> I'm having some trouble with lockstat. I've enabled
>> CONFIG_LOCK_STATS and then run the following commands to collect the
>> lock statistics for the futex_lock test case. I expect this test
>> case to generate a fair amount of contention on the futex hash
>> bucket locks, but they don't show up in the stats (in fact, nothing
>> shows up in the stats). I have seen much longer lock_stat files when
>> I forgot to clear them before the test, but no hb locks showed up
>> there either.
>>
>> Is my usage below incorrect? Do I have to somehow annotate the
>> hb->lock in order for lockstat to track it?
> 
> IMHO, you don't need to do that.
> 
>> lock.lockstat; echo 0 > /proc/sys/kernel/lock_stat
>> futex_lock: Measure FUTEX_LOCK operations per second
>>         Arguments: iterations=10000000 threads=256 adaptive=no
>>                    period=1000 duty-cycle=20%
>> Result: 731 Kiter/s
>>
>> # cat lock.lockstat
>> lock_stat version 0.3
>> *WARNING* lock debugging disabled!! - possibly due to a lockdep warning
> 
> This means lockdep has detect there is something wrong.
> Can you show your 'dmesg'?

dmesg includes the following during bootup, but nothing new while 
running the tests:

BUG: key ffff88024e657858 not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x226/0x5c0()
Hardware name: BladeCenter LS21 -[7971AC1]-
Pid: 1, comm: swapper Not tainted 2.6.34-rc1dvhv4ls #32
Call Trace:
  [<ffffffff81078446>] ? lockdep_init_map+0x226/0x5c0
  [<ffffffff81048687>] warn_slowpath_common+0x87/0xb0
  [<ffffffff810486c4>] warn_slowpath_null+0x14/0x20
  [<ffffffff81078446>] lockdep_init_map+0x226/0x5c0
  [<ffffffff81077f53>] ? lock_release_holdtime+0x83/0xf0
  [<ffffffff8115e5a1>] sysfs_add_file_mode+0x71/0xd0
  [<ffffffff8115e611>] sysfs_add_file+0x11/0x20
  [<ffffffff8115e650>] sysfs_create_file+0x30/0x40
  [<ffffffff814995d9>] device_create_file+0x19/0x20
  [<ffffffff813afe55>] ipmi_register_smi+0xba5/0xfc0
  [<ffffffff81498877>] ? put_device+0x17/0x20
  [<ffffffff810670d0>] ? autoremove_wake_function+0x0/0x40
  [<ffffffff813b3a12>] try_smi_init+0x5d2/0xa20
  [<ffffffff818d5b72>] init_ipmi_si+0x432/0xb80
  [<ffffffff818d5740>] ? init_ipmi_si+0x0/0xb80
  [<ffffffff810001dd>] do_one_initcall+0x3d/0x180
  [<ffffffff822d5a6c>] kernel_init+0x16c/0x200
  [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
  [<ffffffff822d5900>] ? kernel_init+0x0/0x200
  [<ffffffff81003c10>] ? kernel_thread_helper+0x0/0x10
---[ end trace 30838b0dc5ec48e4 ]---

Several more "BUG: key fffXXXXXXXXXXXX not in .data!" lines show up 
throughout the boot process.

I vaguely recall this being normal for lockstat at initial boot.

--
Darren



> 
> Thanks,
> Yong
> 
>> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>                               class name    con-bounces
>> contentions   waittime-min   waittime-max waittime-total
>> acq-bounces acquisitions   holdtime-min   holdtime-max
>> holdtime-total
>> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>
>> #
>>
>> Thanks,
>>
>> -- 
>> Darren Hart
>> IBM Linux Technology Center
>> Real-Time Linux Team
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
