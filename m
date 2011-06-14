Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1FNOv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:51:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55003 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1FNOvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FBX5B9DCYkIlIvveSGT71Dtat5DaKvbvij0wiH7I05Qnm0KsZCfwuR+W28i7Qtnjva
         ABRTgrH7DCObXur4M8rV6rcvJpmv93gOVFXK2U/0i78Q7vkpFHdOcJHPGtswqzi0uLyJ
         6hmnUE6AGjLU1fZTcUs7Fh6WLPNLKaDlrmiV4=
Message-ID: <4DF77539.9020000@gmail.com>
Date: Tue, 14 Jun 2011 16:50:33 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <20110613164712.GA23343@srcf.ucam.org> <4DF64E6A.70700@gmail.com> <20110613180006.GA24902@srcf.ucam.org> <4DF65372.7090307@gmail.com> <20110613181750.GA25372@srcf.ucam.org> <4DF655B5.8040903@gmail.com> <20110613183301.GA25644@srcf.ucam.org>
In-Reply-To: <20110613183301.GA25644@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 13-06-11 20:33, Matthew Garrett schreef:
> Ok, that's odd. These are 0x01800000-0x01900000, which should lie inside 
> the kernel data range (01580279-01aa4cff : Kernel data). We should be 
> skipping that region. How are we touching that reange at all? Can you 
> add a printk to reserve_boot_services to see what it actually ends up 
> reserving?
Finally success!

Didn't notice it before, but my efi memmap has:
[    0.000000] EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)

Later on this range gets reserved for bios:

[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)

So I've added a check for e820.

Also with some digging into the swapper warning, it appears to be because
some memory was allocated in the _init part of the kernel, which you didn't check for.
this probably caused the warnings I had. Now I made sure to cover
the entire kernel from _text to _end, which should cover the entire kernel.

~Maarten
