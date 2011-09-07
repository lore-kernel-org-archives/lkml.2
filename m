Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab1IGVfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:35:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079Ab1IGVfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:35:23 -0400
Message-ID: <4E67E396.702@redhat.com>
Date: Wed, 07 Sep 2011 17:35:18 -0400
From: Jarod Wilson <jarod@redhat.com>
User-Agent: Postbox 2.5.2 (Macintosh/20110804)
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Steve Grubb <sgrubb@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>  <201109071630.15261.sgrubb@redhat.com> <1315427877.3576.46.camel@lappy>  <201109071656.49758.sgrubb@redhat.com> <1315429827.3576.61.camel@lappy>
In-Reply-To: <1315429827.3576.61.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin wrote:
> On Wed, 2011-09-07 at 16:56 -0400, Steve Grubb wrote:
>> On Wednesday, September 07, 2011 04:37:57 PM Sasha Levin wrote:
>>> On Wed, 2011-09-07 at 16:30 -0400, Steve Grubb wrote:
>>>> On Wednesday, September 07, 2011 04:23:13 PM Sasha Levin wrote:
>>>>> On Wed, 2011-09-07 at 16:02 -0400, Steve Grubb wrote:
>>>>>> On Wednesday, September 07, 2011 03:27:37 PM Ted Ts'o wrote:
>>>>>>> On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
>>>>>>>> We're looking for a generic solution here that doesn't require
>>>>>>>> re-educating every single piece of userspace. And anything done
>>>>>>>> in userspace is going to be full of possible holes -- there
>>>>>>>> needs to be something in place that actually *enforces* the
>>>>>>>> policy, and centralized accounting/tracking, lest you wind up
>>>>>>>> with multiple processes racing to grab the entropy.
>>>>>>> Yeah, but there are userspace programs that depend on urandom not
>>>>>>> blocking... so your proposed change would break them.
>>>>>> The only time this kicks in is when a system is under attack. If you
>>>>>> have set this and the system is running as normal, you will never
>>>>>> notice it even there. Almost all uses of urandom grab 4 bytes and
>>>>>> seed openssl or libgcrypt or nss. It then uses those libraries.
>>>>>> There are the odd cases where something uses urandom to generate a
>>>>>> key or otherwise grab a chunk of bytes, but these are still small
>>>>>> reads in the scheme of things. Can you think of any legitimate use
>>>>>> of urandom that grabs 100K or 1M from urandom? Even those numbers
>>>>>> still won't hit the sysctl on a normally function system.
>>>>> As far as I remember, several wipe utilities are using /dev/urandom to
>>>>> overwrite disks (possibly several times).
>>>> Which should generate disk activity and feed entropy to urandom.
>>> I thought you need to feed random, not urandom.
>> I think they draw from the same pool.
>
> There is a blocking and a non blocking pool.

There's a single shared input pool that both the blocking and 
non-blocking pools pull from. New entropy data is added to the input 
pool, then transferred to the interface-specific pools as needed.

>>> Anyway, it won't happen fast enough to actually not block.
>>>
>>> Writing 1TB of urandom into a disk won't generate 1TB (or anything close
>>> to that) of randomness to cover for itself.
>> We don't need a 1:1 mapping of RNG used to entropy acquired. Its more on the scale of
>> 8,000,000:1 or higher.
>
> I'm just saying that writing 1TB into a disk using urandom will start to
> block, it won't generate enough randomness by itself.

Writing 1TB of data to a disk using urandom won't block at all if nobody 
is using /dev/random. We seed /dev/urandom with entropy, then it just 
behaves as a Cryptographic RNG, its not pulling out any further entropy 
data until it needs to reseed, and thus the entropy count isn't dropping 
to 0, so we're not blocking. Someone has to actually drain the entropy, 
typically by pulling a fair bit of data from /dev/random, for the 
blocking to actually come into play.


> Why not implement it as a user mode CUSE driver that would
> wrap /dev/urandom and make it behave any way you want to? why push it
> into the kernel?

Hadn't considered CUSE. But it does have the issues Steve mentioned in 
his earlier reply.

Another proposal that has been kicked around: a 3rd random chardev, 
which implements this functionality, leaving urandom unscathed. Some 
udev magic or a driver param could move/disable/whatever urandom and put 
this alternate device in its place. Ultimately, identical behavior, but 
the true urandom doesn't get altered at all.


-- 
Jarod Wilson
jarod@redhat.com


