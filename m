Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031255Ab2CFU4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:56:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60807 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031124Ab2CFU4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:56:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.42.131.129 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Tue, 6 Mar 2012 12:55:42 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mapcount check in move charge code for
 anonymous page
In-Reply-To: <20120305091719.c9f93f1a.nishimura@mxp.nes.nec.co.jp>
Message-ID: <alpine.LSU.2.00.1203061230530.17934@eggly.anvils>
References: <1330720508-21019-1-git-send-email-n-horiguchi@ah.jp.nec.com> <20120305091719.c9f93f1a.nishimura@mxp.nes.nec.co.jp>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012, Daisuke Nishimura wrote:
> Hi, Horiguchi-san.
> On Fri,  2 Mar 2012 15:35:08 -0500
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > Currently charge on shared anonyous pages is supposed not to moved
> > in task migration. To implement this, we need to check that mapcount > 1,
> > instread of > 2. So this patch fixes it.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > ---
> >  mm/memcontrol.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git linux-next-20120228.orig/mm/memcontrol.c linux-next-20120228/mm/memcontrol.c
> > index b6d1bab..785f6d3 100644
> > --- linux-next-20120228.orig/mm/memcontrol.c
> > +++ linux-next-20120228/mm/memcontrol.c
> > @@ -5102,7 +5102,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
> >  		return NULL;
> >  	if (PageAnon(page)) {
> >  		/* we don't move shared anon */
> > -		if (!move_anon() || page_mapcount(page) > 2)
> > +		if (!move_anon() || page_mapcount(page) > 1)
> >  			return NULL;
> >  	} else if (!move_file())
> >  		/* we ignore mapcount for file pages */
> > -- 
> > 1.7.7.6
> > 
> Sorry, it's my fault..
> Thank you for catching this.
> 
> Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

I'm perversely sorry to see this fix already wing its way into 3.3-rc,
but never mind.

I was puzzling over that same "> 2" test when thinking through the
stats move locking, and again when swap accounting appeared to be
broken through and through (now fixed by two-liner in page_cgroup.c).

Why is there any test on page_mapcount(page) there at all?
2.6.34 comments it
	* TODO: We don't move charges of shared(used by multiple
	* processes) pages for now.
as if it's an unwelcome restriction to be eliminated later.

I don't understand why it was ever there, and would like to remove
it (and update the Documentation file) - just to remove a little
unnecessary complication, including mem_cgroup_count_swap_user().

The file case moves account, even when the page is not mapped into
this address space, even when it's mapped into a thousand others.

Why treat the anonymous so differently here?  I'd have thought it
quite likely (by no means certain, but quite likely) that when you
move a task sharing an anon page from one cg to another, you'll
move the other task(s) sharing it immediately after - strange that
these shared pages should then get left behind.

I was pleased by the "> 2" bug, there almost all the life of
move_charge_at_immigrate, demonstrating that nobody was depending
upon the documented behaviour.

I've a few more cleanups in the swap accounting area, I guess I
should just post this change along with them and we discuss then,
unless you can enlighten me what it's about before I get there.

Thanks,
Hugh
