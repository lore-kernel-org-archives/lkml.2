Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2B1RfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:35:17 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57839 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609Ab2B1RfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:35:15 -0500
Subject: Re: [PATCH] x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32
 oops
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Keith Packard <keithp@keithp.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4F4C3CF3.9030804@zytor.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	 <4F4C3CF3.9030804@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Feb 2012 17:35:03 +0000
Message-ID: <1330450503.4924.59.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 18:33 -0800, H. Peter Anvin wrote:
> On 02/20/2012 05:30 AM, Matt Fleming wrote:
> > 
> > Despite first impressions, it's not possible to use ioremap_cache() to
> > map all cached memory regions on CONFIG_X86_64 because of the way that
> > the memory map might be configured as detailed in the following bug
> > report,
> > 
> > 	https://bugzilla.redhat.com/show_bug.cgi?id=748516
> > 
> > Therefore, we need to ensure that any regions requiring a runtime
> > mapping are covered by the direct kernel mapping table. Previously,
> > this was taken care of by efi_ioremap() but if we handle this case
> > earlier, in setup_arch(), we can delete the CONFIG_X86_32 and
> > CONFIG_X86_64 efi_ioremap() implementations entirely.
> > 
> 
> I went through the bug report but it's not entirely clear to me what the
> fundamental root cause of the problem is, as opposed to what are
> symptoms.  We need to straighten this out, and we need to do so fairly soon.

Right. Honestly, I'm not sure what the root cause is. What is clear is
that we can't arbitrarily map EFI_RUNTIME_SERVICES* regions with
ioremap(), but not why we can't do that. I suspect the only way to
deduce the root cause is to figure out how to make it work.

It might be possible to map the EFI runtime regions with ioremap() as
long as we maintain the same distance between regions as in the initial
physical memory map. But I don't have a Macbook Air to test that idea
out on and trying to solicit testers for previous patches hasn't gone
very well.

> It would seem logical that we include in the kernel memory mapping the
> regions we need, and *ONLY* the regions necessary; in particular we
> shouldn't include *any* memory holes except for the < 1 MiB legacy
> region (which is okay because of fixed MTRRs, but even that should be
> eventually nuked.  That will require driver work hough.)

Seems fair enough. Note that this patch doesn't change that behaviour,
the holes were mapped prior to this.

-- 
Matt Fleming, Intel Open Source Technology Center

