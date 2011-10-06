Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab1JFFMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:12:35 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51199 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1JFFMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:12:34 -0400
Message-ID: <4E8D388B.5020302@ce.jp.nec.com>
Date: Thu, 06 Oct 2011 14:11:39 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Mike Snitzer <snitzer@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
References: <20110722081903.GB7561@ics.muni.cz> <4E2A7806.1060601@ce.jp.nec.com> <20110724221619.GM16487@ics.muni.cz> <4E367256.8020206@ct.jp.nec.com> <20110908132756.GT31717@ics.muni.cz> <CAMM=eLd9fToJ5Kh+vf4WG1ZN-qTc2CX98-+BUkFWWQQ=tCG7LQ@mail.gmail.com> <20110916140839.GE7428@ics.muni.cz> <4E76D810.6010504@ce.jp.nec.com> <20110929205748.GX19004@ics.muni.cz> <4E8C11B0.30000@ce.jp.nec.com> <20111005103545.GQ14063@ics.muni.cz>
In-Reply-To: <20111005103545.GQ14063@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

On 10/05/11 19:35, Lukas Hejtmanek wrote:
> On Wed, Oct 05, 2011 at 05:13:36PM +0900, Jun'ichi Nomura wrote:
>>> yes, 3GB/s and only kwapd0 and kswapd1 is running, no kworker or ksoftirqd..
>>
>> Hmm.. did you find any difference in your profile this time?
> 
> not sure what do you mean.

With SLES 2.6.32.36-0.5-default kernel, you found ksoftirqd
spent most of the time in __blk_recalc_rq_segments, using
sysprof/oprofile. That's why my patch was effective for it.

My question is whether you see such difference between
no-multipath and multipath, in profile data of 3.0.3 (without my patch).

>> I'm trying to reproduce it myself but no success so far
>> (perhaps disks are not fast enough to saturate CPU on my test machine).
> 
> hmm, I have 80 SAS 2.0 disks and two E5640 @ 2.67GHz cpus. 
>  
>> As ksoftirqd in top implies your CPU4 gets too much I/O completions,
>> 'rq_affnity = 2' for both dm and SCSI devices might be a solution.
>> It'll distribute block completion softirqs to submitters and possibly
>> reduce the loads of the 1st CPU in the socket.
>> (See the commit below. It's a new feature of 3.1. Not available in 3.0...)
> 
> So what next? Should I try 3.1 kernel with this patch applied?

Please try 3.1 (without my patch) + 'rq_affinity = 2',
on both multipath and no-multipath.

If you still see performance difference and ksoftirqd
spends most of the time in __blk_recalc_rq_segments,
try 3.1 + my patch + 'rq_affinity = 2'.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
