Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2KPQSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:18:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33922 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab2KPQSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:18:05 -0500
Message-ID: <50A66726.8070804@zytor.com>
Date: Fri, 16 Nov 2012 08:17:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] x86, boot, 64bit: Add support for loading ramdisk
 and bzImage high
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 12:53 AM, Yinghai Lu wrote:
> Now we have limit kdump reseved under 896M, because kexec has the limitation.
> and also bzImage need to stay under 4g.
> 
> To make kexec/kdump could use range above 4g, we need to make bzImage and
> ramdisk could be loaded above 4g.
> During booting bzImage will be unpacked on same postion and stay high.
> 
> The patches add field in boot header to
> 1. get info about ramdisk position info above 4g from bootloader/kexec
> 2. set code64_start_offset in header for bzImage and bootloader/kexec load
>    could check that to decide if need to put bzImage high.
> 
> This patches is tested with kexec tools with local changes, will send kexec
> tools change to kexec list later.
> 
> could be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot
> 
> and it is on top of for-x86-mm
> 

Mostly a good series, but the 0x208 is a showstopper.  0x200 is awkward
as an ABI (too big to just make a jump table, but potentially too small
to hold all the code needed.)  I have sent some other comments, too.

If 0x200 is too small, it isn't a huge problem; we can put a jump at
0x200 and continue the 32-bit code afterwards:


	/* 32-bit code */

	jmp	1f

	.org	0x200
	.code64
ENTRY(startup_64)
	jmp	start_64_real

	.code32
1:
	/* 32-bit code continues... */


It is annoying because it has to be placed by hand, but isn't actually a
problem.  The easy way to do this is probably to push verify_cpu.S into
the post-entry-point area.  The .code64/.code32 don't actually do
anything for a simple jmp, but are added for documentation.

How is collecting comments and ACKs for for-x86-mm coming?  I'd like to
do another review pass today and putting it in -tip if it is in better
shape.  Otherwise I suspect we'll be looking at 3.9, which is OK, of course.

	-hpa


