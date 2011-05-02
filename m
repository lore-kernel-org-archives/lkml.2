Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1EBTsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:48:41 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:49997 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1EBTsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:48:40 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Topic: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
Thread-Index: AQHMBGnbOdiUysHbTUGr026Sn7cwwZRw2pzQgADfZgD//9dIkIAAhckAgALsDiCAAIGrgIADE/mA//+K1cCAAHyegP//qoFAABSsIIAAII/J0A==
Date: Mon, 2 May 2011 19:48:38 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DF543@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <6E21E5352C11B742B20C142EB499E0481DD185@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427064550.GA597@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD266@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110427121856.GA20633@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DD676@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110429164025.GA7698@kroah.com> <20110501154041.GB15210@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DF253@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110501160721.GA8195@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481DF2A0@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110501205315.GC1017@infradead.org>
In-Reply-To: <20110501205315.GC1017@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, May 01, 2011 4:53 PM
> To: KY Srinivasan
> Cc: Greg KH; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/25] Staging: hv: Cleanup vmbus driver code
> 
> On Sun, May 01, 2011 at 06:08:37PM +0000, KY Srinivasan wrote:
> > Could you elaborate on the problems/issues when the block driver registers for
> the
> > IDE majors. On the Qemu side, we have a mechanism to disable the emulation
> when
> > PV drivers load. I don't think there is an equivalent mechanism on the Windows
> side.
> > So, as far as I know, registering for the IDE majors is the only way to also
> prevent native
> > drivers in Linux from taking control of the emulated device.
> 
> What qemu are you talking about for the qemu side?  Upstream qemu
> doesn't have any way to provide the same image as multiple devices,
> nevermind dynamically unplugging bits in that case.  Nor does it support
> the hyperv devices.

I am talking about the qemu that was (is) shipping with Xen.  In Hyper-V,
the block devices configured as IDE devices for the guest will be taken over
by the native drivers if the PV drivers don't load first and  take over the IDE majors.
If you want to have the root device be managed by the PV drivers, this appears to be
the only way to ensure that native IDE drivers don't take over the root device. Granted,
this depends on ensuring the PV drivers load first, but I don't know if there is another way
to achieve this.

> 
> When you steal majors you rely on:
> 
>  a) loading earlier than the driver you steal them from
>  b) the driver not simple using other numbers
>  c) if it doesn't preventing it from working at all, also for
>     devices you don't "replace" with your PV devices.

These are exactly the issues that had to be solved to have the PV 
drivers manage the root device.

>  d) that the guest actually uses the minors your claim, e.g. any
>     current linux distribution uses libata anyway, so you old IDE
>     major claim wouldn't do anything.  Nor would claiming sd majors
>     as the low-level libata driver would still drive the hardware
>     even if SD doesn't bind to it.

By setting up appropriate modprobe rules, this can be addressed.

> 
> You really must never present the same device as two emulated devices
> instead of doing such hacks.

Agreed; I am not sure what the right solution for Hyper-V is other than 
(a) preventing the native IDE drivers from loading and (b) having
the right modprobe rules to ensure libata would not present these
same devices to the guest as scsi devices.

Regards,

K. Y
