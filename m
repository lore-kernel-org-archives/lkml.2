Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab1LNXeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:34:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64345 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab1LNXd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:33:59 -0500
Message-ID: <4EE93262.2030206@gmail.com>
Date: Thu, 15 Dec 2011 00:33:54 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Mike Waychison <mikew@google.com>,
        Andi Kleen <andi@firstfloor.org>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86, efi: Break up large initrd reads
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>  <1318848017-12301-11-git-send-email-matt@console-pimps.org>  <4E9C8AAC.7080803@gmail.com>  <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECC4207.3010607@gmail.com>  <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECE5803.3060203@gmail.com>  <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECEF144.8020303@gmail.com> <1322210899.24448.66.camel@mfleming-mobl1.ger.corp.intel.com> <4EE689D5.4070600@zytor.com> <4EE798CF.7080903@linux.intel.com>
In-Reply-To: <4EE798CF.7080903@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On 12/13/2011 07:26 PM, H. Peter Anvin wrote:
> On 12/12/2011 03:10 PM, H. Peter Anvin wrote:
>> On 11/25/2011 12:48 AM, Matt Fleming wrote:
>>> On Fri, 2011-11-25 at 02:37 +0100, Maarten Lankhorst wrote:
>>>> The efi boot stub tries to read the entire initrd in 1 go,
>>>> however some efi implementations hang if too much if asked
>>>> to read too much data at the same time. After some
>>>> experimentation I found out that my asrock p67 board will
>>>> hang if asked to read chunks of 4mb, so use a safe value.
>>>>
>>>> From elilo source code:
>>>> /*
>>>>  * We load by chunks rather than a single big read because
>>>>  * early versions of EFI had troubles loading files
>>>>  * from floppies in a single big request.  Breaking
>>>>  * the read down into chunks of 4KB fixed that
>>>>  * problem. While this problem has been fixed, we still prefer
>>>>  * this method because it tells us whether or not we're making
>>>>  * forward progress.
>>>>  */
>>>>
>>>> While the comment says 4KB, it's using 4 * EFI_PAGE_SIZE (16KB),
>>>> so I went by the safest route of following elilo here.
>>>>
>> I'm going to NAK this, because I think the performance impact is too
>> severe.  I would like to set the cap at 1 MiB for now, unless we can
>> identify platforms where *that* is known to fail.
>>
>> Maarten, would you be willing to rev your patch?  Furthermore, please
>> make the maximum chunksize a define.
>>
> One more thing, Maarten: could you please provide the full DMI
> information of the affected system?
>
When I was testing in increments of 1 mb, 4 mb was the magic number that caused a hang.
My system runs fine with 1mb and my original patch used that as blocksize.

What dmi information do you need? Top 2 entries from dmidecode, in case that's sufficient:

Handle 0x0001, DMI type 1, 27 bytes
System Information
        Manufacturer: To Be Filled By O.E.M.
        Product Name: To Be Filled By O.E.M.
        Version: To Be Filled By O.E.M.
        Serial Number: To Be Filled By O.E.M.
        UUID: 03000200-0400-0500-0006-000700080009
        Wake-up Type: Power Switch
        SKU Number: To Be Filled By O.E.M.
        Family: To Be Filled By O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
        Manufacturer: ASRock
        Product Name: P67 Pro3
        Version:                      
        Serial Number:                      
        Asset Tag:                      
        Features:
                Board is a hosting board
                Board is replaceable
        Location In Chassis:                      
        Chassis Handle: 0x0003
        Type: Motherboard
        Contained Object Handles: 0

But I suspect the other p67 boards from asrock would be affected by the 4mb crash  too.

~Maarten
