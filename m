Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab2ESWQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 18:16:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2ESWQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 18:16:17 -0400
Message-ID: <4FB81C6C.5080409@ontolab.com>
Date: Sun, 20 May 2012 00:19:24 +0200
From: Christian Stroetmann <stroetmann@ontolab.com>
User-Agent: Mozilla/5.0 (Windows NT 5.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Christian Stroetmann <stroetmann@ontolab.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: NVM Mapping API
References: <20120515133450.GD22985@linux.intel.com> <1337161920.2985.32.camel@dabdike.int.hansenpartnership.com> <20120516173523.GK22985@linux.intel.com> <4FB406F7.10803@ontolab.com>
In-Reply-To: <4FB406F7.10803@ontolab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:febQAhibcmccIIDZQ4Hg1W+BKZDDYOR8VHMIN/xD705
 PdEF7UqACSQ41uz8W483J9bo4o6K/NM0DmumlPIG0KBB5WlFot
 cwqG6vScPYZZS1Oa2nTlztBhkfK1zwD/vd1wcq3mg76sV1Fzce
 0O7SWLBwEVuIW+f/386ZPwbKs5HCXZvBn3A3/sg3T6X1b0kkuF
 hrtzltRFbTNAE0JvKE2sUPqQEUV6KAKO2IeGe9+48GSiVKBHpj
 P9tfyvd7vMWQmDKfpWMkcs6zfyr+JI0UNg/aiPW/Cm4Hc05weJ
 X0dmwYD3rGcFOcTRWMrEvNEveP5Pkicc7SIpmUR1960VyN18Mr
 ZmbhM6OMe+GCg9MqQNWk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On We, May 16, 2012 at 21:58, Christian Stroetmann wrote:
> On We, May 16, 2012 at 19:35,  Matthew Wilcox wrote:
>> On Wed, May 16, 2012 at 10:52:00AM +0100, James Bottomley wrote:
>>> On Tue, 2012-05-15 at 09:34 -0400, Matthew Wilcox wrote:
>>>> There are a number of interesting non-volatile memory (NVM) 
>>>> technologies
>>>> being developed.  Some of them promise DRAM-comparable latencies and
>>>> bandwidths.  At Intel, we've been thinking about various ways to 
>>>> present
>>>> those to software.  This is a first draft of an API that supports the
>>>> operations we see as necessary.  Patches can follow easily enough once
>>>> we've settled on an API.
>>> If we start from first principles, does this mean it's usable as DRAM?
>>> Meaning do we even need a non-memory API for it?  The only difference
>>> would be that some pieces of our RAM become non-volatile.
>> I'm not talking about a specific piece of technology, I'm assuming that
>> one of the competing storage technologies will eventually make it to
>> widespread production usage.  Let's assume what we have is DRAM with a
>> giant battery on it.
> Our ST-RAM (see [1] for the original source of its description) is a 
> concept based on the combination of a writable volatile Random-Access 
> Memory (RAM) chip and a capacitor.
[...]
> Boaz asked: "What is the difference from say a PCIE DRAM card with 
> battery"? It sits in the RAM slot.
>
>
>>
>> So, while we can use it just as DRAM, we're not taking advantage of the
>> persistent aspect of it if we don't have an API that lets us find the
>> data we wrote before the last reboot.  And that sounds like a filesystem
>> to me.
>
> No and yes.
> 1. In the first place it is just a normal DRAM.
> 2. But due to its nature it has also many aspects of a flash memory.
> So the use case is for point
> 1. as a normal RAM module,
> and for point
> 2. as a file system,
> which again can be used
> 2.1 directly by the kernel as a normal file system,
> 2.2 directly by the kernel by the PRAMFS
> 2.3 by the proposed NVMFS, maybe as a shortcut for optimization,
> and
> 2.4 from the userspace, most potentially by using the standard VFS. 
> Maybe this version 2.4 is the same as point 2.2.
>
>>> Or is there some impediment (like durability, or degradation on 
>>> rewrite)
>>> which makes this unsuitable as a complete DRAM replacement?
>> The idea behind using a different filesystem for different NVM types is
>> that we can hide those kinds of impediments in the filesystem.  By the
>> way, did you know DRAM degrades on every write?  I think it's on the
>> order of 10^20 writes (and CPU caches hide many writes to heavily-used
>> cache lines), so it's a long way away from MLC or even SLC rates, but
>> it does exist.
>
> As I said before, a filesystem for the different NVM types would not 
> be enough. These things are more complex due the possibility that they 
> can be used very flexbily.
>
>>
>>> Alternatively, if it's not really DRAM, I think the UNIX file
>>> abstraction makes sense (it's a piece of memory presented as something
>>> like a filehandle with open, close, seek, read, write and mmap), but
>>> it's less clear that it should be an actual file system.  The reason is
>>> that to present a VFS interface, you have to already have fixed the
>>> format of the actual filesystem on the memory because we can't nest
>>> filesystems (well, not without doing artificial loopbacks).  Again, 
>>> this
>>> might make sense if there's some architectural reason why the flash
>>> region has to have a specific layout, but your post doesn't shed any
>>> light on this.
>> We can certainly present a block interface to allow using unmodified
>> standard filesystems on top of chunks of this NVM.  That's probably not
>> the optimum way for a filesystem to use it though; there's really no
>> point in constructing a bio to carry data down to a layer that's simply
>> going to do a memcpy().
>> -- 
>
> I also saw the use cases by Boaz that are
> Journals of other FS, which could be done on top of the NVMFS for 
> example, but is not really what I have in mind, and
> Execute in place, for which an Elf loader feature is needed. 
> Obviously, this use case was envisioned by me as well.
>
> For direct rebooting the checkpointing of standard RAM is also a 
> needed function. The decision what is trashed and what is marked as 
> persistent RAM content has to be made by the RAM experts of the Linux 
> developers or the user. I even think that this is a special use case 
> on its own with many options.
>
Because it is now about 1 year ago when I played around with the 
conceptual hardware aspects of anUninterruptible Power RAM (UPRAM) like 
the ST-RAM, I looked in more detail at the software side yesterday and 
today. So let me please add my first use case that I had in mind last 
year and coined now:
Hybrid Hibernation (HyHi) or alternatively Suspend-to-NVM,
which is similar to hybrid sleep and hibernation, but also differs a 
little bit due to the uninterruptible power feature.

But as it can be seen easily here again, even with this 1 use case exist 
two paths to handle the NVM that are as:
1. RAM and
2. FS,
so that it leads a further time to the discussion, if hibernation should 
be a kernel or a user space function (see [1] and [2] for more 
information related with the discussion about uswsup (userspace software 
suspend) and suspend2, and [3] for uswsup and [4] for TuxOnIce).

Eventually, there is an interest to reuse some functions or code.



Have fun in the sun
C. Stroetmann
> [1] ST-RAM www.ontonics.com/innovation/pipeline.htm#st-ram
>
[1] LKML: Pavel Machek: RE: suspend2 merge lkml.org/lkml/2007/4/24/405
[2] KernelTrap: Linux: Reviewung Suspend2 kerneltrap.org/node/6766
[3] suspend.sourceforge.net
[4] tuxonice.net
