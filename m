Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0IOTqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:46:19 -0400
Received: from waste.org ([173.11.57.241]:43610 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab0IOTqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:46:18 -0400
Subject: Re: [PATCH v2] After swapout/swapin private dirty mappings are
 reported clean in smaps
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Richard Guenther <rguenther@suse.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimYQgm6nKZ4TantPiL4kmUP9FtMQwzqeetVnGrr@mail.gmail.com>
References: <20100915134724.C9EE.A69D9226@jp.fujitsu.com>
	 <201009151034.22497.knikanth@suse.de>
	 <20100915141710.C9F7.A69D9226@jp.fujitsu.com>
	 <201009151201.11359.knikanth@suse.de>
	 <20100915140911.GC4383@balbir.in.ibm.com>
	 <alpine.LNX.2.00.1009151612450.28912@zhemvz.fhfr.qr>
	 <1284561982.21906.280.camel@calx>
	 <alpine.LNX.2.00.1009151648390.28912@zhemvz.fhfr.qr>
	 <1284571473.21906.428.camel@calx>
	 <AANLkTimYQgm6nKZ4TantPiL4kmUP9FtMQwzqeetVnGrr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 14:46:09 -0500
Message-ID: <1284579969.21906.451.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 12:18 -0700, Hugh Dickins wrote:
> On Wed, Sep 15, 2010 at 10:24 AM, Matt Mackall <mpm@selenic.com> wrote:
> 
> > But that's my point: the consistency problem is NOT in smaps. The page
> > is NOT marked dirty, ergo smaps doesn't report it as dirty. Whether or
> > not there is MORE information smaps could be reporting is irrelevant,
> > the information it IS reporting is consistent with the underlying VM
> > data. If there's an inconsistency about what it means to be clean, it's
> > either in the VM or in your head.
> >
> > And I frankly think it's in the VM.
> 
> I don't believe there's any problem in the VM here, we'd be having
> SIGSEGVs all over if there were.

Of course it works. It's just not as orthogonal (aka consistent) as it
could be in this case: it's not actually reflecting any of the usual
meanings of dirtiness here.

> The problem is that /proc/pid/smaps exports a simplified view of the
> VM, and Richard and Nikanth were hoping that it gave them some info
> which it has never pretended to give them,
> 
> It happens to use a pte_dirty(ptent) test: you could argue that that
> should be pte_dirty(ptent) || PageDirty(page) (which would then "fix
> the issue" which Richard sees with swapoff/swapon),

That might be interesting. Are there any other notable cases where
pte_dirty() differs from PageDirty()?

>  or you could argue
> that it should be pte_dirty(ptent) || PageDirty(page) ||
> PageSwapCache(page) (which would then note clean copies of swap cache
> as dirty in the sense which Richard and Nikanth are interested in).
> 
> But after these years, we should probably assume that most users of
> /proc/pid/smaps are used to the existing pte_dirty(ptent) test, and
> would be troubled by a departure from it.

Dunno, my smem tool[1] is probably also expecting too much here and I
should know better!

> > In any case, I don't think Nikanth's fix is the right fix, as it
> > basically says "you can't trust any of this". Either swap should return
> > the pages to their pre-swap dirty state in the VM, or we should add
> > another field here:
> >
> > Weird_Anon_Page_You_Should_Pretend_Is_Private_Dirty: 8 kB
> 
> I think that the most widely useful but simple extension of
> /proc/pid/smaps, that would give them the info they want, would indeed
> be to counts ptes pointing to PageAnon pages and report that total on
> an additional line (say, just before "Swap:"); but there's no need for
> the derogatory name you propose there, "Anon:" would suit fine!

Yes, that wasn't a serious suggestion.

[1] http://www.selenic.com/smem/
-- 
Mathematics is the supreme nostalgia of our time.


