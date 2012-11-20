Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab2KTQUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:20:05 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64201 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab2KTQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:20:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC] dt/platform: Use cell-index for device naming if available
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <50A70485.90302@codeaurora.org>
References: <1352508532-19241-1-git-send-email-stepanm@codeaurora.org>    <509F0E56.6080806@gmail.com>    <CACxGe6s3gJ4fmhn9VBd1Fq8bH5S0_ejmE=KqVjYn20bT42wQ_Q@mail.gmail.com> <554191d69bc21a4b133fb876df84ff89.squirrel@www.codeaurora.org> <50A1B50B.4020509@codeaurora.org> <20121115161020.3205E3E194B@localhost> <50A70485.90302@codeaurora.org>
Date: Tue, 20 Nov 2012 16:19:57 +0000
Message-Id: <20121120161957.7CE973E102F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012 19:29:09 -0800, Stepan Moskovchenko <stepanm@codeaurora.org> wrote:
> On 11/15/2012 8:10 AM, Grant Likely wrote:
> > On Mon, 12 Nov 2012 18:48:43 -0800, Stepan Moskovchenko <stepanm@codeaurora.org> wrote:
> >
> > Well, why exactly do you want to control the names of devices? Is it so
> > that devices match up with what they are, or is it to make things match
> > up with things like clocks and regulators. If it is the latter, then no,
> > don't do this. Use auxdata. When the kernel requires a specific name for
> > a device it is very much a kernel *internal* detail. It does not make
> > sense to encode that into the device tree when it isn't something part
> > of the binding.
> 
> Hi Grant,
> I realize that auxdata is the correct thing to use for keeping the 
> kernel happy (for things like clocks and regulator consumers) but this 
> is not the problem I am trying to solve. My goal is to try to keep 
> userspace happy by trying to create common and predictable names for 
> functionally equivalent devices across different hardware platforms.
> For instance, two similar SoCs may have an SDCC controller which may be 
> logically referred to as "the first SDCC device", though the physical 
> address of this device may be different on the two SoCs. And, due to the 
> <reg>.<name> naming convention, the sysfs entries associated with a 
> particular device will be a dependent on the physical address of the device.
> 
> If userspace wants to touch the sysfs entries of what can logically be 
> described as "the first SDCC device", then userspace needs to know the 
> physical address of this device on each SoC variant it may be running 
> on, since the path to the sysfs entries for this device will be based on 
> the physical address of the device. By using a device naming scheme that 
> replaces the physical address with a logical device number, the 
> userspace-facing interface for each device (such as sysfs entries) could 
> be kept common across SoC variants even when device physical addresses 
> can move around but devices still have the same logical assignments.

Okay, so the thinking is that if the generated name of a device can be
manipulated, say as 'serial0', then userspace can easily find the
device. Correct? If so, then be careful. Userspace is not supposed to
ever rely on a particular path to a device. Instead, userspace is
supposed to wait for a uevent to announce a device's existence, and then
use the data in the uevent attribute.

We /could/ use a device tree alias to manipulate the name of the device,
but as several people have pointed out there can be more than one alias
to a node. Which one do we use? I know I suggested using aliases a
couple of weeks ago, but I now think it is a bad idea after mulling it
over a bit.

What if instead we added something like OF_ALIASES to the uevent
attribute? Then userspace would have access to all the aliases for a
device. Heck, even a shell script can parse the uevent attribute. There
is also precedence for exporting OF data using a uevent. This is from
the versatile device tree support:

# cat /sys/devices/amba.0/uevent 
OF_NAME=amba
OF_FULLNAME=/amba
OF_COMPATIBLE_0=arm,amba-bus
OF_COMPATIBLE_N=1
MODALIAS=of:NambaT<NULL>Carm,amba-bus


> I realize that this problem can be solved by using auxdata to set the 
> device name, but in this case the only purpose of the auxdata would be 
> to keep userspace happy, since all the other in-kernel relationships 
> (for things like clocks and regulators) can already work without having 
> to rely on auxdata. So, introducing auxdata just for consistency of 
> userspace-facing names seems silly and, I am trying to come up with a 
> more appropriate solution.

Yeah, auxdata is completely inappropriate for this.

> 
> What do you think?
> 
> Steve
> 
> -- 
>   The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>   hosted by The Linux Foundation

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
