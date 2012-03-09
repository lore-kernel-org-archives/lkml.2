Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab2CIHeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:34:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53329 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab2CIHeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:34:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Mar 2012 16:32:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] memcg: avoid THP split in task migration
Message-Id: <20120309163245.d6241d9b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1331267128-4673-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <20120309101658.8b36ce4f.kamezawa.hiroyu@jp.fujitsu.com>
	<1331267128-4673-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Mar 2012 23:25:28 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Hi KAMEZAWA-san,
> 
> > On Fri,  2 Mar 2012 15:13:09 -0500
> > Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> ...
> > > +
> > > +	page = pmd_page(pmd);
> > > +	VM_BUG_ON(!page || !PageHead(page));
> > > +	if (!move_anon() || page_mapcount(page) != 1)
> > > +		return 0;
> >
> > Could you add this ?
> > ==
> > static bool move_check_shared_map(struct page *page)
> > {
> >   /*
> >    * Handling of shared pages between processes is a big trouble in memcg.
> >    * Now, we never move shared-mapped pages between memcg at 'task' moving because
> >    * we have no hint which task the page is really belongs to. For example,
> >    * When a task does "fork()-> move to the child other group -> exec()", the charges
> >    * should be stay in the original cgroup.
> >    * So, check mapcount to determine we can move or not.
> >    */
> >    return page_mapcount(page) != 1;
> > }
> > ==
> 
> Thank you.
> 
> We check mapcount only for anonymous pages, so we had better also describe
> that viewpoint?  And this function returns whether the target page of moving
> charge is shared or not, so a name like is_mctgt_shared() looks better to me.
> Moreover, this function explains why we have current implementation, rather
> than why return value is mapcount != 1, so I put the comment above function
> declaration like this:
> 
>   /*
>    * Handling of shared pages between processes is a big trouble in memcg.
>    * Now, we never move shared anonymous pages between memcg at 'task'
>    * moving because we have no hint which task the page is really belongs to.
>    * For example, when a task does "fork() -> move to the child other group
>    * -> exec()", the charges should be stay in the original cgroup.
>    * So, check if a given page is shared or not to determine to move charge.
>    */
>   static bool is_mctgt_shared(struct page *page)
>   {
>      return page_mapcount(page) != 1;
>   }
> 
> As for the difference between anon page and filemapped page, I have no idea
> about current charge moving policy. Is this explained anywhere? (sorry to
> question before researching by myself ...)
> 
> 

Now, I think it's okay to move mapcount check. I posted a patch for reference. 
Please check it.
https://lkml.org/lkml/2012/3/9/40

> > We may be able to support madvise(MOVE_MEMCG) or fadvise(MOVE_MEMCG), if necessary.
> 
> Is this mean moving charge policy can depend on users?
> I feel that's strange because I don't think resouce management should be
> under users' control.
> 
You're right. I 

Hm. I remember some guy suggested 'how about passing prefer memcg as mount option'
or some. Anyway, shared page handling is trouble since memory cgroup was born.

Thanks,
-Kame

