Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0IJFz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 01:55:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38605 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0IJFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 01:55:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4C89C803.10604@jp.fujitsu.com>
Date: Fri, 10 Sep 2010 14:54:11 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: "Patrick J. LoPresti" <lopresti@gmail.com>,
        Andreas Dilger <adilger@sun.com>, Chris Mason <chris.mason@oracle.com>,
        Jiri Olsa <jolsa@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] make file's timestamp more accurate
References: <4C7CC08A.9010302@jp.fujitsu.com> <1284049407.2762.19.camel@localhost.localdomain>
In-Reply-To: <1284049407.2762.19.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

(2010/09/10 1:23), john stultz wrote:
> On Tue, 2010-08-31 at 17:42 +0900, Satoru Takeuchi wrote:
>> linux has supported nanosecond order file's timestamp since 2.5.48.
>> However current file timestamp is got by current_fs_time() and
>> is only updated once a tick. It can't say true nanosecond accuracy.
>> In addition, gettimeofday() before a file operation updating
>> {a,c,m}time would outstrip file's timestamp because of the difference
>> about time source between gettimeofday() and file's timestamp.
>> A certain kind of application would corrupted by this problem.
>
> Applications mixing gettimeofday and filesystem timesamps can currently
> use clock_gettime(CLOCK_REALTIME_COARSE,...) - which returns tick
> granular timestamps, the same as the filesystem timestamps - method to
> avoid this issue.
>
> However, Patrick LoPresti (cc'ed) was working on a similar issue here
> connected to nfs.

Thank you for your comment.

Does it the following one? I overlooked it ;-(

http://lkml.org/lkml/2010/8/13/199

> Consider the following "revision 2" of my proposal:
>
> 1) Add a function pointer "current_fs_time" to struct super_block.
>
> 2) Replace all calls of the form:
>
>     current_fs_time(sb);
>
> with
>
>   sb->current_fs_time(sb);
>
>  3) Arrange for the default value to point to the current implementation.
>
> These first three could be one patch.  They change no functionality;
> they just enable the next step.
>
> Finally:
>
>   4) Add a mount option to cause sb->current_fs_time(sb) to use the
> hi-res implementation.

I like this Patrick's idea. Patrick, are you trying this patch now?
If so, I wait for you, and if no, I'll try to implement it.

Thanks,
Satoru

>
>> I attached a most simple patch fixing this problem here. However
>> it has several problems and I don't say it can be applied as is.
>> The most big two problems is the following:
>>
>>   - It would cause performance regression, especially in
>>     not TSC capable system.
>>   - Is gettimeofday()'s monotonicity reliable on all systems?
>
> It *should* be. But hardware issues can cause trouble here.
>
>> The relative discussion:
>> http://lkml.org/lkml/2010/7/13/443
>>
>> Does anybody have good idea? Should it be tunable, for example?
>
> I think the discussion from earlier suggested that this be configurable
> from a mount option so the performance/granularity trade-off can be
> managed there.
>
> Potential pot-holes on the road here: Although I guess doing this on a
> per-mount basis in the future could make it difficult for apps that use
> CLOCK_REALTIME_COARSE to function if fs granularity is increased. Some
> sort of CLOCK_REALTIME_FS could be introduced to map to whichever
> granularity is right, but that can only be done on a global basis.
> Hrm...
>
> thanks
> -john
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


