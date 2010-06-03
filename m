Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab0FCC54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:57:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45655 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab0FCC5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lG+ZOeS7zht0wNXzXRIlTPHvOkTj3ushwvaQoTBHiJQvz2YdWQdPS6uDjfnVj0l5ZI
         qVE26INgFeR1HQXMOPgPsrzt1RlDXRdXfSglqqsjLnlDdhfUO92tzQ+I5/ZO3jhjzHP3
         2iddO3mhK5lyggXxTNwPFmrSICjCYgCEAoiKU=
MIME-Version: 1.0
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com> 
	<20100601183920.GB19955@kroah.com> <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com> 
	<AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com> 
	<EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com>
From: Frank Pan <frankpzh@gmail.com>
Date: Thu, 3 Jun 2010 10:57:34 +0800
Message-ID: <AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com>
Subject: Re: Add a helper function in PCI IOV to get VF device
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mitch,

> Frank, I'm not sure what you're trying to accomplish here. All of the information you need is already in sysfs. Given the PF device, you can look at /sys/class/net/ethX/device/virtfnX to get the bus/device/function of each of the VF devices.

Yes, that's the most funny part. Sysfs can only be traversed in
usespace. So the thing userspace knows isn't known by driver(pf driver
have no idea about vf's bdf), while the thing driver knows isn't known
by userspace(one cannot infer pf's bdf from vf's bdf).
Please think kernel/userspace as 2 system, they can hardly communicate
these informations. IMHO give a syscall/ioctl telling these is funny
and strange.

> If the VF driver is loaded in your kernel, then given the bus/device/function of the vf device, you can look at /sys/class/net/ethX/device/virtfnX/net to see which interface corresponds to that VF.

VF driver will never be loaded on physical machine, it can only be
loaded in a virtual machine. On a physical machine, VF won't have any
interface.

> Furthermore, if the VF driver is loaded, you can find the PF device by looking at /sys/class/net/ethX/device/physfn, and you can find out which interface it is by looking at /sys/class/net/ethX/device/physfn/net

So, when VF has no interface, this path is also unavailable. That's
why I say given vf's bdf, one cannot infer pf's.

> The current PF drivers (both ixgbe and igb) do not directly manipulate sysfs at all, so there is no /sys/class/net/ethX/vfX. If you see this setup, you are using a very, very old version of the igb driver, which is not supported at all. Please upgrade to a recent kernel/driver combination.

You are right, vfX is not available now. Anyway, I'm hacking igb
driver to provide informations about vf into userspace. When driver
don't know vf's bdf and userspace don't know pf's bdf, this thing
cannot be done. That's the motivation of this patch.

Don't forget another one: PF cannot access VF's PCI space. This is
also a <maybe common> use case. I need this to dump/change the VF's
PCI space.

Thanks for reply.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
