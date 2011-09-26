Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab1IZOTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:19:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1IZOTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:19:18 -0400
Date: Mon, 26 Sep 2011 16:18:34 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch] mm: remove sysctl to manually rescue unevictable pages
Message-ID: <20110926141834.GD14333@redhat.com>
References: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com>
 <20110926112944.GC14333@redhat.com>
 <CAFPAmTQPiHU8AKnQvzMM5KiQr1GnUY+Yf8PwVC6++QK8u149Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFPAmTQPiHU8AKnQvzMM5KiQr1GnUY+Yf8PwVC6++QK8u149Ew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 05:40:52PM +0530, kautuk.c @samsung.com wrote:
> On Mon, Sep 26, 2011 at 4:59 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> > On Sun, Sep 25, 2011 at 04:29:40PM +0530, Kautuk Consul wrote:
> >> write_scan_unavictable_node checks the value req returned by
> >> strict_strtoul and returns 1 if req is 0.
> >>
> >> However, when strict_strtoul returns 0, it means successful conversion
> >> of buf to unsigned long.
> >>
> >> Due to this, the function was not proceeding to scan the zones for
> >> unevictable pages even though we write a valid value to the
> >> scan_unevictable_pages sys file.
> >
> > Given that there is not a real reason for this knob (anymore) and that
> > it apparently never really worked since the day it was introduced, how
> > about we just drop all that code instead?
> >
> >        Hannes
> >
> > ---
> > From: Johannes Weiner <jweiner@redhat.com>
> > Subject: mm: remove sysctl to manually rescue unevictable pages
> >
> > At one point, anonymous pages were supposed to go on the unevictable
> > list when no swap space was configured, and the idea was to manually
> > rescue those pages after adding swap and making them evictable again.
> > But nowadays, swap-backed pages on the anon LRU list are not scanned
> > without available swap space anyway, so there is no point in moving
> > them to a separate list anymore.
> 
> Is this code only for anonymous pages ?
> It seems to look at all pages in the zone both file as well as anon.

The code scans both, but the usecase I described was moving swapbacked
pages from the unevictable list after configuring swap space.

> > The manual rescue could also be used in case pages were stranded on
> > the unevictable list due to race conditions.  But the code has been
> > around for a while now and newly discovered bugs should be properly
> > reported and dealt with instead of relying on such a manual fixup.
> 
> What you say seems to be all right for anon pages, but what about file
> pages ?
> I'm not sure about how this could happen, but what if some file-system caused
> a file cache page to be set to evictable or reclaimable without
> actually removing
> that page from the unevictable list ?

Currently, unevictable file pages come from ramfs, shmem, and mlock.
ramfs never makes them evictable.  shmem, after making an inode
evictable again, scans the that inode's address_space and rescues the
pages it finds.  munlock synchroneously rescues the pages vma's range.
