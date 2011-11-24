Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab1KXOnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:43:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64737 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab1KXOnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:43:22 -0500
Message-ID: <4ECE5803.3060203@gmail.com>
Date: Thu, 24 Nov 2011 15:43:15 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>  <1318848017-12301-11-git-send-email-matt@console-pimps.org>  <4E9C8AAC.7080803@gmail.com>  <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECC4207.3010607@gmail.com> <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Matt,

On 11/23/2011 08:27 PM, Matt Fleming wrote:

> On Wed, 2011-11-23 at 01:44 +0100, Maarten Lankhorst wrote:
>> When I tested this with v3.2-rc2 it didn't boot, it hung before it
>> initialized the kernel.
>> Without initrd it works fine, though.
> Bah, so this change actually makes booting worse? You said before that
> you almost made it to userspace but this seems to hang much earlier now.
> Is that correct?
>
> ... back to the drawing board.
I was looking at why grub2 could boot, seems to be it reads in chunks of
256 kilobytes. I seem to be able to get it to boot with chunks of 4 mb
as well, but didn't test beyond that.

So the fix is to simply read the file in parts, otherwise efi hangs..
As a nice side effect, short reads are also handled, but the efi
firmware seems to choke over huge reads and dies.

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8627a56..9b076f0 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -695,14 +695,16 @@ grow:
 			u64 size;
 
 			size = initrds[j].size;
-			status = efi_call_phys3(fh->read, initrds[j].handle,
-						&size, addr);
-			if (status != EFI_SUCCESS)
-				goto free_initrd_total;
-
+			while (size) {
+				u64 toread = size > 1024 * 1024 ? 1024 * 1024 : size;
+				status = efi_call_phys3(fh->read, initrds[j].handle,
+							&toread, addr);
+				if (status != EFI_SUCCESS)
+					goto free_initrd_total;
+				size -= toread;
+				addr += toread;
+			}
 			efi_call_phys1(fh->close, initrds[j].handle);
-
-			addr += size;
 		}
 
 	}


