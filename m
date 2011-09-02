Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab1IBAUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:20:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738Ab1IBAUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:20:31 -0400
Date: Fri, 2 Sep 2011 02:20:13 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] thp: tail page refcounting fix #5
Message-ID: <20110902002013.GJ10779@redhat.com>
References: <20110824133459.GP23870@redhat.com>
 <20110826062436.GA5847@google.com>
 <20110826161048.GE23870@redhat.com>
 <20110826185430.GA2854@redhat.com>
 <20110827094152.GA16402@google.com>
 <20110827173421.GA2967@redhat.com>
 <CAEwNFnDk0bQZKReKccuQMPEw_6EA2DxN4dm9cmjr01BVT4A7Dw@mail.gmail.com>
 <20110901152417.GF10779@redhat.com>
 <20110901162808.80a2117c.akpm@linux-foundation.org>
 <20110901234527.GD7761@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901234527.GD7761@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 01:45:27AM +0200, Andi Kleen wrote:
> On Thu, Sep 01, 2011 at 04:28:08PM -0700, Andrew Morton wrote:
> > On Thu, 1 Sep 2011 17:24:17 +0200
> > Andrea Arcangeli <aarcange@redhat.com> wrote:
> > 
> > > Ideally direct-io should stop calling get_page() on pages
> > > returned by get_user_pages().
> > 
> > Yeah.  get_user_pages() is sufficient.  Ideally we should be able to
> > undo the get_user_pages() get_page() from within the IO completion
> > interrupt and we're done.
> > 
> > Cc Andi, who is our resident dio tweaker ;)
>
> Noted, I'll put it on my list.

Thanks Andi!

> Should not be too difficult from a quick look, just the convoluted
> nature of direct-io.c requires a lot of double checking.

I also had a look but it wasn't trivial, I'm not even sure why
direct-io.c has to be convoluted.

If we could optimize that, we would stay within get_page_foll() which
won't need to take the compound_lock even for tail
pages. (compound_lock can't be avoided for put_page on tail pages
because it runs long after we release any VM lock)

Calling get_page/put_pages more times than necessary is never ideal, I
imagine the biggest cost is the atomic_inc on the head page that
brings in the cacheline of the head page exclusive, the compound_lock
in the second get_page shouldn't have a measurable effect, so I think
from a practical prospective it's not more worthwhile to optimize
that now, than it already was before.

> Cc Andi, who is our resident dio tweaker ;)

Thanks :)
