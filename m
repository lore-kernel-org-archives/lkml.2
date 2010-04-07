Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab0DGWtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:49:46 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:48696 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0DGWto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:49:44 -0400
Message-ID: <4BBD0B0A.3090702@oracle.com>
Date: Wed, 07 Apr 2010 15:45:30 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Andy Isaacson <adi@hexapodia.org>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <20100407210628.28364.96982.stgit@bob.kio>
In-Reply-To: <20100407210628.28364.96982.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BBD0BC6.0155:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 02:06 PM, Bjorn Helgaas wrote:
> 
> Currently, we only reserve the legacy VGA area [mem 0xa0000-0xbffff] on
> x86_32.  But this legacy area is also used on x86_64, so this patch
> reserves it there, too.
> 
> If we don't reserve it, we may mistakenly move a PCI device to that area,
> as we did here:
> 
>   pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
>   pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
>   pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
>   pci 0000:00:1f.2: BAR 5: assigned [mem 0x000a0000-0x000a07ff]
> 
> as reported by Andy Isaacson at http://lkml.org/lkml/2010/4/6/375
> 
> I think the fact that the BAR is not within a host bridge window is a
> BIOS defect, and it's now more visible because we have "pci=use_crs" as
> the default.  Using "pci=nocrs" is a workaround, because then we won't
> attempt to move the device.

that doesn't look right.

It seem another thread, erission has one model without VGA, and they use that area for other device MMIO.

current for 64bit, We remove [0xa0000, 0x100000) from e820 map if those area is E820_RAM.

in e820_reserve_resources(), kernel will reserve range < 1M according to e820 map.
that is before pci BAR is claimed.

or you can add
boot_params.screen_info.orig_video_isVGA == 1
or double check scan pci tree to see if video is there or not

YH
