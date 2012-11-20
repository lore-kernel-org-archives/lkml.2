Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2KTO6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:58:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:42900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab2KTO6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:58:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,286,1352102400"; 
   d="scan'208";a="250007741"
Date: Tue, 20 Nov 2012 22:58:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Claudio Freire <klaussfreire@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: fadvise interferes with readahead
Message-ID: <20121120145807.GB19467@localhost>
References: <CAGTBQpaDR4+V5b1AwAVyuVLu5rkU=Wc1WeUdLu5ag=WOk5oJzQ@mail.gmail.com>
 <20121120080427.GA11019@localhost>
 <CAGTBQpayd-HyH8SWfUCavS7epybcQR5SAx+tr+wyB38__4b-2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGTBQpayd-HyH8SWfUCavS7epybcQR5SAx+tr+wyB38__4b-2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:34:11AM -0300, Claudio Freire wrote:
> On Tue, Nov 20, 2012 at 5:04 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Yes. The kernel readahead code by design will outperform simple
> > fadvise in the case of clustered random reads. Imagine the access
> > pattern 1, 3, 2, 6, 4, 9. fadvise will trigger 6 IOs literally. While
> > kernel readahead will likely trigger 3 IOs for 1, 3, 2-9. Because on
> > the page miss for 2, it will detect the existence of history page 1
> > and do readahead properly. For hard disks, it's mainly the number of
> > IOs that matters. So even if kernel readahead loses some opportunities
> > to do async IO and possibly loads some extra pages that will never be
> > used, it still manges to perform much better.
> >
> >> The fix would lay in fadvise, I think. It should update readahead
> >> tracking structures. Alternatively, one could try to do it in
> >> do_generic_file_read, updating readahead on !PageUptodate or even on
> >> page cache hits. I really don't have the expertise or time to go
> >> modifying, building and testing the supposedly quite simple patch that
> >> would fix this. It's mostly about the testing, in fact. So if someone
> >> can comment or try by themselves, I guess it would really benefit
> >> those relying on fadvise to fix this behavior.
> >
> > One possible solution is to try the context readahead at fadvise time
> > to check the existence of history pages and do readahead accordingly.
> >
> > However it will introduce *real interferences* between kernel
> > readahead and user prefetching. The original scheme is, once user
> > space starts its own informed prefetching, kernel readahead will
> > automatically stand out of the way.
> 
> I understand that would seem like a reasonable design, but in this
> particular case it doesn't seem to be. I propose that in most cases it
> doesn't really work well as a design decision, to make fadvise work as
> direct I/O. Precisely because fadvise is supposed to be a hint to let
> the kernel make better decisions, and not a request to make the kernel
> stop making decisions.
> 
> Any interference so introduced wouldn't be any worse than the
> interference introduced by readahead over reads. I agree, if fadvise
> were to trigger readahead, it could be bad for applications that don't
> read what they say the will.

Right.

> But if cache hits were to simply update
> readahead state, it would only mean that read calls behave the same
> regardless of fadvise calls. I think that's worth pursuing.

Here you are describing an alternative solution that will somehow trap
into the readahead code even when, for example, the application is
accessing once and again an already cached file?  I'm afraid this will
add non-trivial overheads and is less attractive than the "readahead
on fadvise" solution.

> I ought to try to prepare a patch for this to illustrate my point. Not
> sure I'll be able to though.

I'd be glad to materialize the readahead on fadvise proposal, if there
are no obvious negative examples/cases.

Thanks,
Fengguang
