Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2FSNq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:46:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63676 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2FSNqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 09:46:54 -0400
Date: Tue, 19 Jun 2012 22:46:48 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: MMU: Make kvm_handle_hva() handle range of
 addresses
Message-Id: <20120619224648.bbb360c6eeae9887de7b1f93@gmail.com>
In-Reply-To: <4FDF1AFE.4000607@redhat.com>
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
	<20120615203230.2c577652.yoshikawa.takuya@oss.ntt.co.jp>
	<4FDF1AFE.4000607@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 15:11:42 +0300
Avi Kivity <avi@redhat.com> wrote:

> Potential for improvement: don't do 512 iterations on same large page.
> 
> Something like
> 
>     if ((gfn ^ prev_gfn) & mask(level))
>         ret |= handler(...)
> 
> with clever selection of the first prev_gfn so it always matches (~gfn
> maybe).


I thought up a better solution:

1. Separate rmap_pde from lpage_info->write_count and
   make this a simple array. (I once tried this.)

2. Use gfn_to_index() and loop over rmap array:
 ...
  /* intersection check */
  start = max(start, memslot->userspace_addr);
  end = min(end, memslot->userspace_addr +
                 (memslot->npages << PAGE_SHIFT));
  if (start > end)
      continue;

  /* hva to gfn conversion */
  gfn_start = hva_to_gfn_memslot(start);
  gfn_end = hva_to_gfn_memslot(end);

  /* main part */
  for each level {
      rmapp = __gfn_to_rmap(gfn_start, level, memslot);
      for (idx = gfn_to_index(gfn_start, memslot->base_gfn, level);
           idx < gfn_to_index(gfn_end, memslot->base_gfn, level); idx++) {
              ...
          /* loop over rmap array */
          ret |= handler(kvm, rmapp + idx, data);
      }
  }


Thanks,
	Takuya
