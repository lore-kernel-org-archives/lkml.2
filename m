Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0EJVRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:17:11 -0400
Received: from crca.org.au ([74.207.252.120]:60661 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0EJVRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:17:05 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BE877CB.30009@crca.org.au>
Date: Tue, 11 May 2010 07:16:59 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: Proposal for a new algorithm for reading & writing a hibernation
 image.
References: <4BE7475A.8030901@crca.org.au> <4BE82C4D.20404@tmr.com>
In-Reply-To: <4BE82C4D.20404@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill.

On 11/05/10 01:54, Bill Davidsen wrote:
> Nigel Cunningham wrote:
>> Hi all.
>>
>> Some discussions with Rafael a while ago (can't find the original
>> message now, sorry) got me thinking about whether there might be a
>> better way of writing a complete image of memory, particularly in the
>> context of KMS breaking existing TuxOnIce algorithms. I finally got
>> around to hammering out the algorithm last night, and thought I'd put
>> it out there for others to comment on, particularly since I'm no
>> expert on fault handling - it may be that what I'm thinking of is
>> impossible on the hardware we support.
>>
>> The algorithm I'm thinking of trying to implement goes as follows:
>>
>> When saving the image
>> =====================
>>
>> 1. Modify driver suspend and resume routines so that the freeing of
>> memory used for the storage of state is separated from restoring the
>> resume methods. This will allow us to get the drivers to save their
>> state prior to writing the image, without needing the memory allocated
>> for this purpose to be atomically copied.
>> 2. Prior to writing any of the image, also set up new 4k page tables
>> such that an attempt to make a change to any of the pages we're about
>> to write to disk will result in a page fault, giving us an opportunity
>> to flag the page as needing an atomic copy later. Once this is done,
>> write protection for the page can be disabled and the write that
>> caused the fault allowed to proceed.
>> 3. Write the entire contents of memory to disk.
>> 4. Disable secondary CPUs (no need to do the driver suspend/resume
>> again) and atomically copy pages that faulted while writing the image.
>> 5. Write atomically copied data to disk, giving a complete image on
>> disk of memory at the time of the atomic copy.
>>
>> When loading the image
>> ======================
>> 1. Locate and allocate pages that can have data directly loaded (ie
>> are free now and used in the saved image). These will be loaded
>> without an 'atomic restore'.
>> 2. For other pages:
>> As each page is loaded:
>> - Write protect existing data.
>> - If contents are the same as what is being loaded
>> Discard loaded version
>> If contents change after being write protected,
>> 1. make a copy of unmodified version to later atomically copy back.
>> 2. remove write protection
>> - If contents differ
>> 1. set up atomic restore later
>> 2. remove write protection
>> 3. After loading memory and determining what needs to be atomically
>> restored:
>> - Do drivers suspend, atomic restore as is done at the moment
>>
>> The main difficulties I see with the above are - apart from not being
>> sure that I can achieve the above with fault handling - are:
>>
>> 1. Memory requirements for the atomic copy wouldn't be known until the
>> point where we get to the atomic copy. I guess, though, that with most
>> things frozen, we'd expect the number to be reasonably consistent and
>> small.
>> 2. We also need extra memory for the driver suspend at resume time.
>> That said, since it's not otherwise needed, it could be the same
>> memory that's reserved for doing I/O and for atomically copied data
>> when writing the image.
>>
>> Are there other issues people can see that I might have missed?
>>
> I doubt you "missed" considering compression, but you didn't mention it.

Yeah. I was just focusing on the method of ensuring we get a consistent 
image. I'd be seeking in the first instance to modify the existing 
TuxOnIce code to work this way, so it would still have multithreaded 
I/O, compression and so on.

What I really want to do is work on patches to improve swsusp, but I 
have to keep the existing TuxOnIce users happy too :)

Regards,

Nigel
