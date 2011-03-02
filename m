Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab1CBVrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:47:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55561
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab1CBVq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:46:59 -0500
Date: Wed, 02 Mar 2011 13:47:35 -0800 (PST)
Message-Id: <20110302.134735.260066220.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de,
        riel@redhat.com, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, benh@kernel.crashing.org,
        hugh.dickins@tiscali.co.uk, mel@csn.ul.ie, npiggin@kernel.dk,
        rmk@arm.linux.org.uk, cmetcalf@tilera.com, schwidefsky@de.ibm.com
Subject: Re: [RFC][PATCH 2/6] mm: Change flush_tlb_range() to take an
 mm_struct
From: David Miller <davem@davemloft.net>
In-Reply-To: <1299102027.1310.39.camel@laptop>
References: <20110302180258.956518392@chello.nl>
	<AANLkTimhWKhHojZ-9XZGSh3OzfPhvo__Dib9VfeMWoBQ@mail.gmail.com>
	<1299102027.1310.39.camel@laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 02 Mar 2011 22:40:27 +0100

> On Wed, 2011-03-02 at 11:19 -0800, Linus Torvalds wrote:
>> On Wed, Mar 2, 2011 at 9:59 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > In order to be able to properly support architecture that want/need to
>> > support TLB range invalidation, we need to change the
>> > flush_tlb_range() argument from a vm_area_struct to an mm_struct
>> > because the range might very well extend past one VMA, or not have a
>> > VMA at all.
>> 
>> I really don't think this is right. The whole "drop the icache
>> information" thing is a total anti-optimization, since for some
>> architectures, the icache flush is the _big_ deal. 
> 
> Right, so Tile has the I-cache flush from flush_tlb_range(), I'm not
> sure if that's the right thing to do, Documentation/cachetlb.txt seems
> to suggest doing it from update_mmu_cache() like things.

Sparc32 chips that require a valid TLB entry for I-cache flushes do
the flush from flush_cache_range() and similar.

Sparc64 does not have the "present TLB entry" requirement (since I-cache
is physical), and we handle it in update_mmu_cache() but only as an
optimization.  This scheme works in concert with flush_dcache_page().

Either scheme is valid, the former is best when flushing is based upon
virtual addresses.

But I'll be the first to admit that the interfaces we have for doing
this stuff is basically nothing more than a set of hooks, with
assurances that the hooks will be called in specific situations.  Like
anything else, it's evolved over time based upon architectural needs.

