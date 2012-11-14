Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab2KNOob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:44:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab2KNOoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:44:30 -0500
Date: Wed, 14 Nov 2012 12:37:47 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: lazily drop large spte
Message-ID: <20121114143747.GA7054@amt.cnet>
References: <50978DFE.1000005@linux.vnet.ibm.com>
 <20121112231032.GB5798@amt.cnet>
 <50A20428.1030004@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A20428.1030004@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 04:26:16PM +0800, Xiao Guangrong wrote:
> Hi Marcelo,
> 
> On 11/13/2012 07:10 AM, Marcelo Tosatti wrote:
> > On Mon, Nov 05, 2012 at 05:59:26PM +0800, Xiao Guangrong wrote:
> >> Do not drop large spte until it can be insteaded by small pages so that
> >> the guest can happliy read memory through it
> >>
> >> The idea is from Avi:
> >> | As I mentioned before, write-protecting a large spte is a good idea,
> >> | since it moves some work from protect-time to fault-time, so it reduces
> >> | jitter.  This removes the need for the return value.
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >> ---
> >>  arch/x86/kvm/mmu.c |   34 +++++++++-------------------------
> >>  1 files changed, 9 insertions(+), 25 deletions(-)
> > 
> > Its likely that other 4k pages are mapped read-write in the 2mb range 
> > covered by a read-only 2mb map. Therefore its not entirely useful to
> > map read-only. 
> > 
> 
> It needs a page fault to install a pte even if it is the read access.
> After the change, the page fault can be avoided.
> 
> > Can you measure an improvement with this change?
> 
> I have a test case to measure the read time which has been attached.
> It maps 4k pages at first (dirt-loggged), then switch to large sptes
> (stop dirt-logging), at the last, measure the read access time after write
> protect sptes.
> 
> Before: 23314111 ns	After: 11404197 ns

Ok, i'm concerned about cases similar to e49146dce8c3dc6f44 (with shadow),
that is:

- large page must be destroyed when write protecting due to 
shadowed page.
- with shadow, it does not make sense to write protect 
large sptes as mentioned earlier.

So i wonder why is this part from your patch

-               if (level > PT_PAGE_TABLE_LEVEL &&
-                   has_wrprotected_page(vcpu->kvm, gfn, level)) {
-                       ret = 1;
-                       drop_spte(vcpu->kvm, sptep);
-                       goto done;
-               }

necessary (assuming EPT is in use).

