Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab0JGPlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:41:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:33508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab0JGPlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:41:52 -0400
Message-ID: <4CADEA3D.3020800@kernel.org>
Date: Thu, 07 Oct 2010 17:41:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: -mm: xfs lockdep warning
References: <201009161546.16909.ruirui.r.yang@tieto.com>	<20100917005227.GJ24409@dastard>	<20100920191355.GA28443@infradead.org>	<AANLkTi=45J+=ytj=NC4bYTVJFRakNQQiFd35K7mrf+Gq@mail.gmail.com>	<4CA997DF.5030008@kernel.org>	<20101004092107.GJ4681@dastard>	<AANLkTi=3jjoCtYoK0endt8OM=omygO284WN2ZQZ=jceo@mail.gmail.com>	<4CAB5779.5020901@kernel.org>	<AANLkTineNfy+hfnK-sjHNB+h05oC4qbJ+81pg95Bmn=b@mail.gmail.com>	<4CAC366E.7070609@kernel.org>	<4CAC38D9.8020407@kernel.org>	<AANLkTikw=ObzgWu35fsuriC-jVrzDRHRfFJeT8-4-ndY@mail.gmail.com>	<4CAC934E.2030807@kernel.org>	<AANLkTinrBeMDyQJaYJFALTPpOgEaAy7yoPdyQ0Gpay3G@mail.gmail.com>	<4CACC0CD.5000001@kernel.org>	<4CADAB97.4020500@kernel.org>	<AANLkTikRZZMq9GkaCn_BB7H=F0iGj3P-XbiaEU3RoN5V@mail.gmail.com>	<4CADD3A3.5090401@kernel.org> <AANLkTikRn9hUb6dgGBGvF8czRxqLxm8utXR+iEN17cs1@mail.gmail.com>
In-Reply-To: <AANLkTikRn9hUb6dgGBGvF8czRxqLxm8utXR+iEN17cs1@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Oct 2010 15:41:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/07/2010 05:15 PM, Torsten Kaiser wrote:
> :-(
> The second try with the patched 2.6.36-rc6 got stuck again.

:-(

>> repeat the same test w/ 2.6.35 and see whether there's any noticeable
>> difference?
> 
> I just tested vanilla 2.6.35, userspace and the testcase as with the
> 2.6.36-rc6 kernel.
> Behavior was the same as with the first try of the patched 2.6.36-rc6:
> The testcase started to build up CPU load and memory pressure, then
> the mouse got stuck. After ~1 min the system recovered and KDE became
> usable again. (Compile just finish OK)
> 
> vmstat 60 from 2.6.35:
>  2  0      0 2365848   1060 742072    0    0   205     7 6467 12252 26  5 62  8
> 17  0      0 837936   1060 1079520    0    0  1025    24 2210 13483 69 20  8  2
> 18  0      0 694296   1060 1127728    0    0   231    14  626 1883 74 26  0  0
> 20  0      0 228540    124 998440    0    0    48    12  604 1820 72 28  0  0
> 23  1     24 195456     52 657216    0    0   339    11  563 1669 84 16  0  0
>  0 42 937144  14004      0 164352    0 15617   290 15633  827 1254 24  9  1 66
> 21  1 861184 776104      0 149908  998 3852  2790  3902 1137 2454 45 15  0 40
> 21  0 798544 1131964      0 190004  212    0   530    15  599 1469 87 13  0  0
> 12  1 779488 1536772      0 225312  195    0   398    12  534 1087 88 12  0  0
> 11  0 620620 2201408      0 273976 1338    0  1638    40  851 2281 75 19  3  3
> 12  1 588196 1572564      0 344232  521    0  1326   152  787 1888 86 14  0  0
>  8  0 510876 2286000      0 311464  127    0   442   398  758 1558 88 12  0  0
> 
>> Some level of stuttering is expected if the system is hit
>> with sudden huge spike of memory pressure but let's see if it has
>> regressed somehow.
> 
> Yes, if a swapstorm occurs, I can live with a (short) "lockup". For
> example compiling openoffice on tmpfs is a case where I have seen
> similar short periods of the mouse getting stuck. But with 2.6.36-rc5
> it was the first time that the system did not seem to recover, so I
> think it should count as a regression compared to 2.6.35.
> 
> As the second try with the patched 2.6.36-rc6 got stuck again, could
> it be that your patch is incomplete?
>>From drivers/md/dm-crypt.c:
>         cc->io_queue = create_singlethread_workqueue("kcryptd_io");
>         cc->crypt_queue = create_singlethread_workqueue("kcryptd");
> 
> Do these workqueues also need WQ_MEM_RECLAIM?

No, singlethread wq's are currently mapped to unbound wq's and
automatically HIGHPRI.

> I have attached the SysRq-M output from the patched -rc6. The symptoms
> were the same as with the unpatched kernel. The system got stuck, the
> hung_task_timeout triggered for a numer of programs in sync_page() or
> do_lookup() and one kworker/1:1:496 was probable the nail in the
> coffin.
>
> Do you want me to do more tests with 2.6.35 or the patched .36-rc6? Or
> any other patch I should try?

496 being stuck should be okay.  They are allowed to be stuck there
and that's exactly why we have the rescuers.  Can you please capture
the output of sysrq-t w/ the patch applied and hung trigger tripped?
I'd really like to know what the rescuers are doing.

Thanks.

-- 
tejun
