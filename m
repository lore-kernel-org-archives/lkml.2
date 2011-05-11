Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1EKRTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:19:11 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:39010 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1EKRS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:18:57 -0400
Message-ID: <4DCA2FD0.1070700@kernel.org>
Date: Tue, 10 May 2011 23:42:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110508151848.GA21906@linux.vnet.ibm.com> <20110509073636.GA18247@elte.hu> <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com> <20110510085623.GG2258@linux.vnet.ibm.com> <4DC97E49.7040401@kernel.org> <20110510193216.GN2258@linux.vnet.ibm.com> <4DC9A5A4.1050308@kernel.org> <20110511045443.GS2258@linux.vnet.ibm.com>
In-Reply-To: <20110511045443.GS2258@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DCA2FDF.0191,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2011 09:54 PM, Paul E. McKenney wrote:
> On Tue, May 10, 2011 at 01:52:52PM -0700, Yinghai Lu wrote:
>> On 05/10/2011 12:32 PM, Paul E. McKenney wrote:
>>> On Tue, May 10, 2011 at 11:04:57AM -0700, Yinghai Lu wrote:
>>>> On 05/10/2011 01:56 AM, Paul E. McKenney wrote:
>>>>> On Mon, May 09, 2011 at 02:09:21PM -0700, Yinghai Lu wrote:
>>>>>> On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>>>>>
>>>>>>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>>>>>>>
>>>>>>>> Hello, Ingo,
>>>>>>>>
>>>>>>>> This pull request covers RCU chnages for 2.6.40.  The major new features
>>>>>>>> are RCU priority boosting and the addition of kfree_rcu(), the latter
>>>>>>>> courtesy of Lai Jiangshan.  These two features cover well over half
>>>>>>>> of the commits.  There are a number of smaller features and bug fixes.
>>>>>>>> All have been sent to LKML in the following batches:
>>>>>>>>
>>>>>>>> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
>>>>>>>> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
>>>>>>>> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
>>>>>>>> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
>>>>>>>>
>>>>>>>> The kfree_rcu() uses in the pull request have Acked-by:s from the
>>>>>>>> maintainers.  I have some additional kfree_rcu() requests that lack
>>>>>>>> Acked-by:s, and I will deal with these later.
>>>>>>>>
>>>>>>>> These channges are available in the -rcu git repository at:
>>>>>>>>
>>>>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
>>>>>>>
>>>>>>> Pulled, thanks a lot Paul!
>>>>>>>
>>>>>>
>>>>>> it seems with this one in tip, my 8 sockets test setup will report cpu stall.
>>>>>>
>>>>>> after hard code to enable rcu_cpu_stall_suppress
>>>>>>
>>>>>> Index: linux-2.6/kernel/rcutree.c
>>>>>> ===================================================================
>>>>>> --- linux-2.6.orig/kernel/rcutree.c
>>>>>> +++ linux-2.6/kernel/rcutree.c
>>>>>> @@ -174,7 +174,7 @@ module_param(blimit, int, 0);
>>>>>>  module_param(qhimark, int, 0);
>>>>>>  module_param(qlowmark, int, 0);
>>>>>>
>>>>>> -int rcu_cpu_stall_suppress __read_mostly;
>>>>>> +int rcu_cpu_stall_suppress __read_mostly = 1;
>>>>>>  module_param(rcu_cpu_stall_suppress, int, 0644);
>>>>>>
>>>>>>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
>>>>>>
>>>>>> will get system hang after pnp ACPI init.
>>>>>
>>>>> Could you please send the stack traces from the RCU CPU stall?  Also,
>>>>> you do have ce31332d3c77532d6ea97ddcb475a2b02dd358b4 applied, correct?
>>>>>
>>>>> 							Thanx, Paul
>>>>
>>>> Do not have time to bisect it at this point.
>>>
>>> Could you please send the stack traces from the RCU CPU stall?
> 
> Thank you!  OK, so CPU 0 has not been responding, despite resched IPIs.
> Everyone is idle, except for CPU 124, which detected the stall, and
> possibly CPU 0, which has csum_partial_copy_generic() on the stack, though
> that looks like a backtrace error to me.  The fact that it hangs if you
> disable RCU CPU stall detection leads me to believe that something real
> is being detected.
> 
> This looks very similar to the situation people were seeing before
> ce31332d3c77532d6ea97ddcb475a2b02dd358b4 was applied, so I have attached
> the diagnostic script that helped track this down.  Could you please
> enable CONFIG_RCU_TRACE, mount debugfs, and run the attached script,
> and send me the output?  Please check to make sure that the script knows
> where you mounted debugfs, of course.

Wed May 11 14:33:35 UTC 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=4164  gpnum=4165
rcu_bh: completed=-282  gpnum=18446744073709551334
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=4164 g=4165 s=2 jfq=0 j=92fc nfqs=6792/nfqsng=0(6792) fqlh=737
ff/ff ..>.. 0:254 ^0    
fdff/ffff ..>.. 0:15 ^0    fffc/ffff ..>.. 16:31 ^1    ffff/ffff ..>.. 32:47 ^2    ffff/ffff ..>.. 48:63 ^3    fdff/ffff ..>.. 64:79 ^4    ffff/ffff ..>.. 80:95 ^5    ffff/ffff ..>.. 96:111 ^6    ffff/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    
rcu_bh:
c=18446744073709551334 g=18446744073709551334 s=0 jfq=-1351 j=92fc nfqs=21/nfqsng=0(21) fqlh=2
0/ff ..>.. 0:254 ^0    
0/ffff ..>.. 0:15 ^0    0/ffff ..>.. 16:31 ^1    0/ffff ..>.. 32:47 ^2    0/ffff ..>.. 48:63 ^3    0/ffff ..>.. 64:79 ^4    0/ffff ..>.. 80:95 ^5    0/ffff ..>.. 96:111 ^6    0/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=6072/72 dn=4 df=2570 of=0 ri=601 ql=0 b=10 ci=6119 co=0 ca=0
  1 c=4163 g=4164 pq=0 pqc=4162 qp=1 dt=12470/0 dn=0 df=2722 of=0 ri=13 ql=0 b=10 ci=11239 co=0 ca=0
  2 c=4142 g=4142 pq=1 pqc=4141 qp=0 dt=11168/0 dn=2 df=3326 of=0 ri=149 ql=0 b=10 ci=2170 co=0 ca=0
  3 c=4142 g=4142 pq=1 pqc=4141 qp=0 dt=1694/0 dn=0 df=3570 of=0 ri=6 ql=0 b=10 ci=123 co=0 ca=0
  4 c=4142 g=4142 pq=1 pqc=4141 qp=0 dt=1538/0 dn=2 df=3580 of=0 ri=1 ql=0 b=10 ci=50 co=0 ca=0
  5 c=4142 g=4142 pq=1 pqc=4141 qp=0 dt=1608/0 dn=0 df=3597 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  6 c=4142 g=4142 pq=1 pqc=4141 qp=0 dt=1598/0 dn=2 df=3597 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  7 c=4142 g=4142 pq=1 pqc=4141 qp=0 dt=1646/0 dn=2 df=3597 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  8 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=9158/0 dn=2 df=2368 of=0 ri=760 ql=0 b=10 ci=7223 co=0 ca=0
  9 c=4164 g=4165 pq=1 pqc=4164 qp=0 dt=3131/1 dn=0 df=2685 of=0 ri=1 ql=2 b=10 ci=13631 co=0 ca=0
 10 c=4144 g=4144 pq=1 pqc=4143 qp=0 dt=2020/0 dn=0 df=3444 of=0 ri=1 ql=0 b=10 ci=702 co=0 ca=0
 11 c=4144 g=4144 pq=1 pqc=4143 qp=0 dt=1760/0 dn=2 df=3590 of=0 ri=1 ql=0 b=10 ci=25 co=0 ca=0
 12 c=4144 g=4144 pq=1 pqc=4143 qp=0 dt=1800/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 13 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=3594/0 dn=2 df=3598 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 14 c=4144 g=4144 pq=1 pqc=4143 qp=0 dt=1704/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 15 c=4144 g=4144 pq=1 pqc=4143 qp=0 dt=1648/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 16 c=4164 g=4165 pq=1 pqc=4164 qp=0 dt=18235/1 dn=0 df=2734 of=0 ri=103 ql=2 b=10 ci=3533 co=0 ca=0
 17 c=4164 g=4165 pq=1 pqc=4164 qp=0 dt=1273/1 dn=0 df=2736 of=0 ri=1 ql=11 b=10 ci=11685 co=0 ca=0
 18 c=4146 g=4146 pq=1 pqc=4145 qp=0 dt=1678/0 dn=0 df=3444 of=0 ri=1 ql=0 b=10 ci=665 co=0 ca=0
 19 c=4146 g=4146 pq=1 pqc=4145 qp=0 dt=2044/0 dn=0 df=3568 of=0 ri=1 ql=0 b=10 ci=121 co=0 ca=0
 20 c=4146 g=4146 pq=1 pqc=4145 qp=0 dt=3666/0 dn=0 df=3596 of=0 ri=1 ql=0 b=10 ci=24 co=0 ca=0
 21 c=4146 g=4146 pq=1 pqc=4145 qp=0 dt=1788/0 dn=2 df=3598 of=0 ri=1 ql=0 b=10 ci=21 co=0 ca=0
 22 c=4146 g=4146 pq=1 pqc=4145 qp=0 dt=1726/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 23 c=4146 g=4146 pq=1 pqc=4145 qp=0 dt=1720/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 24 c=4164 g=4165 pq=1 pqc=4164 qp=0 dt=14333/1 dn=0 df=2865 of=0 ri=1 ql=2 b=10 ci=3337 co=0 ca=0
 25 c=4164 g=4165 pq=1 pqc=4164 qp=0 dt=1593/1 dn=0 df=2707 of=0 ri=1 ql=9 b=10 ci=19146 co=0 ca=0
 26 c=4146 g=4146 pq=1 pqc=4145 qp=0 dt=1786/0 dn=2 df=3427 of=0 ri=1 ql=0 b=10 ci=1035 co=0 ca=0
 27 c=4146 g=4146 pq=1 pqc=4145 qp=0 dt=1586/0 dn=2 df=3571 of=0 ri=1 ql=0 b=10 ci=157 co=0 ca=0
 28 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1582/0 dn=0 df=3569 of=0 ri=1 ql=0 b=10 ci=92 co=0 ca=0
 29 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1550/0 dn=2 df=3594 of=0 ri=1 ql=0 b=10 ci=14 co=0 ca=0
 30 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1650/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 31 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1662/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 32 c=4164 g=4165 pq=1 pqc=4164 qp=1 dt=5537/1 dn=0 df=2756 of=0 ri=97 ql=2 b=10 ci=3209 co=0 ca=0
 33 c=4164 g=4165 pq=1 pqc=4164 qp=1 dt=1367/1 dn=0 df=2725 of=0 ri=1 ql=9 b=10 ci=17809 co=0 ca=0
 34 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1784/0 dn=0 df=3474 of=0 ri=1 ql=0 b=10 ci=538 co=0 ca=0
 35 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1670/0 dn=2 df=3577 of=0 ri=1 ql=0 b=10 ci=111 co=0 ca=0
 36 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1682/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 37 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1664/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 38 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1622/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 39 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1664/0 dn=2 df=3598 of=0 ri=1 ql=0 b=10 ci=18 co=0 ca=0
 40 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1846/0 dn=0 df=2958 of=0 ri=1 ql=0 b=10 ci=10276 co=0 ca=0
 41 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1621/1 dn=0 df=2831 of=0 ri=1 ql=3 b=10 ci=16207 co=0 ca=0
 42 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1764/0 dn=0 df=3503 of=0 ri=1 ql=0 b=10 ci=176 co=0 ca=0
 43 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1706/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 44 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1654/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 45 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=2048/0 dn=0 df=3600 of=0 ri=1 ql=0 b=10 ci=12 co=0 ca=0
 46 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1670/0 dn=2 df=3599 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 47 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1694/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 48 c=4151 g=4152 pq=1 pqc=4151 qp=0 dt=35230/0 dn=2 df=2620 of=0 ri=161 ql=0 b=10 ci=20305 co=0 ca=0
 49 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1534/0 dn=0 df=2847 of=0 ri=15 ql=0 b=10 ci=28443 co=0 ca=0
 50 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1910/0 dn=0 df=3461 of=0 ri=1 ql=0 b=10 ci=537 co=0 ca=0
 51 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1994/0 dn=0 df=3564 of=0 ri=1 ql=0 b=10 ci=102 co=0 ca=0
 52 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1834/0 dn=2 df=3584 of=0 ri=1 ql=0 b=10 ci=57 co=0 ca=0
 53 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1630/0 dn=0 df=3596 of=0 ri=1 ql=0 b=10 ci=15 co=0 ca=0
 54 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1608/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 55 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1680/0 dn=2 df=3599 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 56 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1650/0 dn=2 df=2887 of=0 ri=1 ql=0 b=10 ci=2645 co=0 ca=0
 57 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1284/0 dn=0 df=2776 of=0 ri=1 ql=0 b=10 ci=11764 co=0 ca=0
 58 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=2056/0 dn=0 df=3462 of=0 ri=1 ql=0 b=10 ci=650 co=0 ca=0
 59 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=2004/0 dn=2 df=3591 of=0 ri=1 ql=0 b=10 ci=40 co=0 ca=0
 60 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=1686/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 61 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=1598/0 dn=2 df=3599 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 62 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=1686/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 63 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=6030/0 dn=0 df=3414 of=0 ri=30 ql=0 b=10 ci=150 co=0 ca=0
 64 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=8338/0 dn=2 df=3180 of=0 ri=274 ql=0 b=10 ci=1436 co=0 ca=0
 65 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=2888/0 dn=0 df=3076 of=0 ri=6 ql=0 b=10 ci=5781 co=0 ca=0
 66 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=3958/0 dn=0 df=3549 of=0 ri=6 ql=0 b=10 ci=131 co=0 ca=0
 67 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=1616/0 dn=0 df=3593 of=0 ri=1 ql=0 b=10 ci=26 co=0 ca=0
 68 c=4155 g=4156 pq=1 pqc=4155 qp=0 dt=1622/0 dn=0 df=3597 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 69 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1672/0 dn=2 df=3597 of=0 ri=6 ql=0 b=10 ci=11 co=0 ca=0
 70 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1656/0 dn=2 df=3598 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
 71 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1588/0 dn=2 df=3598 of=0 ri=1 ql=0 b=10 ci=12 co=0 ca=0
 72 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=6142/0 dn=4 df=3388 of=0 ri=112 ql=0 b=10 ci=493 co=0 ca=0
 73 c=4164 g=4165 pq=1 pqc=4164 qp=0 dt=7465/1 dn=0 df=2868 of=0 ri=3 ql=32 b=10 ci=72222 co=0 ca=0
 74 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1690/0 dn=2 df=3570 of=0 ri=1 ql=0 b=10 ci=125 co=0 ca=0
 75 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1680/0 dn=2 df=3597 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 76 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1678/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 77 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1666/0 dn=0 df=3597 of=0 ri=1 ql=0 b=10 ci=111 co=0 ca=0
 78 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1714/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 79 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1620/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 80 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=2154/0 dn=2 df=3331 of=0 ri=1 ql=0 b=10 ci=590 co=0 ca=0
 81 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=3648/0 dn=0 df=3130 of=0 ri=1 ql=0 b=10 ci=5193 co=0 ca=0
 82 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1626/0 dn=2 df=3571 of=0 ri=1 ql=0 b=10 ci=106 co=0 ca=0
 83 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1672/0 dn=2 df=3594 of=0 ri=1 ql=0 b=10 ci=22 co=0 ca=0
 84 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1610/0 dn=2 df=3599 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 85 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1640/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 86 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1644/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 87 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1672/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 88 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1852/0 dn=0 df=3349 of=0 ri=1 ql=0 b=10 ci=884 co=0 ca=0
 89 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=2814/0 dn=0 df=3230 of=0 ri=1 ql=0 b=10 ci=2572 co=0 ca=0
 90 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1542/0 dn=0 df=3554 of=0 ri=1 ql=0 b=10 ci=154 co=0 ca=0
 91 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1770/0 dn=2 df=3593 of=0 ri=1 ql=0 b=10 ci=20 co=0 ca=0
 92 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1728/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 93 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1718/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 94 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1716/0 dn=2 df=3602 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 95 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1608/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 96 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1718/0 dn=2 df=3372 of=0 ri=1 ql=0 b=10 ci=493 co=0 ca=0
 97 c=4164 g=4165 pq=1 pqc=4164 qp=1 dt=2656/0 dn=0 df=3278 of=0 ri=1 ql=0 b=10 ci=1015 co=0 ca=0
 98 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1720/0 dn=2 df=3592 of=0 ri=1 ql=0 b=10 ci=27 co=0 ca=0
 99 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1640/0 dn=2 df=3599 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
100 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1728/0 dn=2 df=3598 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
101 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1704/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
102 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1690/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
103 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1696/0 dn=2 df=3597 of=0 ri=1 ql=0 b=10 ci=1923 co=0 ca=0
104 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1694/0 dn=2 df=3406 of=0 ri=1 ql=0 b=10 ci=387 co=0 ca=0
105 c=4164 g=4165 pq=1 pqc=4164 qp=1 dt=2726/0 dn=0 df=3306 of=0 ri=1 ql=0 b=10 ci=20365 co=0 ca=0
106 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1814/0 dn=2 df=3589 of=0 ri=1 ql=0 b=10 ci=50 co=0 ca=0
107 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1722/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
108 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1650/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
109 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1662/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
110 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1714/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
111 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1626/0 dn=2 df=3599 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
112 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=7810/0 dn=0 df=3325 of=0 ri=36 ql=0 b=10 ci=613 co=0 ca=0
113 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=2392/0 dn=0 df=3277 of=0 ri=1 ql=0 b=10 ci=5505 co=0 ca=0
114 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1654/0 dn=0 df=3518 of=0 ri=1 ql=0 b=10 ci=497 co=0 ca=0
115 c=4138 g=4138 pq=1 pqc=4137 qp=0 dt=1566/0 dn=2 df=3589 of=0 ri=1 ql=0 b=10 ci=38 co=0 ca=0
116 c=4139 g=4140 pq=1 pqc=4139 qp=0 dt=1736/0 dn=2 df=3596 of=0 ri=1 ql=0 b=10 ci=34 co=0 ca=0
117 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=1596/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=10 co=0 ca=0
118 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=1638/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
119 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=2682/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
120 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=2234/0 dn=0 df=3397 of=0 ri=1 ql=0 b=10 ci=393 co=0 ca=0
121 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=2980/0 dn=0 df=2005 of=0 ri=1 ql=0 b=10 ci=48877 co=0 ca=0
122 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=1554/0 dn=0 df=3527 of=0 ri=1 ql=0 b=10 ci=333 co=0 ca=0
123 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=1630/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
124 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=1682/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
125 c=4140 g=4140 pq=1 pqc=4139 qp=0 dt=1650/0 dn=2 df=3600 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
126 c=4141 g=4142 pq=1 pqc=4141 qp=0 dt=2466/0 dn=2 df=3595 of=0 ri=1 ql=0 b=10 ci=21 co=0 ca=0
127 c=4142 g=4142 pq=1 pqc=4141 qp=0 dt=1720/0 dn=2 df=3601 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
rcu_bh:
  0 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=6072/72 dn=4 df=7 of=0 ri=0 ql=0 b=10 ci=6 co=0 ca=0
  1 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=12470/0 dn=0 df=12 of=0 ri=0 ql=0 b=10 ci=4 co=0 ca=0
  2 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=11168/0 dn=2 df=13 of=0 ri=0 ql=0 b=10 ci=11 co=0 ca=0
  3 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1694/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  4 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1538/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  5 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1608/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  6 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1598/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  7 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1646/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  8 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=9158/0 dn=2 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  9 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=3131/1 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 10 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2020/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 11 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1760/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 12 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1800/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 13 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=3597/1 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 14 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1704/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 15 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1648/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 16 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=18235/1 dn=0 df=13 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 17 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1273/1 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=8 co=0 ca=0
 18 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1678/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 19 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2044/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 20 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=3666/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 21 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1788/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 22 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1726/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 23 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1720/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 24 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=14333/1 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 25 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1593/1 dn=0 df=15 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 26 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1786/0 dn=2 df=16 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 27 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1586/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 28 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1582/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 29 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1550/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 30 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1650/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 31 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1662/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 32 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=5537/1 dn=0 df=12 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 33 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1367/1 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 34 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1784/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 35 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1670/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 36 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1682/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 37 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1664/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 38 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1622/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 39 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1664/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 40 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1846/0 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 41 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1621/1 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 42 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1764/0 dn=0 df=16 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 43 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1706/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 44 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1654/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 45 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2048/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 46 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1670/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 47 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1694/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 48 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=35230/0 dn=2 df=12 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 49 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1534/0 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 50 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1910/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 51 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1994/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 52 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1834/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 53 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1630/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 54 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1608/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 55 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1680/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 56 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1650/0 dn=2 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 57 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1284/0 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 58 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2056/0 dn=0 df=16 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 59 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2004/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 60 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1686/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 61 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1598/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 62 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1686/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 63 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=6030/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 64 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=8338/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 65 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2888/0 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 66 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=3958/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 67 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1616/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 68 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1622/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 69 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1672/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 70 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1656/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 71 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1588/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 72 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=6142/0 dn=4 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 73 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=7465/1 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 74 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1690/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 75 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1680/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 76 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1678/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 77 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1666/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 78 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1714/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 79 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1620/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 80 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2154/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 81 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=3648/0 dn=0 df=16 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 82 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1626/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 83 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1672/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 84 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1610/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 85 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1640/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 86 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1644/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 87 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1672/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 88 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1852/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 89 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2814/0 dn=0 df=15 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 90 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1542/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 91 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1770/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 92 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1728/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 93 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1718/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 94 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1716/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 95 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1608/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 96 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1718/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 97 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=2656/0 dn=0 df=16 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 98 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1720/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 99 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1640/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
100 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1728/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
101 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1704/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
102 c=18446744073709551332 g=18446744073709551332 pq=1 pqc=18446744073709551331 qp=0 dt=1690/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
103 c=18446744073709551332 g=18446744073709551332 pq=1 pqc=18446744073709551331 qp=0 dt=1696/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
104 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1694/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
105 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=2728/0 dn=0 df=16 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
106 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1814/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
107 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1722/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
108 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1650/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
109 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1662/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
110 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1714/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
111 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1626/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
112 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=7810/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
113 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=2392/0 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
114 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1654/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
115 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1566/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
116 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1736/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
117 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1596/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
118 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1638/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
119 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2682/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
120 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2234/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
121 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2980/0 dn=0 df=14 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
122 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1554/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
123 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1630/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
124 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1682/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
125 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1650/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
126 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2466/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
127 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1720/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=24806 qsp=1521 rpq=6020 cbr=1 cng=1254 gpc=1128 gps=131 nf=683 nn=15589
  1 np=26594 qsp=60 rpq=8004 cbr=5 cng=44 gpc=1620 gps=748 nf=430 nn=15743
  2 np=23556 qsp=164 rpq=6864 cbr=0 cng=28 gpc=1101 gps=715 nf=180 nn=14668
  3 np=21600 qsp=29 rpq=6997 cbr=0 cng=5 gpc=909 gps=708 nf=96 nn=12885
  4 np=21508 qsp=9 rpq=6943 cbr=0 cng=5 gpc=983 gps=729 nf=100 nn=12748
  5 np=21376 qsp=28 rpq=6885 cbr=0 cng=2 gpc=875 gps=683 nf=109 nn=12822
  6 np=21338 qsp=30 rpq=6845 cbr=0 cng=2 gpc=874 gps=689 nf=104 nn=12824
  7 np=21298 qsp=32 rpq=6806 cbr=0 cng=2 gpc=981 gps=700 nf=107 nn=12702
  8 np=30293 qsp=840 rpq=8100 cbr=1 cng=45 gpc=1657 gps=779 nf=590 nn=19121
  9 np=25376 qsp=32 rpq=7677 cbr=1 cng=22 gpc=1742 gps=783 nf=171 nn=14980
 10 np=21235 qsp=7 rpq=6852 cbr=0 cng=8 gpc=1269 gps=806 nf=15 nn=12285
 11 np=20409 qsp=9 rpq=6630 cbr=0 cng=1 gpc=1063 gps=807 nf=5 nn=11903
 12 np=20307 qsp=9 rpq=6574 cbr=0 cng=1 gpc=856 gps=755 nf=2 nn=12119
 13 np=20785 qsp=9 rpq=6541 cbr=0 cng=1 gpc=909 gps=735 nf=4 nn=12595
 14 np=20213 qsp=7 rpq=6482 cbr=0 cng=0 gpc=775 gps=758 nf=2 nn=12196
 15 np=20176 qsp=9 rpq=6443 cbr=0 cng=0 gpc=870 gps=757 nf=3 nn=12103
 16 np=28721 qsp=173 rpq=7569 cbr=0 cng=27 gpc=1742 gps=748 nf=262 nn=18373
 17 np=25111 qsp=26 rpq=7251 cbr=1 cng=11 gpc=1709 gps=698 nf=205 nn=15236
 18 np=20875 qsp=9 rpq=6484 cbr=0 cng=4 gpc=1027 gps=681 nf=26 nn=12653
 19 np=20173 qsp=11 rpq=6309 cbr=0 cng=1 gpc=895 gps=692 nf=8 nn=12268
 20 np=19991 qsp=7 rpq=6224 cbr=0 cng=0 gpc=876 gps=671 nf=5 nn=12215
 21 np=19928 qsp=9 rpq=6173 cbr=0 cng=0 gpc=869 gps=697 nf=5 nn=12184
 22 np=19876 qsp=7 rpq=6122 cbr=0 cng=0 gpc=875 gps=696 nf=1 nn=12182
 23 np=19829 qsp=7 rpq=6077 cbr=0 cng=0 gpc=873 gps=696 nf=2 nn=12181
 24 np=23838 qsp=19 rpq=6839 cbr=0 cng=18 gpc=1548 gps=685 nf=167 nn=14581
 25 np=24901 qsp=96 rpq=6902 cbr=12 cng=15 gpc=1692 gps=698 nf=261 nn=15321
 26 np=20559 qsp=15 rpq=6148 cbr=0 cng=2 gpc=1044 gps=692 nf=14 nn=12659
 27 np=19784 qsp=10 rpq=5927 cbr=0 cng=1 gpc=906 gps=691 nf=13 nn=12246
 28 np=19762 qsp=7 rpq=5886 cbr=0 cng=1 gpc=905 gps=677 nf=9 nn=12284
 29 np=19579 qsp=7 rpq=5813 cbr=0 cng=1 gpc=886 gps=685 nf=8 nn=12186
 30 np=19504 qsp=6 rpq=5760 cbr=0 cng=1 gpc=873 gps=717 nf=2 nn=12151
 31 np=19463 qsp=8 rpq=5714 cbr=0 cng=1 gpc=873 gps=700 nf=1 nn=12174
 32 np=24626 qsp=164 rpq=6629 cbr=0 cng=17 gpc=1707 gps=741 nf=131 nn=15401
 33 np=23699 qsp=37 rpq=6514 cbr=5 cng=7 gpc=1707 gps=733 nf=118 nn=14615
 34 np=19922 qsp=8 rpq=5728 cbr=0 cng=4 gpc=994 gps=729 nf=14 nn=12453
 35 np=19378 qsp=9 rpq=5558 cbr=0 cng=0 gpc=889 gps=727 nf=9 nn=12195
 36 np=19221 qsp=8 rpq=5488 cbr=0 cng=0 gpc=875 gps=716 nf=6 nn=12136
 37 np=19176 qsp=8 rpq=5442 cbr=0 cng=0 gpc=869 gps=721 nf=2 nn=12142
 38 np=19130 qsp=7 rpq=5399 cbr=0 cng=0 gpc=873 gps=722 nf=4 nn=12132
 39 np=19098 qsp=9 rpq=5357 cbr=0 cng=0 gpc=873 gps=720 nf=5 nn=12143
 40 np=22183 qsp=29 rpq=6020 cbr=1 cng=7 gpc=1469 gps=784 nf=83 nn=13819
 41 np=22788 qsp=66 rpq=6047 cbr=13 cng=13 gpc=1670 gps=661 nf=88 nn=14296
 42 np=19432 qsp=8 rpq=5349 cbr=0 cng=0 gpc=1001 gps=793 nf=4 nn=12285
 43 np=18929 qsp=8 rpq=5179 cbr=0 cng=0 gpc=950 gps=797 nf=5 nn=11998
 44 np=18883 qsp=7 rpq=5135 cbr=0 cng=0 gpc=1206 gps=767 nf=1 nn=11774
 45 np=18844 qsp=8 rpq=5092 cbr=0 cng=0 gpc=1199 gps=737 nf=3 nn=11813
 46 np=18799 qsp=7 rpq=5044 cbr=0 cng=0 gpc=1315 gps=801 nf=3 nn=11636
 47 np=18746 qsp=8 rpq=4998 cbr=0 cng=0 gpc=1050 gps=653 nf=3 nn=12042
 48 np=25095 qsp=297 rpq=6163 cbr=3 cng=14 gpc=1687 gps=740 nf=503 nn=15985
 49 np=22838 qsp=68 rpq=5689 cbr=3 cng=12 gpc=1596 gps=695 nf=116 nn=14727
 50 np=19790 qsp=9 rpq=5021 cbr=0 cng=0 gpc=1017 gps=686 nf=96 nn=12970
 51 np=19209 qsp=8 rpq=4858 cbr=0 cng=0 gpc=910 gps=679 nf=63 nn=12699
 52 np=19011 qsp=8 rpq=4788 cbr=0 cng=0 gpc=889 gps=680 nf=48 nn=12606
 53 np=19120 qsp=7 rpq=4730 cbr=0 cng=0 gpc=874 gps=682 nf=60 nn=12774
 54 np=18397 qsp=8 rpq=4682 cbr=0 cng=0 gpc=869 gps=682 nf=9 nn=12155
 55 np=18350 qsp=9 rpq=4635 cbr=0 cng=0 gpc=871 gps=678 nf=5 nn=12161
 56 np=21837 qsp=11 rpq=5384 cbr=0 cng=10 gpc=1575 gps=701 nf=91 nn=14076
 57 np=22322 qsp=27 rpq=5397 cbr=2 cng=11 gpc=1821 gps=707 nf=98 nn=14286
 58 np=18955 qsp=10 rpq=4658 cbr=0 cng=1 gpc=1217 gps=712 nf=21 nn=12346
 59 np=18242 qsp=8 rpq=4469 cbr=0 cng=0 gpc=907 gps=706 nf=4 nn=12156
 60 np=18162 qsp=8 rpq=4412 cbr=0 cng=0 gpc=1030 gps=741 nf=6 nn=11973
 61 np=18117 qsp=8 rpq=4369 cbr=0 cng=0 gpc=950 gps=688 nf=4 nn=12106
 62 np=18075 qsp=7 rpq=4330 cbr=0 cng=0 gpc=872 gps=662 nf=7 nn=12204
 63 np=19170 qsp=44 rpq=4583 cbr=0 cng=0 gpc=1019 gps=671 nf=133 nn=12764
 64 np=22024 qsp=234 rpq=4773 cbr=0 cng=10 gpc=1344 gps=684 nf=67 nn=15146
 65 np=20692 qsp=33 rpq=4833 cbr=0 cng=9 gpc=1402 gps=686 nf=192 nn=13570
 66 np=18466 qsp=32 rpq=4222 cbr=0 cng=4 gpc=923 gps=636 nf=28 nn=12653
 67 np=18101 qsp=8 rpq=4119 cbr=0 cng=3 gpc=1149 gps=633 nf=25 nn=12172
 68 np=18042 qsp=8 rpq=4072 cbr=0 cng=3 gpc=882 gps=666 nf=23 nn=12396
 69 np=17993 qsp=30 rpq=4025 cbr=0 cng=2 gpc=919 gps=683 nf=29 nn=12335
 70 np=17951 qsp=32 rpq=3979 cbr=0 cng=3 gpc=878 gps=676 nf=21 nn=12394
 71 np=17901 qsp=8 rpq=3935 cbr=0 cng=3 gpc=931 gps=733 nf=33 nn=12266
 72 np=20530 qsp=129 rpq=4144 cbr=0 cng=1 gpc=1106 gps=628 nf=28 nn=14623
 73 np=25529 qsp=10 rpq=4626 cbr=1 cng=311 gpc=1244 gps=606 nf=1401 nn=17340
 74 np=17670 qsp=7 rpq=3829 cbr=0 cng=3 gpc=900 gps=775 nf=7 nn=12156
 75 np=17494 qsp=8 rpq=3753 cbr=0 cng=1 gpc=878 gps=770 nf=4 nn=12088
 76 np=17429 qsp=8 rpq=3703 cbr=0 cng=0 gpc=872 gps=766 nf=3 nn=12085
 77 np=17399 qsp=8 rpq=3660 cbr=0 cng=1 gpc=878 gps=772 nf=3 nn=12085
 78 np=17334 qsp=7 rpq=3608 cbr=0 cng=1 gpc=873 gps=764 nf=1 nn=12087
 79 np=17288 qsp=9 rpq=3563 cbr=0 cng=1 gpc=871 gps=758 nf=2 nn=12093
 80 np=19879 qsp=9 rpq=3836 cbr=0 cng=13 gpc=1129 gps=700 nf=116 nn=14085
 81 np=21160 qsp=7 rpq=4050 cbr=0 cng=62 gpc=1317 gps=704 nf=315 nn=14712
 82 np=18105 qsp=7 rpq=3461 cbr=0 cng=0 gpc=907 gps=699 nf=150 nn=12888
 83 np=17157 qsp=9 rpq=3391 cbr=0 cng=0 gpc=886 gps=740 nf=5 nn=12135
 84 np=17085 qsp=8 rpq=3336 cbr=0 cng=0 gpc=880 gps=756 nf=7 nn=12106
 85 np=17039 qsp=9 rpq=3293 cbr=0 cng=0 gpc=875 gps=749 nf=5 nn=12117
 86 np=16993 qsp=7 rpq=3248 cbr=0 cng=0 gpc=877 gps=747 nf=3 nn=12118
 87 np=16948 qsp=8 rpq=3201 cbr=0 cng=0 gpc=879 gps=749 nf=4 nn=12115
 88 np=18331 qsp=20 rpq=3450 cbr=0 cng=3 gpc=1147 gps=718 nf=38 nn=12975
 89 np=19383 qsp=12 rpq=3582 cbr=0 cng=3 gpc=1286 gps=715 nf=165 nn=13632
 90 np=17241 qsp=9 rpq=3121 cbr=0 cng=2 gpc=928 gps=710 nf=38 nn=12442
 91 np=16803 qsp=8 rpq=3031 cbr=0 cng=1 gpc=895 gps=698 nf=2 nn=12176
 92 np=16724 qsp=9 rpq=2976 cbr=0 cng=0 gpc=878 gps=695 nf=8 nn=12167
 93 np=16678 qsp=8 rpq=2932 cbr=0 cng=1 gpc=884 gps=694 nf=3 nn=12164
 94 np=16624 qsp=8 rpq=2886 cbr=0 cng=1 gpc=875 gps=698 nf=1 nn=12163
 95 np=16586 qsp=7 rpq=2842 cbr=0 cng=0 gpc=878 gps=687 nf=3 nn=12176
 96 np=17817 qsp=8 rpq=3050 cbr=0 cng=3 gpc=1114 gps=710 nf=24 nn=12916
 97 np=19239 qsp=8 rpq=3182 cbr=0 cng=3 gpc=1223 gps=714 nf=127 nn=13990
 98 np=16473 qsp=9 rpq=2713 cbr=0 cng=0 gpc=882 gps=710 nf=3 nn=12165
 99 np=16407 qsp=8 rpq=2663 cbr=0 cng=0 gpc=875 gps=719 nf=4 nn=12146
100 np=16350 qsp=8 rpq=2609 cbr=0 cng=0 gpc=876 gps=699 nf=1 nn=12165
101 np=16293 qsp=8 rpq=2562 cbr=0 cng=1 gpc=874 gps=692 nf=3 nn=12161
102 np=16251 qsp=8 rpq=2518 cbr=0 cng=0 gpc=877 gps=683 nf=0 nn=12173
103 np=16225 qsp=11 rpq=2475 cbr=0 cng=0 gpc=877 gps=689 nf=6 nn=12178
104 np=17119 qsp=9 rpq=2651 cbr=0 cng=1 gpc=1089 gps=768 nf=13 nn=12597
105 np=17595 qsp=67 rpq=2711 cbr=2 cng=3 gpc=1140 gps=771 nf=129 nn=12839
106 np=16158 qsp=9 rpq=2364 cbr=0 cng=0 gpc=887 gps=770 nf=5 nn=12132
107 np=16048 qsp=8 rpq=2296 cbr=0 cng=0 gpc=875 gps=770 nf=2 nn=12105
108 np=16006 qsp=7 rpq=2252 cbr=0 cng=0 gpc=881 gps=774 nf=7 nn=12092
109 np=15958 qsp=8 rpq=2206 cbr=0 cng=0 gpc=881 gps=773 nf=3 nn=12095
110 np=15911 qsp=7 rpq=2160 cbr=0 cng=0 gpc=881 gps=767 nf=4 nn=12099
111 np=15866 qsp=7 rpq=2117 cbr=0 cng=0 gpc=881 gps=772 nf=3 nn=12093
112 np=17863 qsp=27 rpq=2417 cbr=0 cng=4 gpc=1163 gps=701 nf=82 nn=13496
113 np=17613 qsp=12 rpq=2430 cbr=1 cng=2 gpc=1214 gps=722 nf=97 nn=13147
114 np=16333 qsp=8 rpq=2072 cbr=0 cng=0 gpc=957 gps=725 nf=25 nn=12554
115 np=15914 qsp=7 rpq=1947 cbr=0 cng=0 gpc=891 gps=711 nf=14 nn=12351
116 np=15840 qsp=8 rpq=1894 cbr=0 cng=0 gpc=881 gps=724 nf=15 nn=12326
117 np=15776 qsp=8 rpq=1845 cbr=0 cng=1 gpc=879 gps=721 nf=5 nn=12325
118 np=15514 qsp=7 rpq=1798 cbr=0 cng=0 gpc=881 gps=717 nf=2 nn=12116
119 np=15472 qsp=8 rpq=1755 cbr=0 cng=0 gpc=881 gps=720 nf=3 nn=12113
120 np=16459 qsp=9 rpq=1943 cbr=0 cng=0 gpc=1103 gps=662 nf=9 nn=12742
121 np=27487 qsp=10 rpq=3390 cbr=1 cng=127 gpc=1560 gps=706 nf=2320 nn=19383
122 np=15730 qsp=7 rpq=1699 cbr=0 cng=2 gpc=954 gps=668 nf=16 nn=12391
123 np=15325 qsp=8 rpq=1577 cbr=0 cng=0 gpc=885 gps=663 nf=5 nn=12195
124 np=15281 qsp=7 rpq=1531 cbr=0 cng=0 gpc=1044 gps=698 nf=5 nn=12003
125 np=15228 qsp=8 rpq=1488 cbr=0 cng=0 gpc=925 gps=686 nf=2 nn=12127
126 np=15223 qsp=9 rpq=1446 cbr=0 cng=0 gpc=1034 gps=724 nf=5 nn=12014
127 np=15142 qsp=8 rpq=1395 cbr=0 cng=0 gpc=1003 gps=669 nf=3 nn=12072
rcu_bh:
  0 np=15589 qsp=0 rpq=12266 cbr=0 cng=6 gpc=3 gps=2 nf=7 nn=3305
  1 np=15743 qsp=0 rpq=12789 cbr=0 cng=1 gpc=4 gps=1 nf=2 nn=2946
  2 np=14668 qsp=0 rpq=13505 cbr=0 cng=1 gpc=1 gps=0 nf=2 nn=1159
  3 np=12885 qsp=0 rpq=12815 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=70
  4 np=12748 qsp=0 rpq=12698 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=50
  5 np=12822 qsp=0 rpq=12818 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  6 np=12824 qsp=0 rpq=12820 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  7 np=12702 qsp=0 rpq=12698 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  8 np=19121 qsp=0 rpq=16647 cbr=0 cng=0 gpc=6 gps=2 nf=0 nn=2466
  9 np=14980 qsp=0 rpq=12483 cbr=0 cng=0 gpc=3 gps=2 nf=0 nn=2492
 10 np=12285 qsp=0 rpq=11814 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=471
 11 np=11903 qsp=0 rpq=11873 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=30
 12 np=12119 qsp=0 rpq=12115 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 13 np=12595 qsp=0 rpq=12123 cbr=0 cng=0 gpc=3 gps=0 nf=0 nn=469
 14 np=12196 qsp=0 rpq=12192 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 15 np=12103 qsp=0 rpq=12099 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 16 np=18373 qsp=0 rpq=15177 cbr=0 cng=0 gpc=6 gps=1 nf=2 nn=3187
 17 np=15236 qsp=0 rpq=12820 cbr=0 cng=2 gpc=2 gps=1 nf=0 nn=2411
 18 np=12653 qsp=0 rpq=12195 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=458
 19 np=12268 qsp=0 rpq=12184 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=84
 20 np=12215 qsp=0 rpq=12198 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=17
 21 np=12184 qsp=0 rpq=12176 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=8
 22 np=12182 qsp=0 rpq=12178 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 23 np=12181 qsp=0 rpq=12177 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 24 np=14581 qsp=0 rpq=12655 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=1923
 25 np=15321 qsp=0 rpq=12848 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=2471
 26 np=12659 qsp=0 rpq=12180 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=477
 27 np=12246 qsp=0 rpq=12167 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=79
 28 np=12284 qsp=0 rpq=12185 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 29 np=12186 qsp=0 rpq=12166 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=20
 30 np=12151 qsp=0 rpq=12147 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 31 np=12174 qsp=0 rpq=12170 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 32 np=15401 qsp=0 rpq=13091 cbr=0 cng=1 gpc=5 gps=1 nf=0 nn=2303
 33 np=14615 qsp=0 rpq=12140 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=2472
 34 np=12453 qsp=0 rpq=12120 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=333
 35 np=12195 qsp=0 rpq=12133 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=62
 36 np=12136 qsp=0 rpq=12132 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 37 np=12142 qsp=0 rpq=12138 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 38 np=12132 qsp=0 rpq=12128 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 39 np=12143 qsp=0 rpq=12132 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
 40 np=13819 qsp=0 rpq=12093 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=1724
 41 np=14296 qsp=0 rpq=12126 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=2166
 42 np=12285 qsp=0 rpq=12042 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=243
 43 np=11998 qsp=0 rpq=11995 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 44 np=11774 qsp=0 rpq=11770 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 45 np=11813 qsp=0 rpq=11807 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=6
 46 np=11636 qsp=0 rpq=11633 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 47 np=12042 qsp=0 rpq=12039 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 48 np=15985 qsp=0 rpq=13693 cbr=0 cng=1 gpc=3 gps=2 nf=0 nn=2286
 49 np=14727 qsp=0 rpq=12614 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=2110
 50 np=12970 qsp=0 rpq=12601 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=369
 51 np=12699 qsp=0 rpq=12614 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=85
 52 np=12606 qsp=0 rpq=12563 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=43
 53 np=12774 qsp=0 rpq=12764 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
 54 np=12155 qsp=0 rpq=12152 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 55 np=12161 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 56 np=14076 qsp=0 rpq=12179 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=1895
 57 np=14286 qsp=0 rpq=12025 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=2257
 58 np=12346 qsp=0 rpq=11955 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=389
 59 np=12156 qsp=0 rpq=12134 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=22
 60 np=11973 qsp=0 rpq=11970 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 61 np=12106 qsp=0 rpq=12102 cbr=0 cng=0 gpc=1 gps=0 nf=0 nn=3
 62 np=12204 qsp=0 rpq=12200 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 63 np=12764 qsp=0 rpq=12651 cbr=0 cng=0 gpc=3 gps=0 nf=0 nn=110
 64 np=15146 qsp=0 rpq=14190 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=956
 65 np=13570 qsp=0 rpq=12478 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=1088
 66 np=12653 qsp=0 rpq=12470 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=183
 67 np=12172 qsp=0 rpq=12163 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=9
 68 np=12396 qsp=0 rpq=12392 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 69 np=12335 qsp=0 rpq=12334 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
 70 np=12394 qsp=0 rpq=12390 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 71 np=12266 qsp=0 rpq=12262 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 72 np=14623 qsp=0 rpq=14140 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=483
 73 np=17340 qsp=0 rpq=16476 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=861
 74 np=12156 qsp=0 rpq=12077 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=79
 75 np=12088 qsp=0 rpq=12078 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
 76 np=12085 qsp=0 rpq=12083 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=2
 77 np=12085 qsp=0 rpq=12073 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=12
 78 np=12087 qsp=0 rpq=12084 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 79 np=12093 qsp=0 rpq=12090 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 80 np=14085 qsp=0 rpq=12836 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1249
 81 np=14712 qsp=0 rpq=13675 cbr=0 cng=0 gpc=3 gps=1 nf=0 nn=1033
 82 np=12888 qsp=0 rpq=12827 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=61
 83 np=12135 qsp=0 rpq=12122 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=13
 84 np=12106 qsp=0 rpq=12103 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 85 np=12117 qsp=0 rpq=12114 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 86 np=12118 qsp=0 rpq=12115 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 87 np=12115 qsp=0 rpq=12111 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 88 np=12975 qsp=0 rpq=12333 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=642
 89 np=13632 qsp=0 rpq=12832 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=797
 90 np=12442 qsp=0 rpq=12343 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 91 np=12176 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=16
 92 np=12167 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=9
 93 np=12164 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 94 np=12163 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 95 np=12176 qsp=0 rpq=12172 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 96 np=12916 qsp=0 rpq=12333 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=583
 97 np=13990 qsp=0 rpq=13175 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=812
 98 np=12165 qsp=0 rpq=12143 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=22
 99 np=12146 qsp=0 rpq=12135 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
100 np=12165 qsp=0 rpq=12155 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
101 np=12161 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
102 np=12173 qsp=0 rpq=12170 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
103 np=12178 qsp=0 rpq=12163 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=15
104 np=12597 qsp=0 rpq=12106 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=491
105 np=12839 qsp=0 rpq=12100 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=739
106 np=12132 qsp=0 rpq=12098 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=34
107 np=12105 qsp=0 rpq=12101 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
108 np=12092 qsp=0 rpq=12089 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
109 np=12095 qsp=0 rpq=12091 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
110 np=12099 qsp=0 rpq=12096 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
111 np=12093 qsp=0 rpq=12091 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=2
112 np=13496 qsp=0 rpq=12849 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=647
113 np=13147 qsp=0 rpq=12321 cbr=0 cng=0 gpc=1 gps=1 nf=1 nn=823
114 np=12554 qsp=0 rpq=12330 cbr=0 cng=0 gpc=1 gps=0 nf=0 nn=223
115 np=12351 qsp=0 rpq=12325 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=26
116 np=12326 qsp=0 rpq=12315 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
117 np=12325 qsp=0 rpq=12322 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
118 np=12116 qsp=0 rpq=12113 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
119 np=12113 qsp=0 rpq=12112 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
120 np=12742 qsp=0 rpq=12201 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=541
121 np=19383 qsp=0 rpq=18247 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=1132
122 np=12391 qsp=0 rpq=12201 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=190
123 np=12195 qsp=0 rpq=12192 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
124 np=12003 qsp=0 rpq=12000 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
125 np=12127 qsp=0 rpq=12124 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
126 np=12014 qsp=0 rpq=11983 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=31
127 np=12072 qsp=0 rpq=12069 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
/sys/kernel/debug/rcu/rcutorture:
cat: /sys/kernel/debug/rcu/rcutorture: No such file or directory
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
no /sys/kernel/debug/rcu/rcuboost

Wed May 11 14:33:58 UTC 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=4217  gpnum=4218
rcu_bh: completed=-278  gpnum=18446744073709551338
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=4217 g=4218 s=2 jfq=1 j=a9d7 nfqs=6853/nfqsng=0(6853) fqlh=738
ff/ff ..>.. 0:254 ^0    
ffff/ffff ..>.. 0:15 ^0    ffff/ffff ..>.. 16:31 ^1    ffff/ffff ..>.. 32:47 ^2    fcfc/ffff ..>.. 48:63 ^3    ffff/ffff ..>.. 64:79 ^4    ffff/ffff ..>.. 80:95 ^5    ffff/ffff ..>.. 96:111 ^6    ffff/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    
rcu_bh:
c=18446744073709551338 g=18446744073709551338 s=0 jfq=-5462 j=a9d7 nfqs=26/nfqsng=0(26) fqlh=2
0/ff ..>.. 0:254 ^0    
0/ffff ..>.. 0:15 ^0    0/ffff ..>.. 16:31 ^1    0/ffff ..>.. 32:47 ^2    0/ffff ..>.. 48:63 ^3    0/ffff ..>.. 64:79 ^4    0/ffff ..>.. 80:95 ^5    0/ffff ..>.. 96:111 ^6    0/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=4217 g=4218 pq=1 pqc=4217 qp=0 dt=6377/73 dn=4 df=2610 of=0 ri=601 ql=2 b=10 ci=6137 co=0 ca=0
  1 c=4217 g=4218 pq=1 pqc=4217 qp=0 dt=12539/1 dn=0 df=2761 of=0 ri=13 ql=9 b=10 ci=11255 co=0 ca=0
  2 c=4182 g=4182 pq=1 pqc=4181 qp=0 dt=11202/0 dn=2 df=3378 of=0 ri=149 ql=0 b=10 ci=2170 co=0 ca=0
  3 c=4190 g=4191 pq=1 pqc=4190 qp=1 dt=1716/0 dn=0 df=3622 of=0 ri=6 ql=0 b=10 ci=123 co=0 ca=0
  4 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1580/0 dn=2 df=3632 of=0 ri=1 ql=0 b=10 ci=50 co=0 ca=0
  5 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1634/0 dn=0 df=3649 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  6 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1632/0 dn=2 df=3649 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  7 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1680/0 dn=2 df=3649 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  8 c=4217 g=4218 pq=1 pqc=4217 qp=1 dt=9281/1 dn=2 df=2418 of=0 ri=760 ql=2 b=10 ci=7225 co=0 ca=0
  9 c=4217 g=4218 pq=1 pqc=4217 qp=1 dt=3181/1 dn=0 df=2729 of=0 ri=1 ql=9 b=10 ci=13650 co=0 ca=0
 10 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=2054/0 dn=0 df=3496 of=0 ri=1 ql=0 b=10 ci=702 co=0 ca=0
 11 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1802/0 dn=2 df=3642 of=0 ri=1 ql=0 b=10 ci=25 co=0 ca=0
 12 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1844/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 13 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=3972/0 dn=2 df=3650 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 14 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1746/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 15 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1674/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 16 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=18828/0 dn=0 df=2779 of=0 ri=103 ql=0 b=10 ci=3539 co=0 ca=0
 17 c=4217 g=4218 pq=1 pqc=4217 qp=1 dt=1311/1 dn=0 df=2777 of=0 ri=1 ql=3 b=10 ci=11712 co=0 ca=0
 18 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1712/0 dn=0 df=3496 of=0 ri=1 ql=0 b=10 ci=665 co=0 ca=0
 19 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=2078/0 dn=0 df=3620 of=0 ri=1 ql=0 b=10 ci=121 co=0 ca=0
 20 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=3688/0 dn=0 df=3648 of=0 ri=1 ql=0 b=10 ci=24 co=0 ca=0
 21 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1810/0 dn=2 df=3650 of=0 ri=1 ql=0 b=10 ci=21 co=0 ca=0
 22 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1752/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 23 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1762/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 24 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=14418/0 dn=0 df=2910 of=0 ri=1 ql=0 b=10 ci=3348 co=0 ca=0
 25 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1630/0 dn=0 df=2740 of=0 ri=1 ql=0 b=10 ci=22440 co=0 ca=0
 26 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1824/0 dn=2 df=3477 of=0 ri=1 ql=0 b=10 ci=1047 co=0 ca=0
 27 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1608/0 dn=2 df=3623 of=0 ri=1 ql=0 b=10 ci=157 co=0 ca=0
 28 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1616/0 dn=0 df=3621 of=0 ri=1 ql=0 b=10 ci=92 co=0 ca=0
 29 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1572/0 dn=2 df=3646 of=0 ri=1 ql=0 b=10 ci=14 co=0 ca=0
 30 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=1672/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 31 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=1696/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 32 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=5680/0 dn=0 df=2801 of=0 ri=97 ql=0 b=10 ci=3220 co=0 ca=0
 33 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=1408/0 dn=0 df=2757 of=0 ri=1 ql=0 b=10 ci=21106 co=0 ca=0
 34 c=4196 g=4197 pq=1 pqc=4196 qp=1 dt=1812/0 dn=0 df=3524 of=0 ri=1 ql=0 b=10 ci=550 co=0 ca=0
 35 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1682/0 dn=2 df=3629 of=0 ri=1 ql=0 b=10 ci=111 co=0 ca=0
 36 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1694/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 37 c=4148 g=4148 pq=1 pqc=4147 qp=0 dt=1680/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 38 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1634/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 39 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1700/0 dn=2 df=3650 of=0 ri=1 ql=0 b=10 ci=18 co=0 ca=0
 40 c=4208 g=4209 pq=1 pqc=4208 qp=1 dt=1918/0 dn=0 df=3004 of=0 ri=1 ql=0 b=10 ci=10285 co=0 ca=0
 41 c=4210 g=4211 pq=1 pqc=4210 qp=1 dt=1656/0 dn=0 df=2864 of=0 ri=1 ql=0 b=10 ci=19494 co=0 ca=0
 42 c=4204 g=4205 pq=1 pqc=4204 qp=1 dt=1788/0 dn=0 df=3553 of=0 ri=1 ql=0 b=10 ci=188 co=0 ca=0
 43 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1718/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 44 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1666/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 45 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=2060/0 dn=0 df=3652 of=0 ri=1 ql=0 b=10 ci=12 co=0 ca=0
 46 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1710/0 dn=2 df=3651 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 47 c=4150 g=4150 pq=1 pqc=4149 qp=0 dt=1730/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 48 c=4217 g=4218 pq=1 pqc=4217 qp=0 dt=35267/1 dn=2 df=2672 of=0 ri=161 ql=2 b=10 ci=20305 co=0 ca=0
 49 c=4217 g=4218 pq=1 pqc=4217 qp=0 dt=1551/1 dn=0 df=2895 of=0 ri=15 ql=7 b=10 ci=28449 co=0 ca=0
 50 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1940/0 dn=0 df=3513 of=0 ri=1 ql=0 b=10 ci=537 co=0 ca=0
 51 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=2000/0 dn=0 df=3616 of=0 ri=1 ql=0 b=10 ci=102 co=0 ca=0
 52 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1864/0 dn=2 df=3636 of=0 ri=1 ql=0 b=10 ci=57 co=0 ca=0
 53 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1660/0 dn=0 df=3648 of=0 ri=1 ql=0 b=10 ci=15 co=0 ca=0
 54 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1614/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 55 c=4152 g=4152 pq=1 pqc=4151 qp=0 dt=1692/0 dn=2 df=3651 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 56 c=4217 g=4218 pq=1 pqc=4217 qp=0 dt=1663/1 dn=2 df=2939 of=0 ri=1 ql=2 b=10 ci=2645 co=0 ca=0
 57 c=4217 g=4218 pq=1 pqc=4217 qp=0 dt=1297/1 dn=0 df=2828 of=0 ri=1 ql=11 b=10 ci=11764 co=0 ca=0
 58 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=2088/0 dn=0 df=3514 of=0 ri=1 ql=0 b=10 ci=650 co=0 ca=0
 59 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=2020/0 dn=2 df=3643 of=0 ri=1 ql=0 b=10 ci=40 co=0 ca=0
 60 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=1718/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 61 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=1610/0 dn=2 df=3651 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 62 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=1706/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 63 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=6180/0 dn=0 df=3466 of=0 ri=30 ql=0 b=10 ci=150 co=0 ca=0
 64 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=8396/0 dn=2 df=3232 of=0 ri=274 ql=0 b=10 ci=1436 co=0 ca=0
 65 c=4217 g=4218 pq=1 pqc=4217 qp=1 dt=2912/0 dn=0 df=3128 of=0 ri=6 ql=0 b=10 ci=5781 co=0 ca=0
 66 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=3994/0 dn=0 df=3601 of=0 ri=6 ql=0 b=10 ci=131 co=0 ca=0
 67 c=4154 g=4154 pq=1 pqc=4153 qp=0 dt=1678/0 dn=0 df=3645 of=0 ri=1 ql=0 b=10 ci=26 co=0 ca=0
 68 c=4155 g=4156 pq=1 pqc=4155 qp=0 dt=1634/0 dn=0 df=3649 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 69 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1688/0 dn=2 df=3649 of=0 ri=6 ql=0 b=10 ci=11 co=0 ca=0
 70 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1692/0 dn=2 df=3650 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
 71 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1624/0 dn=2 df=3650 of=0 ri=1 ql=0 b=10 ci=12 co=0 ca=0
 72 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=6178/0 dn=4 df=3440 of=0 ri=112 ql=0 b=10 ci=493 co=0 ca=0
 73 c=4217 g=4218 pq=1 pqc=4217 qp=1 dt=7498/0 dn=0 df=2919 of=0 ri=3 ql=0 b=10 ci=72254 co=0 ca=0
 74 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1726/0 dn=2 df=3622 of=0 ri=1 ql=0 b=10 ci=125 co=0 ca=0
 75 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1716/0 dn=2 df=3649 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 76 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1714/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 77 c=4156 g=4156 pq=1 pqc=4155 qp=0 dt=1678/0 dn=0 df=3649 of=0 ri=1 ql=0 b=10 ci=111 co=0 ca=0
 78 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1730/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 79 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1656/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 80 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=2190/0 dn=2 df=3383 of=0 ri=1 ql=0 b=10 ci=590 co=0 ca=0
 81 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=3668/0 dn=0 df=3182 of=0 ri=1 ql=0 b=10 ci=5193 co=0 ca=0
 82 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1662/0 dn=2 df=3623 of=0 ri=1 ql=0 b=10 ci=106 co=0 ca=0
 83 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1708/0 dn=2 df=3646 of=0 ri=1 ql=0 b=10 ci=22 co=0 ca=0
 84 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1638/0 dn=2 df=3651 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 85 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1652/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 86 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1680/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 87 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1688/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 88 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1888/0 dn=0 df=3401 of=0 ri=1 ql=0 b=10 ci=884 co=0 ca=0
 89 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=2830/0 dn=0 df=3282 of=0 ri=1 ql=0 b=10 ci=2572 co=0 ca=0
 90 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1578/0 dn=0 df=3606 of=0 ri=1 ql=0 b=10 ci=154 co=0 ca=0
 91 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1788/0 dn=2 df=3645 of=0 ri=1 ql=0 b=10 ci=20 co=0 ca=0
 92 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1758/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 93 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1742/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 94 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1748/0 dn=2 df=3654 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 95 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1628/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 96 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1742/0 dn=2 df=3424 of=0 ri=1 ql=0 b=10 ci=493 co=0 ca=0
 97 c=4164 g=4165 pq=1 pqc=4164 qp=1 dt=2676/0 dn=0 df=3330 of=0 ri=1 ql=0 b=10 ci=1015 co=0 ca=0
 98 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1744/0 dn=2 df=3644 of=0 ri=1 ql=0 b=10 ci=27 co=0 ca=0
 99 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1676/0 dn=2 df=3651 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
100 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1764/0 dn=2 df=3650 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
101 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1724/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
102 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1726/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
103 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1708/0 dn=2 df=3649 of=0 ri=1 ql=0 b=10 ci=1923 co=0 ca=0
104 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1726/0 dn=2 df=3458 of=0 ri=1 ql=0 b=10 ci=387 co=0 ca=0
105 c=4164 g=4165 pq=1 pqc=4164 qp=1 dt=2748/0 dn=0 df=3359 of=0 ri=1 ql=0 b=10 ci=20365 co=0 ca=0
106 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1850/0 dn=2 df=3641 of=0 ri=1 ql=0 b=10 ci=50 co=0 ca=0
107 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1740/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
108 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1686/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
109 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1698/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
110 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1734/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
111 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1662/0 dn=2 df=3651 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
112 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=7844/0 dn=0 df=3377 of=0 ri=36 ql=0 b=10 ci=613 co=0 ca=0
113 c=4202 g=4203 pq=1 pqc=4202 qp=1 dt=2416/0 dn=0 df=3329 of=0 ri=1 ql=0 b=10 ci=5505 co=0 ca=0
114 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1686/0 dn=0 df=3570 of=0 ri=1 ql=0 b=10 ci=497 co=0 ca=0
115 c=4171 g=4171 pq=1 pqc=4170 qp=0 dt=1604/0 dn=2 df=3641 of=0 ri=1 ql=0 b=10 ci=38 co=0 ca=0
116 c=4171 g=4171 pq=1 pqc=4170 qp=0 dt=1776/0 dn=2 df=3648 of=0 ri=1 ql=0 b=10 ci=34 co=0 ca=0
117 c=4171 g=4171 pq=1 pqc=4170 qp=0 dt=1638/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=10 co=0 ca=0
118 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=1680/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
119 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=2724/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
120 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=2276/0 dn=0 df=3449 of=0 ri=1 ql=0 b=10 ci=393 co=0 ca=0
121 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=3026/0 dn=0 df=2057 of=0 ri=1 ql=0 b=10 ci=48877 co=0 ca=0
122 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=1592/0 dn=0 df=3579 of=0 ri=1 ql=0 b=10 ci=333 co=0 ca=0
123 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=1668/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
124 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=1724/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
125 c=4180 g=4180 pq=1 pqc=4179 qp=0 dt=1688/0 dn=2 df=3652 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
126 c=4180 g=4180 pq=1 pqc=4179 qp=0 dt=2504/0 dn=2 df=3647 of=0 ri=1 ql=0 b=10 ci=21 co=0 ca=0
127 c=4180 g=4180 pq=1 pqc=4179 qp=0 dt=1758/0 dn=2 df=3653 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
rcu_bh:
  0 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=6377/73 dn=4 df=9 of=0 ri=0 ql=0 b=10 ci=8 co=0 ca=0
  1 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=12539/1 dn=0 df=15 of=0 ri=0 ql=0 b=10 ci=4 co=0 ca=0
  2 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=11202/0 dn=2 df=17 of=0 ri=0 ql=0 b=10 ci=11 co=0 ca=0
  3 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1716/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  4 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1580/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  5 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1634/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  6 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1632/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  7 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1680/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  8 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=9281/1 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  9 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3181/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 10 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2054/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 11 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1802/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 12 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1844/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 13 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3972/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 14 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1746/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 15 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1674/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 16 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=18828/0 dn=0 df=17 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 17 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1311/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=8 co=0 ca=0
 18 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1712/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 19 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2078/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 20 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3688/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 21 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1810/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 22 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1752/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 23 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1762/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 24 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=14418/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 25 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1630/0 dn=0 df=19 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 26 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1824/0 dn=2 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 27 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1608/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 28 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1616/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 29 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1572/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 30 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1672/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 31 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1696/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 32 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=5680/0 dn=0 df=16 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 33 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1408/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 34 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1812/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 35 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1682/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 36 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1694/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 37 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1680/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 38 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1634/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 39 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1700/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 40 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1918/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 41 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1656/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 42 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1788/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 43 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1718/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 44 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1666/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 45 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2060/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 46 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1710/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 47 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1730/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 48 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=35267/2 dn=2 df=16 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 49 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1551/2 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 50 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1940/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 51 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2000/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 52 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1864/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 53 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1660/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 54 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1614/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 55 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1692/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 56 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1663/1 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 57 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1297/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 58 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2088/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 59 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2020/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 60 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1718/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 61 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1610/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 62 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1706/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 63 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=6180/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 64 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=8396/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 65 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2912/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 66 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=3994/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 67 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1678/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 68 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1634/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 69 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1688/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 70 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1692/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 71 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1624/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 72 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=6178/0 dn=4 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 73 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=7498/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 74 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1726/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 75 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1716/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 76 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1714/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 77 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1678/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 78 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1730/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 79 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1656/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 80 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2190/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 81 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=3668/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 82 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1662/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 83 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1708/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 84 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1638/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 85 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1652/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 86 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1680/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 87 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1688/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 88 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1888/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 89 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2830/0 dn=0 df=19 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 90 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1578/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 91 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1788/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 92 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1758/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 93 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1742/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 94 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1748/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 95 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1628/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 96 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1742/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 97 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=2676/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 98 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1744/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 99 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1676/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
100 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1764/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
101 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1724/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
102 c=18446744073709551332 g=18446744073709551332 pq=1 pqc=18446744073709551331 qp=0 dt=1726/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
103 c=18446744073709551332 g=18446744073709551332 pq=1 pqc=18446744073709551331 qp=0 dt=1708/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
104 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1726/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
105 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=2748/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
106 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1850/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
107 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1740/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
108 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1686/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
109 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1698/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
110 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1734/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
111 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1662/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
112 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=7844/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
113 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2416/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
114 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1686/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
115 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1604/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
116 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1776/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
117 c=18446744073709551335 g=18446744073709551336 pq=1 pqc=18446744073709551335 qp=1 dt=1638/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
118 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1680/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
119 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2724/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
120 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2276/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
121 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3026/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
122 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1592/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
123 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1668/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
124 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1724/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
125 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1688/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
126 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2504/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
127 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1758/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=25023 qsp=1521 rpq=6044 cbr=1 cng=1255 gpc=1142 gps=133 nf=695 nn=15753
  1 np=26683 qsp=60 rpq=8032 cbr=5 cng=45 gpc=1628 gps=749 nf=441 nn=15783
  2 np=23557 qsp=164 rpq=6864 cbr=0 cng=28 gpc=1102 gps=715 nf=180 nn=14668
  3 np=21601 qsp=29 rpq=6997 cbr=0 cng=5 gpc=910 gps=708 nf=96 nn=12885
  4 np=21509 qsp=9 rpq=6943 cbr=0 cng=5 gpc=984 gps=729 nf=100 nn=12748
  5 np=21377 qsp=28 rpq=6885 cbr=0 cng=2 gpc=876 gps=683 nf=109 nn=12822
  6 np=21339 qsp=30 rpq=6845 cbr=0 cng=2 gpc=875 gps=689 nf=104 nn=12824
  7 np=21299 qsp=32 rpq=6806 cbr=0 cng=2 gpc=982 gps=700 nf=107 nn=12702
  8 np=30347 qsp=840 rpq=8110 cbr=1 cng=46 gpc=1670 gps=781 nf=590 nn=19149
  9 np=25433 qsp=32 rpq=7693 cbr=1 cng=22 gpc=1752 gps=783 nf=177 nn=15005
 10 np=21236 qsp=7 rpq=6852 cbr=0 cng=8 gpc=1270 gps=806 nf=15 nn=12285
 11 np=20410 qsp=9 rpq=6630 cbr=0 cng=1 gpc=1064 gps=807 nf=5 nn=11903
 12 np=20308 qsp=9 rpq=6574 cbr=0 cng=1 gpc=857 gps=755 nf=2 nn=12119
 13 np=20874 qsp=9 rpq=6543 cbr=0 cng=1 gpc=917 gps=736 nf=4 nn=12673
 14 np=20214 qsp=7 rpq=6482 cbr=0 cng=0 gpc=776 gps=758 nf=2 nn=12196
 15 np=20177 qsp=9 rpq=6443 cbr=0 cng=0 gpc=871 gps=757 nf=3 nn=12103
 16 np=28829 qsp=173 rpq=7583 cbr=0 cng=28 gpc=1745 gps=754 nf=262 nn=18457
 17 np=25146 qsp=26 rpq=7261 cbr=1 cng=12 gpc=1717 gps=699 nf=205 nn=15251
 18 np=20876 qsp=9 rpq=6484 cbr=0 cng=4 gpc=1028 gps=681 nf=26 nn=12653
 19 np=20174 qsp=11 rpq=6309 cbr=0 cng=1 gpc=896 gps=692 nf=8 nn=12268
 20 np=19992 qsp=7 rpq=6224 cbr=0 cng=0 gpc=877 gps=671 nf=5 nn=12215
 21 np=19929 qsp=9 rpq=6173 cbr=0 cng=0 gpc=870 gps=697 nf=5 nn=12184
 22 np=19877 qsp=7 rpq=6122 cbr=0 cng=0 gpc=876 gps=696 nf=1 nn=12182
 23 np=19830 qsp=7 rpq=6077 cbr=0 cng=0 gpc=874 gps=696 nf=2 nn=12181
 24 np=23873 qsp=19 rpq=6847 cbr=0 cng=18 gpc=1554 gps=685 nf=168 nn=14601
 25 np=24970 qsp=103 rpq=6912 cbr=16 cng=15 gpc=1701 gps=698 nf=262 nn=15366
 26 np=20576 qsp=15 rpq=6151 cbr=0 cng=2 gpc=1047 gps=692 nf=14 nn=12670
 27 np=19785 qsp=10 rpq=5927 cbr=0 cng=1 gpc=907 gps=691 nf=13 nn=12246
 28 np=19763 qsp=7 rpq=5886 cbr=0 cng=1 gpc=906 gps=677 nf=9 nn=12284
 29 np=19580 qsp=7 rpq=5813 cbr=0 cng=1 gpc=887 gps=685 nf=8 nn=12186
 30 np=19505 qsp=6 rpq=5760 cbr=0 cng=1 gpc=874 gps=717 nf=2 nn=12151
 31 np=19464 qsp=8 rpq=5714 cbr=0 cng=1 gpc=874 gps=700 nf=1 nn=12174
 32 np=24658 qsp=164 rpq=6636 cbr=0 cng=17 gpc=1719 gps=741 nf=131 nn=15414
 33 np=23772 qsp=42 rpq=6526 cbr=8 cng=7 gpc=1717 gps=733 nf=120 nn=14661
 34 np=19929 qsp=8 rpq=5731 cbr=0 cng=4 gpc=996 gps=729 nf=14 nn=12455
 35 np=19379 qsp=9 rpq=5558 cbr=0 cng=0 gpc=890 gps=727 nf=9 nn=12195
 36 np=19222 qsp=8 rpq=5488 cbr=0 cng=0 gpc=876 gps=716 nf=6 nn=12136
 37 np=19177 qsp=8 rpq=5442 cbr=0 cng=0 gpc=870 gps=721 nf=2 nn=12142
 38 np=19131 qsp=7 rpq=5399 cbr=0 cng=0 gpc=874 gps=722 nf=4 nn=12132
 39 np=19099 qsp=9 rpq=5357 cbr=0 cng=0 gpc=874 gps=720 nf=5 nn=12143
 40 np=22208 qsp=29 rpq=6027 cbr=1 cng=7 gpc=1470 gps=784 nf=89 nn=13830
 41 np=22867 qsp=70 rpq=6061 cbr=14 cng=18 gpc=1674 gps=663 nf=96 nn=14341
 42 np=19441 qsp=8 rpq=5352 cbr=0 cng=0 gpc=1004 gps=793 nf=4 nn=12288
 43 np=18930 qsp=8 rpq=5179 cbr=0 cng=0 gpc=951 gps=797 nf=5 nn=11998
 44 np=18884 qsp=7 rpq=5135 cbr=0 cng=0 gpc=1207 gps=767 nf=1 nn=11774
 45 np=18844 qsp=8 rpq=5092 cbr=0 cng=0 gpc=1199 gps=737 nf=3 nn=11813
 46 np=18799 qsp=7 rpq=5044 cbr=0 cng=0 gpc=1315 gps=801 nf=3 nn=11636
 47 np=18746 qsp=8 rpq=4998 cbr=0 cng=0 gpc=1050 gps=653 nf=3 nn=12042
 48 np=25120 qsp=297 rpq=6169 cbr=3 cng=15 gpc=1693 gps=740 nf=503 nn=15997
 49 np=22872 qsp=68 rpq=5700 cbr=3 cng=12 gpc=1606 gps=695 nf=116 nn=14740
 50 np=19790 qsp=9 rpq=5021 cbr=0 cng=0 gpc=1017 gps=686 nf=96 nn=12970
 51 np=19209 qsp=8 rpq=4858 cbr=0 cng=0 gpc=910 gps=679 nf=63 nn=12699
 52 np=19011 qsp=8 rpq=4788 cbr=0 cng=0 gpc=889 gps=680 nf=48 nn=12606
 53 np=19120 qsp=7 rpq=4730 cbr=0 cng=0 gpc=874 gps=682 nf=60 nn=12774
 54 np=18397 qsp=8 rpq=4682 cbr=0 cng=0 gpc=869 gps=682 nf=9 nn=12155
 55 np=18350 qsp=9 rpq=4635 cbr=0 cng=0 gpc=871 gps=678 nf=5 nn=12161
 56 np=21845 qsp=11 rpq=5386 cbr=0 cng=10 gpc=1578 gps=701 nf=91 nn=14079
 57 np=22346 qsp=27 rpq=5403 cbr=2 cng=11 gpc=1828 gps=707 nf=98 nn=14297
 58 np=18955 qsp=10 rpq=4658 cbr=0 cng=1 gpc=1217 gps=712 nf=21 nn=12346
 59 np=18242 qsp=8 rpq=4469 cbr=0 cng=0 gpc=907 gps=706 nf=4 nn=12156
 60 np=18162 qsp=8 rpq=4412 cbr=0 cng=0 gpc=1030 gps=741 nf=6 nn=11973
 61 np=18117 qsp=8 rpq=4369 cbr=0 cng=0 gpc=950 gps=688 nf=4 nn=12106
 62 np=18075 qsp=7 rpq=4330 cbr=0 cng=0 gpc=872 gps=662 nf=7 nn=12204
 63 np=19194 qsp=44 rpq=4585 cbr=0 cng=0 gpc=1027 gps=671 nf=133 nn=12778
 64 np=22024 qsp=234 rpq=4773 cbr=0 cng=10 gpc=1344 gps=684 nf=67 nn=15146
 65 np=20693 qsp=33 rpq=4833 cbr=0 cng=9 gpc=1403 gps=686 nf=192 nn=13570
 66 np=18466 qsp=32 rpq=4222 cbr=0 cng=4 gpc=923 gps=636 nf=28 nn=12653
 67 np=18101 qsp=8 rpq=4119 cbr=0 cng=3 gpc=1149 gps=633 nf=25 nn=12172
 68 np=18042 qsp=8 rpq=4072 cbr=0 cng=3 gpc=882 gps=666 nf=23 nn=12396
 69 np=17993 qsp=30 rpq=4025 cbr=0 cng=2 gpc=919 gps=683 nf=29 nn=12335
 70 np=17951 qsp=32 rpq=3979 cbr=0 cng=3 gpc=878 gps=676 nf=21 nn=12394
 71 np=17901 qsp=8 rpq=3935 cbr=0 cng=3 gpc=931 gps=733 nf=33 nn=12266
 72 np=20530 qsp=129 rpq=4144 cbr=0 cng=1 gpc=1106 gps=628 nf=28 nn=14623
 73 np=25530 qsp=10 rpq=4627 cbr=1 cng=311 gpc=1244 gps=606 nf=1401 nn=17340
 74 np=17670 qsp=7 rpq=3829 cbr=0 cng=3 gpc=900 gps=775 nf=7 nn=12156
 75 np=17494 qsp=8 rpq=3753 cbr=0 cng=1 gpc=878 gps=770 nf=4 nn=12088
 76 np=17429 qsp=8 rpq=3703 cbr=0 cng=0 gpc=872 gps=766 nf=3 nn=12085
 77 np=17399 qsp=8 rpq=3660 cbr=0 cng=1 gpc=878 gps=772 nf=3 nn=12085
 78 np=17334 qsp=7 rpq=3608 cbr=0 cng=1 gpc=873 gps=764 nf=1 nn=12087
 79 np=17288 qsp=9 rpq=3563 cbr=0 cng=1 gpc=871 gps=758 nf=2 nn=12093
 80 np=19879 qsp=9 rpq=3836 cbr=0 cng=13 gpc=1129 gps=700 nf=116 nn=14085
 81 np=21160 qsp=7 rpq=4050 cbr=0 cng=62 gpc=1317 gps=704 nf=315 nn=14712
 82 np=18105 qsp=7 rpq=3461 cbr=0 cng=0 gpc=907 gps=699 nf=150 nn=12888
 83 np=17157 qsp=9 rpq=3391 cbr=0 cng=0 gpc=886 gps=740 nf=5 nn=12135
 84 np=17085 qsp=8 rpq=3336 cbr=0 cng=0 gpc=880 gps=756 nf=7 nn=12106
 85 np=17039 qsp=9 rpq=3293 cbr=0 cng=0 gpc=875 gps=749 nf=5 nn=12117
 86 np=16993 qsp=7 rpq=3248 cbr=0 cng=0 gpc=877 gps=747 nf=3 nn=12118
 87 np=16948 qsp=8 rpq=3201 cbr=0 cng=0 gpc=879 gps=749 nf=4 nn=12115
 88 np=18331 qsp=20 rpq=3450 cbr=0 cng=3 gpc=1147 gps=718 nf=38 nn=12975
 89 np=19383 qsp=12 rpq=3582 cbr=0 cng=3 gpc=1286 gps=715 nf=165 nn=13632
 90 np=17241 qsp=9 rpq=3121 cbr=0 cng=2 gpc=928 gps=710 nf=38 nn=12442
 91 np=16803 qsp=8 rpq=3031 cbr=0 cng=1 gpc=895 gps=698 nf=2 nn=12176
 92 np=16724 qsp=9 rpq=2976 cbr=0 cng=0 gpc=878 gps=695 nf=8 nn=12167
 93 np=16678 qsp=8 rpq=2932 cbr=0 cng=1 gpc=884 gps=694 nf=3 nn=12164
 94 np=16624 qsp=8 rpq=2886 cbr=0 cng=1 gpc=875 gps=698 nf=1 nn=12163
 95 np=16586 qsp=7 rpq=2842 cbr=0 cng=0 gpc=878 gps=687 nf=3 nn=12176
 96 np=17817 qsp=8 rpq=3050 cbr=0 cng=3 gpc=1114 gps=710 nf=24 nn=12916
 97 np=19239 qsp=8 rpq=3182 cbr=0 cng=3 gpc=1223 gps=714 nf=127 nn=13990
 98 np=16473 qsp=9 rpq=2713 cbr=0 cng=0 gpc=882 gps=710 nf=3 nn=12165
 99 np=16407 qsp=8 rpq=2663 cbr=0 cng=0 gpc=875 gps=719 nf=4 nn=12146
100 np=16350 qsp=8 rpq=2609 cbr=0 cng=0 gpc=876 gps=699 nf=1 nn=12165
101 np=16293 qsp=8 rpq=2562 cbr=0 cng=1 gpc=874 gps=692 nf=3 nn=12161
102 np=16251 qsp=8 rpq=2518 cbr=0 cng=0 gpc=877 gps=683 nf=0 nn=12173
103 np=16225 qsp=11 rpq=2475 cbr=0 cng=0 gpc=877 gps=689 nf=6 nn=12178
104 np=17119 qsp=9 rpq=2651 cbr=0 cng=1 gpc=1089 gps=768 nf=13 nn=12597
105 np=17595 qsp=67 rpq=2711 cbr=2 cng=3 gpc=1140 gps=771 nf=129 nn=12839
106 np=16158 qsp=9 rpq=2364 cbr=0 cng=0 gpc=887 gps=770 nf=5 nn=12132
107 np=16048 qsp=8 rpq=2296 cbr=0 cng=0 gpc=875 gps=770 nf=2 nn=12105
108 np=16006 qsp=7 rpq=2252 cbr=0 cng=0 gpc=881 gps=774 nf=7 nn=12092
109 np=15958 qsp=8 rpq=2206 cbr=0 cng=0 gpc=881 gps=773 nf=3 nn=12095
110 np=15911 qsp=7 rpq=2160 cbr=0 cng=0 gpc=881 gps=767 nf=4 nn=12099
111 np=15866 qsp=7 rpq=2117 cbr=0 cng=0 gpc=881 gps=772 nf=3 nn=12093
112 np=17863 qsp=27 rpq=2417 cbr=0 cng=4 gpc=1163 gps=701 nf=82 nn=13496
113 np=17614 qsp=12 rpq=2430 cbr=1 cng=2 gpc=1215 gps=722 nf=97 nn=13147
114 np=16333 qsp=8 rpq=2072 cbr=0 cng=0 gpc=957 gps=725 nf=25 nn=12554
115 np=15914 qsp=7 rpq=1947 cbr=0 cng=0 gpc=891 gps=711 nf=14 nn=12351
116 np=15840 qsp=8 rpq=1894 cbr=0 cng=0 gpc=881 gps=724 nf=15 nn=12326
117 np=15776 qsp=8 rpq=1845 cbr=0 cng=1 gpc=879 gps=721 nf=5 nn=12325
118 np=15514 qsp=7 rpq=1798 cbr=0 cng=0 gpc=881 gps=717 nf=2 nn=12116
119 np=15472 qsp=8 rpq=1755 cbr=0 cng=0 gpc=881 gps=720 nf=3 nn=12113
120 np=16459 qsp=9 rpq=1943 cbr=0 cng=0 gpc=1103 gps=662 nf=9 nn=12742
121 np=27488 qsp=10 rpq=3390 cbr=1 cng=127 gpc=1561 gps=706 nf=2320 nn=19383
122 np=15730 qsp=7 rpq=1699 cbr=0 cng=2 gpc=954 gps=668 nf=16 nn=12391
123 np=15325 qsp=8 rpq=1577 cbr=0 cng=0 gpc=885 gps=663 nf=5 nn=12195
124 np=15281 qsp=7 rpq=1531 cbr=0 cng=0 gpc=1044 gps=698 nf=5 nn=12003
125 np=15229 qsp=8 rpq=1488 cbr=0 cng=0 gpc=926 gps=686 nf=2 nn=12127
126 np=15224 qsp=9 rpq=1446 cbr=0 cng=0 gpc=1035 gps=724 nf=5 nn=12014
127 np=15143 qsp=8 rpq=1395 cbr=0 cng=0 gpc=1004 gps=669 nf=3 nn=12072
rcu_bh:
  0 np=15753 qsp=0 rpq=12266 cbr=0 cng=6 gpc=3 gps=2 nf=7 nn=3469
  1 np=15783 qsp=0 rpq=12789 cbr=0 cng=1 gpc=4 gps=1 nf=2 nn=2986
  2 np=14668 qsp=0 rpq=13505 cbr=0 cng=1 gpc=1 gps=0 nf=2 nn=1159
  3 np=12885 qsp=0 rpq=12815 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=70
  4 np=12748 qsp=0 rpq=12698 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=50
  5 np=12822 qsp=0 rpq=12818 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  6 np=12824 qsp=0 rpq=12820 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  7 np=12702 qsp=0 rpq=12698 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  8 np=19149 qsp=0 rpq=16647 cbr=0 cng=0 gpc=6 gps=2 nf=0 nn=2494
  9 np=15005 qsp=0 rpq=12483 cbr=0 cng=0 gpc=3 gps=2 nf=0 nn=2517
 10 np=12285 qsp=0 rpq=11814 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=471
 11 np=11903 qsp=0 rpq=11873 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=30
 12 np=12119 qsp=0 rpq=12115 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 13 np=12673 qsp=0 rpq=12123 cbr=0 cng=0 gpc=3 gps=0 nf=0 nn=547
 14 np=12196 qsp=0 rpq=12192 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 15 np=12103 qsp=0 rpq=12099 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 16 np=18457 qsp=0 rpq=15177 cbr=0 cng=0 gpc=6 gps=1 nf=2 nn=3271
 17 np=15251 qsp=0 rpq=12820 cbr=0 cng=2 gpc=2 gps=1 nf=0 nn=2426
 18 np=12653 qsp=0 rpq=12195 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=458
 19 np=12268 qsp=0 rpq=12184 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=84
 20 np=12215 qsp=0 rpq=12198 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=17
 21 np=12184 qsp=0 rpq=12176 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=8
 22 np=12182 qsp=0 rpq=12178 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 23 np=12181 qsp=0 rpq=12177 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 24 np=14601 qsp=0 rpq=12655 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=1943
 25 np=15366 qsp=0 rpq=12848 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=2516
 26 np=12670 qsp=0 rpq=12180 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=488
 27 np=12246 qsp=0 rpq=12167 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=79
 28 np=12284 qsp=0 rpq=12185 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 29 np=12186 qsp=0 rpq=12166 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=20
 30 np=12151 qsp=0 rpq=12147 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 31 np=12174 qsp=0 rpq=12170 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 32 np=15414 qsp=0 rpq=13091 cbr=0 cng=1 gpc=5 gps=1 nf=0 nn=2316
 33 np=14661 qsp=0 rpq=12140 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=2518
 34 np=12455 qsp=0 rpq=12120 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=335
 35 np=12195 qsp=0 rpq=12133 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=62
 36 np=12136 qsp=0 rpq=12132 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 37 np=12142 qsp=0 rpq=12138 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 38 np=12132 qsp=0 rpq=12128 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 39 np=12143 qsp=0 rpq=12132 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
 40 np=13830 qsp=0 rpq=12093 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=1735
 41 np=14341 qsp=0 rpq=12126 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=2211
 42 np=12288 qsp=0 rpq=12042 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=246
 43 np=11998 qsp=0 rpq=11995 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 44 np=11774 qsp=0 rpq=11770 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 45 np=11813 qsp=0 rpq=11807 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=6
 46 np=11636 qsp=0 rpq=11633 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 47 np=12042 qsp=0 rpq=12039 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 48 np=15997 qsp=0 rpq=13693 cbr=0 cng=1 gpc=3 gps=2 nf=0 nn=2298
 49 np=14740 qsp=0 rpq=12614 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=2123
 50 np=12970 qsp=0 rpq=12601 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=369
 51 np=12699 qsp=0 rpq=12614 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=85
 52 np=12606 qsp=0 rpq=12563 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=43
 53 np=12774 qsp=0 rpq=12764 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
 54 np=12155 qsp=0 rpq=12152 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 55 np=12161 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 56 np=14079 qsp=0 rpq=12179 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=1898
 57 np=14297 qsp=0 rpq=12025 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=2268
 58 np=12346 qsp=0 rpq=11955 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=389
 59 np=12156 qsp=0 rpq=12134 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=22
 60 np=11973 qsp=0 rpq=11970 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 61 np=12106 qsp=0 rpq=12102 cbr=0 cng=0 gpc=1 gps=0 nf=0 nn=3
 62 np=12204 qsp=0 rpq=12200 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 63 np=12778 qsp=0 rpq=12651 cbr=0 cng=0 gpc=3 gps=0 nf=0 nn=124
 64 np=15146 qsp=0 rpq=14190 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=956
 65 np=13570 qsp=0 rpq=12478 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=1088
 66 np=12653 qsp=0 rpq=12470 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=183
 67 np=12172 qsp=0 rpq=12163 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=9
 68 np=12396 qsp=0 rpq=12392 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 69 np=12335 qsp=0 rpq=12334 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
 70 np=12394 qsp=0 rpq=12390 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 71 np=12266 qsp=0 rpq=12262 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 72 np=14623 qsp=0 rpq=14140 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=483
 73 np=17340 qsp=0 rpq=16476 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=861
 74 np=12156 qsp=0 rpq=12077 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=79
 75 np=12088 qsp=0 rpq=12078 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
 76 np=12085 qsp=0 rpq=12083 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=2
 77 np=12085 qsp=0 rpq=12073 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=12
 78 np=12087 qsp=0 rpq=12084 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 79 np=12093 qsp=0 rpq=12090 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 80 np=14085 qsp=0 rpq=12836 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1249
 81 np=14712 qsp=0 rpq=13675 cbr=0 cng=0 gpc=3 gps=1 nf=0 nn=1033
 82 np=12888 qsp=0 rpq=12827 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=61
 83 np=12135 qsp=0 rpq=12122 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=13
 84 np=12106 qsp=0 rpq=12103 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 85 np=12117 qsp=0 rpq=12114 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 86 np=12118 qsp=0 rpq=12115 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 87 np=12115 qsp=0 rpq=12111 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 88 np=12975 qsp=0 rpq=12333 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=642
 89 np=13632 qsp=0 rpq=12832 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=797
 90 np=12442 qsp=0 rpq=12343 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 91 np=12176 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=16
 92 np=12167 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=9
 93 np=12164 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 94 np=12163 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 95 np=12176 qsp=0 rpq=12172 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 96 np=12916 qsp=0 rpq=12333 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=583
 97 np=13990 qsp=0 rpq=13175 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=812
 98 np=12165 qsp=0 rpq=12143 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=22
 99 np=12146 qsp=0 rpq=12135 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
100 np=12165 qsp=0 rpq=12155 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
101 np=12161 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
102 np=12173 qsp=0 rpq=12170 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
103 np=12178 qsp=0 rpq=12163 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=15
104 np=12597 qsp=0 rpq=12106 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=491
105 np=12839 qsp=0 rpq=12100 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=739
106 np=12132 qsp=0 rpq=12098 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=34
107 np=12105 qsp=0 rpq=12101 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
108 np=12092 qsp=0 rpq=12089 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
109 np=12095 qsp=0 rpq=12091 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
110 np=12099 qsp=0 rpq=12096 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
111 np=12093 qsp=0 rpq=12091 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=2
112 np=13496 qsp=0 rpq=12849 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=647
113 np=13147 qsp=0 rpq=12321 cbr=0 cng=0 gpc=1 gps=1 nf=1 nn=823
114 np=12554 qsp=0 rpq=12330 cbr=0 cng=0 gpc=1 gps=0 nf=0 nn=223
115 np=12351 qsp=0 rpq=12325 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=26
116 np=12326 qsp=0 rpq=12315 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
117 np=12325 qsp=0 rpq=12322 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
118 np=12116 qsp=0 rpq=12113 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
119 np=12113 qsp=0 rpq=12112 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
120 np=12742 qsp=0 rpq=12201 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=541
121 np=19383 qsp=0 rpq=18247 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=1132
122 np=12391 qsp=0 rpq=12201 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=190
123 np=12195 qsp=0 rpq=12192 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
124 np=12003 qsp=0 rpq=12000 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
125 np=12127 qsp=0 rpq=12124 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
126 np=12014 qsp=0 rpq=11983 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=31
127 np=12072 qsp=0 rpq=12069 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
/sys/kernel/debug/rcu/rcutorture:
cat: /sys/kernel/debug/rcu/rcutorture: No such file or directory
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
no /sys/kernel/debug/rcu/rcuboost

Wed May 11 14:34:21 UTC 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=4303  gpnum=4304
rcu_bh: completed=-278  gpnum=18446744073709551338
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=4303 g=4304 s=2 jfq=2 j=c086 nfqs=6951/nfqsng=0(6951) fqlh=739
ff/ff ..>.. 0:254 ^0    
ffff/ffff ..>.. 0:15 ^0    ffff/ffff ..>.. 16:31 ^1    ffff/ffff ..>.. 32:47 ^2    ffff/ffff ..>.. 48:63 ^3    ffff/ffff ..>.. 64:79 ^4    ffff/ffff ..>.. 80:95 ^5    ffff/ffff ..>.. 96:111 ^6    ffff/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    
rcu_bh:
c=18446744073709551338 g=18446744073709551338 s=0 jfq=-11269 j=c086 nfqs=26/nfqsng=0(26) fqlh=2
0/ff ..>.. 0:254 ^0    
0/ffff ..>.. 0:15 ^0    0/ffff ..>.. 16:31 ^1    0/ffff ..>.. 32:47 ^2    0/ffff ..>.. 48:63 ^3    0/ffff ..>.. 64:79 ^4    0/ffff ..>.. 80:95 ^5    0/ffff ..>.. 96:111 ^6    0/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=4303 g=4304 pq=1 pqc=4303 qp=0 dt=6809/73 dn=4 df=2679 of=0 ri=601 ql=2 b=10 ci=6159 co=0 ca=0
  1 c=4303 g=4304 pq=1 pqc=4303 qp=0 dt=12597/1 dn=0 df=2827 of=0 ri=13 ql=18 b=10 ci=11282 co=0 ca=0
  2 c=4182 g=4182 pq=1 pqc=4181 qp=0 dt=11214/0 dn=2 df=3464 of=0 ri=149 ql=0 b=10 ci=2170 co=0 ca=0
  3 c=4190 g=4191 pq=1 pqc=4190 qp=1 dt=1728/0 dn=0 df=3708 of=0 ri=6 ql=0 b=10 ci=123 co=0 ca=0
  4 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1600/0 dn=2 df=3718 of=0 ri=1 ql=0 b=10 ci=50 co=0 ca=0
  5 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1646/0 dn=0 df=3735 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  6 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1668/0 dn=2 df=3735 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  7 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1712/0 dn=2 df=3735 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  8 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=9384/0 dn=2 df=2496 of=0 ri=760 ql=0 b=10 ci=7231 co=0 ca=0
  9 c=4303 g=4304 pq=0 pqc=4239 qp=1 dt=3201/1 dn=0 df=2801 of=0 ri=1 ql=3 b=10 ci=13678 co=0 ca=0
 10 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=2074/0 dn=0 df=3582 of=0 ri=1 ql=0 b=10 ci=702 co=0 ca=0
 11 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1822/0 dn=2 df=3728 of=0 ri=1 ql=0 b=10 ci=25 co=0 ca=0
 12 c=4267 g=4268 pq=1 pqc=4267 qp=1 dt=1874/0 dn=2 df=3732 of=0 ri=1 ql=0 b=10 ci=27 co=0 ca=0
 13 c=4291 g=4292 pq=1 pqc=4291 qp=1 dt=4206/0 dn=2 df=3734 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 14 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1760/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 15 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1710/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 16 c=4301 g=4302 pq=1 pqc=4301 qp=1 dt=19402/0 dn=0 df=2862 of=0 ri=103 ql=0 b=10 ci=3541 co=0 ca=0
 17 c=4267 g=4268 pq=1 pqc=4267 qp=1 dt=1336/0 dn=0 df=2849 of=0 ri=1 ql=0 b=10 ci=11747 co=0 ca=0
 18 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1748/0 dn=0 df=3582 of=0 ri=1 ql=0 b=10 ci=665 co=0 ca=0
 19 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=2102/0 dn=0 df=3706 of=0 ri=1 ql=0 b=10 ci=121 co=0 ca=0
 20 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=3712/0 dn=0 df=3734 of=0 ri=1 ql=0 b=10 ci=24 co=0 ca=0
 21 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1834/0 dn=2 df=3736 of=0 ri=1 ql=0 b=10 ci=21 co=0 ca=0
 22 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1768/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 23 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1786/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 24 c=4245 g=4246 pq=1 pqc=4245 qp=1 dt=14498/0 dn=0 df=2990 of=0 ri=1 ql=0 b=10 ci=3357 co=0 ca=0
 25 c=4247 g=4248 pq=1 pqc=4247 qp=1 dt=1654/0 dn=0 df=2812 of=0 ri=1 ql=0 b=10 ci=25721 co=0 ca=0
 26 c=4241 g=4242 pq=1 pqc=4241 qp=1 dt=1848/0 dn=2 df=3561 of=0 ri=1 ql=0 b=10 ci=1059 co=0 ca=0
 27 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1644/0 dn=2 df=3709 of=0 ri=1 ql=0 b=10 ci=157 co=0 ca=0
 28 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1652/0 dn=0 df=3707 of=0 ri=1 ql=0 b=10 ci=92 co=0 ca=0
 29 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1584/0 dn=2 df=3732 of=0 ri=1 ql=0 b=10 ci=14 co=0 ca=0
 30 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=1698/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 31 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=1732/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 32 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=5810/0 dn=0 df=2881 of=0 ri=97 ql=0 b=10 ci=3229 co=0 ca=0
 33 c=4253 g=4254 pq=1 pqc=4253 qp=1 dt=1436/0 dn=0 df=2828 of=0 ri=1 ql=0 b=10 ci=24390 co=0 ca=0
 34 c=4247 g=4248 pq=1 pqc=4247 qp=1 dt=1842/0 dn=0 df=3608 of=0 ri=1 ql=0 b=10 ci=562 co=0 ca=0
 35 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1712/0 dn=2 df=3715 of=0 ri=1 ql=0 b=10 ci=111 co=0 ca=0
 36 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1736/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 37 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1716/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 38 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1672/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 39 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1742/0 dn=2 df=3736 of=0 ri=1 ql=0 b=10 ci=18 co=0 ca=0
 40 c=4259 g=4260 pq=1 pqc=4259 qp=1 dt=2004/0 dn=0 df=3084 of=0 ri=1 ql=0 b=10 ci=10294 co=0 ca=0
 41 c=4260 g=4261 pq=1 pqc=4260 qp=1 dt=1700/0 dn=0 df=2934 of=0 ri=1 ql=0 b=10 ci=22778 co=0 ca=0
 42 c=4255 g=4256 pq=1 pqc=4255 qp=1 dt=1816/0 dn=0 df=3637 of=0 ri=1 ql=0 b=10 ci=200 co=0 ca=0
 43 c=4226 g=4226 pq=1 pqc=4225 qp=0 dt=1750/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 44 c=4226 g=4226 pq=1 pqc=4225 qp=0 dt=1698/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 45 c=4233 g=4233 pq=1 pqc=4232 qp=0 dt=2092/0 dn=0 df=3738 of=0 ri=1 ql=0 b=10 ci=12 co=0 ca=0
 46 c=4233 g=4233 pq=1 pqc=4232 qp=0 dt=1744/0 dn=2 df=3737 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 47 c=4233 g=4233 pq=1 pqc=4232 qp=0 dt=1766/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 48 c=4303 g=4304 pq=1 pqc=4303 qp=0 dt=35311/1 dn=2 df=2735 of=0 ri=161 ql=2 b=10 ci=20577 co=0 ca=0
 49 c=4303 g=4304 pq=1 pqc=4303 qp=0 dt=1593/1 dn=0 df=2964 of=0 ri=15 ql=7 b=10 ci=28689 co=0 ca=0
 50 c=4268 g=4269 pq=0 pqc=4267 qp=1 dt=1976/0 dn=0 df=3592 of=0 ri=1 ql=0 b=10 ci=722 co=0 ca=0
 51 c=4268 g=4269 pq=0 pqc=4267 qp=1 dt=2034/0 dn=0 df=3695 of=0 ri=1 ql=0 b=10 ci=265 co=0 ca=0
 52 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=1902/0 dn=2 df=3722 of=0 ri=1 ql=0 b=10 ci=57 co=0 ca=0
 53 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=1698/0 dn=0 df=3734 of=0 ri=1 ql=0 b=10 ci=15 co=0 ca=0
 54 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=1644/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 55 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=1722/0 dn=2 df=3737 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 56 c=4303 g=4304 pq=1 pqc=4303 qp=0 dt=1697/1 dn=2 df=3023 of=0 ri=1 ql=4 b=10 ci=2647 co=0 ca=0
 57 c=4303 g=4304 pq=1 pqc=4303 qp=0 dt=1331/1 dn=0 df=2908 of=0 ri=1 ql=11 b=10 ci=11779 co=0 ca=0
 58 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=2122/0 dn=0 df=3600 of=0 ri=1 ql=0 b=10 ci=650 co=0 ca=0
 59 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=2046/0 dn=2 df=3729 of=0 ri=1 ql=0 b=10 ci=40 co=0 ca=0
 60 c=4268 g=4269 pq=1 pqc=4268 qp=0 dt=1764/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 61 c=4273 g=4274 pq=1 pqc=4273 qp=1 dt=1632/0 dn=2 df=3737 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 62 c=4281 g=4281 pq=1 pqc=4280 qp=0 dt=1736/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 63 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=6340/0 dn=0 df=3552 of=0 ri=30 ql=0 b=10 ci=150 co=0 ca=0
 64 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=8448/0 dn=2 df=3318 of=0 ri=274 ql=0 b=10 ci=1436 co=0 ca=0
 65 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=2942/0 dn=0 df=3214 of=0 ri=6 ql=0 b=10 ci=5781 co=0 ca=0
 66 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=4036/0 dn=0 df=3687 of=0 ri=6 ql=0 b=10 ci=131 co=0 ca=0
 67 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=1738/0 dn=0 df=3731 of=0 ri=1 ql=0 b=10 ci=26 co=0 ca=0
 68 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=1660/0 dn=0 df=3735 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 69 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=1718/0 dn=2 df=3735 of=0 ri=6 ql=0 b=10 ci=11 co=0 ca=0
 70 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1734/0 dn=2 df=3736 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
 71 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1666/0 dn=2 df=3730 of=0 ri=1 ql=0 b=10 ci=32 co=0 ca=0
 72 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=6224/0 dn=4 df=3526 of=0 ri=112 ql=0 b=10 ci=493 co=0 ca=0
 73 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=7544/0 dn=0 df=2999 of=0 ri=3 ql=0 b=10 ci=72272 co=0 ca=0
 74 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1764/0 dn=2 df=3708 of=0 ri=1 ql=0 b=10 ci=125 co=0 ca=0
 75 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1754/0 dn=2 df=3735 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 76 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1756/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 77 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1700/0 dn=0 df=3735 of=0 ri=1 ql=0 b=10 ci=111 co=0 ca=0
 78 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1756/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 79 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1698/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 80 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=2230/0 dn=2 df=3469 of=0 ri=1 ql=0 b=10 ci=590 co=0 ca=0
 81 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=3684/0 dn=0 df=3268 of=0 ri=1 ql=0 b=10 ci=5193 co=0 ca=0
 82 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1698/0 dn=2 df=3709 of=0 ri=1 ql=0 b=10 ci=106 co=0 ca=0
 83 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1736/0 dn=2 df=3732 of=0 ri=1 ql=0 b=10 ci=22 co=0 ca=0
 84 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1650/0 dn=2 df=3737 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 85 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1664/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 86 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1708/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 87 c=4158 g=4158 pq=1 pqc=4157 qp=0 dt=1704/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 88 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1908/0 dn=0 df=3487 of=0 ri=1 ql=0 b=10 ci=884 co=0 ca=0
 89 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=2846/0 dn=0 df=3368 of=0 ri=1 ql=0 b=10 ci=2572 co=0 ca=0
 90 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1598/0 dn=0 df=3692 of=0 ri=1 ql=0 b=10 ci=154 co=0 ca=0
 91 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1800/0 dn=2 df=3731 of=0 ri=1 ql=0 b=10 ci=20 co=0 ca=0
 92 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1770/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 93 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1754/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 94 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1784/0 dn=2 df=3740 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 95 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1640/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 96 c=4160 g=4160 pq=1 pqc=4159 qp=0 dt=1758/0 dn=2 df=3510 of=0 ri=1 ql=0 b=10 ci=493 co=0 ca=0
 97 c=4239 g=4240 pq=1 pqc=4239 qp=1 dt=2696/0 dn=0 df=3416 of=0 ri=1 ql=0 b=10 ci=1015 co=0 ca=0
 98 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1756/0 dn=2 df=3730 of=0 ri=1 ql=0 b=10 ci=27 co=0 ca=0
 99 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1712/0 dn=2 df=3737 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
100 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1784/0 dn=2 df=3736 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
101 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1736/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
102 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1748/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
103 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1720/0 dn=2 df=3735 of=0 ri=1 ql=0 b=10 ci=1923 co=0 ca=0
104 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1762/0 dn=2 df=3544 of=0 ri=1 ql=0 b=10 ci=387 co=0 ca=0
105 c=4239 g=4240 pq=1 pqc=4239 qp=1 dt=2768/0 dn=0 df=3445 of=0 ri=1 ql=0 b=10 ci=20365 co=0 ca=0
106 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1890/0 dn=2 df=3727 of=0 ri=1 ql=0 b=10 ci=50 co=0 ca=0
107 c=4162 g=4162 pq=1 pqc=4161 qp=0 dt=1752/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
108 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1706/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
109 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1726/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
110 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1746/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
111 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1684/0 dn=2 df=3737 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
112 c=4298 g=4299 pq=1 pqc=4298 qp=1 dt=7876/0 dn=0 df=3441 of=0 ri=36 ql=0 b=10 ci=694 co=0 ca=0
113 c=4202 g=4203 pq=1 pqc=4202 qp=1 dt=2436/0 dn=0 df=3415 of=0 ri=1 ql=0 b=10 ci=5505 co=0 ca=0
114 c=4164 g=4164 pq=1 pqc=4163 qp=0 dt=1722/0 dn=0 df=3656 of=0 ri=1 ql=0 b=10 ci=497 co=0 ca=0
115 c=4171 g=4171 pq=1 pqc=4170 qp=0 dt=1632/0 dn=2 df=3727 of=0 ri=1 ql=0 b=10 ci=38 co=0 ca=0
116 c=4171 g=4171 pq=1 pqc=4170 qp=0 dt=1792/0 dn=2 df=3734 of=0 ri=1 ql=0 b=10 ci=34 co=0 ca=0
117 c=4171 g=4171 pq=1 pqc=4170 qp=0 dt=1674/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=10 co=0 ca=0
118 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=1716/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
119 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=2752/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
120 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=2312/0 dn=0 df=3535 of=0 ri=1 ql=0 b=10 ci=393 co=0 ca=0
121 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=3044/0 dn=0 df=2143 of=0 ri=1 ql=0 b=10 ci=48877 co=0 ca=0
122 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=1604/0 dn=0 df=3665 of=0 ri=1 ql=0 b=10 ci=333 co=0 ca=0
123 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=1684/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
124 c=4173 g=4173 pq=1 pqc=4172 qp=0 dt=1744/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
125 c=4180 g=4180 pq=1 pqc=4179 qp=0 dt=1708/0 dn=2 df=3738 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
126 c=4180 g=4180 pq=1 pqc=4179 qp=0 dt=2524/0 dn=2 df=3733 of=0 ri=1 ql=0 b=10 ci=21 co=0 ca=0
127 c=4180 g=4180 pq=1 pqc=4179 qp=0 dt=1774/0 dn=2 df=3739 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
rcu_bh:
  0 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=6809/73 dn=4 df=9 of=0 ri=0 ql=0 b=10 ci=8 co=0 ca=0
  1 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=12597/1 dn=0 df=15 of=0 ri=0 ql=0 b=10 ci=4 co=0 ca=0
  2 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=11214/0 dn=2 df=17 of=0 ri=0 ql=0 b=10 ci=11 co=0 ca=0
  3 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1728/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  4 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1600/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  5 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1646/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  6 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1668/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  7 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1712/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  8 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=9384/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  9 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3201/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 10 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2074/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 11 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1822/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 12 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1874/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 13 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=4206/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 14 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1760/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 15 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1710/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 16 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=19402/0 dn=0 df=17 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 17 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1336/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=8 co=0 ca=0
 18 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1748/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 19 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2102/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 20 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3712/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 21 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1834/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 22 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1768/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 23 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1786/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 24 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=14498/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 25 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1654/0 dn=0 df=19 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 26 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1848/0 dn=2 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 27 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1644/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 28 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1652/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 29 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1584/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 30 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1698/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 31 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1732/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 32 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=5810/0 dn=0 df=16 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 33 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1436/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 34 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1842/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 35 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1712/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 36 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1736/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 37 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1716/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 38 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1672/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 39 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1742/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 40 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2004/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 41 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1700/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 42 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1816/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 43 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1750/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 44 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1698/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 45 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2092/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 46 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1744/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 47 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1766/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 48 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=35311/1 dn=2 df=16 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 49 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1593/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 50 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1976/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 51 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2034/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 52 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1902/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 53 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1698/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 54 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1644/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 55 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1722/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 56 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1697/1 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 57 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1331/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 58 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2122/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 59 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2046/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 60 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1764/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 61 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1632/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 62 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1736/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 63 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=6340/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 64 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=8448/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 65 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2942/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 66 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=4036/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 67 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1738/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 68 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1660/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 69 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1718/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 70 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1734/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 71 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1666/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 72 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=6224/0 dn=4 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 73 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=7544/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 74 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1764/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 75 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1754/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 76 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1756/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 77 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1700/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 78 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1756/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 79 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1698/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 80 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2230/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 81 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=3684/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 82 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1698/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 83 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1736/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 84 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1650/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 85 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1664/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 86 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1708/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 87 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1704/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 88 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1908/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 89 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=2846/0 dn=0 df=19 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 90 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1598/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 91 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1800/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 92 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1770/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 93 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1754/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 94 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1784/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 95 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1640/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 96 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1758/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 97 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2696/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 98 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1756/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 99 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1712/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
100 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1784/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
101 c=18446744073709551330 g=18446744073709551330 pq=1 pqc=18446744073709551329 qp=0 dt=1736/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
102 c=18446744073709551332 g=18446744073709551332 pq=1 pqc=18446744073709551331 qp=0 dt=1748/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
103 c=18446744073709551332 g=18446744073709551332 pq=1 pqc=18446744073709551331 qp=0 dt=1720/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
104 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1762/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
105 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2768/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
106 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1890/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
107 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1752/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
108 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1706/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
109 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1726/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
110 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1746/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
111 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1684/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
112 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=7876/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
113 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2436/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
114 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1722/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
115 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1632/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
116 c=18446744073709551334 g=18446744073709551334 pq=1 pqc=18446744073709551333 qp=0 dt=1792/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
117 c=18446744073709551335 g=18446744073709551336 pq=1 pqc=18446744073709551335 qp=1 dt=1674/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
118 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1716/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
119 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2752/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
120 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2312/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
121 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3044/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
122 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1604/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
123 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1684/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
124 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1744/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
125 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1708/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
126 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2524/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
127 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1774/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=25285 qsp=1521 rpq=6066 cbr=1 cng=1256 gpc=1169 gps=134 nf=695 nn=15964
  1 np=26771 qsp=60 rpq=8060 cbr=5 cng=45 gpc=1638 gps=749 nf=452 nn=15822
  2 np=23557 qsp=164 rpq=6864 cbr=0 cng=28 gpc=1102 gps=715 nf=180 nn=14668
  3 np=21601 qsp=29 rpq=6997 cbr=0 cng=5 gpc=910 gps=708 nf=96 nn=12885
  4 np=21509 qsp=9 rpq=6943 cbr=0 cng=5 gpc=984 gps=729 nf=100 nn=12748
  5 np=21377 qsp=28 rpq=6885 cbr=0 cng=2 gpc=876 gps=683 nf=109 nn=12822
  6 np=21339 qsp=30 rpq=6845 cbr=0 cng=2 gpc=875 gps=689 nf=104 nn=12824
  7 np=21299 qsp=32 rpq=6806 cbr=0 cng=2 gpc=982 gps=700 nf=107 nn=12702
  8 np=30373 qsp=840 rpq=8114 cbr=1 cng=46 gpc=1676 gps=782 nf=590 nn=19164
  9 np=25478 qsp=32 rpq=7706 cbr=1 cng=22 gpc=1757 gps=783 nf=183 nn=15026
 10 np=21236 qsp=7 rpq=6852 cbr=0 cng=8 gpc=1270 gps=806 nf=15 nn=12285
 11 np=20410 qsp=9 rpq=6630 cbr=0 cng=1 gpc=1064 gps=807 nf=5 nn=11903
 12 np=20332 qsp=9 rpq=6580 cbr=0 cng=2 gpc=858 gps=755 nf=7 nn=12130
 13 np=20911 qsp=9 rpq=6547 cbr=0 cng=1 gpc=924 gps=736 nf=4 nn=12699
 14 np=20214 qsp=7 rpq=6482 cbr=0 cng=0 gpc=776 gps=758 nf=2 nn=12196
 15 np=20177 qsp=9 rpq=6443 cbr=0 cng=0 gpc=871 gps=757 nf=3 nn=12103
 16 np=28931 qsp=173 rpq=7597 cbr=0 cng=29 gpc=1751 gps=758 nf=262 nn=18534
 17 np=25198 qsp=26 rpq=7275 cbr=1 cng=15 gpc=1726 gps=699 nf=205 nn=15277
 18 np=20876 qsp=9 rpq=6484 cbr=0 cng=4 gpc=1028 gps=681 nf=26 nn=12653
 19 np=20174 qsp=11 rpq=6309 cbr=0 cng=1 gpc=896 gps=692 nf=8 nn=12268
 20 np=19992 qsp=7 rpq=6224 cbr=0 cng=0 gpc=877 gps=671 nf=5 nn=12215
 21 np=19929 qsp=9 rpq=6173 cbr=0 cng=0 gpc=870 gps=697 nf=5 nn=12184
 22 np=19877 qsp=7 rpq=6122 cbr=0 cng=0 gpc=876 gps=696 nf=1 nn=12182
 23 np=19830 qsp=7 rpq=6077 cbr=0 cng=0 gpc=874 gps=696 nf=2 nn=12181
 24 np=23902 qsp=19 rpq=6853 cbr=0 cng=18 gpc=1560 gps=685 nf=169 nn=14617
 25 np=25038 qsp=108 rpq=6919 cbr=18 cng=16 gpc=1713 gps=698 nf=263 nn=15411
 26 np=20585 qsp=15 rpq=6153 cbr=0 cng=2 gpc=1050 gps=692 nf=14 nn=12674
 27 np=19785 qsp=10 rpq=5927 cbr=0 cng=1 gpc=907 gps=691 nf=13 nn=12246
 28 np=19763 qsp=7 rpq=5886 cbr=0 cng=1 gpc=906 gps=677 nf=9 nn=12284
 29 np=19580 qsp=7 rpq=5813 cbr=0 cng=1 gpc=887 gps=685 nf=8 nn=12186
 30 np=19505 qsp=6 rpq=5760 cbr=0 cng=1 gpc=874 gps=717 nf=2 nn=12151
 31 np=19464 qsp=8 rpq=5714 cbr=0 cng=1 gpc=874 gps=700 nf=1 nn=12174
 32 np=24711 qsp=164 rpq=6649 cbr=0 cng=18 gpc=1730 gps=741 nf=136 nn=15437
 33 np=23840 qsp=47 rpq=6535 cbr=12 cng=7 gpc=1729 gps=733 nf=121 nn=14703
 34 np=19935 qsp=8 rpq=5733 cbr=0 cng=4 gpc=998 gps=729 nf=14 nn=12457
 35 np=19379 qsp=9 rpq=5558 cbr=0 cng=0 gpc=890 gps=727 nf=9 nn=12195
 36 np=19222 qsp=8 rpq=5488 cbr=0 cng=0 gpc=876 gps=716 nf=6 nn=12136
 37 np=19177 qsp=8 rpq=5442 cbr=0 cng=0 gpc=870 gps=721 nf=2 nn=12142
 38 np=19131 qsp=7 rpq=5399 cbr=0 cng=0 gpc=874 gps=722 nf=4 nn=12132
 39 np=19099 qsp=9 rpq=5357 cbr=0 cng=0 gpc=874 gps=720 nf=5 nn=12143
 40 np=22232 qsp=29 rpq=6033 cbr=1 cng=7 gpc=1471 gps=784 nf=95 nn=13841
 41 np=22933 qsp=77 rpq=6072 cbr=18 cng=22 gpc=1680 gps=664 nf=99 nn=14378
 42 np=19449 qsp=8 rpq=5354 cbr=0 cng=0 gpc=1007 gps=793 nf=4 nn=12291
 43 np=18930 qsp=8 rpq=5179 cbr=0 cng=0 gpc=951 gps=797 nf=5 nn=11998
 44 np=18884 qsp=7 rpq=5135 cbr=0 cng=0 gpc=1207 gps=767 nf=1 nn=11774
 45 np=18845 qsp=8 rpq=5092 cbr=0 cng=0 gpc=1200 gps=737 nf=3 nn=11813
 46 np=18800 qsp=7 rpq=5044 cbr=0 cng=0 gpc=1316 gps=801 nf=3 nn=11636
 47 np=18747 qsp=8 rpq=4998 cbr=0 cng=0 gpc=1051 gps=653 nf=3 nn=12042
 48 np=25202 qsp=297 rpq=6190 cbr=3 cng=15 gpc=1702 gps=740 nf=514 nn=16038
 49 np=22939 qsp=68 rpq=5720 cbr=3 cng=12 gpc=1623 gps=695 nf=116 nn=14770
 50 np=19819 qsp=9 rpq=5028 cbr=0 cng=0 gpc=1025 gps=686 nf=96 nn=12984
 51 np=19238 qsp=8 rpq=4864 cbr=0 cng=0 gpc=918 gps=680 nf=63 nn=12713
 52 np=19012 qsp=8 rpq=4788 cbr=0 cng=0 gpc=890 gps=680 nf=48 nn=12606
 53 np=19121 qsp=7 rpq=4730 cbr=0 cng=0 gpc=875 gps=682 nf=60 nn=12774
 54 np=18398 qsp=8 rpq=4682 cbr=0 cng=0 gpc=870 gps=682 nf=9 nn=12155
 55 np=18351 qsp=9 rpq=4635 cbr=0 cng=0 gpc=872 gps=678 nf=5 nn=12161
 56 np=21872 qsp=11 rpq=5393 cbr=0 cng=10 gpc=1585 gps=701 nf=91 nn=14092
 57 np=22373 qsp=27 rpq=5410 cbr=2 cng=11 gpc=1830 gps=707 nf=104 nn=14309
 58 np=18956 qsp=10 rpq=4658 cbr=0 cng=1 gpc=1218 gps=712 nf=21 nn=12346
 59 np=18243 qsp=8 rpq=4469 cbr=0 cng=0 gpc=908 gps=706 nf=4 nn=12156
 60 np=18163 qsp=8 rpq=4412 cbr=0 cng=0 gpc=1031 gps=741 nf=6 nn=11973
 61 np=18118 qsp=8 rpq=4369 cbr=0 cng=0 gpc=951 gps=688 nf=4 nn=12106
 62 np=18076 qsp=7 rpq=4330 cbr=0 cng=0 gpc=873 gps=662 nf=7 nn=12204
 63 np=19218 qsp=44 rpq=4589 cbr=0 cng=0 gpc=1034 gps=671 nf=133 nn=12791
 64 np=22026 qsp=234 rpq=4773 cbr=0 cng=11 gpc=1345 gps=684 nf=67 nn=15146
 65 np=20694 qsp=33 rpq=4834 cbr=0 cng=9 gpc=1403 gps=686 nf=192 nn=13570
 66 np=18467 qsp=32 rpq=4222 cbr=0 cng=4 gpc=924 gps=636 nf=28 nn=12653
 67 np=18102 qsp=8 rpq=4119 cbr=0 cng=3 gpc=1150 gps=633 nf=25 nn=12172
 68 np=18043 qsp=8 rpq=4072 cbr=0 cng=3 gpc=883 gps=666 nf=23 nn=12396
 69 np=17994 qsp=30 rpq=4025 cbr=0 cng=2 gpc=920 gps=683 nf=29 nn=12335
 70 np=17952 qsp=32 rpq=3979 cbr=0 cng=3 gpc=879 gps=676 nf=21 nn=12394
 71 np=17926 qsp=8 rpq=3942 cbr=0 cng=3 gpc=938 gps=733 nf=33 nn=12277
 72 np=20531 qsp=129 rpq=4144 cbr=0 cng=1 gpc=1107 gps=628 nf=28 nn=14623
 73 np=25555 qsp=10 rpq=4635 cbr=1 cng=311 gpc=1250 gps=606 nf=1401 nn=17351
 74 np=17671 qsp=7 rpq=3829 cbr=0 cng=3 gpc=901 gps=775 nf=7 nn=12156
 75 np=17495 qsp=8 rpq=3753 cbr=0 cng=1 gpc=879 gps=770 nf=4 nn=12088
 76 np=17430 qsp=8 rpq=3703 cbr=0 cng=0 gpc=873 gps=766 nf=3 nn=12085
 77 np=17400 qsp=8 rpq=3660 cbr=0 cng=1 gpc=879 gps=772 nf=3 nn=12085
 78 np=17335 qsp=7 rpq=3608 cbr=0 cng=1 gpc=874 gps=764 nf=1 nn=12087
 79 np=17289 qsp=9 rpq=3563 cbr=0 cng=1 gpc=872 gps=758 nf=2 nn=12093
 80 np=19880 qsp=9 rpq=3836 cbr=0 cng=13 gpc=1130 gps=700 nf=116 nn=14085
 81 np=21161 qsp=7 rpq=4050 cbr=0 cng=62 gpc=1318 gps=704 nf=315 nn=14712
 82 np=18106 qsp=7 rpq=3461 cbr=0 cng=0 gpc=908 gps=699 nf=150 nn=12888
 83 np=17158 qsp=9 rpq=3391 cbr=0 cng=0 gpc=887 gps=740 nf=5 nn=12135
 84 np=17086 qsp=8 rpq=3336 cbr=0 cng=0 gpc=881 gps=756 nf=7 nn=12106
 85 np=17040 qsp=9 rpq=3293 cbr=0 cng=0 gpc=876 gps=749 nf=5 nn=12117
 86 np=16994 qsp=7 rpq=3248 cbr=0 cng=0 gpc=878 gps=747 nf=3 nn=12118
 87 np=16949 qsp=8 rpq=3201 cbr=0 cng=0 gpc=880 gps=749 nf=4 nn=12115
 88 np=18332 qsp=20 rpq=3450 cbr=0 cng=3 gpc=1148 gps=718 nf=38 nn=12975
 89 np=19384 qsp=12 rpq=3582 cbr=0 cng=3 gpc=1287 gps=715 nf=165 nn=13632
 90 np=17242 qsp=9 rpq=3121 cbr=0 cng=2 gpc=929 gps=710 nf=38 nn=12442
 91 np=16804 qsp=8 rpq=3031 cbr=0 cng=1 gpc=896 gps=698 nf=2 nn=12176
 92 np=16724 qsp=9 rpq=2976 cbr=0 cng=0 gpc=878 gps=695 nf=8 nn=12167
 93 np=16678 qsp=8 rpq=2932 cbr=0 cng=1 gpc=884 gps=694 nf=3 nn=12164
 94 np=16624 qsp=8 rpq=2886 cbr=0 cng=1 gpc=875 gps=698 nf=1 nn=12163
 95 np=16586 qsp=7 rpq=2842 cbr=0 cng=0 gpc=878 gps=687 nf=3 nn=12176
 96 np=17817 qsp=8 rpq=3050 cbr=0 cng=3 gpc=1114 gps=710 nf=24 nn=12916
 97 np=19240 qsp=8 rpq=3183 cbr=0 cng=3 gpc=1223 gps=714 nf=127 nn=13990
 98 np=16473 qsp=9 rpq=2713 cbr=0 cng=0 gpc=882 gps=710 nf=3 nn=12165
 99 np=16407 qsp=8 rpq=2663 cbr=0 cng=0 gpc=875 gps=719 nf=4 nn=12146
100 np=16350 qsp=8 rpq=2609 cbr=0 cng=0 gpc=876 gps=699 nf=1 nn=12165
101 np=16293 qsp=8 rpq=2562 cbr=0 cng=1 gpc=874 gps=692 nf=3 nn=12161
102 np=16251 qsp=8 rpq=2518 cbr=0 cng=0 gpc=877 gps=683 nf=0 nn=12173
103 np=16225 qsp=11 rpq=2475 cbr=0 cng=0 gpc=877 gps=689 nf=6 nn=12178
104 np=17119 qsp=9 rpq=2651 cbr=0 cng=1 gpc=1089 gps=768 nf=13 nn=12597
105 np=17596 qsp=67 rpq=2712 cbr=2 cng=3 gpc=1140 gps=771 nf=129 nn=12839
106 np=16158 qsp=9 rpq=2364 cbr=0 cng=0 gpc=887 gps=770 nf=5 nn=12132
107 np=16048 qsp=8 rpq=2296 cbr=0 cng=0 gpc=875 gps=770 nf=2 nn=12105
108 np=16006 qsp=7 rpq=2252 cbr=0 cng=0 gpc=881 gps=774 nf=7 nn=12092
109 np=15958 qsp=8 rpq=2206 cbr=0 cng=0 gpc=881 gps=773 nf=3 nn=12095
110 np=15911 qsp=7 rpq=2160 cbr=0 cng=0 gpc=881 gps=767 nf=4 nn=12099
111 np=15866 qsp=7 rpq=2117 cbr=0 cng=0 gpc=881 gps=772 nf=3 nn=12093
112 np=17959 qsp=27 rpq=2442 cbr=0 cng=4 gpc=1170 gps=701 nf=97 nn=13545
113 np=17614 qsp=12 rpq=2430 cbr=1 cng=2 gpc=1215 gps=722 nf=97 nn=13147
114 np=16333 qsp=8 rpq=2072 cbr=0 cng=0 gpc=957 gps=725 nf=25 nn=12554
115 np=15914 qsp=7 rpq=1947 cbr=0 cng=0 gpc=891 gps=711 nf=14 nn=12351
116 np=15840 qsp=8 rpq=1894 cbr=0 cng=0 gpc=881 gps=724 nf=15 nn=12326
117 np=15776 qsp=8 rpq=1845 cbr=0 cng=1 gpc=879 gps=721 nf=5 nn=12325
118 np=15514 qsp=7 rpq=1798 cbr=0 cng=0 gpc=881 gps=717 nf=2 nn=12116
119 np=15472 qsp=8 rpq=1755 cbr=0 cng=0 gpc=881 gps=720 nf=3 nn=12113
120 np=16459 qsp=9 rpq=1943 cbr=0 cng=0 gpc=1103 gps=662 nf=9 nn=12742
121 np=27488 qsp=10 rpq=3390 cbr=1 cng=127 gpc=1561 gps=706 nf=2320 nn=19383
122 np=15730 qsp=7 rpq=1699 cbr=0 cng=2 gpc=954 gps=668 nf=16 nn=12391
123 np=15325 qsp=8 rpq=1577 cbr=0 cng=0 gpc=885 gps=663 nf=5 nn=12195
124 np=15281 qsp=7 rpq=1531 cbr=0 cng=0 gpc=1044 gps=698 nf=5 nn=12003
125 np=15229 qsp=8 rpq=1488 cbr=0 cng=0 gpc=926 gps=686 nf=2 nn=12127
126 np=15224 qsp=9 rpq=1446 cbr=0 cng=0 gpc=1035 gps=724 nf=5 nn=12014
127 np=15143 qsp=8 rpq=1395 cbr=0 cng=0 gpc=1004 gps=669 nf=3 nn=12072
rcu_bh:
  0 np=15964 qsp=0 rpq=12266 cbr=0 cng=6 gpc=3 gps=2 nf=7 nn=3680
  1 np=15822 qsp=0 rpq=12789 cbr=0 cng=1 gpc=4 gps=1 nf=2 nn=3025
  2 np=14668 qsp=0 rpq=13505 cbr=0 cng=1 gpc=1 gps=0 nf=2 nn=1159
  3 np=12885 qsp=0 rpq=12815 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=70
  4 np=12748 qsp=0 rpq=12698 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=50
  5 np=12822 qsp=0 rpq=12818 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  6 np=12824 qsp=0 rpq=12820 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  7 np=12702 qsp=0 rpq=12698 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  8 np=19164 qsp=0 rpq=16647 cbr=0 cng=0 gpc=6 gps=2 nf=0 nn=2509
  9 np=15026 qsp=0 rpq=12483 cbr=0 cng=0 gpc=3 gps=2 nf=0 nn=2538
 10 np=12285 qsp=0 rpq=11814 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=471
 11 np=11903 qsp=0 rpq=11873 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=30
 12 np=12130 qsp=0 rpq=12115 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=15
 13 np=12699 qsp=0 rpq=12123 cbr=0 cng=0 gpc=3 gps=0 nf=0 nn=573
 14 np=12196 qsp=0 rpq=12192 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 15 np=12103 qsp=0 rpq=12099 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 16 np=18534 qsp=0 rpq=15177 cbr=0 cng=0 gpc=6 gps=1 nf=2 nn=3348
 17 np=15277 qsp=0 rpq=12820 cbr=0 cng=2 gpc=2 gps=1 nf=0 nn=2452
 18 np=12653 qsp=0 rpq=12195 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=458
 19 np=12268 qsp=0 rpq=12184 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=84
 20 np=12215 qsp=0 rpq=12198 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=17
 21 np=12184 qsp=0 rpq=12176 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=8
 22 np=12182 qsp=0 rpq=12178 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 23 np=12181 qsp=0 rpq=12177 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 24 np=14617 qsp=0 rpq=12655 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=1959
 25 np=15411 qsp=0 rpq=12848 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=2561
 26 np=12674 qsp=0 rpq=12180 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=492
 27 np=12246 qsp=0 rpq=12167 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=79
 28 np=12284 qsp=0 rpq=12185 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 29 np=12186 qsp=0 rpq=12166 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=20
 30 np=12151 qsp=0 rpq=12147 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 31 np=12174 qsp=0 rpq=12170 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 32 np=15437 qsp=0 rpq=13091 cbr=0 cng=1 gpc=5 gps=1 nf=0 nn=2339
 33 np=14703 qsp=0 rpq=12140 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=2560
 34 np=12457 qsp=0 rpq=12120 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=337
 35 np=12195 qsp=0 rpq=12133 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=62
 36 np=12136 qsp=0 rpq=12132 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 37 np=12142 qsp=0 rpq=12138 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 38 np=12132 qsp=0 rpq=12128 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 39 np=12143 qsp=0 rpq=12132 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
 40 np=13841 qsp=0 rpq=12093 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=1746
 41 np=14378 qsp=0 rpq=12126 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=2248
 42 np=12291 qsp=0 rpq=12042 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=249
 43 np=11998 qsp=0 rpq=11995 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 44 np=11774 qsp=0 rpq=11770 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 45 np=11813 qsp=0 rpq=11807 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=6
 46 np=11636 qsp=0 rpq=11633 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 47 np=12042 qsp=0 rpq=12039 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 48 np=16038 qsp=0 rpq=13693 cbr=0 cng=1 gpc=3 gps=2 nf=0 nn=2339
 49 np=14770 qsp=0 rpq=12614 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=2153
 50 np=12984 qsp=0 rpq=12601 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=383
 51 np=12713 qsp=0 rpq=12614 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 52 np=12606 qsp=0 rpq=12563 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=43
 53 np=12774 qsp=0 rpq=12764 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
 54 np=12155 qsp=0 rpq=12152 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 55 np=12161 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 56 np=14092 qsp=0 rpq=12179 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=1911
 57 np=14309 qsp=0 rpq=12025 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=2280
 58 np=12346 qsp=0 rpq=11955 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=389
 59 np=12156 qsp=0 rpq=12134 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=22
 60 np=11973 qsp=0 rpq=11970 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 61 np=12106 qsp=0 rpq=12102 cbr=0 cng=0 gpc=1 gps=0 nf=0 nn=3
 62 np=12204 qsp=0 rpq=12200 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 63 np=12791 qsp=0 rpq=12651 cbr=0 cng=0 gpc=3 gps=0 nf=0 nn=137
 64 np=15146 qsp=0 rpq=14190 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=956
 65 np=13570 qsp=0 rpq=12478 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=1088
 66 np=12653 qsp=0 rpq=12470 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=183
 67 np=12172 qsp=0 rpq=12163 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=9
 68 np=12396 qsp=0 rpq=12392 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 69 np=12335 qsp=0 rpq=12334 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
 70 np=12394 qsp=0 rpq=12390 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 71 np=12277 qsp=0 rpq=12262 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=15
 72 np=14623 qsp=0 rpq=14140 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=483
 73 np=17351 qsp=0 rpq=16476 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=872
 74 np=12156 qsp=0 rpq=12077 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=79
 75 np=12088 qsp=0 rpq=12078 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
 76 np=12085 qsp=0 rpq=12083 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=2
 77 np=12085 qsp=0 rpq=12073 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=12
 78 np=12087 qsp=0 rpq=12084 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 79 np=12093 qsp=0 rpq=12090 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 80 np=14085 qsp=0 rpq=12836 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1249
 81 np=14712 qsp=0 rpq=13675 cbr=0 cng=0 gpc=3 gps=1 nf=0 nn=1033
 82 np=12888 qsp=0 rpq=12827 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=61
 83 np=12135 qsp=0 rpq=12122 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=13
 84 np=12106 qsp=0 rpq=12103 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 85 np=12117 qsp=0 rpq=12114 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 86 np=12118 qsp=0 rpq=12115 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 87 np=12115 qsp=0 rpq=12111 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 88 np=12975 qsp=0 rpq=12333 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=642
 89 np=13632 qsp=0 rpq=12832 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=797
 90 np=12442 qsp=0 rpq=12343 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 91 np=12176 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=16
 92 np=12167 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=9
 93 np=12164 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 94 np=12163 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 95 np=12176 qsp=0 rpq=12172 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 96 np=12916 qsp=0 rpq=12333 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=583
 97 np=13990 qsp=0 rpq=13175 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=812
 98 np=12165 qsp=0 rpq=12143 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=22
 99 np=12146 qsp=0 rpq=12135 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
100 np=12165 qsp=0 rpq=12155 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
101 np=12161 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
102 np=12173 qsp=0 rpq=12170 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
103 np=12178 qsp=0 rpq=12163 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=15
104 np=12597 qsp=0 rpq=12106 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=491
105 np=12839 qsp=0 rpq=12100 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=739
106 np=12132 qsp=0 rpq=12098 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=34
107 np=12105 qsp=0 rpq=12101 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
108 np=12092 qsp=0 rpq=12089 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
109 np=12095 qsp=0 rpq=12091 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
110 np=12099 qsp=0 rpq=12096 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
111 np=12093 qsp=0 rpq=12091 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=2
112 np=13545 qsp=0 rpq=12849 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=696
113 np=13147 qsp=0 rpq=12321 cbr=0 cng=0 gpc=1 gps=1 nf=1 nn=823
114 np=12554 qsp=0 rpq=12330 cbr=0 cng=0 gpc=1 gps=0 nf=0 nn=223
115 np=12351 qsp=0 rpq=12325 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=26
116 np=12326 qsp=0 rpq=12315 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
117 np=12325 qsp=0 rpq=12322 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
118 np=12116 qsp=0 rpq=12113 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
119 np=12113 qsp=0 rpq=12112 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
120 np=12742 qsp=0 rpq=12201 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=541
121 np=19383 qsp=0 rpq=18247 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=1132
122 np=12391 qsp=0 rpq=12201 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=190
123 np=12195 qsp=0 rpq=12192 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
124 np=12003 qsp=0 rpq=12000 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
125 np=12127 qsp=0 rpq=12124 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
126 np=12014 qsp=0 rpq=11983 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=31
127 np=12072 qsp=0 rpq=12069 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
/sys/kernel/debug/rcu/rcutorture:
cat: /sys/kernel/debug/rcu/rcutorture: No such file or directory
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
no /sys/kernel/debug/rcu/rcuboost

Wed May 11 14:34:45 UTC 2011
/sys/kernel/debug/rcu/rcugp:
rcu_sched: completed=4365  gpnum=4366
rcu_bh: completed=-278  gpnum=18446744073709551338
/sys/kernel/debug/rcu/rcuhier:
rcu_sched:
c=4365 g=4366 s=2 jfq=2 j=d7dd nfqs=7021/nfqsng=0(7021) fqlh=739
ff/ff ..>.. 0:254 ^0    
ffff/ffff ..>.. 0:15 ^0    ffff/ffff ..>.. 16:31 ^1    ffff/ffff ..>.. 32:47 ^2    fdfe/ffff ..>.. 48:63 ^3    ffff/ffff ..>.. 64:79 ^4    ffff/ffff ..>.. 80:95 ^5    ffff/ffff ..>.. 96:111 ^6    ffff/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    
rcu_bh:
c=18446744073709551338 g=18446744073709551338 s=0 jfq=-17244 j=d7dd nfqs=26/nfqsng=0(26) fqlh=2
0/ff ..>.. 0:254 ^0    
0/ffff ..>.. 0:15 ^0    0/ffff ..>.. 16:31 ^1    0/ffff ..>.. 32:47 ^2    0/ffff ..>.. 48:63 ^3    0/ffff ..>.. 64:79 ^4    0/ffff ..>.. 80:95 ^5    0/ffff ..>.. 96:111 ^6    0/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    
/sys/kernel/debug/rcu/rcudata:
rcu_sched:
  0 c=4365 g=4366 pq=1 pqc=4365 qp=0 dt=7237/73 dn=4 df=2718 of=0 ri=601 ql=4 b=10 ci=6199 co=0 ca=0
  1 c=4365 g=4366 pq=1 pqc=4365 qp=0 dt=12649/1 dn=0 df=2878 of=0 ri=13 ql=9 b=10 ci=11312 co=0 ca=0
  2 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=11246/0 dn=2 df=3526 of=0 ri=149 ql=0 b=10 ci=2170 co=0 ca=0
  3 c=4190 g=4191 pq=1 pqc=4190 qp=1 dt=1740/0 dn=0 df=3770 of=0 ri=6 ql=0 b=10 ci=123 co=0 ca=0
  4 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1612/0 dn=2 df=3780 of=0 ri=1 ql=0 b=10 ci=50 co=0 ca=0
  5 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1658/0 dn=0 df=3797 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  6 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1700/0 dn=2 df=3797 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  7 c=4211 g=4211 pq=1 pqc=4210 qp=0 dt=1728/0 dn=2 df=3797 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
  8 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=9484/0 dn=2 df=2552 of=0 ri=760 ql=0 b=10 ci=7235 co=0 ca=0
  9 c=4365 g=4366 pq=1 pqc=4365 qp=0 dt=3221/1 dn=0 df=2853 of=0 ri=1 ql=12 b=10 ci=13696 co=0 ca=0
 10 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=2086/0 dn=0 df=3644 of=0 ri=1 ql=0 b=10 ci=702 co=0 ca=0
 11 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1834/0 dn=2 df=3790 of=0 ri=1 ql=0 b=10 ci=25 co=0 ca=0
 12 c=4267 g=4268 pq=1 pqc=4267 qp=1 dt=1890/0 dn=2 df=3794 of=0 ri=1 ql=0 b=10 ci=27 co=0 ca=0
 13 c=4291 g=4292 pq=1 pqc=4291 qp=1 dt=4218/0 dn=2 df=3796 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 14 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1772/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 15 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1746/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 16 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=19988/0 dn=0 df=2922 of=0 ri=103 ql=0 b=10 ci=3543 co=0 ca=0
 17 c=4331 g=4332 pq=1 pqc=4331 qp=1 dt=1352/0 dn=0 df=2905 of=0 ri=1 ql=0 b=10 ci=11761 co=0 ca=0
 18 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=1768/0 dn=0 df=3644 of=0 ri=1 ql=0 b=10 ci=665 co=0 ca=0
 19 c=4213 g=4213 pq=1 pqc=4212 qp=0 dt=2114/0 dn=0 df=3768 of=0 ri=1 ql=0 b=10 ci=121 co=0 ca=0
 20 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=3724/0 dn=0 df=3796 of=0 ri=1 ql=0 b=10 ci=24 co=0 ca=0
 21 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1846/0 dn=2 df=3798 of=0 ri=1 ql=0 b=10 ci=21 co=0 ca=0
 22 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1784/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 23 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1798/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 24 c=4337 g=4338 pq=1 pqc=4337 qp=1 dt=14566/0 dn=0 df=3046 of=0 ri=1 ql=0 b=10 ci=3366 co=0 ca=0
 25 c=4339 g=4340 pq=1 pqc=4339 qp=1 dt=1670/0 dn=0 df=2860 of=0 ri=1 ql=0 b=10 ci=28852 co=0 ca=0
 26 c=4333 g=4334 pq=1 pqc=4333 qp=1 dt=1864/0 dn=2 df=3621 of=0 ri=1 ql=0 b=10 ci=1071 co=0 ca=0
 27 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1680/0 dn=2 df=3771 of=0 ri=1 ql=0 b=10 ci=157 co=0 ca=0
 28 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1688/0 dn=0 df=3769 of=0 ri=1 ql=0 b=10 ci=92 co=0 ca=0
 29 c=4215 g=4215 pq=1 pqc=4214 qp=0 dt=1596/0 dn=2 df=3794 of=0 ri=1 ql=0 b=10 ci=14 co=0 ca=0
 30 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=1710/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 31 c=4217 g=4217 pq=1 pqc=4216 qp=0 dt=1764/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 32 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=5938/0 dn=0 df=2932 of=0 ri=97 ql=0 b=10 ci=3256 co=0 ca=0
 33 c=4343 g=4344 pq=1 pqc=4343 qp=1 dt=1456/0 dn=0 df=2876 of=0 ri=1 ql=0 b=10 ci=27522 co=0 ca=0
 34 c=4343 g=4344 pq=1 pqc=4343 qp=1 dt=1858/0 dn=0 df=3664 of=0 ri=1 ql=0 b=10 ci=576 co=0 ca=0
 35 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1724/0 dn=2 df=3777 of=0 ri=1 ql=0 b=10 ci=111 co=0 ca=0
 36 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1772/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 37 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1728/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 38 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1684/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 39 c=4224 g=4224 pq=1 pqc=4223 qp=0 dt=1770/0 dn=2 df=3798 of=0 ri=1 ql=0 b=10 ci=18 co=0 ca=0
 40 c=4350 g=4351 pq=1 pqc=4350 qp=1 dt=2074/0 dn=0 df=3140 of=0 ri=1 ql=0 b=10 ci=10303 co=0 ca=0
 41 c=4352 g=4353 pq=1 pqc=4352 qp=1 dt=1734/0 dn=0 df=2979 of=0 ri=1 ql=0 b=10 ci=25912 co=0 ca=0
 42 c=4346 g=4347 pq=1 pqc=4346 qp=1 dt=1828/0 dn=0 df=3697 of=0 ri=1 ql=0 b=10 ci=212 co=0 ca=0
 43 c=4226 g=4226 pq=1 pqc=4225 qp=0 dt=1786/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 44 c=4226 g=4226 pq=1 pqc=4225 qp=0 dt=1734/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 45 c=4233 g=4233 pq=1 pqc=4232 qp=0 dt=2128/0 dn=0 df=3800 of=0 ri=1 ql=0 b=10 ci=12 co=0 ca=0
 46 c=4233 g=4233 pq=1 pqc=4232 qp=0 dt=1780/0 dn=2 df=3799 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 47 c=4233 g=4233 pq=1 pqc=4232 qp=0 dt=1802/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 48 c=4365 g=4366 pq=1 pqc=4365 qp=0 dt=35327/1 dn=2 df=2796 of=0 ri=161 ql=2 b=10 ci=20579 co=0 ca=0
 49 c=4365 g=4366 pq=1 pqc=4365 qp=0 dt=1619/1 dn=0 df=3017 of=0 ri=15 ql=7 b=10 ci=28706 co=0 ca=0
 50 c=4268 g=4269 pq=1 pqc=4268 qp=1 dt=1992/0 dn=0 df=3654 of=0 ri=1 ql=0 b=10 ci=722 co=0 ca=0
 51 c=4268 g=4269 pq=1 pqc=4268 qp=1 dt=2048/0 dn=0 df=3757 of=0 ri=1 ql=0 b=10 ci=265 co=0 ca=0
 52 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=1938/0 dn=2 df=3784 of=0 ri=1 ql=0 b=10 ci=57 co=0 ca=0
 53 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=1714/0 dn=0 df=3796 of=0 ri=1 ql=0 b=10 ci=15 co=0 ca=0
 54 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=1668/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 55 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=1746/0 dn=2 df=3799 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 56 c=4365 g=4366 pq=1 pqc=4365 qp=0 dt=1713/1 dn=2 df=3079 of=0 ri=1 ql=2 b=10 ci=2655 co=0 ca=0
 57 c=4365 g=4366 pq=1 pqc=4365 qp=0 dt=1347/1 dn=0 df=2964 of=0 ri=1 ql=11 b=10 ci=11792 co=0 ca=0
 58 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=2158/0 dn=0 df=3662 of=0 ri=1 ql=0 b=10 ci=650 co=0 ca=0
 59 c=4261 g=4261 pq=1 pqc=4260 qp=0 dt=2062/0 dn=2 df=3791 of=0 ri=1 ql=0 b=10 ci=40 co=0 ca=0
 60 c=4268 g=4269 pq=1 pqc=4268 qp=0 dt=1800/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 61 c=4273 g=4274 pq=1 pqc=4273 qp=1 dt=1644/0 dn=2 df=3799 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 62 c=4281 g=4281 pq=1 pqc=4280 qp=0 dt=1756/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 63 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=6496/0 dn=0 df=3614 of=0 ri=30 ql=0 b=10 ci=150 co=0 ca=0
 64 c=4327 g=4328 pq=1 pqc=4327 qp=1 dt=8498/0 dn=2 df=3372 of=0 ri=274 ql=0 b=10 ci=1442 co=0 ca=0
 65 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=2958/0 dn=0 df=3276 of=0 ri=6 ql=0 b=10 ci=5781 co=0 ca=0
 66 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=4094/0 dn=0 df=3749 of=0 ri=6 ql=0 b=10 ci=131 co=0 ca=0
 67 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=1756/0 dn=0 df=3793 of=0 ri=1 ql=0 b=10 ci=26 co=0 ca=0
 68 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=1696/0 dn=0 df=3797 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 69 c=4299 g=4299 pq=1 pqc=4298 qp=0 dt=1758/0 dn=2 df=3797 of=0 ri=6 ql=0 b=10 ci=11 co=0 ca=0
 70 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1750/0 dn=2 df=3798 of=0 ri=6 ql=0 b=10 ci=10 co=0 ca=0
 71 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1702/0 dn=2 df=3792 of=0 ri=1 ql=0 b=10 ci=32 co=0 ca=0
 72 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=6248/0 dn=4 df=3588 of=0 ri=112 ql=0 b=10 ci=493 co=0 ca=0
 73 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=7578/0 dn=0 df=3061 of=0 ri=3 ql=0 b=10 ci=72272 co=0 ca=0
 74 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1800/0 dn=2 df=3770 of=0 ri=1 ql=0 b=10 ci=125 co=0 ca=0
 75 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1790/0 dn=2 df=3797 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 76 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1792/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 77 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1736/0 dn=0 df=3797 of=0 ri=1 ql=0 b=10 ci=111 co=0 ca=0
 78 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1778/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 79 c=4301 g=4301 pq=1 pqc=4300 qp=0 dt=1734/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 80 c=4307 g=4308 pq=1 pqc=4307 qp=1 dt=2248/0 dn=2 df=3531 of=0 ri=1 ql=0 b=10 ci=590 co=0 ca=0
 81 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=3718/0 dn=0 df=3330 of=0 ri=1 ql=0 b=10 ci=5193 co=0 ca=0
 82 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=1740/0 dn=2 df=3771 of=0 ri=1 ql=0 b=10 ci=106 co=0 ca=0
 83 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=1778/0 dn=2 df=3794 of=0 ri=1 ql=0 b=10 ci=22 co=0 ca=0
 84 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=1688/0 dn=2 df=3799 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 85 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=1702/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 86 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=1746/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 87 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=1730/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 88 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=1934/0 dn=0 df=3549 of=0 ri=1 ql=0 b=10 ci=884 co=0 ca=0
 89 c=4310 g=4310 pq=1 pqc=4309 qp=0 dt=2872/0 dn=0 df=3430 of=0 ri=1 ql=0 b=10 ci=2572 co=0 ca=0
 90 c=4318 g=4318 pq=1 pqc=4317 qp=0 dt=1620/0 dn=0 df=3754 of=0 ri=1 ql=0 b=10 ci=154 co=0 ca=0
 91 c=4318 g=4318 pq=1 pqc=4317 qp=0 dt=1838/0 dn=2 df=3793 of=0 ri=1 ql=0 b=10 ci=20 co=0 ca=0
 92 c=4325 g=4325 pq=1 pqc=4324 qp=0 dt=1808/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
 93 c=4325 g=4325 pq=1 pqc=4324 qp=0 dt=1788/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 94 c=4325 g=4325 pq=1 pqc=4324 qp=0 dt=1826/0 dn=2 df=3802 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 95 c=4325 g=4325 pq=1 pqc=4324 qp=0 dt=1662/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
 96 c=4325 g=4325 pq=1 pqc=4324 qp=0 dt=1784/0 dn=2 df=3572 of=0 ri=1 ql=0 b=10 ci=493 co=0 ca=0
 97 c=4326 g=4327 pq=1 pqc=4326 qp=1 dt=2726/0 dn=0 df=3478 of=0 ri=1 ql=0 b=10 ci=1015 co=0 ca=0
 98 c=4352 g=4353 pq=1 pqc=4352 qp=0 dt=1786/0 dn=2 df=3792 of=0 ri=1 ql=0 b=10 ci=27 co=0 ca=0
 99 c=4353 g=4353 pq=1 pqc=4352 qp=0 dt=1754/0 dn=2 df=3799 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
100 c=4354 g=4355 pq=1 pqc=4354 qp=0 dt=1818/0 dn=2 df=3798 of=0 ri=1 ql=0 b=10 ci=11 co=0 ca=0
101 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=1770/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
102 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=1782/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
103 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=1750/0 dn=2 df=3797 of=0 ri=1 ql=0 b=10 ci=1923 co=0 ca=0
104 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=1804/0 dn=2 df=3606 of=0 ri=1 ql=0 b=10 ci=387 co=0 ca=0
105 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=2806/0 dn=0 df=3507 of=0 ri=1 ql=0 b=10 ci=20365 co=0 ca=0
106 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=1928/0 dn=2 df=3789 of=0 ri=1 ql=0 b=10 ci=50 co=0 ca=0
107 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=1782/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
108 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=1734/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
109 c=4355 g=4355 pq=1 pqc=4354 qp=0 dt=1756/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
110 c=4356 g=4357 pq=1 pqc=4356 qp=0 dt=1776/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
111 c=4357 g=4357 pq=1 pqc=4356 qp=0 dt=1714/0 dn=2 df=3799 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
112 c=4357 g=4357 pq=1 pqc=4356 qp=0 dt=7918/0 dn=0 df=3503 of=0 ri=36 ql=0 b=10 ci=694 co=0 ca=0
113 c=4357 g=4357 pq=1 pqc=4356 qp=0 dt=2470/0 dn=0 df=3477 of=0 ri=1 ql=0 b=10 ci=5505 co=0 ca=0
114 c=4357 g=4357 pq=1 pqc=4356 qp=0 dt=1764/0 dn=0 df=3718 of=0 ri=1 ql=0 b=10 ci=497 co=0 ca=0
115 c=4357 g=4357 pq=1 pqc=4356 qp=0 dt=1658/0 dn=2 df=3789 of=0 ri=1 ql=0 b=10 ci=38 co=0 ca=0
116 c=4357 g=4357 pq=1 pqc=4356 qp=0 dt=1820/0 dn=2 df=3796 of=0 ri=1 ql=0 b=10 ci=34 co=0 ca=0
117 c=4363 g=4363 pq=1 pqc=4362 qp=0 dt=1712/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=10 co=0 ca=0
118 c=4363 g=4363 pq=1 pqc=4362 qp=0 dt=1758/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
119 c=4363 g=4363 pq=1 pqc=4362 qp=0 dt=2778/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
120 c=4364 g=4365 pq=1 pqc=4364 qp=0 dt=2334/0 dn=0 df=3597 of=0 ri=1 ql=0 b=10 ci=393 co=0 ca=0
121 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=3070/0 dn=0 df=2205 of=0 ri=1 ql=0 b=10 ci=48877 co=0 ca=0
122 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=1626/0 dn=0 df=3727 of=0 ri=1 ql=0 b=10 ci=333 co=0 ca=0
123 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=1706/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
124 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=1766/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
125 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=1730/0 dn=2 df=3800 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
126 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=2546/0 dn=2 df=3795 of=0 ri=1 ql=0 b=10 ci=21 co=0 ca=0
127 c=4365 g=4365 pq=1 pqc=4364 qp=0 dt=1796/0 dn=2 df=3801 of=0 ri=1 ql=0 b=10 ci=9 co=0 ca=0
rcu_bh:
  0 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=7237/73 dn=4 df=9 of=0 ri=0 ql=0 b=10 ci=8 co=0 ca=0
  1 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=12649/1 dn=0 df=15 of=0 ri=0 ql=0 b=10 ci=4 co=0 ca=0
  2 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=11246/0 dn=2 df=17 of=0 ri=0 ql=0 b=10 ci=11 co=0 ca=0
  3 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1740/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  4 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1612/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  5 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1658/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  6 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1700/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  7 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1728/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  8 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=9484/0 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
  9 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3221/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 10 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2086/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 11 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1834/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 12 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1890/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 13 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=4218/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 14 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1772/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 15 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1746/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 16 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=19988/0 dn=0 df=17 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 17 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1352/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=8 co=0 ca=0
 18 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1768/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 19 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2114/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 20 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3724/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 21 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1846/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 22 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1784/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 23 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1798/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 24 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=14566/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 25 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1670/0 dn=0 df=19 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 26 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1864/0 dn=2 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 27 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1680/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 28 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1688/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 29 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1596/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 30 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1710/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 31 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1764/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 32 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=5938/0 dn=0 df=16 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 33 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1456/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 34 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1858/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 35 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1724/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 36 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1772/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 37 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1728/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 38 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1684/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 39 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1770/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 40 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2074/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 41 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1734/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 42 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1828/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 43 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1786/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 44 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1734/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 45 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2128/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 46 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1780/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 47 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1802/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 48 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=35327/1 dn=2 df=16 of=0 ri=0 ql=0 b=10 ci=2 co=0 ca=0
 49 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1619/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 50 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1992/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 51 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2048/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 52 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1938/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 53 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1714/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 54 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1668/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 55 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1746/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 56 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1713/1 dn=2 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 57 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1347/1 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 58 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2158/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 59 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2062/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 60 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1800/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 61 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1644/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 62 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1756/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 63 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=6496/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 64 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=8498/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 65 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2958/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 66 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=4094/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 67 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1756/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 68 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1696/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 69 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1758/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 70 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1750/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 71 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1702/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 72 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=6248/0 dn=4 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 73 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=7578/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 74 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1800/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 75 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1790/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 76 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1792/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 77 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1736/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 78 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1778/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 79 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1734/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 80 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2248/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 81 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3718/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 82 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1740/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 83 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1778/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 84 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1688/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 85 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1702/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 86 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1746/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 87 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1730/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 88 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1934/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 89 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2872/0 dn=0 df=19 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 90 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1620/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 91 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1838/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 92 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1808/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 93 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1788/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 94 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1826/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 95 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1662/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 96 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1784/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 97 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2726/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 98 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1786/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
 99 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1754/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
100 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1818/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
101 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1770/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
102 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1782/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
103 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1750/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
104 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1804/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
105 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2806/0 dn=0 df=20 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
106 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1928/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
107 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1782/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
108 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1734/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
109 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1756/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
110 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1776/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
111 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1714/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
112 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=7918/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
113 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2470/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
114 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1764/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
115 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1658/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
116 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1820/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
117 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1712/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
118 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1758/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
119 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2778/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
120 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2334/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
121 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=3070/0 dn=0 df=18 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
122 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1626/0 dn=0 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
123 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1706/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
124 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1766/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
125 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1730/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
126 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=2546/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
127 c=18446744073709551338 g=18446744073709551338 pq=1 pqc=18446744073709551337 qp=0 dt=1796/0 dn=2 df=22 of=0 ri=0 ql=0 b=10 ci=0 co=0 ca=0
/sys/kernel/debug/rcu/rcu_pending:
rcu_sched:
  0 np=25632 qsp=1521 rpq=6099 cbr=1 cng=1258 gpc=1188 gps=137 nf=703 nn=16246
  1 np=26817 qsp=60 rpq=8075 cbr=5 cng=46 gpc=1644 gps=749 nf=456 nn=15842
  2 np=23561 qsp=164 rpq=6864 cbr=0 cng=28 gpc=1104 gps=715 nf=180 nn=14670
  3 np=21602 qsp=29 rpq=6998 cbr=0 cng=5 gpc=910 gps=708 nf=96 nn=12885
  4 np=21510 qsp=9 rpq=6943 cbr=0 cng=5 gpc=985 gps=729 nf=100 nn=12748
  5 np=21378 qsp=28 rpq=6885 cbr=0 cng=2 gpc=877 gps=683 nf=109 nn=12822
  6 np=21340 qsp=30 rpq=6845 cbr=0 cng=2 gpc=876 gps=689 nf=104 nn=12824
  7 np=21300 qsp=32 rpq=6806 cbr=0 cng=2 gpc=983 gps=700 nf=107 nn=12702
  8 np=30419 qsp=840 rpq=8121 cbr=1 cng=46 gpc=1688 gps=783 nf=590 nn=19190
  9 np=25540 qsp=32 rpq=7723 cbr=1 cng=22 gpc=1766 gps=784 nf=191 nn=15053
 10 np=21237 qsp=7 rpq=6852 cbr=0 cng=8 gpc=1271 gps=806 nf=15 nn=12285
 11 np=20410 qsp=9 rpq=6630 cbr=0 cng=1 gpc=1064 gps=807 nf=5 nn=11903
 12 np=20332 qsp=9 rpq=6580 cbr=0 cng=2 gpc=858 gps=755 nf=7 nn=12130
 13 np=20911 qsp=9 rpq=6547 cbr=0 cng=1 gpc=924 gps=736 nf=4 nn=12699
 14 np=20214 qsp=7 rpq=6482 cbr=0 cng=0 gpc=776 gps=758 nf=2 nn=12196
 15 np=20177 qsp=9 rpq=6443 cbr=0 cng=0 gpc=871 gps=757 nf=3 nn=12103
 16 np=29031 qsp=173 rpq=7610 cbr=0 cng=29 gpc=1756 gps=763 nf=262 nn=18611
 17 np=25227 qsp=26 rpq=7282 cbr=1 cng=15 gpc=1732 gps=699 nf=205 nn=15293
 18 np=20876 qsp=9 rpq=6484 cbr=0 cng=4 gpc=1028 gps=681 nf=26 nn=12653
 19 np=20174 qsp=11 rpq=6309 cbr=0 cng=1 gpc=896 gps=692 nf=8 nn=12268
 20 np=19992 qsp=7 rpq=6224 cbr=0 cng=0 gpc=877 gps=671 nf=5 nn=12215
 21 np=19929 qsp=9 rpq=6173 cbr=0 cng=0 gpc=870 gps=697 nf=5 nn=12184
 22 np=19877 qsp=7 rpq=6122 cbr=0 cng=0 gpc=876 gps=696 nf=1 nn=12182
 23 np=19830 qsp=7 rpq=6077 cbr=0 cng=0 gpc=874 gps=696 nf=2 nn=12181
 24 np=23932 qsp=19 rpq=6860 cbr=0 cng=18 gpc=1565 gps=685 nf=170 nn=14634
 25 np=25105 qsp=115 rpq=6927 cbr=20 cng=16 gpc=1723 gps=698 nf=264 nn=15457
 26 np=20599 qsp=15 rpq=6156 cbr=0 cng=2 gpc=1052 gps=692 nf=14 nn=12683
 27 np=19785 qsp=10 rpq=5927 cbr=0 cng=1 gpc=907 gps=691 nf=13 nn=12246
 28 np=19763 qsp=7 rpq=5886 cbr=0 cng=1 gpc=906 gps=677 nf=9 nn=12284
 29 np=19580 qsp=7 rpq=5813 cbr=0 cng=1 gpc=887 gps=685 nf=8 nn=12186
 30 np=19505 qsp=6 rpq=5760 cbr=0 cng=1 gpc=874 gps=717 nf=2 nn=12151
 31 np=19464 qsp=8 rpq=5714 cbr=0 cng=1 gpc=874 gps=700 nf=1 nn=12174
 32 np=24744 qsp=164 rpq=6657 cbr=0 cng=18 gpc=1743 gps=741 nf=136 nn=15449
 33 np=23901 qsp=50 rpq=6547 cbr=15 cng=7 gpc=1738 gps=733 nf=121 nn=14740
 34 np=19959 qsp=8 rpq=5740 cbr=0 cng=4 gpc=1004 gps=729 nf=14 nn=12468
 35 np=19379 qsp=9 rpq=5558 cbr=0 cng=0 gpc=890 gps=727 nf=9 nn=12195
 36 np=19222 qsp=8 rpq=5488 cbr=0 cng=0 gpc=876 gps=716 nf=6 nn=12136
 37 np=19177 qsp=8 rpq=5442 cbr=0 cng=0 gpc=870 gps=721 nf=2 nn=12142
 38 np=19131 qsp=7 rpq=5399 cbr=0 cng=0 gpc=874 gps=722 nf=4 nn=12132
 39 np=19099 qsp=9 rpq=5357 cbr=0 cng=0 gpc=874 gps=720 nf=5 nn=12143
 40 np=22259 qsp=29 rpq=6040 cbr=1 cng=7 gpc=1471 gps=784 nf=101 nn=13855
 41 np=23011 qsp=81 rpq=6085 cbr=22 cng=26 gpc=1685 gps=664 nf=102 nn=14427
 42 np=19460 qsp=8 rpq=5357 cbr=0 cng=0 gpc=1009 gps=793 nf=4 nn=12297
 43 np=18930 qsp=8 rpq=5179 cbr=0 cng=0 gpc=951 gps=797 nf=5 nn=11998
 44 np=18884 qsp=7 rpq=5135 cbr=0 cng=0 gpc=1207 gps=767 nf=1 nn=11774
 45 np=18845 qsp=8 rpq=5092 cbr=0 cng=0 gpc=1200 gps=737 nf=3 nn=11813
 46 np=18800 qsp=7 rpq=5044 cbr=0 cng=0 gpc=1316 gps=801 nf=3 nn=11636
 47 np=18747 qsp=8 rpq=4998 cbr=0 cng=0 gpc=1051 gps=653 nf=3 nn=12042
 48 np=25212 qsp=297 rpq=6193 cbr=3 cng=15 gpc=1704 gps=740 nf=514 nn=16043
 49 np=22984 qsp=68 rpq=5734 cbr=3 cng=12 gpc=1633 gps=695 nf=116 nn=14791
 50 np=19819 qsp=9 rpq=5028 cbr=0 cng=0 gpc=1025 gps=686 nf=96 nn=12984
 51 np=19238 qsp=8 rpq=4864 cbr=0 cng=0 gpc=918 gps=680 nf=63 nn=12713
 52 np=19012 qsp=8 rpq=4788 cbr=0 cng=0 gpc=890 gps=680 nf=48 nn=12606
 53 np=19121 qsp=7 rpq=4730 cbr=0 cng=0 gpc=875 gps=682 nf=60 nn=12774
 54 np=18398 qsp=8 rpq=4682 cbr=0 cng=0 gpc=870 gps=682 nf=9 nn=12155
 55 np=18351 qsp=9 rpq=4635 cbr=0 cng=0 gpc=872 gps=678 nf=5 nn=12161
 56 np=21897 qsp=11 rpq=5400 cbr=0 cng=10 gpc=1591 gps=701 nf=91 nn=14104
 57 np=22398 qsp=27 rpq=5417 cbr=2 cng=11 gpc=1830 gps=707 nf=110 nn=14321
 58 np=18956 qsp=10 rpq=4658 cbr=0 cng=1 gpc=1218 gps=712 nf=21 nn=12346
 59 np=18243 qsp=8 rpq=4469 cbr=0 cng=0 gpc=908 gps=706 nf=4 nn=12156
 60 np=18163 qsp=8 rpq=4412 cbr=0 cng=0 gpc=1031 gps=741 nf=6 nn=11973
 61 np=18118 qsp=8 rpq=4369 cbr=0 cng=0 gpc=951 gps=688 nf=4 nn=12106
 62 np=18076 qsp=7 rpq=4330 cbr=0 cng=0 gpc=873 gps=662 nf=7 nn=12204
 63 np=19242 qsp=44 rpq=4594 cbr=0 cng=0 gpc=1040 gps=671 nf=133 nn=12804
 64 np=22060 qsp=234 rpq=4783 cbr=0 cng=11 gpc=1352 gps=684 nf=71 nn=15159
 65 np=20694 qsp=33 rpq=4834 cbr=0 cng=9 gpc=1403 gps=686 nf=192 nn=13570
 66 np=18467 qsp=32 rpq=4222 cbr=0 cng=4 gpc=924 gps=636 nf=28 nn=12653
 67 np=18102 qsp=8 rpq=4119 cbr=0 cng=3 gpc=1150 gps=633 nf=25 nn=12172
 68 np=18043 qsp=8 rpq=4072 cbr=0 cng=3 gpc=883 gps=666 nf=23 nn=12396
 69 np=17994 qsp=30 rpq=4025 cbr=0 cng=2 gpc=920 gps=683 nf=29 nn=12335
 70 np=17952 qsp=32 rpq=3979 cbr=0 cng=3 gpc=879 gps=676 nf=21 nn=12394
 71 np=17926 qsp=8 rpq=3942 cbr=0 cng=3 gpc=938 gps=733 nf=33 nn=12277
 72 np=20531 qsp=129 rpq=4144 cbr=0 cng=1 gpc=1107 gps=628 nf=28 nn=14623
 73 np=25555 qsp=10 rpq=4635 cbr=1 cng=311 gpc=1250 gps=606 nf=1401 nn=17351
 74 np=17671 qsp=7 rpq=3829 cbr=0 cng=3 gpc=901 gps=775 nf=7 nn=12156
 75 np=17495 qsp=8 rpq=3753 cbr=0 cng=1 gpc=879 gps=770 nf=4 nn=12088
 76 np=17430 qsp=8 rpq=3703 cbr=0 cng=0 gpc=873 gps=766 nf=3 nn=12085
 77 np=17400 qsp=8 rpq=3660 cbr=0 cng=1 gpc=879 gps=772 nf=3 nn=12085
 78 np=17335 qsp=7 rpq=3608 cbr=0 cng=1 gpc=874 gps=764 nf=1 nn=12087
 79 np=17289 qsp=9 rpq=3563 cbr=0 cng=1 gpc=872 gps=758 nf=2 nn=12093
 80 np=19880 qsp=9 rpq=3836 cbr=0 cng=13 gpc=1130 gps=700 nf=116 nn=14085
 81 np=21161 qsp=7 rpq=4050 cbr=0 cng=62 gpc=1318 gps=704 nf=315 nn=14712
 82 np=18106 qsp=7 rpq=3461 cbr=0 cng=0 gpc=908 gps=699 nf=150 nn=12888
 83 np=17158 qsp=9 rpq=3391 cbr=0 cng=0 gpc=887 gps=740 nf=5 nn=12135
 84 np=17086 qsp=8 rpq=3336 cbr=0 cng=0 gpc=881 gps=756 nf=7 nn=12106
 85 np=17040 qsp=9 rpq=3293 cbr=0 cng=0 gpc=876 gps=749 nf=5 nn=12117
 86 np=16994 qsp=7 rpq=3248 cbr=0 cng=0 gpc=878 gps=747 nf=3 nn=12118
 87 np=16949 qsp=8 rpq=3201 cbr=0 cng=0 gpc=880 gps=749 nf=4 nn=12115
 88 np=18332 qsp=20 rpq=3450 cbr=0 cng=3 gpc=1148 gps=718 nf=38 nn=12975
 89 np=19384 qsp=12 rpq=3582 cbr=0 cng=3 gpc=1287 gps=715 nf=165 nn=13632
 90 np=17242 qsp=9 rpq=3121 cbr=0 cng=2 gpc=929 gps=710 nf=38 nn=12442
 91 np=16804 qsp=8 rpq=3031 cbr=0 cng=1 gpc=896 gps=698 nf=2 nn=12176
 92 np=16725 qsp=9 rpq=2976 cbr=0 cng=0 gpc=879 gps=695 nf=8 nn=12167
 93 np=16679 qsp=8 rpq=2932 cbr=0 cng=1 gpc=885 gps=694 nf=3 nn=12164
 94 np=16625 qsp=8 rpq=2886 cbr=0 cng=1 gpc=876 gps=698 nf=1 nn=12163
 95 np=16587 qsp=7 rpq=2842 cbr=0 cng=0 gpc=879 gps=687 nf=3 nn=12176
 96 np=17818 qsp=8 rpq=3050 cbr=0 cng=3 gpc=1115 gps=710 nf=24 nn=12916
 97 np=19241 qsp=8 rpq=3184 cbr=0 cng=3 gpc=1223 gps=714 nf=127 nn=13990
 98 np=16474 qsp=9 rpq=2713 cbr=0 cng=0 gpc=883 gps=710 nf=3 nn=12165
 99 np=16408 qsp=8 rpq=2663 cbr=0 cng=0 gpc=876 gps=719 nf=4 nn=12146
100 np=16351 qsp=8 rpq=2609 cbr=0 cng=0 gpc=877 gps=699 nf=1 nn=12165
101 np=16294 qsp=8 rpq=2562 cbr=0 cng=1 gpc=875 gps=692 nf=3 nn=12161
102 np=16252 qsp=8 rpq=2518 cbr=0 cng=0 gpc=878 gps=683 nf=0 nn=12173
103 np=16226 qsp=11 rpq=2475 cbr=0 cng=0 gpc=878 gps=689 nf=6 nn=12178
104 np=17120 qsp=9 rpq=2651 cbr=0 cng=1 gpc=1090 gps=768 nf=13 nn=12597
105 np=17597 qsp=67 rpq=2713 cbr=2 cng=3 gpc=1140 gps=771 nf=129 nn=12839
106 np=16159 qsp=9 rpq=2364 cbr=0 cng=0 gpc=888 gps=770 nf=5 nn=12132
107 np=16049 qsp=8 rpq=2296 cbr=0 cng=0 gpc=876 gps=770 nf=2 nn=12105
108 np=16007 qsp=7 rpq=2252 cbr=0 cng=0 gpc=882 gps=774 nf=7 nn=12092
109 np=15959 qsp=8 rpq=2206 cbr=0 cng=0 gpc=882 gps=773 nf=3 nn=12095
110 np=15912 qsp=7 rpq=2160 cbr=0 cng=0 gpc=882 gps=767 nf=4 nn=12099
111 np=15867 qsp=7 rpq=2117 cbr=0 cng=0 gpc=882 gps=772 nf=3 nn=12093
112 np=17960 qsp=27 rpq=2443 cbr=0 cng=4 gpc=1170 gps=701 nf=97 nn=13545
113 np=17615 qsp=12 rpq=2431 cbr=1 cng=2 gpc=1215 gps=722 nf=97 nn=13147
114 np=16334 qsp=8 rpq=2072 cbr=0 cng=0 gpc=958 gps=725 nf=25 nn=12554
115 np=15915 qsp=7 rpq=1947 cbr=0 cng=0 gpc=892 gps=711 nf=14 nn=12351
116 np=15841 qsp=8 rpq=1894 cbr=0 cng=0 gpc=882 gps=724 nf=15 nn=12326
117 np=15777 qsp=8 rpq=1845 cbr=0 cng=1 gpc=880 gps=721 nf=5 nn=12325
118 np=15515 qsp=7 rpq=1798 cbr=0 cng=0 gpc=882 gps=717 nf=2 nn=12116
119 np=15473 qsp=8 rpq=1755 cbr=0 cng=0 gpc=882 gps=720 nf=3 nn=12113
120 np=16460 qsp=9 rpq=1943 cbr=0 cng=0 gpc=1104 gps=662 nf=9 nn=12742
121 np=27489 qsp=10 rpq=3390 cbr=1 cng=127 gpc=1562 gps=706 nf=2320 nn=19383
122 np=15731 qsp=7 rpq=1699 cbr=0 cng=2 gpc=955 gps=668 nf=16 nn=12391
123 np=15326 qsp=8 rpq=1577 cbr=0 cng=0 gpc=886 gps=663 nf=5 nn=12195
124 np=15282 qsp=7 rpq=1531 cbr=0 cng=0 gpc=1045 gps=698 nf=5 nn=12003
125 np=15230 qsp=8 rpq=1488 cbr=0 cng=0 gpc=927 gps=686 nf=2 nn=12127
126 np=15225 qsp=9 rpq=1446 cbr=0 cng=0 gpc=1036 gps=724 nf=5 nn=12014
127 np=15144 qsp=8 rpq=1395 cbr=0 cng=0 gpc=1005 gps=669 nf=3 nn=12072
rcu_bh:
  0 np=16246 qsp=0 rpq=12266 cbr=0 cng=6 gpc=3 gps=2 nf=7 nn=3962
  1 np=15842 qsp=0 rpq=12789 cbr=0 cng=1 gpc=4 gps=1 nf=2 nn=3045
  2 np=14670 qsp=0 rpq=13505 cbr=0 cng=1 gpc=1 gps=0 nf=2 nn=1161
  3 np=12885 qsp=0 rpq=12815 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=70
  4 np=12748 qsp=0 rpq=12698 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=50
  5 np=12822 qsp=0 rpq=12818 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  6 np=12824 qsp=0 rpq=12820 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  7 np=12702 qsp=0 rpq=12698 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
  8 np=19190 qsp=0 rpq=16647 cbr=0 cng=0 gpc=6 gps=2 nf=0 nn=2535
  9 np=15053 qsp=0 rpq=12483 cbr=0 cng=0 gpc=3 gps=2 nf=0 nn=2565
 10 np=12285 qsp=0 rpq=11814 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=471
 11 np=11903 qsp=0 rpq=11873 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=30
 12 np=12130 qsp=0 rpq=12115 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=15
 13 np=12699 qsp=0 rpq=12123 cbr=0 cng=0 gpc=3 gps=0 nf=0 nn=573
 14 np=12196 qsp=0 rpq=12192 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 15 np=12103 qsp=0 rpq=12099 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 16 np=18611 qsp=0 rpq=15177 cbr=0 cng=0 gpc=6 gps=1 nf=2 nn=3425
 17 np=15293 qsp=0 rpq=12820 cbr=0 cng=2 gpc=2 gps=1 nf=0 nn=2468
 18 np=12653 qsp=0 rpq=12195 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=458
 19 np=12268 qsp=0 rpq=12184 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=84
 20 np=12215 qsp=0 rpq=12198 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=17
 21 np=12184 qsp=0 rpq=12176 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=8
 22 np=12182 qsp=0 rpq=12178 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 23 np=12181 qsp=0 rpq=12177 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 24 np=14634 qsp=0 rpq=12655 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=1976
 25 np=15457 qsp=0 rpq=12848 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=2607
 26 np=12683 qsp=0 rpq=12180 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=501
 27 np=12246 qsp=0 rpq=12167 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=79
 28 np=12284 qsp=0 rpq=12185 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 29 np=12186 qsp=0 rpq=12166 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=20
 30 np=12151 qsp=0 rpq=12147 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 31 np=12174 qsp=0 rpq=12170 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 32 np=15449 qsp=0 rpq=13091 cbr=0 cng=1 gpc=5 gps=1 nf=0 nn=2351
 33 np=14740 qsp=0 rpq=12140 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=2597
 34 np=12468 qsp=0 rpq=12120 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=348
 35 np=12195 qsp=0 rpq=12133 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=62
 36 np=12136 qsp=0 rpq=12132 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 37 np=12142 qsp=0 rpq=12138 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 38 np=12132 qsp=0 rpq=12128 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 39 np=12143 qsp=0 rpq=12132 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
 40 np=13855 qsp=0 rpq=12093 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=1760
 41 np=14427 qsp=0 rpq=12126 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=2297
 42 np=12297 qsp=0 rpq=12042 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=255
 43 np=11998 qsp=0 rpq=11995 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 44 np=11774 qsp=0 rpq=11770 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 45 np=11813 qsp=0 rpq=11807 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=6
 46 np=11636 qsp=0 rpq=11633 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 47 np=12042 qsp=0 rpq=12039 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 48 np=16043 qsp=0 rpq=13693 cbr=0 cng=1 gpc=3 gps=2 nf=0 nn=2344
 49 np=14791 qsp=0 rpq=12614 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=2174
 50 np=12984 qsp=0 rpq=12601 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=383
 51 np=12713 qsp=0 rpq=12614 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 52 np=12606 qsp=0 rpq=12563 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=43
 53 np=12774 qsp=0 rpq=12764 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
 54 np=12155 qsp=0 rpq=12152 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 55 np=12161 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 56 np=14104 qsp=0 rpq=12179 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=1923
 57 np=14321 qsp=0 rpq=12025 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=2292
 58 np=12346 qsp=0 rpq=11955 cbr=0 cng=0 gpc=1 gps=1 nf=0 nn=389
 59 np=12156 qsp=0 rpq=12134 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=22
 60 np=11973 qsp=0 rpq=11970 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 61 np=12106 qsp=0 rpq=12102 cbr=0 cng=0 gpc=1 gps=0 nf=0 nn=3
 62 np=12204 qsp=0 rpq=12200 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 63 np=12804 qsp=0 rpq=12651 cbr=0 cng=0 gpc=3 gps=0 nf=0 nn=150
 64 np=15159 qsp=0 rpq=14190 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=969
 65 np=13570 qsp=0 rpq=12478 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=1088
 66 np=12653 qsp=0 rpq=12470 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=183
 67 np=12172 qsp=0 rpq=12163 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=9
 68 np=12396 qsp=0 rpq=12392 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 69 np=12335 qsp=0 rpq=12334 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
 70 np=12394 qsp=0 rpq=12390 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 71 np=12277 qsp=0 rpq=12262 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=15
 72 np=14623 qsp=0 rpq=14140 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=483
 73 np=17351 qsp=0 rpq=16476 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=872
 74 np=12156 qsp=0 rpq=12077 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=79
 75 np=12088 qsp=0 rpq=12078 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
 76 np=12085 qsp=0 rpq=12083 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=2
 77 np=12085 qsp=0 rpq=12073 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=12
 78 np=12087 qsp=0 rpq=12084 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 79 np=12093 qsp=0 rpq=12090 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 80 np=14085 qsp=0 rpq=12836 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1249
 81 np=14712 qsp=0 rpq=13675 cbr=0 cng=0 gpc=3 gps=1 nf=0 nn=1033
 82 np=12888 qsp=0 rpq=12827 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=61
 83 np=12135 qsp=0 rpq=12122 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=13
 84 np=12106 qsp=0 rpq=12103 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 85 np=12117 qsp=0 rpq=12114 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 86 np=12118 qsp=0 rpq=12115 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 87 np=12115 qsp=0 rpq=12111 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 88 np=12975 qsp=0 rpq=12333 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=642
 89 np=13632 qsp=0 rpq=12832 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=797
 90 np=12442 qsp=0 rpq=12343 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=99
 91 np=12176 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=16
 92 np=12167 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=9
 93 np=12164 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 94 np=12163 qsp=0 rpq=12160 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
 95 np=12176 qsp=0 rpq=12172 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
 96 np=12916 qsp=0 rpq=12333 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=583
 97 np=13990 qsp=0 rpq=13175 cbr=0 cng=0 gpc=2 gps=1 nf=0 nn=812
 98 np=12165 qsp=0 rpq=12143 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=22
 99 np=12146 qsp=0 rpq=12135 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
100 np=12165 qsp=0 rpq=12155 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=10
101 np=12161 qsp=0 rpq=12158 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
102 np=12173 qsp=0 rpq=12170 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
103 np=12178 qsp=0 rpq=12163 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=15
104 np=12597 qsp=0 rpq=12106 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=491
105 np=12839 qsp=0 rpq=12100 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=739
106 np=12132 qsp=0 rpq=12098 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=34
107 np=12105 qsp=0 rpq=12101 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
108 np=12092 qsp=0 rpq=12089 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
109 np=12095 qsp=0 rpq=12091 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
110 np=12099 qsp=0 rpq=12096 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
111 np=12093 qsp=0 rpq=12091 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=2
112 np=13545 qsp=0 rpq=12849 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=696
113 np=13147 qsp=0 rpq=12321 cbr=0 cng=0 gpc=1 gps=1 nf=1 nn=823
114 np=12554 qsp=0 rpq=12330 cbr=0 cng=0 gpc=1 gps=0 nf=0 nn=223
115 np=12351 qsp=0 rpq=12325 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=26
116 np=12326 qsp=0 rpq=12315 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=11
117 np=12325 qsp=0 rpq=12322 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
118 np=12116 qsp=0 rpq=12113 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
119 np=12113 qsp=0 rpq=12112 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=1
120 np=12742 qsp=0 rpq=12201 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=541
121 np=19383 qsp=0 rpq=18247 cbr=0 cng=0 gpc=2 gps=1 nf=1 nn=1132
122 np=12391 qsp=0 rpq=12201 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=190
123 np=12195 qsp=0 rpq=12192 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
124 np=12003 qsp=0 rpq=12000 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
125 np=12127 qsp=0 rpq=12124 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
126 np=12014 qsp=0 rpq=11983 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=31
127 np=12072 qsp=0 rpq=12069 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=3
/sys/kernel/debug/rcu/rcutorture:
cat: /sys/kernel/debug/rcu/rcutorture: No such file or directory
no /sys/kernel/debug/rcu/rcutorture
/sys/kernel/debug/rcu/rcuboost:
cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
no /sys/kernel/debug/rcu/rcuboost

