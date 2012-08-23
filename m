Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab2HWXyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:54:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58353 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab2HWXyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:54:12 -0400
Message-ID: <5036C297.80402@zytor.com>
Date: Thu, 23 Aug 2012 16:53:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/4] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1344983957-4996-1-git-send-email-jacob.shin@amd.com> <1344983957-4996-4-git-send-email-jacob.shin@amd.com> <50356BA9.5030906@zytor.com> <20120823145043.GA4671@jshin-Toonie> <50364E9E.6020104@zytor.com> <20120823223514.GA6502@jshin-Toonie>
In-Reply-To: <20120823223514.GA6502@jshin-Toonie>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 03:35 PM, Jacob Shin wrote:
> 
> I looked into this a bit more, and I think what's happening is that this
> user defined memory map leaves out the region where the kernel is loaded on
> to during the boot process. The kernel and the direct mapped page tables up
> to initial max_pfn_mapped reside somwhere under 512M (KERNEL_IMAGE_SIZE),
> I guess it depends on how big your uncompressed kernel is.
> 
> And at the first attempt to set_fixmap_nocache(FIX_APIC_BASE, address) in
> arch/x86/apic/apic.c: register_lapic_address runs into badness because the
> memory region where the initial page tables live is no longer mapped
> because of the above user supplied memory map.
> 
> So I guess there is a disconnect between really early code that seems to
> rely on the boot loader as to where in physical memory it resides and its
> initial page tables live, and the later memory initialization code where
> it looks at the E820 (and here user can interject their own memory map
> using the command line arguments)
> 
> Not really sure how to handle this case .. any advice?
> 

We have two options: one scream really loud and die, assuming the
bootloader actually loaded us on top of non-memory and we're going to
die anyway; or scream really loud but try to continue (i.e. override the
memory type).  I would suggest doing the latter in the near term, and
shift to the former a bit further down the line.

	-hpa
