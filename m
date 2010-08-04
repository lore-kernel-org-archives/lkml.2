Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0HDChX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:37:23 -0400
Received: from tuxonice.net ([74.207.252.127]:54374 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520Ab0HDChW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:37:22 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C58D25F.5030705@tuxonice.net>
Date: Wed, 04 Aug 2010 12:37:19 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
References: <1280465201.2600.10.camel@shrek.rexursive.com>	<1280486667.2608.1.camel@shrek.rexursive.com>	<4C534C9D.8000600@tuxonice.net>	<1280532174.2583.1.camel@shrek.rexursive.com>	<4C5362E7.3000706@tuxonice.net>	<1280538184.2583.11.camel@shrek.rexursive.com>	<4C537A01.5040808@tuxonice.net>	<1280540035.2658.5.camel@shrek.rexursive.com>	<1280551286.3097.6.camel@shrek.rexursive.com>	<20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>	<1280710453.2727.8.camel@shrek.rexursive.com>	<20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>	<1280712068.2671.0.camel@shrek.rexursive.com>	<20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>	<1280713381.2673.2.camel@shrek.rexursive.com>	<1280800750.3305.4.camel@shrek.rexursive.com>	<4C58C771.6040505@tuxonice.net>	<20100804110248.13a2452b.kamezawa.hiroyu@jp.fujitsu.com>	<1280888059.2741.8.camel@shrek.rexursive.com> <20100804111828.e4234160.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100804111828.e4234160.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 04/08/10 12:18, KAMEZAWA Hiroyuki wrote:
> On Wed, 04 Aug 2010 12:14:19 +1000
> Bojan Smojver<bojan@rexursive.com>  wrote:
>
>> On Wed, 2010-08-04 at 11:02 +0900, KAMEZAWA Hiroyuki wrote:
>>> Then, after resume, all vmalloc() area is resumed as "allocated".
>>>
>>> Wrong ?
>>
>> I actually tried remembering vmalloc() returned pointers into a global
>> variable as you suggested. On resume, they were always set to NULL,
>> which would suggest that what has gotten into the image was the state
>> before vmalloc() was called in save_image(). See:
>> http://lkml.org/lkml/2010/8/2/537.
>>
>> Anyone else wants to comment here?
>>
> Hmm, ok. let's see the result.
>
> The reason I mention about the race is my patch corrupts saved image
> by changing swap_map[] status and swap-cache radix-tree during save_image().
>
> Maybe I don't understand something important.

That's a different issue.

Remember that the snapshot includes more than just the running programs. 
It includes structs recording filesystem info and the state of swap. 
This is why we say you can't safely hibernate, use your filesystem from 
another kernel or OS, then resume. The use of the filesystem in another 
kernel/OS makes the state on disk inconsistent with the state in memory 
that we saved in our image. (I'm assuming it's written to or at least 
that the journal is replayed).

I'm not 100% sure, but it sounds like your issue is the same, but with 
swap. If you free a swap page post-snapshot and it gets used for (say) 
saving a page of the image, then you have a problem post-resume. The 
resumed kernel will think the swap state is still as it originally was 
and might try to swap back in the page of memory that was freed and used 
for the snapshot, creating in-memory corruption.

One solution is to allocate the swap for the image before the snapshot. 
This is what TuxOnIce does - it freezes processes, calculates the image 
statistics and uses them to allocate storage and free memory as 
necessary, writes the first part of the image then does the snapshot and 
writes the remainder. By doing things in this order, the only unknown is 
the amount of memory needed for drivers, and that can be handled pretty 
easily.

Regards,

Nigel
