Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab1GWBWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 21:22:55 -0400
Received: from shawmail.shawcable.com ([64.59.128.220]:40404 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1GWBWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 21:22:48 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 21:22:48 EDT
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=W1EbViUdRLrB3xZls61b9cpNy9JNgdRUyrcMJe3sx/g= c=1 sm=1
 a=W5tzhRmXAaIA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=oITwzJHm7LvCvV+zlaC6mA==:17 a=mJjC6ScEAAAA:8 a=VwQbUJbxAAAA:8
 a=sbPyZIEDq7rn96eqKDQA:9 a=w5uCj7jwrVlxaYQSctkA:7 a=CjuIK1q_8ugA:10
 a=x8gzFH9gYPwA:10 a=0kPLrQdw3YYA:10 a=2NEUOfxDfW4A:10 a=OVgFkghfmzAehRUQ:21
 a=aTsB0ev5Wm6NPDdk:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
X-IronPort-AV: E=Sophos;i="4.67,250,1309759200"; 
   d="scan'208";a="361899553"
X-reinject: true
References: <1311271641.14555.114.camel@calx> <m2pql2c0qz.fsf@firstfloor.org> <20110722163335.2df4f6ca@notabene.brown> <1311363269.14555.261.camel@calx> <20110722205922.GS8006@one.firstfloor.org> <1311369102.14555.268.camel@calx> <20110722214732.GW8006@one.firstfloor.org> <20110722221039.GB10749@fieldses.org> <20110722223158.GC10749@fieldses.org> <20110723085915.308ddc02@notabene.brown>
In-Reply-To: <20110723085915.308ddc02@notabene.brown>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <93A3B8BD-B4F0-4F07-8E34-7CCA08439AA6@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Andi Kleen <andi@firstfloor.org>,
        Matt Mackall <mpm@selenic.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8J2)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Nanosecond fs timestamp support: sad
Date: Fri, 22 Jul 2011 19:13:29 -0600
To: NeilBrown <neilb@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As an FYI, Lustre uses i_version to store the transaction number in which a file changed. It sets the i_version itself. If NFSv4 were to set i_version when it needs to transition the state of a file then it wouldn't cause overhead on filesystems that are not being used for NFS export.

I don't think timestamps can ever be completely safe for distributed state management, unless the kernel bends the rules on what a timestamp IS, e.g. by never reverting the ctime when the clock moves backward and such. 

Cheers, Andreas

On 2011-07-22, at 4:59 PM, NeilBrown <neilb@suse.de> wrote:

> On Fri, 22 Jul 2011 18:31:58 -0400 "J. Bruce Fields" <bfields@fieldses.org>
> wrote:
> 
>> On Fri, Jul 22, 2011 at 06:10:39PM -0400, bfields wrote:
>>> On Fri, Jul 22, 2011 at 11:47:32PM +0200, Andi Kleen wrote:
>>>> On Fri, Jul 22, 2011 at 04:11:42PM -0500, Matt Mackall wrote:
>>>>> On Fri, 2011-07-22 at 22:59 +0200, Andi Kleen wrote:
>>>>>>> Indeed. Only usefully exists on ext4 and requires extra system calls.
>>>>>> 
>>>>>> Not sure what you mean?  It's in stat(2), just like the timestamps.
>>>>> 
>>>>> I don't see anything that looks like a version or generation number in
>>>>> either the man pages, the asm-generic/stat.h, or glibc's asm/stat.h.
>>>>> Pointer?
>>>> 
>>>> Hmm you're right. I thought it was in there, but apparently not.
>>>> I think it should be added there though. We still have some unused 
>>>> fields.
>>> 
>>> But last I checked I thought it was only ext4 that actually incremented
>>> the i_version on IO, and even then only when given a (non-default) mount
>>> option.
>>> 
>>> My notes on what needs to be done there:
>>> 
>>>    - collect data to determine whether turning on i_version causes
>>>      any significant performance regressions.
>>>        - Last I talked to him, Ted Tso recommended running
>>>          Bonnie on a local disk, since it does a lot of little
>>>          writes, which is somewhat of a worst case, as it will
>>>          generate extra metadata updates for each write.
>>>          Compare total wall-clock time, number of iops, and
>>>          number of bytes (using some kind of block tracing).
>>>    - If there aren't any problems, turn it on by default, and we're
>>>      done.
>> 
>> (Well,and talk the other filesystem implementors into doing it.)
>> 
> 
> But does anyone apart from NFSv4 actually *want* i_version as opposed to the
> more-generally-useful precise timestamps?
> 
> If not, we probably should tell NFSv4 to use timestamps and focus on making
> them work well.
> ??
> 
> The timestamp used doesn't need to update ever nanosecond.  I think if it
> were just updated on every userspace->kernel transition  (or effective
> equivalents inside kernel threads) that would be enough capture all
> causality.  I wonder how that would be achieved..  I wonder if RCU machinery
> could help - doesn't it keep track of when threads schedule ... or something?
> 
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
