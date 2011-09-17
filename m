Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1IQMMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 08:12:40 -0400
Received: from mail-ew0-f45.google.com ([209.85.215.45]:53904 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1IQMMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 08:12:39 -0400
Message-ID: <4E748EB2.1000203@gmail.com>
Date: Sat, 17 Sep 2011 14:12:34 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Matt Domsch <Matt_Domsch@Dell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        "Hargrave, Jordan" <Jordan_Hargrave@Dell.com>
Subject: Re: [PATCH v2 10/10] x86, efi: EFI boot stub support
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>  <1315838094-2307-11-git-send-email-matt@console-pimps.org>  <4E6F69A1.9030406@gmail.com>  <1316016478.3466.74.camel@mfleming-mobl1.ger.corp.intel.com>  <20110915045231.GA32136@emperor.us.dell.com> <4E71B196.1060504@gmail.com>  <20110915115255.GA4669@emperor.us.dell.com>  <4E71F33C.2010809@gmail.com> <1316259866.3578.20.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1316259866.3578.20.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Matt,

On 09/17/2011 01:44 PM, Matt Fleming wrote:
> On Thu, 2011-09-15 at 14:44 +0200, Maarten Lankhorst wrote:
>> Thanks, that makes much more sense. The man page makes mention
>> of extra arguments, but it kind of looked like the way to pass it was by
>> using -u -@ - which didn't work of course. :)
>>
>> So for reference:
>> efibootmgr -L 'EFI Native Linux Boot' -l '\vmlinuz.efi' -d /dev/sdb -u root=/dev/sdb2 console=ttyS0,115200n8
>>
>> or as ASCII (reads much prettier in efibootmgr -v)
>> efibootmgr -L 'EFI Native Linux Boot' -l '\vmlinuz.efi' -d /dev/sdb root=/dev/sdb2 console=ttyS0,115200n8
>>
>> This is the fixed patch I'm using for booting native linux kernel,
>> with passing args tested for UCS-2 and ASCII. It seems that
>> options_size can be halved safely, otherwise too much data is
>> copied from input.
> Thanks for looking at this Maarten. I've been staring at this code for
> far too long to notice buglets like this ;-)
>
>> I keep the first word, since otherwise the first argument is stripped off,
>> and it's probably harmless for the kernel to read something like
>> \vmlinuz.efi when you don't do a direct boot.
>>
>> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
>>
>> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
>> index 6c34828..f77f9f5 100644
>> --- a/arch/x86/boot/compressed/eboot.c
>> +++ b/arch/x86/boot/compressed/eboot.c
>> @@ -619,12 +619,12 @@ static efi_status_t make_boot_params(struct boot_params *boot_params,
>>  	unsigned long cmdline;
>>  	u8 nr_entries;
>>  	u16 *s2;
>> -	u8 *s1;
>> +	u8 *s1, *s2_8;
>>  	int i;
>>  
>>  	hdr->type_of_loader = 0x21;
>>  
>> -	status = low_alloc(options_size, 1, &cmdline);
>> +	status = low_alloc(options_size+1, 1, &cmdline);
>>  	if (status != EFI_SUCCESS)
>>  		goto fail;
> If no options were passed to the stub then we really don't want to do
> the allocation at all. Speaking of 'options_size', have you tested the
> values that get passed in from image->load_options? Running with the
> OVMF firmware under qemu I get sizes that are always larger than the
> NUL-byte in the argument string. For example, executing "bzImage foo"
> results in image->load_options being 38!
I tested on my own physical system, not qemu or anything.

Anyhow it seems the cmdline_size is meant for reading, and setting it
is completely ignored, see below. Could we make it a static array so
no allocation needs to be done?
> Remember that ->options_size represents 16-bit characters and cmdline is
> going to be ASCII. options_size will always be larger than the value we
> need, so there's no need for the +1. At the moment we're actually
> allocating too much memory and that needs to be fixed.
Reading up a bit more, I think the sane approach would be to allocate
COMMAND_LINE_SIZE and null terminate it. cmdline_size is meant to be
read only it seems:

Documentation/x86/boot.txt:
Field name:	cmdline_size
Type:		read
Offset/size:	0x238/4
Protocol:	2.06+

  The maximum size of the command line without the terminating
  zero. This means that the command line can contain at most
  cmdline_size characters. With protocol version 2.05 and earlier, the
  maximum size was 255.

>> @@ -633,27 +633,29 @@ static efi_status_t make_boot_params(struct boot_params *boot_params,
>>  	/* Convert unicode cmdline to ascii */
>>  	s1 = (u8 *)(unsigned long)hdr->cmd_line_ptr;
>>  	s2 = (u16 *)options;
>> +	s2_8 = (u8*)options;
>>  
>> -	if (s2 && options_size) {
>> -		/* Skip first word, that's the kernel name */
>> -		while (*s2 && *s2 != ' ' && *s2 != '\n') {
>> -			options_size--;
>> -			s2++;
>> -		}
>> -
>> -		/* skip space */
>> -		if (*s2 == ' ') {
>> -			options_size--;
>> -			s2++;
>> -		}
>> -
>> -		while (options_size-- != 0) {
>> +	if (options_size < 2 || !s2) {
>> +		*s1 = '\0';
>> +	} else if (s2_8[1] && s2_8[1] < 0x80 && s2_8[0] < 0x80) {
>> +		/* Passed as ASCII */
>> +		s2 = NULL;
>> +		memcpy(s1, s2_8, options_size);
>> +		hdr->cmdline_size = options_size;
>> +	} else {
>> +		options_size /= 2; /* Passed as UCS-2 */
>> +		while (options_size-- != 0 && *s2) {
>>  			*s1++ = *s2++;
>>  			hdr->cmdline_size++;
>>  		}
>> -
>>  		*s1 = '\0';
>> +		s1 = (u8 *)(unsigned long)hdr->cmd_line_ptr;
>>  	}
>> +	if (hdr->cmdline_size && s1[hdr->cmdline_size - 1] == '\0')
>> +		hdr->cmdline_size--;
>> +	if (hdr->cmdline_size && s1[hdr->cmdline_size - 1] == '\n')
>> +		hdr->cmdline_size--;
>> +	s1[hdr->cmdline_size] = '\0';
>>  
>>  	hdr->ramdisk_image = 0;
>>  	hdr->ramdisk_size = 0;
> Hmm... I'm really not convinced that we need to support ASCII cmdline
> arguments, sorry. efibootmgr has support for UCS-2, so that's what
> should be used.
>
I know, but this is nicer for displaying, compare this efibootmgr -v output:

Boot0002* Linux ASCII Boot     HD(...)File(\vmlinuz.efi)root=/dev/sdb2 console=ttyS0,115200n8.
Boot0003* Linux UCS-2 Boot     HD(...)File(\vmlinuz.efi)r.o.o.t.=./.d.e.v./.s.d.b.2. .c.o.n.s.o.l.e.=.t.t.y.S.0.,.1.1.5.2.0.0.n.8...

And it's more foolproof, since it's easy to pass strings as
ASCII since it's the default, and it would show up readable in efibootmgr.

~Maarten

