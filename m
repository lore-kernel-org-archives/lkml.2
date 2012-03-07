Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2CGPts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:49:48 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38577 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2CGPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:49:46 -0500
Message-ID: <4F578388.7050603@linux.vnet.ibm.com>
Date: Wed, 07 Mar 2012 21:19:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "prashanth@linux.vnet.ibm.com" <prashanth@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "paulmck@linux.vnet.ibm.com >> \"Paul E. McKenney\"" 
	<paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at suspend/resume
References: <20120306204357.13169.90791.stgit@zurg> <4F5763CD.8050903@linux.vnet.ibm.com> <4F578176.9060808@openvz.org>
In-Reply-To: <4F578176.9060808@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030715-8878-0000-0000-00000192DBE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 09:10 PM, Konstantin Khlebnikov wrote:

> Srivatsa S. Bhat wrote:
>> On 03/07/2012 02:15 AM, Konstantin Khlebnikov wrote:
>>
>>> This is fix for suspend/resume regression introduced in commit
>>> 8f2f748b0656
>>> ("CPU hotplug, cpusets, suspend: Don't touch cpusets during
>>> suspend/resume")
>>> Without this patch suspend always hangs on my thinkpad x220 (2 x CPU
>>> * HT).
>>>
>>
>>
>> Hey, with commit 8f2f748b0656, suspend/resume works perfectly for me!
>> I ran it
>> multiple times just to make sure, and everything worked just great.
>>
>> Apart from that, I even tried suspend/resume after building the kernel
>> with
>> and without CONFIG_CPUSETS. Both cases worked perfectly.
>>
>> So, I am really surprised at what you stated above. Are you *really*
>> sure you
>> are facing suspend hangs *because* of the above commit?
>>
>> And AFAICS hardware doesn't matter for the code in question, but in
>> any case,
>> the laptop on which I tested it is:
>> Thinkpad T420 (Intel core i5-2540M), 2 cores * HT (total 4 logical cpus).
>>
>> Also, the patch you posted here doesn't make much sense.. nor does it
>> give a
>> clue as to what might be wrong at your end (if anything is really
>> wrong, that
>> is). Do you have CONFIG_CPUSETS set or unset? Could you share your
>> .config?
> 
> my kernel config in attachment. CONFIG_CPUSETS=n
> 
>>
>> Coming to your patch, assuming you have CONFIG_CPUSETS enabled, then,
>> calling rebuild_sched_domains() at that point is useless because the
>> cpusets
>> weren't changed at all. So generate_sched_domains() would generate the
>> same
>> sched domain partitions that is already there.. And hence
>> partition_sched_domains() would essentially do nothing.. no sched
>> domain is
>> destroyed, and no new domains are created.
>>
>> However, if CONFIG_CPUSETS is unset, then, before commit 8f2f748b0656,
>> partition_sched_domains(1, NULL, NULL) would have been invoked, thus
>> rebuilding
>> a single sched domain. And that is why I specifically also tested commit
>> 8f2f748b0656 with CONFIG_CPUSETS unset - and that also worked fine (as I
>> mentioned above).
>>
>> So could you please check again?
>>
>> By the way, you can use the pm-test framework (see
>> Documentation/power/basic-
>> pm-debugging.txt) to pin-point which stage is causing the hang.
>> Specifically, the stage where CPU hotplug is done is 'processors'.
>>
>> So you should probably try out this level:
>> # echo processors>  /sys/power/pm_test
>> # echo mem>  /sys/power/state
>>
>> Replacing processors with core enables even deeper level suspend testing.
> 
> Your patch has obvious side-effect.
> Bug reproducing is very stable, it disappears if revert your patch or
> apply mine.
> Problem may be not in your patch, it may only trigger some longstanding
> bug.


Thanks a lot for the confirmation! Let us revert commit 8f2f748b0656 then.

Regards,

Srivatsa S. Bhat

