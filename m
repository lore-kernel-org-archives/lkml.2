Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab1KXQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:58:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33518 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1KXQ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:58:18 -0500
Message-ID: <4ECE77A4.2040703@gmail.com>
Date: Thu, 24 Nov 2011 17:58:12 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>  <1318848017-12301-11-git-send-email-matt@console-pimps.org>  <4E9C8AAC.7080803@gmail.com>  <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECC4207.3010607@gmail.com> <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com> <4ECE5803.3060203@gmail.com>
In-Reply-To: <4ECE5803.3060203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Matt,

On 11/24/2011 03:43 PM, Maarten Lankhorst wrote:
> Hey Matt,
>
> On 11/23/2011 08:27 PM, Matt Fleming wrote:
>
>> On Wed, 2011-11-23 at 01:44 +0100, Maarten Lankhorst wrote:
>>> When I tested this with v3.2-rc2 it didn't boot, it hung before it
>>> initialized the kernel.
>>> Without initrd it works fine, though.
>> Bah, so this change actually makes booting worse? You said before that
>> you almost made it to userspace but this seems to hang much earlier now.
>> Is that correct?
>>
>> ... back to the drawing board.
> I was looking at why grub2 could boot, seems to be it reads in chunks of
> 256 kilobytes. I seem to be able to get it to boot with chunks of 4 mb
> as well, but didn't test beyond that.
>
> So the fix is to simply read the file in parts, otherwise efi hangs..
> As a nice side effect, short reads are also handled, but the efi
> firmware seems to choke over huge reads and dies.
So after I was encouraged by mjg59 to find out the limit,
I put this patch to test maximum file size with together..

Turns out that it pukes on 4 mb, my printf was fucked,
in the patch below I corrected it, so I don't know for sure
if that included 4 mb being bad or not. I suppose writing
a test for read(fd, addr, 5 * 1024 * 1024) was too hard for
efi to pass. ;)

Just make a file with dd if=/dev/urandom of=initrd.img bs=1M count=99
to find out when/if YOUR efi implementation will die! :D

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8627a56..415b875 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -30,6 +30,19 @@
 #define PIXEL_BLT_ONLY					3
 #define PIXEL_FORMAT_MAX				4
 
+typedef struct _EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL {
+  void* Reset;
+  void *OutputString;
+  void *TestString;
+  void *QueryMode;
+  void *SetMode;
+  void *SetAttribute;
+  void *ClearScreen;
+  void *SetCursorPosition;
+  void *EnableCursor;
+  void *Mode;
+} __attribute__((packed)) EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL;
+
 typedef struct {
 	u32 red_mask;
 	u32 green_mask;
@@ -692,17 +705,27 @@ grow:
 
 		addr = initrd_addr;
 		for (j = 0; j < nr_initrds; j++) {
-			u64 size;
-
-			size = initrds[j].size;
-			status = efi_call_phys3(fh->read, initrds[j].handle,
-						&size, addr);
-			if (status != EFI_SUCCESS)
-				goto free_initrd_total;
-
+			u64 size, chunksize;
+			uint16_t str[] = { 'S', 'i', 'z', 'e', ':', ' ', ' ',' ', ' ', '\r', '\n', 0 };
+			EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL *output = (void*)sys_table->stderr;
+
+			for (chunksize = 1024 * 1024; chunksize < initrds[j].size; chunksize += 1024 * 1024) {
+				str[5] = ((chunksize / 1024 / 1024) / 10) + '0';
+				str[6] = ((chunksize / 1024 / 1024) % 10) + '0';
+				efi_call_phys2(output->OutputString, sys_table->stderr_handle, str);
+				size = initrds[j].size;
+				efi_call_phys2(fh->set_position, initrds[j].handle, 0);
+				while (size) {
+					u64 toread = size > chunksize ? chunksize : size;
+					status = efi_call_phys3(fh->read, initrds[j].handle,
+							&toread, addr);
+					if (status != EFI_SUCCESS)
+						goto free_initrd_total;
+					size -= toread;
+					addr += toread;
+				}
+			}
 			efi_call_phys1(fh->close, initrds[j].handle);
-
-			addr += size;
 		}
 
 	}


