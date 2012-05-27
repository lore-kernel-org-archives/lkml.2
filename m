Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2E0RBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 13:01:42 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:50495 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2E0RBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 13:01:40 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <4FC22098.3070803@kernel.org> <4FC25048.109@wwwdotorg.org> <20120527161405.GA29360@n2100.arm.linux.org.uk>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120527161405.GA29360@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: arm: Remaining issue with alignment of __log_buf in printk.c
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Sun, 27 May 2012 18:01:28 +0100
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: Jonathan Cameron <jic23@kernel.org>, kay.sievers@vrfy.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Message-ID: <ff649cb2-d71d-4bea-adf7-1ec6d1de1207@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

>On Sun, May 27, 2012 at 10:03:20AM -0600, Stephen Warren wrote:
>> On 05/27/2012 06:39 AM, Jonathan Cameron wrote:
>> > Hi All,
>> > 
>> > My stargate 2 board refused to start and after bisection I ended
>> > up at the same patch that Stephen found an alignment issue in.
>> > Unfortunately Stephen's patch doesn't seem to have fixed the
>> > issue for me.
>> > https://lkml.org/lkml/2012/5/10/510 is the thread.  Patch from
>> > Stephen is : f8450fca6ecdea38b5a882fdf6cd097e3ec8651c
>> > 
>> > Increasing the alignement for 32 bit systems to 8 seems to do the
>> > job but I can't immediately think why...
>> > 
>> > System is a pxa27x strong arm.
>
>First thing to point out is that PXA27x is Xscale, not StrongARM.
Sorry my mistake!
>
>> The first element in the structure type that's actually stored in the
>> __log_buf array is a u64; see struct log in kernel/printk.c.
>Depending
>> on alignment rules, a u64 and a struct containing it might require a
>> 4-byte or 8-byte alignment. The following link implies this might
>have
>> changed over time:
>> 
>> http://wiki.debian.org/ArmEabiPort#Struct_packing_and_alignment
>> 
>> (see "64-bit data type alignment" a little below that anchor). I'm
>not
>> sure what ABI the kernel expects to use internally, or your compiler;
>> perhaps you need the new EABI 8-byte alignment requirement for a u64
>and
>> hence the struct as a whole, but Tegra (or my toolchain?) is OK with
>the
>> older 4-byte alignment for a u64 or struct?
>> 
>> Further, I'm not sure if the following alignment selection logic:
>> 
>> > #if !defined(CONFIG_64BIT) ||
>defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>> > #define LOG_ALIGN 4
>> > #else
>> > #define LOG_ALIGN 8
>> > #endif
>> 
>> ... uses the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS for its intended
>> purpose?
>> 
>> Russell, can you please comment here. Thanks.
>
>And most likely it's using EABI which does want 8 byte alignment. 
Indeed I am using eabi.
 So
>this
>should probably be fixed for EABI builds.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
