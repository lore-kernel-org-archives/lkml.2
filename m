Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab0HDCZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:25:01 -0400
Received: from tuxonice.net ([74.207.252.127]:58449 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab0HDCZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:25:00 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C58CF79.4000406@tuxonice.net>
Date: Wed, 04 Aug 2010 12:24:57 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
References: <1280465201.2600.10.camel@shrek.rexursive.com>	<1280486667.2608.1.camel@shrek.rexursive.com>	<4C534C9D.8000600@tuxonice.net>	<1280532174.2583.1.camel@shrek.rexursive.com>	<4C5362E7.3000706@tuxonice.net>	<1280538184.2583.11.camel@shrek.rexursive.com>	<4C537A01.5040808@tuxonice.net>	<1280540035.2658.5.camel@shrek.rexursive.com>	<1280551286.3097.6.camel@shrek.rexursive.com>	<20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>	<1280710453.2727.8.camel@shrek.rexursive.com>	<20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>	<1280712068.2671.0.camel@shrek.rexursive.com>	<20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>	<1280713381.2673.2.camel@shrek.rexursive.com>	<1280800750.3305.4.camel@shrek.rexursive.com>	<4C58C771.6040505@tuxonice.net> <20100804110248.13a2452b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100804110248.13a2452b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 04/08/10 12:02, KAMEZAWA Hiroyuki wrote:
> On Wed, 04 Aug 2010 11:50:41 +1000
> Nigel Cunningham<nigel@tuxonice.net>  wrote:
>
>> Hi.
>>
>> Sorry for the delay in replying.
>>
>> On 03/08/10 11:59, Bojan Smojver wrote:
>>>>  From all this, I only got "In swsusp_free()" printed on resume. So, it
>>> seems that save_image() does indeed free those vmalloc()-ed buffers and
>>> they are not saved in the image.
>>>
>>> I even put this in hibernate.c:
>>> ---------------------
>>>           /* Restore control flow magically appears here */
>>>           restore_processor_state();
>>>           if (!in_suspend)
>>>                   platform_leave(platform_mode);
>>>
>>>           printk(KERN_ERR "Resumed, checking swsusp_lzo_buffers.\n");
>>>           if (swsusp_lzo_buffers) {
>>>                   printk (KERN_ERR "Setting vmalloc() buffers.\n");
>>>                   memset(swsusp_lzo_buffers, 0, 80 * PAGE_SIZE);
>>>           }
>>> ---------------------
>>>
>>> This printed just "Resumed, checking swsusp_lzo_buffers.", meaning it
>>> was already set to NULL.
>>>
>>> Any further comments on this? Nigel, what do you reckon?
>>
>> I don't see what all the fuss was about. save_image is called after the
>> snapshot is made (hibernate called hibernation_snapshot to create the
>> image, then swsusp_write which in turn calls save_image), so there's no
>> possibility of the memory allocated by it being included in the image or
>> of a memory leak ocuring as a result.
>>
>
> I'm sorry if I'm wrong. Here is logic in my mind. (I'm reading hibernate(void).
> not sure about user.c )
> (linenumber is from 2.6.34 global, plz ignore)

Yeah, I'm ignoring uswsusp too. That shouldn't matter.

>   624         error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
>   625         if (error)
>   626                 goto Thaw;
>   627
>   628         if (in_suspend) {
>   629                 unsigned int flags = 0;
>   630
>   631                 if (hibernation_mode == HIBERNATION_PLATFORM)
>   632                         flags |= SF_PLATFORM_MODE;
>   633                 pr_debug("PM: writing image.\n");
>   634                 error = swsusp_write(flags);
>
> Then, swsusp_write() actually writes image to the disk. Right ?

Yes

> It finally calls save_image(). save_image() executes following loop.
>
>   433         while (1) {
>   434                 ret = snapshot_read_next(snapshot, PAGE_SIZE);
>   435                 if (ret<= 0)
>   436                         break;
>   437                 ret = swap_write_page(handle, data_of(*snapshot),&bio);
>   438                 if (ret)
>   439                         break;
>   440                 if (!(nr_pages % m))
>   441                         printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
>   442                 nr_pages++;
>   443         }
>
> Ok, here, the image written to disk is got by snapshot_read_next().
> Then, what it does ?
>
> ==
> 1650                         page = pfn_to_page(memory_bm_next_pfn(&copy_bm));
> 1651                         if (PageHighMem(page)) {
> 1652                                 /* Highmem pages are copied to the buffer,
> 1653                                  * because we can't return with a kmapped
> 1654                                  * highmem page (we may not be called again).
> 1655                                  */
> 1656                                 void *kaddr;
> 1657
> 1658                                 kaddr = kmap_atomic(page, KM_USER0);
> 1659                                 memcpy(buffer, kaddr, PAGE_SIZE);
> 1660                                 kunmap_atomic(kaddr, KM_USER0);
> 1661                                 handle->buffer = buffer;
> 1662                         } else {
> 1663                                 handle->buffer = page_address(page);
> 1664                         }
> ==
>
> Ok, what actually written to disk is an image of memory at save_image() is
> called.
>
> What happens at vmalloc ?
> 	1. page tabels for vmalloc() is set up.
> 	2. vm_struct object is allocated.
> 	3. vmap is allcoated.
>
> Above "3" states are all saved into the disk image, as "used".
>
> Then, after resume, all vmalloc() area is resumed as "allocated".
>
> Wrong ?

Yes, because what's being written is the snapshot that was created in 
hibernation_snapshot. Any memory you allocate afterwards is irrelevant 
because it's not part of that snapshot that was made earlier and is now 
being written to disk. Think of the point where hibernation_snapshot is 
called as being like taking a photo, and this later part as like 
printing the photo. Once you've taken the photo, people in the photo can 
move around without making any difference to the photo you've taken. So 
here. Our vmallocs and so on after the snapshot don't affect it.

Regards,

Nigel
