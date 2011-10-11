Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1JKXUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 19:20:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62432 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1JKXUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 19:20:50 -0400
MIME-Version: 1.0
In-Reply-To: <4E94BC46.5080505@xenotime.net>
References: <1172297901.46681.1318361517579.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
	<4E94BC46.5080505@xenotime.net>
Date: Wed, 12 Oct 2011 08:20:48 +0900
Message-ID: <CAKYAXd86Hvq5SEVvmf4M99smeXbDiUsS+ASXy9-U7xmrREGjvQ@mail.gmail.com>
Subject: Re: mmc core broken dependency on CONFIG_BLOCK (Was: linux-next: Tree
 for Oct 11 (mmc))
From: NamJae Jeon <linkinjeon@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Andrei Warkentin <awarkentin@vmware.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/12 Randy Dunlap <rdunlap@xenotime.net>:
> On 10/11/11 12:31, Andrei Warkentin wrote:
>> Hi Randy,
>>
>> ----- Original Message -----
>>> From: "Randy Dunlap" <rdunlap@xenotime.net>
>>> To: "Stephen Rothwell" <sfr@canb.auug.org.au>
>>> Cc: linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org, "Chris Ball"
>>> <cjb@laptop.org>
>>> Sent: Tuesday, October 11, 2011 2:49:39 PM
>>> Subject: Re: linux-next: Tree for Oct 11 (mmc)
>>>
>>> On 10/11/11 02:11, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> The linux-next tree is now available from
>>>> git://github.com/sfrothwell/linux-next.git as a temporary measure
>>>> while
>>>> the kernel.org servers are unavailable.
>>>>
>>>> It may also turn up on git.kernel.org (depending on the mirroring).
>>>>  The
>>>> patch set is still absent, however.
>>>>
>>>> Changes since 20111007:
>>>
>>>
>>> When CONFIG_BLOCK is not enabled:
>>>
>>> In file included from
>>> next-2011-1011/drivers/mmc/card/sdio_uart.c:43:0:
>>> next-2011-1011/include/linux/mmc/card.h:175:12: error:
>>> 'DISK_NAME_LEN' undeclared here (not in a function)
>>>
>>> Deleting the #include <linux/mmc/card.h> fixes the sdio_uart.c build.
>>> However, the same problem occurs in mmc/core/core.c:
>>>
>>
>> Because linux/genhd is now included, oops. I'm pretty positive this is due to the "mmc : general purpose partition support" patch pulled recently. I am adding NamJae, who was the author.
>>
>>> In file included from next-2011-1011/drivers/mmc/core/core.c:30:0:
>>> next-2011-1011/include/linux/mmc/card.h:175:12: error:
>>> 'DISK_NAME_LEN' undeclared here (not in a function)
>>>
>>> Should mmc/core/ depend on BLOCK?  or should it just be made
>>> to build even when BLOCK is not enabled?
>>>
>>
>> I don't think there should be a direct dependency on BLOCK. I have two suggestions -
>> 1) Have our own define similar to (and in fact smaller):
>>    linux/genhd.h:#define DISK_NAME_LEN                     32
>> 2) Put the MMC physical partition code under an #ifdef CONFIG_BLOCK, which is a reasonable
>>    proposition, given that there wouldn't be any need to parse physical partition info if
>>    it would never be consumed by the MMC block driver.
>>
>> Thoughts?
>
> Agreed on part 2).  Do part 1) if it is required, but it's usually better
> not to duplicate constants or structs etc.
> IOW, can DISK_NAME_LEN in linux/genhd.h be exposed even when CONFIG_BLOCK
> is not enabled?

Hi Randy, Andrei.

I suggest third option for this.
As you know, MMC like ATA Driver and SCSI Driver etc.. can not enable
without CONFIG_BLOCK
So I think that mmc should be depended from CONFIG_BLOCK like other
block device driver.
see the their Kconfig. How do you think ?
--------------------------------------------------------------------------------------------------------------------------------
menuconfig ATA
        tristate "Serial ATA and Parallel ATA drivers"
        depends on HAS_IOMEM
        depends on BLOCK
        depends on !(M32R || M68K) || BROKEN


config SCSI
        tristate "SCSI device support"
        depends on BLOCK
        select SCSI_DMA if HAS_DMA
        ---help---
---------------------------------------------------------------------------------------------------------------------

>
>
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
