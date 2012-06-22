Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab2FVOdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:33:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51758 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab2FVOdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:33:44 -0400
Date: Fri, 22 Jun 2012 23:33:38 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de, paulus@samba.org,
        aarcange@redhat.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: MMU: Avoid handling same rmap_pde in
 kvm_handle_hva_range()
Message-Id: <20120622233338.0e105766a0623ed7564d2c63@gmail.com>
In-Reply-To: <20120621175238.705e6188.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120621174842.22779780.yoshikawa.takuya@oss.ntt.co.jp>
	<20120621175238.705e6188.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 17:52:38 +0900
Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:

...
> +			/* Handle the first one even if idx == idx_end. */
> +			do {
> +				ret |= handler(kvm, rmapp++, data);
> +			} while (++idx < idx_end);

This is unclear and... maybe wrong.


I will change this as follows:
---
  hva_start = max(start, memslot->userspace_addr);
  hva_end = min(end, memslot->userspace_addr +
                          (memslot->npages << PAGE_SHIFT));
  if (hva_start >= hva_end)
          continue;
  /*
   * { gfn(page) | page intersects with [hva_start, hva_end) }
   * = [gfn_start, gfn_end).
   */
  gfn_start = hva_to_gfn_memslot(hva_start, memslot);
  gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE-1, memslot);

  for (j = PT_PAGE_TABLE_LEVEL;
       j < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++j) {
          unsigned long idx, idx_end;
          unsigned long *rmapp; 
          /*
           * { idx(page_j) | page_j intersects with [hva_start, hva_end) }
           * = [idx, idx_end].
           */
          idx = gfn_to_index(gfn_start, memslot->base_gfn, j);
          idx_end = gfn_to_index(gfn_end - 1, memslot->base_gfn, j);

          rmapp = __gfn_to_rmap(gfn_start, j, memslot);

          for (; idx <= idx_end; ++idx) {
                  ret |= handler(kvm, rmapp++, data);
          }
  }
---

This way, much clearly, we can handle exactly same rmaps as before.

I also need to change ppc code as well in patch 3.

Thanks,
	Takuya
