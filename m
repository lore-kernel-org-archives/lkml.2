Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2E0QDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 12:03:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57333 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2E0QDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 12:03:22 -0400
Message-ID: <4FC25048.109@wwwdotorg.org>
Date: Sun, 27 May 2012 10:03:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, Russell King <rmk@arm.linux.org.uk>
CC: kay.sievers@vrfy.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: arm: Remaining issue with alignment of __log_buf in printk.c
References: <4FC22098.3070803@kernel.org>
In-Reply-To: <4FC22098.3070803@kernel.org>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2012 06:39 AM, Jonathan Cameron wrote:
> Hi All,
> 
> My stargate 2 board refused to start and after bisection I ended
> up at the same patch that Stephen found an alignment issue in.
> Unfortunately Stephen's patch doesn't seem to have fixed the
> issue for me.
> https://lkml.org/lkml/2012/5/10/510 is the thread.  Patch from
> Stephen is : f8450fca6ecdea38b5a882fdf6cd097e3ec8651c
> 
> Increasing the alignement for 32 bit systems to 8 seems to do the
> job but I can't immediately think why...
> 
> System is a pxa27x strong arm.

The first element in the structure type that's actually stored in the
__log_buf array is a u64; see struct log in kernel/printk.c. Depending
on alignment rules, a u64 and a struct containing it might require a
4-byte or 8-byte alignment. The following link implies this might have
changed over time:

http://wiki.debian.org/ArmEabiPort#Struct_packing_and_alignment

(see "64-bit data type alignment" a little below that anchor). I'm not
sure what ABI the kernel expects to use internally, or your compiler;
perhaps you need the new EABI 8-byte alignment requirement for a u64 and
hence the struct as a whole, but Tegra (or my toolchain?) is OK with the
older 4-byte alignment for a u64 or struct?

Further, I'm not sure if the following alignment selection logic:

> #if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> #define LOG_ALIGN 4
> #else
> #define LOG_ALIGN 8
> #endif

... uses the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS for its intended
purpose?

Russell, can you please comment here. Thanks.
