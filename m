Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab1D1Po3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:44:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49990 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab1D1PoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Jad56UAERvOhwv+iW9LTJi4gOUWmsWuodHpOz81PfKpnAXk0P/2iv754se3nvUM2fh
         BFGp4iZMSqRpRGJitKoa2lP9uBd/A6LEOq/zsb375JiWOtYlaT8kkhBYnoR8pHy6L36d
         taGuOgqa+I4gPB6gFqhh9xo3qEGdtVB+bm/hQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com>
References: <20110426112756.GF4308@linux.vnet.ibm.com>
	<20110426183859.6ff6279b@neptune.home>
	<20110426190918.01660ccf@neptune.home>
	<BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
	<alpine.LFD.2.02.1104262314110.3323@ionos>
	<20110427081501.5ba28155@pluto.restena.lu>
	<20110427204139.1b0ea23b@neptune.home>
	<alpine.LFD.2.02.1104272351290.3323@ionos>
	<alpine.LFD.2.02.1104281051090.19095@ionos>
	<BANLkTinB5S7q88dch78i-h28jDHx5dvfQw@mail.gmail.com>
	<20110428102609.GJ2135@linux.vnet.ibm.com>
	<1303997401.7819.5.camel@marge.simson.net>
	<BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com>
Date: Thu, 28 Apr 2011 17:44:20 +0200
Message-ID: <BANLkTi=guS_Vc3XAs0xfp6tBZP4FxudFQg@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3SFiqPw032450

On Thu, Apr 28, 2011 at 5:28 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Thu, Apr 28, 2011 at 3:30 PM, Mike Galbraith <efault@gmx.de> wrote:
>> On Thu, 2011-04-28 at 03:26 -0700, Paul E. McKenney wrote:
>>> On Thu, Apr 28, 2011 at 11:45:03AM +0200, Sedat Dilek wrote:
>>> > Hi,
>>> >
>>> > not sure if my problem from linux-2.6-rcu.git#sedat.2011.04.23a is
>>> > related to the issue here.
>>> >
>>> > Just FYI:
>>> > I am here on a Pentium-M (uniprocessor aka UP) and still unsure if I
>>> > have the correct (optimal?) kernel-configs set.
>>> >
>>> > Paul gave me a script to collect RCU data and I enhanced it with
>>> > collecting SCHED data.
>>> >
>>> > In the above mentionned GIT branch I applied these two extra commits
>>> > (0001 requested by Paul and 0002 proposed by Thomas):
>>> >
>>> > patches/0001-Revert-rcu-restrict-TREE_RCU-to-SMP-builds-with-PREE.patch
>>> > patches/0002-sched-Add-warning-when-RT-throttling-is-activated.patch
>>> >
>>> > Furthermore, I have added my kernel-config file, scripts, patches and
>>> > logs (also output of 'cat /proc/cpuinfo').
>>> >
>>> > Hope this helps the experts to narrow down the problem.
>>>
>>> Yow!!!
>>>
>>> Now this one might well be able to hit the 950 millisecond limit.
>>> There are no fewer than 1,314,958 RCU callbacks queued up at the end of
>>> the test.  And RCU has indeed noticed this and cranked up the number
>>> of callbacks to be handled by each invocation of rcu_do_batch() to
>>> 2,147,483,647.  And only 15 seconds earlier, there were zero callbacks
>>> queued and the rcu_do_batch() limit was at the default of 10 callbacks
>>> per invocation.
>>
>> Yeah, yow.  Once the RT throttle hit, it stuck.
>>
>>  .clock                         : 1386824.201768
>>  .rt_nr_running                 : 2
>>  .rt_throttled                  : 1
>>  .rt_time                       : 950.132427
>>  .rt_runtime                    : 950.000000
>>           rcuc0     7         0.034118     10857    98         0.034118      1472.309646         0.000000 /
>> FF    1      1 R    R 0 [rcuc0]
>>  .clock                         : 1402450.997994
>>  .rt_nr_running                 : 2
>>  .rt_throttled                  : 1
>>  .rt_time                       : 950.132427
>>  .rt_runtime                    : 950.000000
>>           rcuc0     7         0.034118     10857    98         0.034118      1472.309646         0.000000 /
>> FF    1      1 R    R 0 [rcuc0]
>>
>> ...
>>
>>  .clock                         : 2707432.862374
>>  .rt_nr_running                 : 2
>>  .rt_throttled                  : 1
>>  .rt_time                       : 950.132427
>>  .rt_runtime                    : 950.000000
>>           rcuc0     7         0.034118     10857    98         0.034118      1472.309646         0.000000 /
>> FF    1      1 R    R 0 [rcuc0]
>>  .clock                         : 2722572.958381
>>  .rt_nr_running                 : 2
>>  .rt_throttled                  : 1
>>  .rt_time                       : 950.132427
>>  .rt_runtime                    : 950.000000
>>           rcuc0     7         0.034118     10857    98         0.034118      1472.309646         0.000000 /
>> FF    1      1 R    R 0 [rcuc0]
>>
>>
>
> Hi,
>
> OK, I tried with the patch proposed by Thomas (0003):
>
> patches/0001-Revert-rcu-restrict-TREE_RCU-to-SMP-builds-with-PREE.patch
> patches/0002-sched-Add-warning-when-RT-throttling-is-activated.patch
> patches/0003-sched-Remove-skip_clock_update-check.patch
>
> From the very beginning it looked as the system is "stable" due to:
>
>  .rt_nr_running                 : 0
>  .rt_throttled                  : 0
>
> This changed when I started a simple tar-job to save my kernel
> build-dir to an external USB-hdd.
> From...
>
>  .rt_nr_running                 : 1
>  .rt_throttled                  : 1
>
> ...To:
>
>  .rt_nr_running                 : 2
>  .rt_throttled                  : 1
>
> Unfortunately, reducing all activities to a minimum load, did not
> change from last known RT throttling state.
>
> Just noticed rt_time exceeds the value of 950 first time here:
>
>  .rt_nr_running                 : 1
>  .rt_throttled                  : 1
>  .rt_time                       : 950.005460
>
> Full data attchached as tarball.
>
> - Sedat -
>
> P.S.: Excerpt from
> collectdebugfs-v2_2.6.39-rc3-rcutree-sedat.2011.04.23a+.log (0:0 ->
> 1:1 -> 2:1)
>
> --
> rt_rq[0]:
>  .rt_nr_running                 : 0
>  .rt_throttled                  : 0
>  .rt_time                       : 888.893877
>  .rt_runtime                    : 950.000000
>
> runnable tasks:
>            task   PID         tree-key  switches  prio
> exec-runtime         sum-exec        sum-sleep
> ----------------------------------------------------------------------------------------------------------
> R            cat  2652    115108.993460         1   120
> 115108.993460         1.147986         0.000000 /
> --
> rt_rq[0]:
>  .rt_nr_running                 : 1
>  .rt_throttled                  : 1
>  .rt_time                       : 950.005460
>  .rt_runtime                    : 950.000000
>
> runnable tasks:
>            task   PID         tree-key  switches  prio
> exec-runtime         sum-exec        sum-sleep
> ----------------------------------------------------------------------------------------------------------
>           rcuc0     7         0.000000     56869    98
> 0.000000       981.385605         0.000000 /
> --
> rt_rq[0]:
>  .rt_nr_running                 : 2
>  .rt_throttled                  : 1
>  .rt_time                       : 950.005460
>  .rt_runtime                    : 950.000000
>
> runnable tasks:
>            task   PID         tree-key  switches  prio
> exec-runtime         sum-exec        sum-sleep
> ----------------------------------------------------------------------------------------------------------
>           rcuc0     7         0.000000     56869    98
> 0.000000       981.385605         0.000000 /
> --
>

As an addendum:

First call trace is seen after:

[  651.616057] sched: RT throttling activated
[  711.616033] INFO: rcu_sched_state detected stall on CPU 0 (t=15000 jiffies)

- Sedat -
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
