Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab1FFPCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:02:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64877 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1FFPCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:02:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iDE2LGRDcimUnF6Md0v5t34AgkDI7BXUG+xphzHPmWtveigE5hdQfhb6cPdhhANFV2
         63mVpzUrVFEnXEzgX2LW3PKRKIvEii9bFMJYCx2U334PDv3HXLLgBkvd4wPBduU28C5h
         uk07xK4EZ8fZW9KpOdsMtgKWuZUI51Oa2d8jc=
Message-ID: <4DECEBE6.3060302@gmail.com>
Date: Mon, 06 Jun 2011 17:01:58 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>	<4CE17C4B.1070305@xs4all.nl>	<20101115185848.GI2583@sunsite.ms.mff.cuni.cz>	<20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>	<AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>	<20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>	<4CE1968D.3050706@xs4all.nl>	<4DE8DC16.6030308@xs4all.nl>	<20110603133351.GA25130@srcf.ucam.org>	<4DE8EF13.9030609@xs4all.nl>	<20110603144644.GA26782@srcf.ucam.org>
In-Reply-To: <20110603144644.GA26782@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

2011/6/3 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Fri, Jun 03, 2011 at 04:26:27PM +0200, Jim Bos wrote:
>> On 06/03/2011 03:33 PM, Matthew Garrett wrote:
>> > ? You've got 143 boot services/code regions, which is more than I'd
>> > tested against, so I'm unsure whether we're overflowing something here.
>> >
>>
>> That's seems to be the only EFI patch in 2.6.39.1 and I effectively
>> removed by =not= applying (skipping) the parts of the 2.6.39.1 patch to
>> above 3 files.
>> So yes removing "x86, efi: Retain boot service code until after
>> switching to virtual mode" indeed fixes the problem for me.
>
> Ok, thanks. I'll look into that. Might be best to drop it from stable
> for the moment until I've made sure it works on machines with excessive
> maps.

Looking at your patch in 2.6.39.1

I see:
+               memblock_x86_reserve_range(start, start + size, "EFI Boot");

and to free it:
+               free_bootmem_late(start, size);

Maybe this is causing the pager issue on 3.0, can you test this patch?


efi: free memory with the correct call

Commit 916f676f8dc introduced a call to free_bootmem_late while it
reserves memory with memblock_x64_reserve_range
Fix this call to silence the swapper BUGs:

BUG: Bad page state in process swapper  pfn:00000

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0d3a4fa..d2eefaa 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -29,7 +29,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/efi.h>
-#include <linux/bootmem.h>
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
@@ -334,7 +333,7 @@ static void __init efi_free_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
-		free_bootmem_late(start, size);
+		memblock_x86_free_memory_in_range(start, start + size);
 	}
 }
 

--
~Maarten
