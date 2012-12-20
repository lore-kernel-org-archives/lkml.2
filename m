Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2LTNll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:41:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab2LTNlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:41:32 -0500
Message-ID: <1356010887.10845.11.camel@ul30vt.home>
Subject: Re: [PATCH 0/7] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Dec 2012 06:41:27 -0700
In-Reply-To: <20121220132255.GH17584@redhat.com>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
	 <20121219213037.b234f9d4f187df2132e65576@gmail.com>
	 <1355931777.3224.562.camel@bling.home>
	 <20121220140232.67733085.yoshikawa_takuya_b1@lab.ntt.co.jp>
	 <20121220125946.GB7750@amt.cnet> <20121220132255.GH17584@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 15:22 +0200, Gleb Natapov wrote:
> On Thu, Dec 20, 2012 at 10:59:46AM -0200, Marcelo Tosatti wrote:
> > On Thu, Dec 20, 2012 at 02:02:32PM +0900, Takuya Yoshikawa wrote:
> > > On Wed, 19 Dec 2012 08:42:57 -0700
> > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > 
> > > > Please let me know if you can identify one of these as the culprit.
> > > > They're all very simple, but there's always a chance I've missed a hard
> > > > coding of slot numbers somewhere.  Thanks,
> > > 
> > > I identified the one:
> > >   commit b7f69c555ca430129b6cde81e9f0927531420c5c
> > >   KVM: Minor memory slot optimization
> > > 
> > > IIUC, the problem was that you did not care about the generation of
> > > slots which was updated by update_memslots():
> > > 
> > >   Your patch reused the old memory slots which was there before
> > >   doing the update for invalidating the slot, and badly, we did flush
> > >   shadow pages after that before doing the second update for finally
> > >   installing the new slot.  As a result, the generation did not change
> > >   from that of the invalidated one, although the ghc(gfn to hva cache)
> > >   might be stale.
> > > 
> > >   After that, kvm_write_guest_cached() checked if ghc should be
> > >   initialized by comparing ghc's generation with that old one,
> > >   resulting mark_page_dirty_in_slot() was called with the invalid
> > >   cache contents.
> > > 
> > > Although we can do something to correct the generation alone, I do not
> > > think such a trick is worth it because this is not a hot path.  Let's
> > > just revert the patch.
> > 
> > Agreed. No dependencies by the following patches on it?
> Heh, this generation management looks subtle. Would be easy to break by
> other changes to the code. I wounder can we make it less subtle somehow.

Hmm, isn't the fix as simple as:

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -847,7 +847,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
                                GFP_KERNEL);
                if (!slots)
                        goto out_free;
-       }
+       } else
+               slots->generation = kvm->memslots->generation;
 
        /* map new memory slot into the iommu */
        if (npages) {

Or even just slots->generation++ since we're holding the lock across all
of this.

The original patch can be reverted, there are no following dependencies,
but the idea was that we're making the memslot array larger, so there
could be more pressure in allocating it, so let's not trivially do extra
frees and allocs.  Thanks,

Alex

