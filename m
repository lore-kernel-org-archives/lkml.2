Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab1IOMoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:44:55 -0400
Received: from mail-ew0-f43.google.com ([209.85.215.43]:35318 "EHLO
	mail-ew0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933558Ab1IOMot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:44:49 -0400
Message-ID: <4E71F33C.2010809@gmail.com>
Date: Thu, 15 Sep 2011 14:44:44 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@Dell.com>
CC: Matt Fleming <matt@console-pimps.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        "Hargrave, Jordan" <Jordan_Hargrave@Dell.com>
Subject: Re: [PATCH v2 10/10] x86, efi: EFI boot stub support
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org> <1315838094-2307-11-git-send-email-matt@console-pimps.org> <4E6F69A1.9030406@gmail.com> <1316016478.3466.74.camel@mfleming-mobl1.ger.corp.intel.com> <20110915045231.GA32136@emperor.us.dell.com> <4E71B196.1060504@gmail.com> <20110915115255.GA4669@emperor.us.dell.com>
In-Reply-To: <20110915115255.GA4669@emperor.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On 09/15/2011 01:52 PM, Matt Domsch wrote:
> On Thu, Sep 15, 2011 at 03:04:38AM -0500, Maarten Lankhorst wrote:
>> Hey Matt,
>>
>> On 09/15/2011 06:52 AM, Matt Domsch wrote:
>>> On Wed, Sep 14, 2011 at 11:07:58AM -0500, Matt Fleming wrote:
>>>> On Tue, 2011-09-13 at 16:33 +0200, Maarten Lankhorst wrote:
>>>>> This version seems to boot for me.
>>>> Yay! Thanks for testing.
>>>>
>>>>> Is it useful to add 32-bits support though?
>>>>> It seems that only some older versions of OSX use it. I could see if I can
>>>>> revive my mac mini, iirc it has 32-bits efi, or at least used to have.
>>>> 32-bit UEFI platforms do exist, so I think it's worth supporting them.
>>>>
>>>>> Do I need to pass anything to add it to efibootmgr?
>>>>>
>>>>> I tried something like this:
>>>>> echo "args" | efibootmgr -c -l '\vmlinuz.efi' -L 'Native EFI linux boot' -@ - -u -d /dev/sdb
>>>>>
>>>>> And it boots vmlinuz.efi, but the arguments I passed do not appear to
>>>>> have any effect.
>>>> No idea, I've never used efibootmgr. Let's add Matt Domsch to the
>>>> discussion (now Cc'd).
>>> Maarten, do you not see your 'args' in /proc/cmdline after booting the
>>> entry?  From reading this thread, that's what you should see.
>>>
>>> Can you provide an 'efibootmgr -v' and hexdump -C
>>> /sys/firmware/efi/vars/Boot*  to see the args are appended as expected
>>> in the boot variable in nvram?
>>>
>>> Adding Jordan Hargrave, who is maintainer for efibootmgr now.
>> Thanks, that helped. It looks like efibootmgr stores the arguments without converting it to UCS-2.
> When using -@, you are correct.  Given a file (or stdin), it places it
> unmodified onto the command line of the boot loader.
>
> When using efibootmgr -u, all extra arguments passed to efibootmgr's
> command line are converted to UCS-2.
>
> When using efibootmgr -a, all extra arguments passed to efibootmgr's
> command line are not converted and are treated as ascii.
>
> So it's a matter of how you invoke efibootmgr as to which kind of blob
> winds up appended to the boot loader's command line.  Using -@ means
> it's entirely up to you to create the blob you need apriori.  This was
> done to allow arbitrary blobs to be passed in.
>
Thanks, that makes much more sense. The man page makes mention
of extra arguments, but it kind of looked like the way to pass it was by
using -u -@ - which didn't work of course. :)

So for reference:
efibootmgr -L 'EFI Native Linux Boot' -l '\vmlinuz.efi' -d /dev/sdb -u root=/dev/sdb2 console=ttyS0,115200n8

or as ASCII (reads much prettier in efibootmgr -v)
efibootmgr -L 'EFI Native Linux Boot' -l '\vmlinuz.efi' -d /dev/sdb root=/dev/sdb2 console=ttyS0,115200n8

This is the fixed patch I'm using for booting native linux kernel,
with passing args tested for UCS-2 and ASCII. It seems that
options_size can be halved safely, otherwise too much data is
copied from input.

I keep the first word, since otherwise the first argument is stripped off,
and it's probably harmless for the kernel to read something like
\vmlinuz.efi when you don't do a direct boot.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 6c34828..f77f9f5 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -619,12 +619,12 @@ static efi_status_t make_boot_params(struct boot_params *boot_params,
 	unsigned long cmdline;
 	u8 nr_entries;
 	u16 *s2;
-	u8 *s1;
+	u8 *s1, *s2_8;
 	int i;
 
 	hdr->type_of_loader = 0x21;
 
-	status = low_alloc(options_size, 1, &cmdline);
+	status = low_alloc(options_size+1, 1, &cmdline);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -633,27 +633,29 @@ static efi_status_t make_boot_params(struct boot_params *boot_params,
 	/* Convert unicode cmdline to ascii */
 	s1 = (u8 *)(unsigned long)hdr->cmd_line_ptr;
 	s2 = (u16 *)options;
+	s2_8 = (u8*)options;
 
-	if (s2 && options_size) {
-		/* Skip first word, that's the kernel name */
-		while (*s2 && *s2 != ' ' && *s2 != '\n') {
-			options_size--;
-			s2++;
-		}
-
-		/* skip space */
-		if (*s2 == ' ') {
-			options_size--;
-			s2++;
-		}
-
-		while (options_size-- != 0) {
+	if (options_size < 2 || !s2) {
+		*s1 = '\0';
+	} else if (s2_8[1] && s2_8[1] < 0x80 && s2_8[0] < 0x80) {
+		/* Passed as ASCII */
+		s2 = NULL;
+		memcpy(s1, s2_8, options_size);
+		hdr->cmdline_size = options_size;
+	} else {
+		options_size /= 2; /* Passed as UCS-2 */
+		while (options_size-- != 0 && *s2) {
 			*s1++ = *s2++;
 			hdr->cmdline_size++;
 		}
-
 		*s1 = '\0';
+		s1 = (u8 *)(unsigned long)hdr->cmd_line_ptr;
 	}
+	if (hdr->cmdline_size && s1[hdr->cmdline_size - 1] == '\0')
+		hdr->cmdline_size--;
+	if (hdr->cmdline_size && s1[hdr->cmdline_size - 1] == '\n')
+		hdr->cmdline_size--;
+	s1[hdr->cmdline_size] = '\0';
 
 	hdr->ramdisk_image = 0;
 	hdr->ramdisk_size = 0;



