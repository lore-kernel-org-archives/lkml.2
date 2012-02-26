Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2BZAHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 19:07:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab2BZAGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 19:06:45 -0500
Message-ID: <4F497782.3060902@redhat.com>
Date: Sat, 25 Feb 2012 22:06:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: Jidong Xiao <jidong.xiao@gmail.com>, david@lang.hm,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com> <4F4661D6.7030809@gmail.com> <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com> <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm> <CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com> <20120224162109.1bbf157b@redhat.com> <20120225150940.GA3719@localhost>
In-Reply-To: <20120225150940.GA3719@localhost>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-02-2012 13:10, Eduard - Gabriel Munteanu escreveu:
> On Fri, Feb 24, 2012 at 04:21:09PM -0200, Mauro Carvalho Chehab wrote:
>> Moving a buggy driver to userspace won't fix the bug. You're just moving
>> it from one place to another place. Also, the code will likely require changes
>> to work on userspace, so, the chances are that you're actually introducing more
>> bugs.
> 
> Hi,
> 
> 
> It does provide isolation, see below.

It depends on what you call isolation. Moving drivers to userspace
will protect ring 0, this but won't prevent OS attacks. See below.
> 
>> The impact of the bug won't also reduce, on most cases, as the userspace driver
>> will very likely require root capabilities.
> 
> Not as proposed, that's the point. For IOMMU-enabled systems, you can
> safely delegate an entire device to a userspace device and minimize
> privileged code. If I understand correctly, the performance impact is
> also minimal with respect to driver <-> device interaction. I'm not sure
> if driver <-> client might be problematic, but you can probably have the
> device DMA directly from/into client memory given the right mechanisms.
> 
> This is currently employed by virtualization software to do PCI
> passthrough. The guest OS can directly control the hardware.
> 
> Sure, you can't do it without proper hardware support. The question is
> how we can reuse existing code.
> 
>> Also, as driver talks directly with the hardware, an userspace block driver
>> would have access to the raw disk data. So, even if you find a way for it to
>> run unprivileged, it can still mangle the data written on the disk, and
>> even have a malicious code there that adds or allows to add a malware at the
>> disk partitions.
> 
> That's true, but it still makes sense for other drivers, say NIC
> drivers. Why should corrupting a network driver possibly result in total
> privilege escalation?

Bad NIC drivers could allow overriding firewall settings, making an external
packet to look as if it were a local one.

>> That's said, there are much more eyes inspecting the kernel sources than on any 
>> other userspace project. So, the risk of a bad code to be inserted unnoticed at
>> the Linux kernel is degrees of magnitude lower than on an userspace driver.
> 
> Those much more eyes have already missed important bugs in the past.

Yes, nobody is perfect. But the probability that something passes on a 4000+ people
review is lower than the probability of a bug on a piece of code where just one 
or two people are looking on it.

> No disrespect here, I'm just saying in many cases (like the one mentioned
> above) this approach almost eliminates the issue altogether.

It doesn't. Security is based on 3 pilars: confidentiality, integrity, availability (CIA).

Moving a driver from kernelspace to userspace will likely weak all 3:

- it is easier to inspect the data, reducing confidentiality;
- it is easier to forge data or to mangle, reducing integrity;
- the driver availability will likely weak, as less people will likely be looking
  into it, and the driver doesn't need to have the generally stronger criteria
  adopted by the Kernel maintainers to accept it[1].


[1] Ok, if an userspace driver stops, the kernel can still run (this is not different
than the great majority of kernel driver OOPSes: only the driver stops). Yet, if 
the driver is needed for normal operation of that system, having it stopped drops
the system availability.

Also, it is easier to replace an userspace driver than a kernel one, especially
if the distro has some mechanism to taint non-signed drivers, or if module
support is disabled.

> It's one reason we keep certain userspace out of the kernel.
> 
>> So, I can't see any advantage on doing something like that.
>>
> 
> Another advantage is you can debug and/or profile the driver more
> easily.

This is only partially true. The current debug tools available on the
Kernel are not hard to deal with, and are not behind what's available
on userspace.

> Consider a failed takeover attempt that results in a core dump
> (which also wouldn't result in a complete DoS of the machine).
>
> Anyway, I'm not arguing "this is the way it should be done". After all,
> not all machines are able to handle such a setup. But don't throw the
> baby out with the water, it's worth considering ways to make things
> safer. Also, let's not label things like this one as "microkernel" or
> "academia" and totally reject them; instead consider whether it's
> practical given recent advancements.
> 
> 
> 	Regards,
> 	Eduard
> 

