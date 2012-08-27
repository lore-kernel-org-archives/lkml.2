Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2H0UPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:15:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35819 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab2H0UP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:15:29 -0400
Message-ID: <503BD556.8080406@zytor.com>
Date: Mon, 27 Aug 2012 13:15:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com> <1345852516-3125-4-git-send-email-jacob.shin@amd.com> <50381C9D.5070007@zytor.com> <20120825004859.GB10812@jshin-Toonie> <5038269E.80707@zytor.com> <20120825042020.GC26127@jshin-Toonie> <503852BE.1010908@zytor.com> <20120827191729.GB23135@jshin-Toonie>
In-Reply-To: <20120827191729.GB23135@jshin-Toonie>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 12:17 PM, Jacob Shin wrote:
> 
> if there is E820_RAM right above ISA region, then you get to initialize
> 0 ~ max_low_pfn in one big chunk, which results in some memory configurations
> for more 2M or 1G page tables which means less space used for page tables.
> 

We need to be able to coalesce small page tables to large, anyway; there
are plenty of machines in the field who do small chunks.  I'm not too
worried about the legacy region being in 4K pages; it will be broken
into 4K pages anyway by the TLB.

Another thing is that we may want to map from the top down (on i386 at
least top of lowmem down); we don't want to fill low memory with page
tables because of devices with restricted DMA masks.

> im also worried about the case where that first call to init_memory_mapping
> for 0 ~ 1MB, results in max_pfn_mapped = 1MB, and the next call to
> init_memory_mapping is some large enough area, where we don't have enough
> space under 1MB for all the page tables needed (maybe only 4K page tables
> are supported or something).

This is serious... I'm worrying that this might be a more general
problem.  In that case we probably need to handle the case where we have
filled up all the "free" memory with page tables for the next chunk;
however, in that case the answer is pretty simple: we can then allow the
memory already mapped to become page tables for the new chunk.

	-hpa
