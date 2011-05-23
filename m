Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab1EWWFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:05:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29431 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1EWWFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:05:53 -0400
Date: Mon, 23 May 2011 18:05:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110523220536.GB11961@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DDADA3C.0049:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 10:56:27PM +0100, Daniel Haid wrote:
> Hello,
> 
> I have an x86_64 system with a VIA chipset and 4GB of RAM. The
> mainboard
> is an ASUS M2V where the bios-setup has an option called "Map around
> memory hole" and I have an "ATI Technologies Inc RV710 [Radeon HD

There had to be more than 'Map around memory hole'? Was it called
GART or IOMMU?

> 4350]"
> graphics card according to lspci.
> 
> Now one of the following things happen to my system:
> 
> 1) With the bios-option enabled and no kernel parameters I get the
> following error:
> 
> [drm:r600_ring_test] *ERROR* radeon: ring test failed
> (scratch(0x8504)=0xCAFEDEAD)
> radeon 0000:02:00.0: disabling GPU acceleration
> 
> and then I can not use any 3d-acceleration. I also get the message

The problem you are hitting (I think) is that the AMD GART poor-man IOMMU is turned off
and the SWIOTLB is used instead. If you would like some technical
details, take a look at:
http://lists.freedesktop.org/archives/dri-devel/2011-January/006885.html
(the point #2 is what you are hitting).

> 
> Looks like a VIA chipset. Disabling IOMMU. Override with iommu=allowed
> 
> 2) With the bios-option enabled and "mem=3072M" I can not use only
> 3GB of RAM,
> but the radeon card works.
> 
> 3) With the bios-option enabled and "iommu=allowed" I get 4GB of RAM
> and
> the radeon card works. But I wonder whether this can have any bad
> effects?

Not sure why the AMD GART IOMMU gets disabled on VIA chipsets. You might
want to use 'git gui blame arch/x86/kernel/early-quirks.c' and look
at the code in question to figure that out.

> 
> 4) Without the bios-option (and without any kernel parameters) I do not
> get the "Looks like a VIA chipset. Disabling IOMMU. Override with
> iommu=allowed"
> message, but strangely linux shows only about 3GB of RAM.
> 
> I did not try other combinations. Now my questions are
> 
> A) Is this a bug in the radeon driver? Or maybe not, since
> Documentation/x86/x86_64/boot-options.txt
> seems to imply that for >3GB an iommu is required?

Correct, and an IOMMU does get turned on. The SWIOTLB one.
> 
> B) Is it safe to use iommu=allowed in my case ? If not, what
> problems will I encounter and what
> options should I use instead? Will I be stuck with 3GB of RAM?

Well, if everything works.... but you might just want to use
the git gui blame to take a look at the back-story of why the quirk
was added.
