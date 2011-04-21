Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1DUOre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:47:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38933 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab1DUOrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=RwWH1RKDy+RnO9I7K63F+F5GzYiznEe8e1z1Hj83V20IyuXOuu/pXmRcLCfoAqASag
         vWG1iLXHTgbqbdr9yfq2UoejPsCRXVb6immiLTc30BIQrLKWbStnR6INwYJq5tafw42N
         7OHmvrThDMepcQSRJw0vanTBycaLcxERJrnAg=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110421142853.GA2235@linux.vnet.ibm.com>
References: <BANLkTikd2MpRPF37R+vCwnb7Lzzd6EiS7A@mail.gmail.com>
	<BANLkTinq=mC9rs5R3U8FPLCp-GgCJris_g@mail.gmail.com>
	<BANLkTimT9OhHLL5NaPOP30MdiMfmmmEcyQ@mail.gmail.com>
	<BANLkTikVW9Z=WxD7=w9c=Z6kHO-Za2ru8A@mail.gmail.com>
	<20110414224411.GF2141@linux.vnet.ibm.com>
	<20110421050823.GA4487@linux.vnet.ibm.com>
	<BANLkTinFmG5GVq6D8+wq_89OPF8snsQ=Jw@mail.gmail.com>
	<BANLkTi=c=+JnU9dQsVhgjZbOtArhHQz+EQ@mail.gmail.com>
	<BANLkTimEWqBVdq8MWbjAAfXCLPQdiHkuNg@mail.gmail.com>
	<20110421142853.GA2235@linux.vnet.ibm.com>
Date: Thu, 21 Apr 2011 16:47:31 +0200
Message-ID: <BANLkTineNYTXffcNT59STsk5nkLhi=o-kA@mail.gmail.com>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 4:28 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Apr 21, 2011 at 02:49:37PM +0200, Sedat Dilek wrote:
>> On Thu, Apr 21, 2011 at 12:24 PM, Sedat Dilek
>> <sedat.dilek@googlemail.com> wrote:
>> > On Thu, Apr 21, 2011 at 11:07 AM, Sedat Dilek
>> > <sedat.dilek@googlemail.com> wrote:
>> >> On Thu, Apr 21, 2011 at 7:08 AM, Paul E. McKenney
>> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >>> On Thu, Apr 14, 2011 at 03:44:11PM -0700, Paul E. McKenney wrote:
>> >>>> On Fri, Apr 15, 2011 at 12:19:34AM +0200, Sedat Dilek wrote:
>> >>>> > On Thu, Apr 14, 2011 at 12:19 PM, Sedat Dilek
>> >>>> > <sedat.dilek@googlemail.com> wrote:
>> >>>> > > On Thu, Apr 14, 2011 at 11:16 AM, Sedat Dilek
>> >>>> > > <sedat.dilek@googlemail.com> wrote:
>> >>>> > >> [ Adding CC to RCU maintainer (Hi Paul :-)) ]
>> >>>> > >>
>> >>>> > >> Helping me for now with (see also Documentation/RCU/stallwarn.txt):
>> >>>> > >>
>> >>>> > >> # cat /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
>> >>>> > >> 0
>> >>>> > >>
>> >>>> > >> # echo "1" > /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
>> >>>> > >>
>> >>>> > >> # cat /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
>> >>>> > >> 1
>> >>>> > >>
>> >>>> > >> - Sedat -
>> >>>> > >>
>> >>>> > >
>> >>>> > > That workaround helped till a system-freeze when generating a tarball
>> >>>> > > from my current kernel-tree.
>> >>>> > > I switched back to my yesterday's linux-next kernel.
>> >>>> > >
>> >>>> > > - Sedat -
>> >>>> > >
>> >>>> >
>> >>>> > I isolated the culprit so far:
>> >>>> >
>> >>>> > commit 900507fc62d5ba0164c07878dbc36ac97866a858
>> >>>> > "rcu: move TREE_RCU from softirq to kthread"
>> >>>> >
>> >>>> > With this revert my system does not show the symptoms I have reported.
>> >>>>
>> >>>> Hmmm...  I never was able to reproduce this, but did find a workload
>> >>>> that slowed up the grace periods.  I fixed that (which turned out to
>> >>>> be a wakeup problem), but my hopes that it would also fix your problem
>> >>>> were clearly unfounded.  I have once again stopped exporting this commit
>> >>>> to -next.
>> >>>
>> >>> I have added some debug tracing, which are available at branch
>> >>> "sedat.2011.04.19a" in the git repository at:
>> >>>
>> >>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
>> >>>
>> >>> Alternatively, if it is easier, the shown below can be used.  FWIW,
>> >>> this patch is against 2.6.39-rc3.
>> >>>
>> >>> Either way, if you get a chance to run your tests on this, could you
>> >>> please run the attached script (collectdebugfs.sh) and capture its output?
>> >>> Sample output is attached as well (collectdebugfs.sh.out):  the script
>> >>> should output something vaguely like the sample output every 15 seconds
>> >>> or so.
>> >>>
>> >>> The script assumes that debugfs is enabled (along with CONFIG_RCU_TRACE=y)
>> >>> and mounted as follows:
>> >>>
>> >>>        mount -t debugfs none /sys/kernel/debug/
>> >>>
>> >>> Or if you mount debugfs somewhere else, please set the script's DEBUGFS_MP
>> >>> variable accordingly.
>> >>>
>> >>>                                                        Thanx, Paul
>> >>>
>> >>> ------------------------------------------------------------------------
>> >>>
>> >>
>> >> Welcome to operation "Kill that RCU brainbug" (Starship troopers part X)!
>
> Actually, only Part III thus far, but point taken...  ;-)
>
>> >> Of course I can help with testing.
>
> Thank you very much!
>
>> >> Paul, did you see recent RCU-related fixes to fs between rc3 and rc4?
>> >>
>> >> commit c1530019e311c91d14b24d8e74d233152d806e45
>> >> vfs: Fix absolute RCU path walk failures due to uninitialized seq number
>> >>
>> >> fff3e5ade4455a4b42a19c95dd7a167a3cb7956a
>> >> fs: synchronize_rcu when unregister_filesystem success not failure
>> >>
>> >> IIRC, Jens has pending block/plugging patches in his for-linus tree.
>> >> Especially this one (CONFIG_PREEMPT):
>> >>
>> >> 5f45c69589b7d2953584e6cd0b31e35dbe960ad0
>> >> cfq-iosched: read_lock() does not always imply rcu_read_lock()
>
> Thank you for pointing them out, but the diagnostics clearly show
> that one of the kthreads isn't getting awakened when it should be...
>
> More below.
>
>> >> Some questions to test-scenario:
>> >>
>> >> Shall I test from linux-2.6-rcu.git#sedat.2011.04.19a GIT tree?
>> >> I think that's the ideal solution.
>
> Agreed.
>
>> >> Or shall I pull sedat.2011.04.19a GIT branch into "BROKEN" linux-next
>> >> (next-20110414)?
>
> Unnecessarily increasing the number of bugs in the system under test
> doesn't seem wise to me.  ;-)
>

Yepp, I tested from your RCU tree and the given GIT branch only.

>> >> Again, with which RCU/HZ/PREEMPT kernel-config options shall I test?
>> >> This is from my yesterday's linux-next:
>> >>
>> >> # egrep 'RCU|_HZ |PREEMPT' /boot/config-2.6.39-rc4-next20110420.4-686-small
>> >> # RCU Subsystem
>> >> CONFIG_TREE_RCU=y
>> >> # CONFIG_PREEMPT_RCU is not set
>> >> CONFIG_RCU_TRACE=y
>> >> CONFIG_RCU_FANOUT=32
>> >> # CONFIG_RCU_FANOUT_EXACT is not set
>> >> CONFIG_RCU_FAST_NO_HZ=y
>> >> CONFIG_TREE_RCU_TRACE=y
>> >> # CONFIG_PREEMPT_NONE is not set
>> >> CONFIG_PREEMPT_VOLUNTARY=y
>> >> # CONFIG_PREEMPT is not set
>> >> # CONFIG_SPARSE_RCU_POINTER is not set
>> >> CONFIG_RCU_TORTURE_TEST=m
>> >> CONFIG_RCU_CPU_STALL_TIMEOUT=60
>
> The options that were causing you trouble before, but with
> both CONFIG_TREE_RCU (the one that failed quickly) and with
> CONFIG_TREE_PREEMPT_RCU (which failed slowly).
>
>> >> Regards,
>> >> - Sedat -
>> >>
>> >
>> > Looks like you want me to test with RCU_BOOST and RCU_TORTURE_TEST :-).
>
> No, it is just that my diagnostics don't apply cleanly before the
> commit that enabled RCU_BOOST.
>
> Ah!  I see.  No, I just made my script dump all the RCU debugfs
> information, I wasn't trying to provide guidance.  ;-)
>
>> > Attached is collectdebugfs-dileks.log, my current kernel-config and a
>> > build-script to generate Debian packages.
>
> Hmmmm...  The system died within 30 seconds?  The usual way that RCU
> hangs the system is by memory exhaustion: grace periods stop advancing,
> RCU callbacks therefore never get invoked, and RCU-protected memory
> therefore never gets freed.  But I guess if your workload freed
> RCU-protected data fast enough, the system could hang quickly.
>

The first log might be incomplete, I stopped it by Ctrl+C.
In the 2nd-run I have seen too late, that the script continues collecting data.
So, my fault.

>> > $ LANG=C ./collectdebugfs.sh 2>&1 | tee collectdebugfs-dileks.log
>> >
>> > I will do a 2nd run with PREEMPT_RCU enabled.
>> >
>> > - Sedat -
>> >
>>
>> Here the results from the 2nd-run (PREEMPT_RCU enabled).
>
> OK, and the grace periods clearly stopped advancing early on.
>
> Beyond that point, the per-CPU kthread is blocked, but RCU has some
> work for it to do.  So someone has called invoke_rcu_cpu_kthread(),
> but rcu_cpu_kthread() is still blocked.  I don't see a bug right
> off-hand, but it is early in the morning for me, so I might easily
> be missing something.
>
> Hmmm...
>
> The synchronization between these two assumes that the per-CPU
> kthread is always bound to the respective CPU, so if was somehow
> being migrated off, that might explain these results.
>
> I will add some more diagnostics, test them locally, then push
> out an update.  Seem reasonable?
>
> And thank you again for the testing!!!
>

Ping me when you have new stuff for testing.
Tomorrow (friday), here is public holiday and monday, too.
So a looong weekend.

>                                                Thanx, Paul
>
>> - Sedat -
>
>> Thu Apr 21 14:37:27 CEST 2011
>> rcu_preempt_state: completed=13022  gpnum=13023  age=0  max=54
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=13023 g=13024 s=2 jfq=3 j=4d18 nfqs=731/nfqsng=0(731) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=45800 j=4d18 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-24703 j=4d18 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=13026 g=13027 pq=1 pqc=13026 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=81 qs=N.WD kt=0/W b=10 ci=242547 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=19291 qsp=4 rpq=19287 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 3012
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:37:42 CEST 2011
>> rcu_preempt_state: completed=14707  gpnum=14708  age=0  max=54
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=14708 g=14709 s=2 jfq=3 j=5bd3 nfqs=830/nfqsng=0(830) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=42029 j=5bd3 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-28474 j=5bd3 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=14709 g=14710 pq=1 pqc=14709 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=31 qs=N.W. kt=0/W b=10 ci=263538 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=23057 qsp=4 rpq=23053 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 4691
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:37:57 CEST 2011
>> rcu_preempt_state: completed=16459  gpnum=16460  age=0  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=16459 g=16460 s=2 jfq=3 j=6a82 nfqs=990/nfqsng=0(990) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=38270 j=6a82 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-32233 j=6a82 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=16460 g=16461 pq=1 pqc=16460 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=120 qs=N.W. kt=0/W b=10 ci=291395 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=26818 qsp=4 rpq=26814 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 6227
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:38:12 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=1644  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=7931 nfqs=1146/nfqsng=0(1146) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=34511 j=7931 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-35992 j=7931 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=7209 qs=N.W. kt=1/W b=10 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=30576 qsp=4 rpq=30572 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:38:27 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=5400  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=87dc nfqs=1267/nfqsng=0(1267) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=30756 j=87dc nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-39747 j=87dc nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=14248 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=34330 qsp=4 rpq=34326 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:38:42 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=9156  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=0 j=9689 nfqs=1544/nfqsng=0(1544) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=26999 j=9689 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-43504 j=9689 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=27472 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=38089 qsp=4 rpq=38085 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:38:57 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=12918  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=3 j=a53b nfqs=2120/nfqsng=0(2120) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=23237 j=a53b nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-47266 j=a53b nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=51443 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=41848 qsp=4 rpq=41844 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:39:12 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=16673  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=3 j=b3e7 nfqs=2799/nfqsng=0(2799) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=19481 j=b3e7 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-51022 j=b3e7 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=94614 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=45606 qsp=4 rpq=45602 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:39:27 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=20432  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=3 j=c297 nfqs=3471/nfqsng=0(3471) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=15721 j=c297 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-54782 j=c297 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=137507 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=49367 qsp=4 rpq=49363 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:39:42 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=24197  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=d14a nfqs=4116/nfqsng=0(4116) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=11958 j=d14a nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-58545 j=d14a nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=188499 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=53130 qsp=4 rpq=53126 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:39:57 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=27964  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=1 j=e001 nfqs=4810/nfqsng=0(4810) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 G.>T 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=8191 j=e001 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-62312 j=e001 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=235065 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=56897 qsp=4 rpq=56893 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:40:12 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=31722  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=eeaf nfqs=5478/nfqsng=0(5478) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=4433 j=eeaf nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-66070 j=eeaf nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=276793 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=60655 qsp=4 rpq=60651 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:40:28 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=35486  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=3 j=fd63 nfqs=6179/nfqsng=0(6179) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=669 j=fd63 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-69834 j=fd63 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=319929 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=64416 qsp=4 rpq=64412 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:40:43 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=39246  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=3 j=c13 nfqs=6856/nfqsng=0(6856) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-3091 j=c13 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-73594 j=c13 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=358327 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=68179 qsp=4 rpq=68175 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:40:58 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=43011  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=1ac7 nfqs=7535/nfqsng=0(7535) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 G.>T 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-6855 j=1ac7 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-77358 j=1ac7 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=413879 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=71941 qsp=4 rpq=71937 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:41:13 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=46764  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=0 j=2970 nfqs=7888/nfqsng=0(7888) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-10608 j=2970 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-81111 j=2970 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=420128 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=75695 qsp=4 rpq=75691 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:41:28 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=50519  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=381b nfqs=8327/nfqsng=0(8327) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-14363 j=381b nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-84866 j=381b nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=446254 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=79454 qsp=4 rpq=79450 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:41:43 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=54286  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=46d2 nfqs=8659/nfqsng=0(8659) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-18130 j=46d2 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-88633 j=46d2 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=474722 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=83216 qsp=4 rpq=83212 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:41:58 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=58041  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=557d nfqs=8733/nfqsng=0(8733) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-21885 j=557d nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-92388 j=557d nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=477483 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=86971 qsp=4 rpq=86967 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:42:13 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=61798  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=1 j=642b nfqs=8892/nfqsng=0(8892) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-25643 j=642b nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-96146 j=642b nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=495375 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=90731 qsp=4 rpq=90727 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:42:28 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=65556  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=72d8 nfqs=8973/nfqsng=0(8973) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-29400 j=72d8 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-99903 j=72d8 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=500171 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=94486 qsp=4 rpq=94482 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:42:43 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=69310  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=1 j=8182 nfqs=9071/nfqsng=0(9071) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-33154 j=8182 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-103657 j=8182 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=505394 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=98241 qsp=4 rpq=98237 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:42:58 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=73066  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=2 j=902e nfqs=9232/nfqsng=0(9232) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 G.>T 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-36910 j=902e nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-107413 j=902e nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=516914 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=101996 qsp=4 rpq=101992 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>> Thu Apr 21 14:43:13 CEST 2011
>> rcu_preempt_state: completed=17263  gpnum=17264  age=76820  max=221
>> rcu_sched_state: completed=-300  gpnum=4294966996  age=0  max=0
>> rcu_bh_state: completed=-298  gpnum=4294966998  age=0  max=1
>> rcu_preempt:
>> c=17263 g=17264 s=3 jfq=0 j=9ed9 nfqs=9298/nfqsng=0(9298) fqlh=0
>> 1/1 ..>. 0:31 ^0
>> 1/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_sched:
>> c=4294966996 g=4294966996 s=0 jfq=-40665 j=9ed9 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_bh:
>> c=4294966998 g=4294966998 s=0 jfq=-111168 j=9ed9 nfqs=0/nfqsng=0(0) fqlh=0
>> 0/1 ..>. 0:31 ^0
>> 0/1 ..>. 0:15 ^0    0/0 ..>. 16:31 ^1
>> rcu_preempt:
>>   0 c=17263 g=17264 pq=1 pqc=17263 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=517861 qs=N.W. kt=1/W b=2147483647 ci=299175 co=0 ca=0
>> rcu_sched:
>>   0 c=0 g=0 pq=1 pqc=4294967295 qp=1 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=0 co=0 ca=0
>> rcu_bh:
>>   0 c=4294966998 g=4294966998 pq=1 pqc=4294966997 qp=0 dt=40499/1/0 df=0 of=0 ri=0 ql=0 qs=.... kt=1/W b=10 ci=6 co=0 ca=0
>> rcu_preempt:
>>   0 np=0 qsp=0 rpq=0 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcu_sched:
>>   0 np=105752 qsp=4 rpq=105748 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=4
>> rcu_bh:
>>   0 np=4 qsp=0 rpq=4 cbr=0 cng=0 gpc=0 gps=0 nf=0 nn=0
>> rcutorture test sequence: 0 (test in progress)
>> rcutorture update version number: 7004
>> cat: /sys/kernel/debug/rcu/rcuboost: No such file or directory
>> no rcuboost
>>
>
>
>
>
