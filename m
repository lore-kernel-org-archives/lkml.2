Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1A0Ubz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:31:55 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:18026 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752691Ab1A0Uby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:31:54 -0500
Message-ID: <4D41D649.6020800@bluewatersys.com>
Date: Fri, 28 Jan 2011 09:32:09 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: gregkh@suse.de, rjw@sisk.pl, mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, joe@perches.com
Subject: Re: [PATCH 1/6] mm/page_alloc: use appropriate printk priority level
References: <20110125235700.GR8008@google.com> <1296084570-31453-2-git-send-email-msb@chromium.org> <4D40BD00.1090408@bluewatersys.com> <20110127042228.GX8008@google.com>
In-Reply-To: <20110127042228.GX8008@google.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 05:22 PM, Mandeep Singh Baines wrote:
> Ryan Mallon (ryan@bluewatersys.com) wrote:
>> On 01/27/2011 12:29 PM, Mandeep Singh Baines wrote:
>>> printk()s without a priority level default to KERN_WARNING. To reduce
>>> noise at KERN_WARNING, this patch set the priority level appriopriately
>>> for unleveled printks()s. This should be useful to folks that look at
>>> dmesg warnings closely.
>>>
>>> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
>>> ---
>>
>>> @@ -4700,33 +4700,36 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
>>>  	find_zone_movable_pfns_for_nodes(zone_movable_pfn);
>>>  
>>>  	/* Print out the zone ranges */
>>> -	printk("Zone PFN ranges:\n");
>>> +	printk(KERN_INFO "Zone PFN ranges:\n");
>>>  	for (i = 0; i < MAX_NR_ZONES; i++) {
>>>  		if (i == ZONE_MOVABLE)
>>>  			continue;
>>> -		printk("  %-8s ", zone_names[i]);
>>> +		printk(KERN_INFO "  %-8s ", zone_names[i]);
>>>  		if (arch_zone_lowest_possible_pfn[i] ==
>>>  				arch_zone_highest_possible_pfn[i])
>>>  			printk("empty\n");
>>
>> Should be printk(KERN_CONT ... (or pr_cont).
>>
>>>  		else
>>> -			printk("%0#10lx -> %0#10lx\n",
>>> +			printk(KERN_INFO "%0#10lx -> %0#10lx\n",
>>>  				arch_zone_lowest_possible_pfn[i],
>>>  				arch_zone_highest_possible_pfn[i]);
>>
>> The printk above doesn't have a trailing newline so this should be
>> printk(KERN_CONT ...
>>
>> There are a couple of other places in this patch series that also need
>> to be fixed in a similar manner.
>>
> 
> D'oh. Good catch;)
> 
> The KERN_INFO here was unintentional. I had intended to leave it out.
> The code I was looking at as a reference was just omitting KERN_ for
> continuations. But I take it that the convention is to use KERN_CONT.
> I'll fixup the patch series to use that.

I think in general it is nicer to use KERN_CONT because it explicitly
shows that there is a printk somewhere above with no trailing newline.

Note that include/linux/printk.h has this to say about KERN_CONT:

/*
 * Annotation for a "continued" line of log printout (only done after a
 * line that had no enclosing \n). Only to be used by core/arch code
 * during early bootup (a continued line is not SMP-safe otherwise).
 */

I'm guessing that the above is safe, but if you are fixing printks up
then it would be good to check that places using continued lines are safe.

> I tried to use pr_ wherever the file was already using it or where I was
> changing all printk()s. For files with many printk()s I just continued
> using printk() to keep the patch small and also to avoid mixing printk
> with pr_. However, if it is preferrable, I'm happy to replace all printk()s
> with pr_ in the files I touch in the series.

I'm not sure what the policy on changing printk to the pr_ variants is.
Cc'ed Joe Perches who knows more about such things.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
