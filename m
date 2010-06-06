Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0FFHBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 03:01:53 -0400
Received: from crca.org.au ([74.207.252.120]:60791 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0FFHBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 03:01:52 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C0B47D8.2070807@crca.org.au>
Date: Sun, 06 Jun 2010 17:01:44 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm
 for reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <201006052121.45816.rjw@sisk.pl> <4C0AD5BF.3030204@crca.org.au> <201006060120.45682.rjw@sisk.pl>
In-Reply-To: <201006060120.45682.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

On 06/06/10 09:20, Rafael J. Wysocki wrote:
> On Sunday 06 June 2010, Nigel Cunningham wrote:
>> On 06/06/10 05:21, Rafael J. Wysocki wrote:
>>> On Saturday 05 June 2010, Maxim Levitsky wrote:
>>>> On Sat, 2010-06-05 at 20:45 +0200, Rafael J. Wysocki wrote:
>>>>> On Saturday 05 June 2010, Nigel Cunningham wrote:
>>>>>> Hi again.
>>>>>>
>>>>>> As I think about this more, I reckon we could run into problems at
>>>>>> resume time with reloading the image. Even if some bits aren't modified
>>>>>> as we're writing the image, they still might need to be atomically
>>>>>> restored. If we make the atomic restore part too small, we might not be
>>>>>> able to do that.
>>>>>>
>>>>>> So perhaps the best thing would be to stick with the way TuxOnIce splits
>>>>>> the image at the moment (page cache / process pages vs 'rest'), but
>>>>>> using this faulting mechanism to ensure we do get all the pages that are
>>>>>> changed while writing the first part of the image.
>>>>>
>>>>> I still don't quite understand why you insist on saving the page cache data
>>>>> upfront and re-using the memory occupied by them for another purpose.  If you
>>>>> dropped that requirement, I'd really have much less of a problem with the
>>>>> TuxOnIce's approach.
>>>> Because its the biggest advantage?
>>>
>>> It isn't in fact.
>>
>> Because saving a complete image of memory gives you a much more
>> responsive system, post-resume - especially if (as is likely) you're
>> going to keep doing the same work post-resume that you were doing
>> pre-hibernate.
>
> We've given that argument for (at least) 100 times already and I still claim
> that the user won't see a difference between putting 80% and 95% of RAM
> contents into the image (you don't save 100%, at least not every time).

On 64 bit operating systems, saving 100% of the image - even with full 
ram - is the entirely possible and in my experience the norm. For the 
last month or so, I've been running a 32 bit OS again on my 64 bit 
laptop, and have been seeing it free memory more often because of the 
constraints highmem includes (I haven't gotten around to trying those 
changes you made which might help in this regard).

Whether running 32 bit or 64, the part of the image that's saved prior 
to the atomic copy usually accounts for around (going off progress bars) 
80-95% of the image. This is why - for 64 bit at least - it's rare to 
have to free memory. The atomically copied part easily fits in the 
memory that's already been saved.

So the main reasons for not saving 100% of the image would be:

1) The user said they don't want 100% saved (image size limit sysfs entry)
2) Insufficient storage (user choice)
3) 32 bit OS with highmem constraints (which I'll hopefully deal with soon).

>> Saving a complete image means it's for all intents and
>> purposes just as if you'd never done the hibernation. Dropping page
>> cache, on the other hand, slows things down post-resume because it has
>> to be repopulated - and the repopulation takes longer than reading the
>> pages as part of the image because they're not compressed and there's
>> extra work required to get the pages back in.
>
> I'm not talking about dropping the page cache, but about keeping it in place
> and saving as a part of the image - later.  The part I think is too complicated
> is the re-using of that memory for creating the "atomic" image.  That in my
> opinion really goes too far and causes things to be excessively fragile -
> without a really good reason (it is like "we do that because we can" IMO).

First, it's not fragile. All it depends on is the freezer being 
effective, just as the other parts of hibernation depend on the freezer 
being effective. Checksumming has been used to confirm that the contents 
of memory haven't changed prior to this page fault idea. I can think of 
examples where pages have been found to have changed, but they're few 
and far between, and easily addressed by resaving the affected pages in 
the atomic copy.

Second, it's not done without reason or simply because we can. It's done 
because it's been proven to make it more likely for us to be able to 
hibernate successfully in the first place AND gives us a more responsive 
system post-resume.

We haven't mentioned the first part so far, so let me go into more 
detail there. The problem with not doing things the TuxOnIce way is that 
you when you have more than (say) 80% of memory in use, you MUST free 
memory. Depending upon your workload, that simply might not be possible. 
In other cases, the only way to free memory might be to swap it out, but 
you're then reducing the amount of storage available for the image, 
which means you have to free more memory again, which means... For 
maximum reliability, you need an algorithm wherein you can save the 
contents of memory as they are at the start of the cycle.

>>>> Really saving whole memory makes huge difference.
>>>
>>> You don't have to save the _whole_ memory to get the same speed (you don't
>>> do that anyway, but the amount of data you don't put into the image with
>>> TuxOnIce is smaller).  Something like 80% would be just sufficient IMO and
>>> then (a) the level of complications involved would drop significantly and (2)
>>> you'd be able to use the image-reading code already in the kernel without
>>> any modifications.  It really looks like a win-win to me, doesn't it?
>>
>> It is certainly true that you'll notice the effect less if you save 80%
>> of memory instead of 40%, but how much you'll be affected is also
>> heavily influenced by your amount of memory and how you're using it. If
>> you're swapping heavily or don't have much memory (embedded), freeing
>> memory might not be an option.
>
> I don't think you have any practical example of anything like this, do you?

I don't have one right now that I can copy and paste, but it wouldn't be 
hard at all to show the effect of eating more or less memory by running 
a range of image size limits with timed kernel compiles afterwards. To 
prove the second part of my statement, I'd have to boot with mem=. I 
certainly don't see it with 4GB of memory, but I'm writing out of 
recollections from when I worked hard on reliability while still having 
a laptop with 1GB of RAM and users who often had less. Hmmm... I wonder 
if I can find archived email list discussions from that period. If you 
insist, I'll go looking :)

>> At the end of the day, I would argue that the user knows best, and this
>> should be a tuneable. This is, in fact the way TuxOnIce has done it for
>> years: the user can use a single sysfs entry to set a (soft) image size
>> limit in MB (values 1 and up), tell TuxOnIce to only free memory if
>> needed (0), abort if freeing memory is necessary (-1) or drop caches (-2).
>>
>> I do agree that doing a single atomic copy and saving the result makes
>> for a simpler algorithm, but I've always been of the opinion that we're
>> writing code to satisfy real work needs and desires, not our own desires
>> for simpler or easier to understand algorithms. Doing the bare minimum
>> isn't an option for me.
>
> I'm not talking about that!
>
> In short, if your observation that the page cache doesn't really change during
> hibernation is correct, then it should be possible to avoid making an atomic
> copy of it and to save it directly from its original locations.  I think that
> would allow us to save about 80% of memory in the majority of cases without
> the entire complexity that makes things extremely fragile and depends haevily
> on the current (undocumented) behavior of our mm subsystem that _happens_
> to be favourable to TuxOnIce.  HTH

I'm not sure what this current undocumented behaviour is. All I'm 
relying on is the freezer working and the mm subsystem not deciding to 
free process pages or LRU for no good reason. Remember that kswapd is 
also frozen.

Regards,

Nigel
