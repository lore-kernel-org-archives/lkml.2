Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1BXIXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:23:43 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:33433 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab1BXIXm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:11:1>);
	Thu, 24 Feb 2011 03:23:42 -0500
Message-Id: <4D66239902000078000336D6@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 24 Feb 2011 08:23:37 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andrea Arcangeli" <aarcange@redhat.com>
Cc: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Hugh Dickins" <hughd@google.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Johannes Weiner" <jweiner@redhat.com>,
        "Larry Woodman" <lwoodman@redhat.com>,
        "Rik van Riel" <riel@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
References: <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random> <20110217101941.GH2380@redhat.com>
 <20110221143023.GF13092@random.random> <20110221145350.GH25382@redhat.com>
 <4D6378760200007800033104@vpn.id2.novell.com>
 <20110222134956.GU13092@random.random>
 <4D63D4CD020000780003320A@vpn.id2.novell.com>
 <20110224042222.GG31195@random.random>
In-Reply-To: <20110224042222.GG31195@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.02.11 at 05:22, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Tue, Feb 22, 2011 at 02:22:53PM +0000, Jan Beulich wrote:
>> >>> On 22.02.11 at 14:49, Andrea Arcangeli <aarcange@redhat.com> wrote:
>> > On Tue, Feb 22, 2011 at 07:48:54AM +0000, Jan Beulich wrote:
>> >> A possible alternative would be to acquire the page table lock
>> >> in vmalloc_sync_all() only in the Xen case (perhaps by storing
>> >> NULL into page->index in pgd_set_mm() when not running on
>> >> Xen). This is utilizing the fact that there aren't (supposed to
>> >> be - for non-pvops this is definitely the case) any TLB flush IPIs
>> >> under Xen, and hence the race you're trying to fix doesn't
>> >> exist there (while non-Xen doesn't need the extra locking).
>> > 
>> > That's sure ok with me. Can we use a global runtime to check if the
>> > guest is running under Xen paravirt, instead of passing that info
>> > through page->something?
>> 
>> If everyone's okay with putting a couple of "if (xen_pv_domain())"
>> into mm/fault.c - sure. I would have thought that this wouldn't be
>> liked, hence the suggestion to make this depend on seeing the
>> backlink be non-NULL.
> 
> What about this? The page->private logic gets optimized away at
> compile time with XEN=n.
> 
> The removal of _irqsave from pgd_lock, I'll delay it as it's no bugfix
> anymore.
> 
> ===
> Subject: xen: stop taking the page_table_lock with irq disabled
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> It's forbidden to take the page_table_lock with the irq disabled or if there's
> contention the IPIs (for tlb flushes) sent with the page_table_lock held will
> never run leading to a deadlock.
> 
> Only Xen needs the page_table_lock and Xen won't need IPI TLB flushes hence 
> the deadlock doesn't exist for Xen.

Looks reasonable to me, except for the implementation no longer
matching subject and description (the lock still gets taken with
IRQs disabled, just that - as far as we can tell so far - doesn't
matter for Xen).

With the conditional on the reader side I also wonder whether
the conditional on the writer side is really a good thing to have,
considering that generally distro kernels are likely to have XEN
enabled.

Jan

