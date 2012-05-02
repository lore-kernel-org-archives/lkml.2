Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2EBIRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:17:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab2EBIRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:17:08 -0400
Date: Wed, 2 May 2012 10:17:05 +0200
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Jan Kara <jack@suse.cz>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de,
        Andrea Arcangeli <aarcange@redhat.com>, Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned
 buffers
Message-ID: <20120502081705.GB16976@quack.suse.cz>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
 <CAHGf_=qdE3yNw=htuRssfav2pECO1Q0+gWMRTuNROd_3tVrd6Q@mail.gmail.com>
 <CAHGf_=ojhwPUWJR0r+jVgjNd5h_sRrppzJntSpHzxyv+OuBueg@mail.gmail.com>
 <x49ehr4lyw1.fsf@segfault.boston.devel.redhat.com>
 <CAHGf_=rzcfo3OnwT-YsW2iZLchHs3eBKncobvbhTm7B5PE=L-w@mail.gmail.com>
 <x491un3nc7a.fsf@segfault.boston.devel.redhat.com>
 <CAPa8GCCgLUt1EDAy7-O-mo0qir6Bf5Pi3Va1EsQ3ZW5UU=+37g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPa8GCCgLUt1EDAy7-O-mo0qir6Bf5Pi3Va1EsQ3ZW5UU=+37g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 02-05-12 01:50:46, Nick Piggin wrote:
> On 2 May 2012 01:38, Jeff Moyer <jmoyer@redhat.com> wrote:
> > KOSAKI Motohiro <kosaki.motohiro@gmail.com> writes:
> >
> >> On Tue, May 1, 2012 at 11:11 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> >>> KOSAKI Motohiro <kosaki.motohiro@gmail.com> writes:
> >>>
> >>>>> Hello,
> >>>>>
> >>>>> Thank you revisit this. But as far as my remember is correct, this issue is NOT
> >>>>> unaligned access issue. It's just get_user_pages(_fast) vs fork race issue. i.e.
> >>>>> DIRECT_IO w/ multi thread process should not use fork().
> >>>>
> >>>> The problem is, fork (and its COW logic) assume new access makes cow break,
> >>>> But page table protection can't detect a DMA write. Therefore DIO may override
> >>>> shared page data.
> >>>
> >>> Hm, I've only seen this with misaligned or multiple sub-page-sized reads
> >>> in the same page.  AFAIR, aligned, page-sized I/O does not get split.
> >>> But, I could be wrong...
> >>
> >> If my remember is correct, the reproducer of past thread is misleading.
> >>
> >> dma_thread.c in
> >> http://lkml.indiana.edu/hypermail/linux/kernel/0903.1/01498.html has
> >> align parameter. But it doesn't only change align. Because of, every
> >> worker thread read 4K (pagesize), then
> >>  - when offset is page aligned
> >>     -> every page is accessed from only one worker
> >>  - when offset is not page aligned
> >>     -> every page is accessed from two workers
> >>
> >> But I don't remember why two threads are important things. hmm.. I'm
> >> looking into the code a while.
> >> Please don't 100% trust me.
> >
> > I bet Andrea or Larry would remember the details.
> 
> KOSAKI-san is correct, I think.
> 
> The race is something like this:
> 
> DIO-read
>     page = get_user_pages()
>                                                         fork()
>                                                             COW(page)
>                                                          touch(page)
>     DMA(page)
>     page_cache_release(page);
> 
> So whether parent or child touches the page, determines who gets the
> actual DMA target, and who gets the copy.
  OK, this is roughly what I understood from original threads as well. So
if our buffer is page aligned and its size is page aligned, you would hit
the corruption only if you do modify the buffer while IO to / from that buffer
is in progress. And that would seem like a really bad programming practice
anyway. So I still believe that having everything page size aligned will
effectively remove the problem although I agree it does not aim at the core
of it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
