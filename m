Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2FKINp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:13:45 -0400
Received: from mail.pr.hu ([87.242.0.5]:55587 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab2FKINm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:13:42 -0400
Message-ID: <4FD5A89E.1000202@pr.hu>
Date: Mon, 11 Jun 2012 10:13:18 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
References: <4FD4F45D.5050103@pr.hu> <4FD5A3A8.4020305@ladisch.de>
In-Reply-To: <4FD5A3A8.4020305@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.8 (--)
X-Scan-Signature: 121d2db6017a7bb2c7a9246e5803eee8
X-Spam-Tracer: backend.mail.pr.hu -2.8 20120611081301Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-06-11 09:52 keltezéssel, Clemens Ladisch írta:
> Boszormenyi Zoltan wrote:
>> I have an AMD FX-8120 boxed CPU in an ASUS M5A99X-EVO mainboard
>> with 32GB DDR3/1600 memory, running Fedora 17, upgraded from 16.
>>
>> I get occasional crashes and signal 11 during kernel compilation even
>> with single-job make. Sometimes the compiler jumps out with a strange
>> error message, like "stray \NNN character in the source". When re-running
>> make, the error doesn't happen in the same file and the source file doesn't
>> contain the character being complained about when inspecting with
>> an editor or hexdump.
>>
>> Now, a few minutes ago I was able to catch this bug when I copied the
>> kernel GIT tree to apply a patch manually and did "git commit -a".
>> Strangely, the commit contained one extra file that I didn't touch.
>> git diff showed this for the extra file:
>>
>> ==============================
>> --- a/drivers/usb/gadget/fsl_usb2_udc.h
>> +++ b/drivers/usb/gadget/fsl_usb2_udc.h
>> @@ -427,7 +427,7 @@ struct ep_td_struct {
>>   #define  DTD_ADDR_MASK                        0xFFFFFFE0
>>   #define  DTD_PACKET_SIZE                      0x7FFF0000
>>   #define  DTD_LENGTH_BIT_POS                   16
>> -#define  DTD_ERROR_MASK                       (DTD_STATUS_HALTED | \
>> +#define  DTD_ERROR_MASK                       (DTD_STATUS_HALTED | ^Z
>>                                                  DTD_STATUS_DATA_BUFF_ERR | \
>>                                                  DTD_STATUS_TRANSACTION_ERR)
>>   /* Alignment requirements; must be a power of two */
>> ==============================
>>
>> The "^Z" is a 0-character in the file and is not present in the
>> original source tree, only in the copy.

Actually, the "^Z" there is 0x1a. It should be 0x5c, the backslash character.

> Is it always a zero, or other invalids characters?
> (The (number of) changed bits might tell something.)

IIRC, GCC has a different error for a 0-character and "stray \NNN character"
(that's not inside a string literal) and both happened at some time.
Sorry, I didn't bother to make a note of the error messages.

>
>> Similar errors happened during copying large files on the same
>> machine but it seems it's enough to trigger if the total amount
>> of data read is large enough.
> Does "large enough" mean "large enough so that they are not in the file
> cache"?
>
> All caches and your memory are ECC protected,

Unfortunately the memory is not with ECC. "Large enough" means it's
usually not in file system cache

>   so I think it is unlikely
> that the problem is with these.  If I had to guess, I'd point to your
> disk (firmware) or the SATA controller.  (A bad or loose SATA cable
> would throw CRC errors into the kernel log.  Are there any?)

The disks (8 of them) are attached to 3ware 9650SE-8LPML in RAID10.
tw_cli reports no problems.

> What is the exact offset of the changed byte in the file?  (It might be
> at a cacheline, sector, or page boundary.)

The bad character is at offset 0x4b74.

>> Does anyone know whether it's a known problem in AMD FX CPUs?
> http://support.amd.com/us/Processor_TechDocs/48063_15h_Mod_00h-0Fh_Rev_Guide.pdf

Thanks but I have seen this file already. The "no fix planned" for every
errata is saddening...

>
>
> Regards,
> Clemens
>

