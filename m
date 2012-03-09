Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab2CICdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:33:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39678 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2CICdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:33:51 -0500
Date: Thu, 8 Mar 2012 18:33:14 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] memcg: avoid THP split in task migration
In-Reply-To: <20120309101658.8b36ce4f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LSU.2.00.1203081816170.18242@eggly.anvils>
References: <1330719189-20047-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1330719189-20047-2-git-send-email-n-horiguchi@ah.jp.nec.com> <20120309101658.8b36ce4f.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, KAMEZAWA Hiroyuki wrote:
> > +
> > +	page = pmd_page(pmd);
> > +	VM_BUG_ON(!page || !PageHead(page));
> > +	if (!move_anon() || page_mapcount(page) != 1)
> > +		return 0;
> 
> Could you add this ?
> ==
> static bool move_check_shared_map(struct page *page)
> {
>   /*
>    * Handling of shared pages between processes is a big trouble in memcg.
>    * Now, we never move shared-mapped pages between memcg at 'task' moving because
>    * we have no hint which task the page is really belongs to. For example, 
>    * When a task does "fork()-> move to the child other group -> exec()", the charges
>    * should be stay in the original cgroup. 
>    * So, check mapcount to determine we can move or not.
>    */
>    return page_mapcount(page) != 1;
> }

That's a helpful elucidation, thank you.  However...

That is not how it has actually been behaving for the last 18 months
(because of the "> 2" bug), so in practice you are asking for a change
in behaviour there.

And it's not how it has been and continues to behave with file pages.

Isn't getting that behaviour in fork-move-exec just a good reason not
to set move_charge_at_immigrate?

I think there are other scenarios where you do want all the pages to
move if move_charge_at_immigrate: and that's certainly easier to
describe and to understand and to code.

But if you do insist on not moving the shared, then it needs to involve
something like mem_cgroup_count_swap_user() on PageSwapCache pages,
rather than just the bare page_mapcount().

I'd rather delete than add code here!

Hugh
