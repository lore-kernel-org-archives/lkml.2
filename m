Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab2LTFCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:02:12 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:41901 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2LTFCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:02:06 -0500
Date: Thu, 20 Dec 2012 14:02:32 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, mtosatti@redhat.com,
        gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
Message-Id: <20121220140232.67733085.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <1355931777.3224.562.camel@bling.home>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121219213037.b234f9d4f187df2132e65576@gmail.com>
	<1355931777.3224.562.camel@bling.home>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 08:42:57 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> Please let me know if you can identify one of these as the culprit.
> They're all very simple, but there's always a chance I've missed a hard
> coding of slot numbers somewhere.  Thanks,

I identified the one:
  commit b7f69c555ca430129b6cde81e9f0927531420c5c
  KVM: Minor memory slot optimization

IIUC, the problem was that you did not care about the generation of
slots which was updated by update_memslots():

  Your patch reused the old memory slots which was there before
  doing the update for invalidating the slot, and badly, we did flush
  shadow pages after that before doing the second update for finally
  installing the new slot.  As a result, the generation did not change
  from that of the invalidated one, although the ghc(gfn to hva cache)
  might be stale.

  After that, kvm_write_guest_cached() checked if ghc should be
  initialized by comparing ghc's generation with that old one,
  resulting mark_page_dirty_in_slot() was called with the invalid
  cache contents.

Although we can do something to correct the generation alone, I do not
think such a trick is worth it because this is not a hot path.  Let's
just revert the patch.

Thanks,
	Takuya
