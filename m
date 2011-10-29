Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab1J2Msq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 08:48:46 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41770 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab1J2Msp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 08:48:45 -0400
Message-ID: <4EABF4C2.7000104@gmail.com>
Date: Sat, 29 Oct 2011 14:42:42 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, msb@chromium.org,
        linux-kernel@vger.kernel.org, sergiu@chromium.org,
        Bryan Freed <bfreed@chromium.org>, akpm@linux-foundation.org,
        seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops appears geared to not support ARM
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org> <4EABBBD3.5030700@gmail.com> <20111029093458.GX19187@n2100.arm.linux.org.uk> <4EABDDBE.5080407@gmail.com> <20111029115507.GA19187@n2100.arm.linux.org.uk>
In-Reply-To: <20111029115507.GA19187@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/10/2011 13:55, Russell King - ARM Linux ha scritto:
> On Sat, Oct 29, 2011 at 01:04:30PM +0200, Marco Stornelli wrote:
>> About the ioremap problem. It seems there is a problem on some ARM arch
>> to use ioremap (ramoops driver) to remap a piece of RAM even if it's not
>> used by kernel (reserved at boot with mem option, Bryan can you
>> confirm?).
>
> It's all very simple.
>
> We have three major 'memory types' - 'normal memory' which must be used
> for things like RAM that we execute code from and use atomic operations
> within.  This can be prefetched and reordered at will.
>
> 'device memory' is for devices, which tighter restrictions on reordering
> and guarantees concerning reads and writes.
>
> 'strongly ordered memory' is much like device memory.
>
> It is absolutely not permitted to map the same physical addresses with
> different types - this is a stronger requirement than getting the cache
> attributes the same.
>
> System memory is mapped using 'normal memory' - obviously because we need
> to be able to execute code and have working atomic operations throughout
> kernel memory.
>
> Now, ioremap creates device memory - because its main function is to
> dynamically map memory regions in devices.
>
> Now think: if we have system memory mapped as 'normal memory', and then
> we try to use ioremap() to remap some of that memory, that will create
> a new 'device memory' mapping with the existing 'normal memory' mapping
> still present.  Now look at the paragraph 'It is absolutely not permitted'
> and realise that the requirements for the architecture are being violated
> if we permitted this to occur.
>
> Also realise that if that condition is violated, 'unpredictable behaviour'
> will occur - not to the extent that the CPU will hang, but it could cause
> data errors which could influence overall system stability.
>
> So, the whole idea of using plain ioremap() with system memory is one
> that is just completely unsupportable on ARM without _first_ removing
> memory from the system mapping, which in turn means updating the page
> tables for every task in the system.
>

Ok, I understand, but other question: isn't there any way to reserve 
normal memory? Or at least, hasn't the mem kernel option any effect from 
that point of view?
