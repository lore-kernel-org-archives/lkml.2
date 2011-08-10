Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1HJOye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:54:34 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:1284 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1HJOyd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:8:1>);
	Wed, 10 Aug 2011 10:54:33 -0400
Message-Id: <4E42B8000200007800050992@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 10 Aug 2011 15:55:28 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <mjg@redhat.com>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Matt Fleming" <matt@console-pimps.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <hpa@linux.intel.com>,
        "Avi Kivity" <avi@redhat.com>, "Marcelo Tosatti" <mtosatti@redhat.com>,
        "johnstultz" <johnstul@us.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
 <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
 <4E4009A50200007800050258@nat28.tlf.novell.com>
 <20110810090330.GF26762@elte.hu>
 <4E426D4702000078000508B5@nat28.tlf.novell.com>
 <20110810095140.GB21059@elte.hu> 
In-Reply-To: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.08.11 at 15:12, Jan Beulich wrote:
> >>> On 10.08.11 at 11:51, Ingo Molnar <mingo@elte.hu> wrote:
> > * Jan Beulich <JBeulich@novell.com> wrote:
> >> But then again I don't seem to be able to boot 3.0.1 with both 
> >> patches applied on my only EFI box, so there must be something else 
> >> that broke, and hence maybe I really did test it (on 3.0-rc7) and 
> >> it worked then. Debugging...
> > 
> > Ok, once you figure it out we can merge all fixes upstream ASAP.
> 
> So this is a combination of two recent events: In my patch set, I
> recently removed efi.c's X86_32 conditional around setting
> x86_platform.[gs]et_wallclock. Without that removal, the deadlock
> wouldn't occur (because mach_get_cmos_time() would get called
> instead) on 64-bits, which is the only thing I run.
> 
> With that conditional removed, Matthew's NX consolidation patch
> gets into the way: For the physical call path it is simply wrong
> (correct only for the phys_efi_set_virtual_address_map() call, as
> there the memory map got virtual addresses assigned already) -
> it switches from early_runtime_code_mapping_set_exec()'s using
> of md->phys_addr to efi_set_executable() using md->virt_addr.
> But the latter isn't set at that point yet. And it's unclear to me why
> this works on 32-bit.

Worse - even the original code would not have worked afaict. Calling
set_memory_{,n}x() this early cannot work without a small adjustment
to the CPA logic, as all of the flushing functions have
BUG_ON(irqs_disabled()) at their beginning.

Jan

