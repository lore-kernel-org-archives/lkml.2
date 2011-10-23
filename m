Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab1JWT0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 15:26:34 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:17427
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab1JWT0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 15:26:33 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK9371K146fK1432N98dKzz1202hzzz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4EA46A16.5080005@am.sony.com>
Date: Sun, 23 Oct 2011 12:25:10 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Ming Lei <tom.leiming@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Joe Perches <joe@perches.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        <mem@selenic.com>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
References: <4E9E0B71.9020708@am.sony.com> <1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com> <1500345.YeXPhIIHc5@wuerfel> <CACVXFVMb9p8PiTYWGTNn-FtQts0sRgmK+BQ6kaJ6-D89CAT=xQ@mail.gmail.com> <20111022133648.GA21374@n2100.arm.linux.org.uk>
In-Reply-To: <20111022133648.GA21374@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2011 6:36 AM, Russell King - ARM Linux wrote:
> On Sat, Oct 22, 2011 at 04:50:15PM +0800, Ming Lei wrote:
>> On Wed, Oct 19, 2011 at 6:51 PM, Arnd Bergmann<arnd@arndb.de>  wrote:
>>> On Tuesday 18 October 2011 17:26:44 Tim Bird wrote:
>>>> Even inside Sony, usage of 4K stacks is limited
>>>> to some very special cases, where memory is exceedingly
>>>> tight (we have one system with 4M of RAM).  And we
>>>> don't mind lopping off features or coding around
>>>> problem areas to support our special case.
>>> I would imagine that in those cases, you can gain more by reducing the
>>> number of threads in the system. What is the highest number of
>>> concurrent threads that you expect in a limited use case with no
>>> networking or block devices?
We have about 50 hard real-time threads, that are part of a
software stack for digital cameras that was ported over from
micro-itron.  It has taken a _LONG_ time (on the order of a
few years) to tune the Linux system using RT-preempt to run
these threads as is.  It would be very painful to re-architect this
part of the system.

Note that these threads don't have any of the issues that
people have raised about filesystem stack depth or printk
recursion, since they avoid a whole range of Linux syscalls
to avoid real-time issues (and stack size issues).

I'm looking at possibly implementing a mixed stack
size system, but I don't know if that will work, or whether
it would be acceptable upstream.

>>> If system run for some time, sometimes it may be difficult for
>>> memory allocator to allocate 2 continuous page frames even  there are
>>> many spare page frames in system because of
>>> fragment issue, so the patch does make sense.
> If memory fragmentation is an issue for this, it probably means that we
> need to switch to a software page size of 8K (or maybe 16K) rather than
> stick with the hardware 4K size.  That would be a much more reliable
> solution, especially as the L1 page table is 16K (if you're suffering
> from memory fragmentation, the first thing which'd get you is the L1
> page table allocation, not the kernel stack allocation.)
>
>> Anyway, it provides one option for user to apply 4k stack to avoid
>> such kind of process creation failure.
> I refer you to the comments made by people who've tried running with 4K
> stacks on x86, and their _vast_ experience of doing this.  If they say
> that it causes stack overflows, then it's a problem.
>
I really don't think anyone on x86 has any experience whatsoever
with anything like this.  This is on a digital camera, with a flash
filesystem, with a 10M memory budget, with just about every
in and out-of-tree patch from Linux-tiny applied and configured.
Many of the things that bloat up the kernel just aren't there at
all.

> The possibility of a kernel stack overflow is not something that should
> be taken lightly
Agreed.

This kind of development is done with extensive in-house testing,
and an absolutely fixed users space. This may sound like an
isolated case, but I know Sony is not alone and that lots of
embedded products are developed like this.  I'm pretty sure
others would benefit from this patch.

We've already shipped tens of thousands of cameras
with this, with no problems, so it's certainly possible to get it
right.

Whether to include this comes down to a question of whether
the ability of someone to get it wrong should preclude
allowing the *option* into the kernel.
   -- Tim

