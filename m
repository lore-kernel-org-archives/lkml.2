Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0KQCVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:21:14 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58074 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0KQCVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:21:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PhAk6AY0Up2Nb0rNH7WvlG7ozq7XZxEvI/Z9aX+akr67lQGJxNodU/CvuTePUOBwWD
         //OzpIGNuNQR+fwDvvPOBg+vh7BzAfliNGhn6gvmjG5n/nJOypJisHtfkL8psWUZjQGW
         8lrQjK6wiHhIz9IbT7mqQ1j8KeshHTmh4MQFU=
Message-ID: <4CE33C14.9030503@gmail.com>
Date: Tue, 16 Nov 2010 18:21:08 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        arjan@linux.intel.com, linuxppc-dev@lists.ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: [PATCH 1/5] of: Add support for linking device tree blobs into
 vmlinux
References: <cover.1289943240.git.dirk.brandewie@gmail.com> <9129f0a21ea48fb2dcb89cea290e88f3e8c0d8a2.1289943240.git.dirk.brandewie@gmail.com> <4CE32453.2090403@caviumnetworks.com>
In-Reply-To: <4CE32453.2090403@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/16/2010 04:39 PM, David Daney wrote:
> Thanks for doing this. However I have a few comments...
>
> On 11/16/2010 02:41 PM, dirk.brandewie@gmail.com wrote:
>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>
>> /* .data section */
>> #define DATA_DATA \
>> *(.data) \
>> @@ -468,7 +482,8 @@
>> MCOUNT_REC() \
>> DEV_DISCARD(init.rodata) \
>> CPU_DISCARD(init.rodata) \
>> - MEM_DISCARD(init.rodata)
>> + MEM_DISCARD(init.rodata) \
>> + KERNEL_DTB()
>>
>
> I thought the init.rodata was only for data used by __init things. Although the
> current linker scripts do not put it in the section that gets recycled as usable
> memory.
>
> IIRC the unflattened version of the device tree has pointers to the flattened
> data. Since the device tree nodes are live for the entire kernel lifecycle,
> shouldn't the device tree blobs be in non-init memory?
>

The contents of the blob get copied to allocated memory during 
unflatten_device_tree() so the blob that is linked in is no longer needed after 
init.

>
>> #define INIT_TEXT \
>> *(.init.text) \
>> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
>> index 4c72c11..29db062 100644
>> --- a/scripts/Makefile.lib
>> +++ b/scripts/Makefile.lib
>> @@ -200,6 +200,26 @@ quiet_cmd_gzip = GZIP $@
>> cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9> $@) || \
>> (rm -f $@ ; false)
>>
>> +# DTC
>> +# ---------------------------------------------------------------------------
>> +$(obj)/%.dtb.S: $(obj)/%.dtb FORCE
>
> Why FORCE?
Crud left over from debugging I will remove.
>
>
>> + @echo '#include<asm-generic/vmlinux.lds.h>'> $@
>> + @echo '.section .dtb.init.rodata,"a"'>> $@
>> + @echo '.balign DTB_ALIGNMENT'>> $@
>> + @echo '.global __dtb_$(*F)_begin'>> $@
>> + @echo '__dtb_$(*F)_begin:'>> $@
>> + @echo '.incbin "$<" '>> $@
>> + @echo '__dtb_$(*F)_end:'>> $@
>> + @echo '.global __dtb_$(*F)_end'>> $@
>> + @echo '.balign DTB_ALIGNMENT'>> $@
>> +
>> +DTC = $(objtree)/scripts/dtc/dtc
>> +
>> +quiet_cmd_dtc = DTC $@
>> + cmd_dtc = $(DTC) -O dtb -o $(obj)/$*.dtb -b 0 $(DTS_FLAGS) $(src)/dts/$*.dts
>> +
>> +$(obj)/%.dtb: $(src)/dts/%.dts
>> + $(call if_changed,dtc)
>>
>
> Do all the generated files get cleaned up?
>
> I will try it tomorrow to see for sure.
>
Looks like I need to add the generated .S files to clean-files

>
> Thanks,
> David Daney

