Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab0FEWzD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:55:03 -0400
Received: from crca.org.au ([74.207.252.120]:47963 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614Ab0FEWy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:54:59 -0400
X-Bogosity: Ham, spamicity=0.000001
Message-ID: <4C0AD5BF.3030204@crca.org.au>
Date: Sun, 06 Jun 2010 08:54:55 +1000
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
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <201006052045.19889.rjw@sisk.pl> <1275765021.12828.2.camel@maxim-laptop> <201006052121.45816.rjw@sisk.pl>
In-Reply-To: <201006052121.45816.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 06/06/10 05:21, Rafael J. Wysocki wrote:
> On Saturday 05 June 2010, Maxim Levitsky wrote:
>> On Sat, 2010-06-05 at 20:45 +0200, Rafael J. Wysocki wrote:
>>> On Saturday 05 June 2010, Nigel Cunningham wrote:
>>>> Hi again.
>>>>
>>>> As I think about this more, I reckon we could run into problems at
>>>> resume time with reloading the image. Even if some bits aren't modified
>>>> as we're writing the image, they still might need to be atomically
>>>> restored. If we make the atomic restore part too small, we might not be
>>>> able to do that.
>>>>
>>>> So perhaps the best thing would be to stick with the way TuxOnIce splits
>>>> the image at the moment (page cache / process pages vs 'rest'), but
>>>> using this faulting mechanism to ensure we do get all the pages that are
>>>> changed while writing the first part of the image.
>>>
>>> I still don't quite understand why you insist on saving the page cache data
>>> upfront and re-using the memory occupied by them for another purpose.  If you
>>> dropped that requirement, I'd really have much less of a problem with the
>>> TuxOnIce's approach.
>> Because its the biggest advantage?
>
> It isn't in fact.

Because saving a complete image of memory gives you a much more 
responsive system, post-resume - especially if (as is likely) you're 
going to keep doing the same work post-resume that you were doing 
pre-hibernate. Saving a complete image means it's for all intents and 
purposes just as if you'd never done the hibernation. Dropping page 
cache, on the other hand, slows things down post-resume because it has 
to be repopulated - and the repopulation takes longer than reading the 
pages as part of the image because they're not compressed and there's 
extra work required to get the pages back in.

>> Really saving whole memory makes huge difference.
>
> You don't have to save the _whole_ memory to get the same speed (you don't
> do that anyway, but the amount of data you don't put into the image with
> TuxOnIce is smaller).  Something like 80% would be just sufficient IMO and
> then (a) the level of complications involved would drop significantly and (2)
> you'd be able to use the image-reading code already in the kernel without
> any modifications.  It really looks like a win-win to me, doesn't it?

It is certainly true that you'll notice the effect less if you save 80% 
of memory instead of 40%, but how much you'll be affected is also 
heavily influenced by your amount of memory and how you're using it. If 
you're swapping heavily or don't have much memory (embedded), freeing 
memory might not be an option.

At the end of the day, I would argue that the user knows best, and this 
should be a tuneable. This is, in fact the way TuxOnIce has done it for 
years: the user can use a single sysfs entry to set a (soft) image size 
limit in MB (values 1 and up), tell TuxOnIce to only free memory if 
needed (0), abort if freeing memory is necessary (-1) or drop caches (-2).

I do agree that doing a single atomic copy and saving the result makes 
for a simpler algorithm, but I've always been of the opinion that we're 
writing code to satisfy real work needs and desires, not our own desires 
for simpler or easier to understand algorithms. Doing the bare minimum 
isn't an option for me. That's why I started trying to improve swsusp in 
the first place, and why I kept working on it even through the 
difficulties I've had with Pavel and times when I've really just wanted 
to drop the whole thing.

Saving the image in two parts isn't inherently unreliable, Rafael. Even 
the recent KMS changes haven't broken TuxOnIce - the kernel bugzilla 
report turned out to be KMS breakage, not TuxOnIce (I didn't change 
anything in TuxOnIce, and it started working again in 2.6.34). Yes, this 
isn't a guarantee that something in the future won't break TuxOnIce, but 
it does show (and especially when you remember that it's worked this way 
without issue for something like 8 or 9 years) that the basic concept 
isn't inherently flaws. The page faulting idea is, I think, the last 
piece of the puzzle to make it perfectly reliable, regardless of what 
changes are made in the future.

Regards,

Nigel
