Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1LIUQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:16:18 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:5669 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1LIUQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:16:16 -0500
Date: Fri, 9 Dec 2011 21:16:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, davej@redhat.com, axboe@kernel.dk,
        hpa@zytor.com, herbert@gondor.hengli.com.au, ying.huang@intel.com,
        lenb@kernel.org
Subject: Re: [PATCH 01/10] Add driver auto probing for x86 features
Message-ID: <20111209211601.08dabc88@endymion.delvare>
In-Reply-To: <20111208144516.GE24062@one.firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
	<1323304882-27953-2-git-send-email-andi@firstfloor.org>
	<20111208103540.4778b896@endymion.delvare>
	<20111208144516.GE24062@one.firstfloor.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Thu, 8 Dec 2011 15:45:16 +0100, Andi Kleen wrote:
> On Thu, Dec 08, 2011 at 10:35:40AM +0100, Jean Delvare wrote:
> > > +/**
> > > + * x86_match_cpu - match current CPU again an array of x86_cpu_ids
> > 
> > The code is actually matching the boot cpu, which isn't necessarily the
> > current CPU. I think it would be better to let the caller pass a
> > specific cpu as a parameter. At least the hwmon drivers would benefit
> > from that. Then you can add an helper function x86_match_boot_cpu()
> > calling x86_match_cpu() on &boot_cpu_data if you want.
> 
> I don't really see a point of this currently -- the udev/modprobe loading is 
> global anyways.

Irrelevant. You load a driver when any, not all, of the devices in the
system are supported by said driver. This obviously holds for PCI
devices and drivers (you don't refrain from loading the network card's
driver because that driver doesn't support your graphics card), the CPU
device case is no different (in theory at least.)

As a matter of fact, the sensors-detect script (which is in charge of
finding the right hwmon drivers to load on a given system when these
drivers do not support auto-loading via module aliases) does exactly
this for CPU thermal sensor detection. It loops over the complete list
of online CPUs, and if any is supported by coretemp or via-cputemp,
then it suggests loading the driver in question. The search is not
limited to CPU#0.

> If we really want to support asymmetric configs a lot 
> more work all over the kernel is needed and this could be still
> changed.

Can you guarantee that there is no asymmetric system already working
today? If you can't, then your approach could cause a regression. This
is why I am asking for an API change to let drivers pass a specific CPU
to x86_match_cpu(). There are at least two drivers who would take
benefit of this. Your patch set is supposed to only add driver
auto-loading, and while cleaning up the code in the process is nice, I
think you should avoid driver behavior changes, these are out of scope
for such a patch set.

Seriously, this API change is very small and unintrusive, so I just
can't think of a valid reason to not do it.

-- 
Jean Delvare
