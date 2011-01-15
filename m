Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1AOT3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 14:29:45 -0500
Received: from smtp-out.google.com ([74.125.121.67]:36869 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1AOT3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 14:29:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NLJUJ+ldBpTKpAvQnQmlWi8p8Ba8ZwYZnpN0Vk3qow2OnXsm/NuMQjAYaCHppJWCTx
         pnxmcPfB/1pmpijbFKEA==
MIME-Version: 1.0
In-Reply-To: <1295101791.20231.11.camel@marge.simson.net>
References: <20110115015749.692623529@google.com> <1295101791.20231.11.camel@marge.simson.net>
From: Paul Turner <pjt@google.com>
Date: Sat, 15 Jan 2011 11:29:09 -0800
Message-ID: <AANLkTimbRwsC=JvFQw9mAQ9TM045vbNqyDsA3rvWvtxn@mail.gmail.com>
Subject: Re: [wake_afine fixes/improvements 0/3] Introduction
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 6:29 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Fri, 2011-01-14 at 17:57 -0800, Paul Turner wrote:
>> I've been looking at the wake_affine path to improve the group scheduling case
>> (wake affine performance for fair group sched has historically lagged) as well
>> as tweaking performance in general.
>>
>> The current series of patches is attached, the first of which should probably be
>> considered for 2.6.38 since it fixes a bug/regression in the case of waking up
>> onto a previously (group) empty cpu.  While the others can be considered more
>> forwards looking.
>>
>> I've been using an rpc ping-pong workload which is known be sensitive to poor affine
>> decisions to benchmark these changes, I'm happy to run these patches against
>> other workloads.  In particular improvements on reaim have been demonstrated,
>> but since it's not as stable a benchmark the numbers are harder to present in
>> a representative fashion.  Suggestions/pet benchmarks greatly appreciated
>> here.
>>
>> Some other things experimented with (but didn't pan out as a performance win):
>> - Considering instantaneous load on prev_cpu as well as current_cpu
>> - Using more gentle wl/wg values to reflect that they a task's contribution to
>> load_contribution is likely less than its weight.
>>
>> Performance:
>>
>> (througput is measured in txn/s across a 5 minute interval, with a 30 second
>> warmup)
>>
>> tip (no group scheduling):
>> throughput=57798.701988 reqs/sec.
>> throughput=58098.876188 reqs/sec.
>>
>> tip: (autogroup + current shares code and associated broken effective_load)
>> throughput=49824.283179 reqs/sec.
>> throughput=48527.942386 reqs/sec.
>>
>> tip (autogroup + old tg_shares code): [parity goal post]
>> throughput=57846.575060 reqs/sec.
>> throughput=57626.442034 reqs/sec.
>>
>> tip (autogroup + effective_load rewrite):
>> throughput=58534.073595 reqs/sec.
>> throughput=58068.072052 reqs/sec.
>>
>> tip (autogroup + effective_load + no affine moves for hot tasks):
>> throughput=60907.794697 reqs/sec.
>> throughput=61208.305629 reqs/sec.
>
> The effective_load() change is a humongous improvement for mysql+oltp.
> The rest is iffy looking on my box with this load.
>

Yes -- this one is definitely the priority, the other is more forward
looking since we've had some good gains with it internally.

> Looks like what will happen with NO_HOT_AFFINE if say two high frequency
> ping pong players are perturbed such that one lands non-affine, it will
> stay that way instead of recovering, because these will always be hot.
> I haven't tested that though, pure rumination ;-)
>

This is a  valid concern, the improvements we've seen have been with
many clients.  Thinking about it I suspect a better option might be to
just increase the imbalance_pct required for a hot task rather than
blocking the move entirely.  Will try this.

> mysql+oltp numbers
>
> unpatched v2.6.37-7185-g52cfd50
>
> clients              1          2          4          8         16         32         64        128        256
> noautogroup   11084.37   20904.39   37356.65   36855.64   35395.45   35585.32   33343.44   28259.58   21404.18
>              11025.94   20870.93   37272.99   36835.54   35367.92   35448.45   33422.20   28309.88   21285.18
>              11076.00   20774.98   36847.44   36881.97   35295.35   35031.19   33490.84   28254.12   21307.13
> 1        avg  11062.10   20850.10   37159.02   36857.71   35352.90   35354.98   33418.82   28274.52   21332.16
>
> autogroup     10963.27   20058.34   23567.63   29361.08   29111.98   29731.23   28563.18   24151.10   18163.00
>              10754.92   19713.71   22983.43   28906.34   28576.12   30809.49   28384.14   24208.99   18057.34
>              10990.27   19645.70   22193.71   29247.07   28763.53   30764.55   28912.45   24143.41   18002.07
> 2        avg  10902.82   19805.91   22914.92   29171.49   28817.21   30435.09   28619.92   24167.83   18074.13
>                  .985       .949       .616       .791       .815       .860       .856       .854       .847
>
> patched v2.6.37-7185-g52cfd50
>
> noautogroup   11095.73   20794.49   37062.81   36611.92   35444.55   35468.36   33463.56   28236.18   21255.67
>              11035.59   20649.44   37304.91   36878.34   35331.63   35248.05   33424.15   28147.17   21370.39
>              11077.88   20653.92   37207.26   37047.54   35441.78   35445.02   33469.31   28050.80   21306.89
>         avg  11069.73   20699.28   37191.66   36845.93   35405.98   35387.14   33452.34   28144.71   21310.98
> vs 1             1.000       .992      1.000       .999      1.001      1.000      1.001       .995       .999
>
> noautogroup   10784.89   20304.49   37482.07   37251.63   35556.21   35116.93   32187.66   27839.60   21023.17
> NO_HOT_AFFINE 10627.17   19835.43   37611.04   37168.37   35609.65   35289.32   32331.95   27598.50   21366.97
>              10378.76   19998.29   37018.31   36888.67   35633.45   35277.39   32300.37   27896.24   21532.09
>         avg  10596.94   20046.07   37370.47   37102.89   35599.77   35227.88   32273.32   27778.11   21307.41
> vs 1              .957       .961      1.005      1.006      1.006       .996       .965       .982       .998
>
> autogroup     10452.16   19547.57   36082.97   36653.02   35251.51   34099.80   31226.18   27274.91   20927.65
>              10586.36   19931.37   36928.99   36640.64   35604.17   34238.38   31528.80   27412.44   20874.03
>              10472.72   20143.83   36407.91   36715.85   35481.78   34332.42   31612.57   27357.18   21018.63
> 3        avg  10503.74   19874.25   36473.29   36669.83   35445.82   34223.53   31455.85   27348.17   20940.10
> vs 1              .949       .953       .981       .994      1.002       .967       .941       .967       .981
> vs 2              .963      1.003      1.591      1.257      1.230      1.124      1.099      1.131      1.158
>
> autogroup     10276.41   19642.90   36790.86   36575.28   35326.89   34094.66   31626.82   27185.72   21017.51
> NO_HOT_AFFINE 10305.91   20027.66   37017.90   36814.35   35452.63   34268.32   31399.49   27353.71   21039.37
>              11013.96   19977.08   36984.17   36661.80   35393.99   34141.05   31246.47   26960.48   20873.94
>         avg  10532.09   19882.54   36930.97   36683.81   35391.17   34168.01   31424.26   27166.63   20976.94
> vs 1              .952       .953       .993       .995      1.001       .966       .940       .960       .983
> vs 2              .965      1.003      1.611      1.257      1.228      1.122      1.097      1.124      1.160
> vs 3             1.002      1.000      1.012      1.000       .998       .998       .998       .993      1.001
>
>
>
