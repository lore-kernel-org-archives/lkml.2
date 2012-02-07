Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab2BGWfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:35:47 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47242 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab2BGWfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:35:39 -0500
MIME-Version: 1.0
In-Reply-To: <4F31A1A2.8020201@zytor.com>
References: <1327911855-6501-1-git-send-email-yinghai@kernel.org>
	<4F31A1A2.8020201@zytor.com>
Date: Tue, 7 Feb 2012 14:35:38 -0800
X-Google-Sender-Auth: siJmXJ_prp-47aoY71idLKJPScA
Message-ID: <CAE9FiQVMO6Y-T01fuJeqYPp5bqnQfh0ZKPGv4G_wNM9tA6n0zg@mail.gmail.com>
Subject: Re: [PATCH -v2] x86, mm: Probe memory block size for generic x86 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 2:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/30/2012 12:24 AM, Yinghai Lu wrote:
>> Usually if the system support memory remapping to get back memory for mmio
>> range, we will have 128M ... 2G at the end.
>>
>> Try to probe that size.
>>
>> So we can get less entries in /sys/devices/system/memory/
>>
>> -v2: don't probe it every time when /sys/../block_size_byte is showed...
>>
>
> Okay... what on Earth is the point of this?
>
> This just screams "dangerous toxic heuristic that's likely to break
> unusual configurations", and reducing the number of entries in a /sys
> directory is hardly motivation for anything.
>
> You need a much better description of what you're trying to accomplish
> and why that matters in the first place.

that is for memory hotplug support.

on one 2048g system, current x86_64 have 128M as section size, and one
memory_block only include
one section.
So that directory will have 16400 entries.

recent change will try to use block id to find block pointer in /sys
for any section, and reuse that block pointer.
even only one section per block. and that finding will take some time
... already have one patch that will skip the search in that case
during booting up.

but other case, We may still have this finding problem.

So solution could be increase block size just like SGI UV system did.
(harded code to 2g).

This patch is trying to probe the block size to make it match mmio remap size.
for example, AMD system after rev E or Intel Nehalem later system will
have memory range
[0, TOM), [4g, TOM2]. if the memory hole is 2g and total is 128g, TOM
will be 2g, and TOM2 will be 130g.
We could use 2g as block size instead of default 128M.
That will reduce number of entries in  /sys/devices/system/memory/

Yinghai
