Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab1JEI3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:29:46 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:62864 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1JEI3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:29:45 -0400
Message-ID: <4E8C11B0.30000@ce.jp.nec.com>
Date: Wed, 05 Oct 2011 17:13:36 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Mike Snitzer <snitzer@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
References: <20110721132627.GY7561@ics.muni.cz> <4E291F28.2040609@ct.jp.nec.com> <20110722081903.GB7561@ics.muni.cz> <4E2A7806.1060601@ce.jp.nec.com> <20110724221619.GM16487@ics.muni.cz> <4E367256.8020206@ct.jp.nec.com> <20110908132756.GT31717@ics.muni.cz> <CAMM=eLd9fToJ5Kh+vf4WG1ZN-qTc2CX98-+BUkFWWQQ=tCG7LQ@mail.gmail.com> <20110916140839.GE7428@ics.muni.cz> <4E76D810.6010504@ce.jp.nec.com> <20110929205748.GX19004@ics.muni.cz>
In-Reply-To: <20110929205748.GX19004@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

On 09/30/11 05:57, Lukas Hejtmanek wrote:
> On Mon, Sep 19, 2011 at 02:50:08PM +0900, Jun'ichi Nomura wrote:
>>   2.6.32.36
>>     no-multipath:        2.8 GB/s
>>     multipath:           600 MB/s
>>     multipath w/ patch:  2.8-2.9 GB/s
>>
>>   3.0.3
>>     no-multipath:        ??
>>     multipath:           2.5 GB/s
>>     multipath w/ patch:  2.5 GB/s(?)
>>
>> Have you tried 3.0.3 without multipath?
> 
> yes, 3GB/s and only kwapd0 and kswapd1 is running, no kworker or ksoftirqd..

Hmm.. did you find any difference in your profile this time?

I'm trying to reproduce it myself but no success so far
(perhaps disks are not fast enough to saturate CPU on my test machine).

As ksoftirqd in top implies your CPU4 gets too much I/O completions,
'rq_affnity = 2' for both dm and SCSI devices might be a solution.
It'll distribute block completion softirqs to submitters and possibly
reduce the loads of the 1st CPU in the socket.
(See the commit below. It's a new feature of 3.1. Not available in 3.0...)

  commit 5757a6d76cdf6dda2a492c09b985c015e86779b1
  Author: Dan Williams <dan.j.williams@intel.com>
  Date:   Sat Jul 23 20:44:25 2011 +0200

    block: strict rq_affinity
    
    Some systems benefit from completions always being steered to the strict
    requester cpu rather than the looser "per-socket" steering that
    blk_cpu_to_group() attempts by default. This is because the first
    CPU in the group mask ends up being completely overloaded with work,
    while the others (including the original submitter) has power left
    to spare.
    
    Allow the strict mode to be set by writing '2' to the sysfs control
    file. This is identical to the scheme used for the nomerges file,
    where '2' is a more aggressive setting than just being turned on.
    
    echo 2 > /sys/block/<bdev>/queue/rq_affinity

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
