Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab2LTOfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 09:35:54 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62010 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2LTOft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 09:35:49 -0500
Date: Thu, 20 Dec 2012 23:35:45 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
Message-Id: <20121220233545.95378d066b2ce61a76106a88@gmail.com>
In-Reply-To: <1356010887.10845.11.camel@ul30vt.home>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121219213037.b234f9d4f187df2132e65576@gmail.com>
	<1355931777.3224.562.camel@bling.home>
	<20121220140232.67733085.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121220125946.GB7750@amt.cnet>
	<20121220132255.GH17584@redhat.com>
	<1356010887.10845.11.camel@ul30vt.home>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012 06:41:27 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> Hmm, isn't the fix as simple as:
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -847,7 +847,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>                                 GFP_KERNEL);
>                 if (!slots)
>                         goto out_free;
> -       }
> +       } else
> +               slots->generation = kvm->memslots->generation;
>  
>         /* map new memory slot into the iommu */
>         if (npages) {
> 
> Or even just slots->generation++ since we're holding the lock across all
> of this.

Yes, the fix should work, but I do not want to update the
generation from outside of update_memslots().

> The original patch can be reverted, there are no following dependencies,
> but the idea was that we're making the memslot array larger, so there
> could be more pressure in allocating it, so let's not trivially do extra
> frees and allocs.  Thanks,

I agree that the current set_memory_region() is not good for frequent updates.
But the alloc/free is not a major factor at the moment: flushing shadows should
be more problematic.

Thanks,
	Takuya
