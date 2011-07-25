Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1GYKjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:39:31 -0400
Received: from gold.linx.net ([195.66.232.40]:35798 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab1GYKjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:39:25 -0400
From: Tony Vroon <tony@linx.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: MTRR setup failure on Fujitsu Lifebook S761
In-Reply-To: <20110722081225.2272F10082@gold.linx.net>
Message-Id: <20110725103922.5718910089@gold.linx.net>
Date: Mon, 25 Jul 2011 11:39:22 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/11 09:12, Tony Vroon wrote:
> The contents of /proc/mtrr are:
> reg00: base=0x0ffc00000 ( 4092MB), size=    4MB, count=1: write-protect
> reg01: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg02: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> reg03: base=0x0c0000000 ( 3072MB), size=  512MB, count=1: write-back
> reg04: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: uncachable
> reg05: base=0x0cc000000 ( 3264MB), size=   64MB, count=1: uncachable
> reg06: base=0x0cb000000 ( 3248MB), size=   16MB, count=1: uncachable
> reg07: base=0x0cac00000 ( 3244MB), size=    4MB, count=1: uncachable
> reg08: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
> reg09: base=0x130000000 ( 4864MB), size=  256MB, count=1: uncachable

I believe this is closer to the optimum:
adrastea ~ # cat /proc/mtrr
reg00: base=0x0ffc00000 ( 4092MB), size=    4MB, count=1: write-protect
reg01: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg02: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg03: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
reg04: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: write-combining
reg05: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg09: base=0x130000000 ( 4864MB), size=  256MB, count=1: uncachable

0x0d0000000 is the range triggering the warning before, it is the AGP 
aperture for the Sandy Bridge graphics.

I used the following script to get there:
adrastea ~ # cat /usr/sbin/mtrr.sh 
#!/bin/bash
echo "disable=3" >| /proc/mtrr
echo "disable=4" >| /proc/mtrr
echo "disable=5" >| /proc/mtrr
echo "disable=6" >| /proc/mtrr
echo "disable=7" >| /proc/mtrr
echo "disable=8" >| /proc/mtrr
echo "base=0xc0000000 size=0x10000000 type=write-back" >| /proc/mtrr
echo "base=0xd0000000 size=0x10000000 type=write-combining" >| /proc/mtrr
echo "base=0x100000000 size=0x40000000 type=write-back" >| /proc/mtrr

Two questions remain...
1) Why can't the MTRR sanitizer figure this one out? (Even on 3.0.0-03370-gb6844e8)
2) If the MTRR sanitizer will not be fixed, how can I override the above MTRRs on the kernel command line?

Regards,
-- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net 
