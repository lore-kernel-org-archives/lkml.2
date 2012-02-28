Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2B1Cdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:33:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49844 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2B1Cdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:33:53 -0500
Message-ID: <4F4C3CF3.9030804@zytor.com>
Date: Mon, 27 Feb 2012 18:33:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Keith Packard <keithp@keithp.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32
 oops
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 05:30 AM, Matt Fleming wrote:
> 
> Despite first impressions, it's not possible to use ioremap_cache() to
> map all cached memory regions on CONFIG_X86_64 because of the way that
> the memory map might be configured as detailed in the following bug
> report,
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=748516
> 
> Therefore, we need to ensure that any regions requiring a runtime
> mapping are covered by the direct kernel mapping table. Previously,
> this was taken care of by efi_ioremap() but if we handle this case
> earlier, in setup_arch(), we can delete the CONFIG_X86_32 and
> CONFIG_X86_64 efi_ioremap() implementations entirely.
> 

I went through the bug report but it's not entirely clear to me what the
fundamental root cause of the problem is, as opposed to what are
symptoms.  We need to straighten this out, and we need to do so fairly soon.

It would seem logical that we include in the kernel memory mapping the
regions we need, and *ONLY* the regions necessary; in particular we
shouldn't include *any* memory holes except for the < 1 MiB legacy
region (which is okay because of fixed MTRRs, but even that should be
eventually nuked.  That will require driver work hough.)

As I said, in a lot of ways the right thing would be for ioremap() to
manifest mappings in the standard 1:1 position, but when I very very
briefly looked at it it look ed like that would require core changes
which probably makes it too much work.

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

