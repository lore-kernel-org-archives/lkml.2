Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1FVEsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 00:48:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44964 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1FVEsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 00:48:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=gTX588wWP96QhExKg62akp8/m37T/QMf0LbkYK3Gcir/vLWr8Z9P7Yd5XujbrQYpug
         EfBl3Zdg/Or4pvTY0oaeoo0Y/QPYkt8iTrht8tLu561V/SIVeIpGUKu92CWlkjYM9OZx
         zTyuULMN1TlxzaiInQ9d1EGH+6Mf7R6y8H8rs=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 2/2 V2] ksm: take dirty bit as reference to avoid volatile pages scanning
Date: Wed, 22 Jun 2011 12:47:39 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.5.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        "linux-mm" <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201106212055.25400.nai.xia@gmail.com> <201106220804.12508.nai.xia@gmail.com> <20110622003536.GQ25383@sequoia.sous-sol.org>
In-Reply-To: <20110622003536.GQ25383@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221247.39827.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 08:35:36 Chris Wright wrote:
> * Nai Xia (nai.xia@gmail.com) wrote:
> > (Sorry for repeated mail, I forgot to Cc the list..)
> > 
> > On Wednesday 22 June 2011 06:38:00 you wrote:
> > > * Nai Xia (nai.xia@gmail.com) wrote:
> > > > Introduced ksm_page_changed() to reference the dirty bit of a pte. We clear 
> > > > the dirty bit for each pte scanned but don't flush the tlb. For a huge page, 
> > > > if one of the subpage has changed, we try to skip the whole huge page 
> > > > assuming(this is true by now) that ksmd linearly scans the address space.
> > > 
> > > This doesn't build w/ kvm as a module.
> > 
> > I think it's because of the name-error of a related kvm patch, which I only sent
> > in a same email thread. http://marc.info/?l=linux-mm&m=130866318804277&w=2
> > The patch split is not clean...I'll redo it.
> > 
> 
> It needs an export as it is.
> ERROR: "kvm_dirty_update" [arch/x86/kvm/kvm-intel.ko] undefined!

Oops, yes, I forgot to do that! I'll correct it in the next submission.

Thanks,
Nai

> 
> Although perhaps could be done w/out that dirty_update altogether (as I
> mentioned in other email)?
> 
> > > 
> > > > A NEW_FLAG is also introduced as a status of rmap_item to make ksmd scan
> > > > more aggressively for new VMAs - only skip the pages considered to be volatile
> > > > by the dirty bits. This can be enabled/disabled through KSM's sysfs interface.
> > > 
> > > This seems like it should be separated out.  And while it might be useful
> > > to enable/disable for testing, I don't think it's worth supporting for
> > > the long term.  Would also be useful to see the value of this flag.
> > 
> > I think it maybe useful for uses who want to turn on/off this scan policy explicitly
> > according to their working sets? 
> 
> Can you split it out, and show the benefit of it directly?  I think it
> only benefits:
> 
> p = mmap()
> memset(p, $value, entire buffer);
> ...
> very slowly (w.r.t scan times) touch bits of buffer and trigger cow to
> break sharing.
> 
> Would you agree?
> 
> thanks,
> -chris
> 
