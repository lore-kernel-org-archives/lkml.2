Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab1FVAg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:36:27 -0400
Received: from sous-sol.org ([216.99.217.87]:38965 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757133Ab1FVAgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:36:25 -0400
Date: Tue, 21 Jun 2011 17:35:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Nai Xia <nai.xia@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 V2] ksm: take dirty bit as reference to avoid
 volatile pages scanning
Message-ID: <20110622003536.GQ25383@sequoia.sous-sol.org>
References: <201106212055.25400.nai.xia@gmail.com>
 <201106212136.17445.nai.xia@gmail.com>
 <20110621223800.GO25383@sequoia.sous-sol.org>
 <201106220804.12508.nai.xia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106220804.12508.nai.xia@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nai Xia (nai.xia@gmail.com) wrote:
> (Sorry for repeated mail, I forgot to Cc the list..)
> 
> On Wednesday 22 June 2011 06:38:00 you wrote:
> > * Nai Xia (nai.xia@gmail.com) wrote:
> > > Introduced ksm_page_changed() to reference the dirty bit of a pte. We clear 
> > > the dirty bit for each pte scanned but don't flush the tlb. For a huge page, 
> > > if one of the subpage has changed, we try to skip the whole huge page 
> > > assuming(this is true by now) that ksmd linearly scans the address space.
> > 
> > This doesn't build w/ kvm as a module.
> 
> I think it's because of the name-error of a related kvm patch, which I only sent
> in a same email thread. http://marc.info/?l=linux-mm&m=130866318804277&w=2
> The patch split is not clean...I'll redo it.
> 

It needs an export as it is.
ERROR: "kvm_dirty_update" [arch/x86/kvm/kvm-intel.ko] undefined!

Although perhaps could be done w/out that dirty_update altogether (as I
mentioned in other email)?

> > 
> > > A NEW_FLAG is also introduced as a status of rmap_item to make ksmd scan
> > > more aggressively for new VMAs - only skip the pages considered to be volatile
> > > by the dirty bits. This can be enabled/disabled through KSM's sysfs interface.
> > 
> > This seems like it should be separated out.  And while it might be useful
> > to enable/disable for testing, I don't think it's worth supporting for
> > the long term.  Would also be useful to see the value of this flag.
> 
> I think it maybe useful for uses who want to turn on/off this scan policy explicitly
> according to their working sets? 

Can you split it out, and show the benefit of it directly?  I think it
only benefits:

p = mmap()
memset(p, $value, entire buffer);
...
very slowly (w.r.t scan times) touch bits of buffer and trigger cow to
break sharing.

Would you agree?

thanks,
-chris
