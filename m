Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1DZT0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:26:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35650 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1DZT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=fQzJvMg39wocI4rROWKh0aQ6bie25+kB/sXKP6oLDYiy59pm3Qz5MM3nMOLfNV8yjB
         1W1G0wnMNAEWuxlRPVUg==
Date: Tue, 26 Apr 2011 12:26:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Matt Fleming <matt@console-pimps.org>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 2/3] track numbers of pagetable pages
In-Reply-To: <20110426155743.2e76282d@mfleming-mobl1.ger.corp.intel.com>
Message-ID: <alpine.LSU.2.00.1104261217430.9334@sister.anvils>
References: <20110415173821.62660715@kernel> <20110415173823.EA7A7473@kernel> <20110416104456.3915b7de@mfleming-mobl1.ger.corp.intel.com> <1303138924.9615.2487.camel@nimitz> <20110426155743.2e76282d@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011, Matt Fleming wrote:

> [Added Hugh Dickins to the CC list]
> 
> Sorry it's taken me so long to reply Dave.
> 
> On Mon, 18 Apr 2011 08:02:04 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
> > On Sat, 2011-04-16 at 10:44 +0100, Matt Fleming wrote:
> > > >  static inline void pgtable_page_dtor(struct mm_struct *mm, struct page *page)
> > > >  {
> > > >  	pte_lock_deinit(page);
> > > > +	dec_mm_counter(mm, MM_PTEPAGES);
> > > >  	dec_zone_page_state(page, NR_PAGETABLE);
> > > >  }
> > > 
> > > I'm probably missing something really obvious but...
> > > 
> > > Is this safe in the non-USE_SPLIT_PTLOCKS case? If we're not using
> > > split-ptlocks then inc/dec_mm_counter() are only safe when done under
> > > mm->page_table_lock, right? But it looks to me like we can end up doing,
> > > 
> > >   __pte_alloc()
> > >       pte_alloc_one()
> > >           pgtable_page_ctor()
> > > 
> > > before acquiring mm->page_table_lock in __pte_alloc().
> > 
> > No, it's probably not safe.  We'll have to come up with something a bit
> > different in that case.  Either that, or just kill the non-atomic case.
> > Surely there's some percpu magic counter somewhere in the kernel that is
> > optimized for fast (unlocked?) updates and rare, slow reads.
> 
> It seems it was Hugh that added these atomics in f412ac08c986 ("[PATCH]
> mm: fix rss and mmlist locking").
> 
> Hugh, what was the reason that you left the old counters around (the
> ones protected by page_table_lock)? It seems to me that we could
> delete those and just have the single case that uses the atomic_t
> operations.

The only reason was to avoid adding costly atomic operations into a
configuration that had no need for them there: the page_table_lock
sufficed.

Certainly it would be simpler just to delete the non-atomic variant.

And I think it's fair to say that any configuration on which we're
measuring performance to that degree (rather than "does it boot fast?"
type measurements), would already be going the split ptlocks route.

> 
> Would anyone object to a patch that removed the non-atomic case?

Not I.

Hugh
