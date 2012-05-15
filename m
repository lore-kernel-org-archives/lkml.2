Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2EONSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:18:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59717 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab2EONSj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 15 May 2012 09:18:39 -0400
Message-Id: <4FB273EB0200007800083D32@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 15 May 2012 14:19:07 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <matt.fleming@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
 <20120515124707.GB25248@srcf.ucam.org>
In-Reply-To: <20120515124707.GB25248@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.05.12 at 14:47, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, May 15, 2012 at 01:18:19PM +0100, Jan Beulich wrote:
> 
>> Simply removing the #ifdef around the respective code isn't enough,
>> however: The runtime code must not only be forced to be executable, it
>> also must have a proper virtual address set (which on at least the
>> system I'm testing on isn't the case for all necessary regions, or at
>> least not as early as they're now being required).
> 
> I don't understand this. The get_time pointer won't be updated to the 
> virtual function until the end of efi_enter_virtual_mode, at which point 
> all runtime regions should have a virtual address mapped. We also call 
> runtime_code_page_mkexec() immediately after updating that pointer, 
> although maybe the order should be swapped. So I think the bug you're 
> fixing is not the bug you think you're fixing...

I would have expected that things work that way, but they
don't. In particular is the function in efi_64.c that's being
modified here called from efi_call_phys_{pro,epi}log(), and at
that point we can't expect virtual addresses to be uniformly
set yet. So it's a physical call that requires the fixup done
here, as efi_set_executable() simply expects ->virt_addr to
be valid. I suspect that no physical calls other than
phys_efi_set_virtual_address_map() were being done so far
at all on 64-bit, hiding the problem.

Jan

