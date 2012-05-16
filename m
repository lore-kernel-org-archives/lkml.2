Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965435Ab2EPTza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:55:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760531Ab2EPTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:55:24 -0400
Message-ID: <4FB406F7.10803@ontolab.com>
Date: Wed, 16 May 2012 21:58:47 +0200
From: Christian Stroetmann <stroetmann@ontolab.com>
User-Agent: Mozilla/5.0 (Windows NT 5.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: NVM Mapping API
References: <20120515133450.GD22985@linux.intel.com> <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com> <20120516173523.GK22985@linux.intel.com>
In-Reply-To: <20120516173523.GK22985@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:y9EwqRNuDwBIDzp/HcgY4fx45r5PjDE8/762/YPagvg
 c8iPkyqfZhSKNR7Ya4aEFVWvf925GSebWRe6/pZs2FdVmW2c5G
 p/dhqLd6OsjzZl1FSiaQcOk2immhViGxvqjT6gKabI4/ciR8Qm
 9HSks0npviA3xqa8mjlz2hQdvvtQbpNM/2cnombuyBsQZ+5iMw
 uqpXefLZ5hP2tBX2BWPqFBGgSJHRb6ZNrCz0tjXjCJ37zVgACS
 eJKGvZuxTxqSvSsIizD2RukQbH+tSSu0iKz00I5GNEf4hAH9nW
 gi51GKpxMLbSsFwcP6ctvu9HUkDAGzlS1UAlm3PaDNnTXxbXH0
 f/zXIpqfkHiDX27kt1/g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hardcore Coders,

I wanted to step into the discussion already yesterday, but ... I was 
afraid to be rude in doing so.

On We, May 16, 2012 at 19:35,  Matthew Wilcox wrote:
> On Wed, May 16, 2012 at 10:52:00AM +0100, James Bottomley wrote:
>> On Tue, 2012-05-15 at 09:34 -0400, Matthew Wilcox wrote:
>>> There are a number of interesting non-volatile memory (NVM) technologies
>>> being developed.  Some of them promise DRAM-comparable latencies and
>>> bandwidths.  At Intel, we've been thinking about various ways to present
>>> those to software.  This is a first draft of an API that supports the
>>> operations we see as necessary.  Patches can follow easily enough once
>>> we've settled on an API.
>> If we start from first principles, does this mean it's usable as DRAM?
>> Meaning do we even need a non-memory API for it?  The only difference
>> would be that some pieces of our RAM become non-volatile.
> I'm not talking about a specific piece of technology, I'm assuming that
> one of the competing storage technologies will eventually make it to
> widespread production usage.  Let's assume what we have is DRAM with a
> giant battery on it.
Our ST-RAM (see [1] for the original source of its description) is a 
concept based on the combination of a writable volatile Random-Access 
Memory (RAM) chip and a capacitor. Either an adapter, which has a 
capacitor, is placed between a motherboard and a memory modul, the 
memory chip is simply connected with a capacitor, or a RAM chip is 
directly integrated with a chip capacitor. Also, the capacitor could be 
an element that is integrated directly with the rest of a RAM chip. 
While a computer system is running, the capacitor is charged with 
electric power, so that after a computing system is switched off the 
memory module will still be supported with needed power out of the 
capacitor and in this way the content of the memory is not lost. In this 
way a computing system has not to be booted in most of the normal use 
cases after it is switched on again.

Boaz asked: "What is the difference from say a PCIE DRAM card with battery"? It sits in the RAM slot.


>
> So, while we can use it just as DRAM, we're not taking advantage of the
> persistent aspect of it if we don't have an API that lets us find the
> data we wrote before the last reboot.  And that sounds like a filesystem
> to me.

No and yes.
1. In the first place it is just a normal DRAM.
2. But due to its nature it has also many aspects of a flash memory.
So the use case is for point
1. as a normal RAM module,
and for point
2. as a file system,
which again can be used
2.1 directly by the kernel as a normal file system,
2.2 directly by the kernel by the PRAMFS
2.3 by the proposed NVMFS, maybe as a shortcut for optimization,
and
2.4 from the userspace, most potentially by using the standard VFS. 
Maybe this version 2.4 is the same as point 2.2.

>> Or is there some impediment (like durability, or degradation on rewrite)
>> which makes this unsuitable as a complete DRAM replacement?
> The idea behind using a different filesystem for different NVM types is
> that we can hide those kinds of impediments in the filesystem.  By the
> way, did you know DRAM degrades on every write?  I think it's on the
> order of 10^20 writes (and CPU caches hide many writes to heavily-used
> cache lines), so it's a long way away from MLC or even SLC rates, but
> it does exist.

As I said before, a filesystem for the different NVM types would not be 
enough. These things are more complex due the possibility that they can 
be used very flexbily.

>
>> Alternatively, if it's not really DRAM, I think the UNIX file
>> abstraction makes sense (it's a piece of memory presented as something
>> like a filehandle with open, close, seek, read, write and mmap), but
>> it's less clear that it should be an actual file system.  The reason is
>> that to present a VFS interface, you have to already have fixed the
>> format of the actual filesystem on the memory because we can't nest
>> filesystems (well, not without doing artificial loopbacks).  Again, this
>> might make sense if there's some architectural reason why the flash
>> region has to have a specific layout, but your post doesn't shed any
>> light on this.
> We can certainly present a block interface to allow using unmodified
> standard filesystems on top of chunks of this NVM.  That's probably not
> the optimum way for a filesystem to use it though; there's really no
> point in constructing a bio to carry data down to a layer that's simply
> going to do a memcpy().
> --

I also saw the use cases by Boaz that are
Journals of other FS, which could be done on top of the NVMFS for 
example, but is not really what I have in mind, and
Execute in place, for which an Elf loader feature is needed. Obviously, 
this use case was envisioned by me as well.

For direct rebooting the checkpointing of standard RAM is also a needed 
function. The decision what is trashed and what is marked as persistent 
RAM content has to be made by the RAM experts of the Linux developers or 
the user. I even think that this is a special use case on its own with 
many options.



With all the best
C. Stroetmann

[1] ST-RAM www.ontonics.com/innovation/pipeline.htm#st-ram
