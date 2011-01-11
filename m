Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1AKPrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:47:05 -0500
Received: from mail-ey0-f194.google.com ([209.85.215.194]:37265 "EHLO
	mail-ey0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab1AKPq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:46:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=ZVdJZxrlHNWZOtH+Xz8XaqdKjqXAIsUqQ4D9dj5qYh5MIaZuP5YjXhuLgW76WgJQOe
         wT10cHZrbR0s5WcFP9+hmmN9PkXQZeghYYRoVklQ8o3MdB+1Dw5iTsCf2jV3xE1u1yMN
         4rO8C9BZaYd6sRbfzBxY3M96phA8eUHQspeg0=
MIME-Version: 1.0
In-Reply-To: <4D2BFA08.5030104@ahsoftware.de>
References: <4D2B4CE4.9080309@ahsoftware.de> <alpine.LFD.2.00.1101101722470.9794@xanadu.home>
 <4D2BFA08.5030104@ahsoftware.de>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 11 Jan 2011 21:16:38 +0530
X-Google-Sender-Auth: ejYTeerWrXkOObxSRCBlmWbWskM
Message-ID: <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com>
Subject: Re: ARM: relocation out of range (when loading a module)
To: Alexander Holler <holler@ahsoftware.de>
Cc: Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:04, Alexander Holler <holler@ahsoftware.de> wrote:
> Point is that I would like to understand why including an initramfs has such
> consequences.
>
> I have to search for some pictures which are explaining the memory layout
> (never had any interested in that before).
>
> I assume some memory near the kernel is reserved for the modules and an
> initramfs will come inbetween the kernel and the reserved memory for
> modules.

Modules get placed 16MiB below PAGE_OFFSET, and when you add another
~16MiB initramfs between them and the kernel symbols, you exceed the
offset range of the branch instruction.

It's possible to hack around this by placing the initramfs at the end of
the kernel image rather than at the beginning with the rest of the init
data.  Something like the below should work, although you should also
probably take care of alignment and also have this section freed when
the rest of the init data is freed.

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index b16c079..05ad361 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -46,7 +46,6 @@ SECTIONS
 		INIT_CALLS
 		CON_INITCALL
 		SECURITY_INITCALL
-		INIT_RAM_FS

 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
@@ -170,6 +169,11 @@ SECTIONS

 		_edata = .;
 	}
+
+	.initramfs : {
+		INIT_RAM_FS
+	}
+
 	_edata_loc = __data_loc + SIZEOF(.data);

 #ifdef CONFIG_HAVE_TCM
