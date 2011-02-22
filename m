Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1BVHtC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:49:02 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:47726 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1BVHtB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:11:1>);
	Tue, 22 Feb 2011 02:49:01 -0500
Message-Id: <4D6378760200007800033104@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 22 Feb 2011 07:48:54 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Andrea Arcangeli" <aarcange@redhat.com>,
        "Johannes Weiner" <jweiner@redhat.com>
Cc: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Hugh Dickins" <hughd@google.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Larry Woodman" <lwoodman@redhat.com>,
        "Rik van Riel" <riel@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
References: <20110204012109.GP5843@random.random>
 <4D4C6F45.6010204@goop.org> <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random> <20110217101941.GH2380@redhat.com>
 <20110221143023.GF13092@random.random> <20110221145350.GH25382@redhat.com>
In-Reply-To: <20110221145350.GH25382@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.02.11 at 15:53, Johannes Weiner <jweiner@redhat.com> wrote:
> On Mon, Feb 21, 2011 at 03:30:23PM +0100, Andrea Arcangeli wrote:
>> On Thu, Feb 17, 2011 at 11:19:41AM +0100, Johannes Weiner wrote:
>> > So Xen needs all page tables protected when pinning/unpinning and
>> > extended page_table_lock to cover kernel range, which it does nowhere
>> > else AFAICS.  But the places it extended are also taking the pgd_lock,
>> > so I wonder if Xen could just take the pgd_lock itself in these paths
>> > and we could revert page_table_lock back to cover user va only?
>> > Jeremy, could this work?  Untested.
>> 
>> If this works for Xen, I definitely prefer this.
> 
> Below is real submission, with changelog and sign-off and all (except
> testing on Xen itself, sorry).  I moved pgd_lock acquisition in this
> version to make the lock ordering perfectly clear.  Xen people, could
> you have a look at this?

While I think that it would be correct, it doesn't look like a
reasonable fix to me: It effectively serializes process (address
space) construction and destruction.

A possible alternative would be to acquire the page table lock
in vmalloc_sync_all() only in the Xen case (perhaps by storing
NULL into page->index in pgd_set_mm() when not running on
Xen). This is utilizing the fact that there aren't (supposed to
be - for non-pvops this is definitely the case) any TLB flush IPIs
under Xen, and hence the race you're trying to fix doesn't
exist there (while non-Xen doesn't need the extra locking).

Jan

