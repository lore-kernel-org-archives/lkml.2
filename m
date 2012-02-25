Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2BYPMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 10:12:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51815 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab2BYPMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 10:12:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of edgmnt@gmail.com designates 10.14.100.142 as permitted sender) smtp.mail=edgmnt@gmail.com; dkim=pass header.i=edgmnt@gmail.com
Date: Sat, 25 Feb 2012 17:10:59 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jidong Xiao <jidong.xiao@gmail.com>, david@lang.hm,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120225150940.GA3719@localhost>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <4F4661D6.7030809@gmail.com>
 <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
 <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
 <CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com>
 <20120224162109.1bbf157b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224162109.1bbf157b@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 04:21:09PM -0200, Mauro Carvalho Chehab wrote:
> Moving a buggy driver to userspace won't fix the bug. You're just moving
> it from one place to another place. Also, the code will likely require changes
> to work on userspace, so, the chances are that you're actually introducing more
> bugs.

Hi,


It does provide isolation, see below.

> The impact of the bug won't also reduce, on most cases, as the userspace driver
> will very likely require root capabilities.

Not as proposed, that's the point. For IOMMU-enabled systems, you can
safely delegate an entire device to a userspace device and minimize
privileged code. If I understand correctly, the performance impact is
also minimal with respect to driver <-> device interaction. I'm not sure
if driver <-> client might be problematic, but you can probably have the
device DMA directly from/into client memory given the right mechanisms.

This is currently employed by virtualization software to do PCI
passthrough. The guest OS can directly control the hardware.

Sure, you can't do it without proper hardware support. The question is
how we can reuse existing code.

> Also, as driver talks directly with the hardware, an userspace block driver
> would have access to the raw disk data. So, even if you find a way for it to
> run unprivileged, it can still mangle the data written on the disk, and
> even have a malicious code there that adds or allows to add a malware at the
> disk partitions.

That's true, but it still makes sense for other drivers, say NIC
drivers. Why should corrupting a network driver possibly result in total
privilege escalation?

> That's said, there are much more eyes inspecting the kernel sources than on any 
> other userspace project. So, the risk of a bad code to be inserted unnoticed at
> the Linux kernel is degrees of magnitude lower than on an userspace driver.

Those much more eyes have already missed important bugs in the past. No
disrespect here, I'm just saying in many cases (like the one mentioned
above) this approach almost eliminates the issue altogether. It's one
reason we keep certain userspace out of the kernel.

> So, I can't see any advantage on doing something like that.
> 

Another advantage is you can debug and/or profile the driver more
easily. Consider a failed takeover attempt that results in a core dump
(which also wouldn't result in a complete DoS of the machine).

Anyway, I'm not arguing "this is the way it should be done". After all,
not all machines are able to handle such a setup. But don't throw the
baby out with the water, it's worth considering ways to make things
safer. Also, let's not label things like this one as "microkernel" or
"academia" and totally reject them; instead consider whether it's
practical given recent advancements.


	Regards,
	Eduard

