Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab2FUNmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 09:42:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2FUNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 09:42:05 -0400
Date: Thu, 21 Jun 2012 22:41:59 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        agraf@suse.de, paulus@samba.org, aarcange@redhat.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: MMU: Make kvm_handle_hva() handle range of
 addresses
Message-Id: <20120621224159.48ce3575e1834d3bdb643fb9@gmail.com>
In-Reply-To: <4FE2DA5B.4080706@redhat.com>
References: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
	<20120615203230.2c577652.yoshikawa.takuya@oss.ntt.co.jp>
	<4FDF1AFE.4000607@redhat.com>
	<20120619224648.bbb360c6eeae9887de7b1f93@gmail.com>
	<4FE2DA5B.4080706@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should have read this before sending v2...

On Thu, 21 Jun 2012 11:24:59 +0300
Avi Kivity <avi@redhat.com> wrote:

> > 1. Separate rmap_pde from lpage_info->write_count and
> >    make this a simple array. (I once tried this.)
> > 
> 
> This has the potential to increase cache misses, but I don't think it's
> a killer.  The separation can simplify other things as well.

Yes, I think so too.

IIRC, write_count and rmap_pde are not used together so often.

> > 2. Use gfn_to_index() and loop over rmap array:

...

> >   /* main part */
> >   for each level {
> >       rmapp = __gfn_to_rmap(gfn_start, level, memslot);
> >       for (idx = gfn_to_index(gfn_start, memslot->base_gfn, level);
> >            idx < gfn_to_index(gfn_end, memslot->base_gfn, level); idx++) {
> >               ...
> >           /* loop over rmap array */
> >           ret |= handler(kvm, rmapp + idx, data);
> >       }
> >   }
> > 
> 
> Probably want idx <= gfn_to_index(gfn_end-1, ...) otherwise we fail on
> small slots.

I was thinking the same thing when making v2.
But I will check the boundary condition again.

(mmu_notifier + memslot + lpage + rmap...) * alignment...
Very confusing.

Thanks,
	Takuya
