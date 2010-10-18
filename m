Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0JRAZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:25:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44394 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0JRAZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:25:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Oct 2010 09:19:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] memcg: new lock for mutual execution of
 account_move and file stats
Message-Id: <20101018091948.6314175a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTikTMhf9NrLxdrw4Sqi8QiqaVOcfVBQWZWw6s6Vw@mail.gmail.com>
References: <20101015170627.e5033fa4.kamezawa.hiroyu@jp.fujitsu.com>
	<20101015171225.70d4ca8f.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTimDRuE9oBpj6h13wFKazuOzOm8UbFdM+qhbc0On@mail.gmail.com>
	<AANLkTikTMhf9NrLxdrw4Sqi8QiqaVOcfVBQWZWw6s6Vw@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010 14:35:47 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Sun, Oct 17, 2010 at 2:33 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> > On Fri, Oct 15, 2010 at 5:12 PM, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >>
> >> When we try to enhance page's status update to support other flags,
> >> one of problem is updating status from IRQ context.
> >>
> >> Now, mem_cgroup_update_file_stat() takes lock_page_cgroup() to avoid
> >> race with _account move_. IOW, there are no races with charge/uncharge
> >> in nature. Considering an update from IRQ context, it seems better
> >> to disable IRQ at lock_page_cgroup() to avoid deadlock.
> >>
> >> But lock_page_cgroup() is used too widerly and adding IRQ disable
> >> there makes the performance bad. To avoid the big hammer, this patch
> >> adds a new lock for update_stat().
> >>
> >> This lock is for mutual execustion of updating stat and accout moving.
> >> This adds a new lock to move_account..so, this makes move_account slow.
> >> But considering trade-off, I think it's acceptable.
> >>
> >> A score of moving 8GB anon pages, 8cpu Xeon(3.1GHz) is here.
> >>
> >> [before patch] (mmotm + optimization patch (#1 in this series)
> >> [root@bluextal kamezawa]# time echo 2257 > /cgroup/B/tasks
> >>
> >> real    0m0.694s
> >> user    0m0.000s
> >> sys     0m0.683s
> >>
> >> [After patch]
> >> [root@bluextal kamezawa]# time echo 2238 > /cgroup/B/tasks
> >>
> >> real    0m0.741s
> >> user    0m0.000s
> >> sys     0m0.730s
> >>
> >> This moves 8Gbytes == 2048k pages. But no bad effects to codes
> >> other than "move".
> >>
> >> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > It looks good than old approach.
> > Just a below nitpick.
> >
> >> ---
> >>  include/linux/page_cgroup.h |   29 +++++++++++++++++++++++++++++
> >>  mm/memcontrol.c             |   11 +++++++++--
> >>  2 files changed, 38 insertions(+), 2 deletions(-)
> >>
> >> Index: mmotm-1013/include/linux/page_cgroup.h
> >> ===================================================================
> >> --- mmotm-1013.orig/include/linux/page_cgroup.h
> >> +++ mmotm-1013/include/linux/page_cgroup.h
> >> @@ -36,6 +36,7 @@ struct page_cgroup *lookup_page_cgroup(s
> >>  enum {
> >>        /* flags for mem_cgroup */
> >>        PCG_LOCK,  /* page cgroup is locked */
> >> +       PCG_LOCK_STATS, /* page cgroup's stat accounting flags are locked */
> >
> > Hmm, I think naming isn't a good. Aren't both for stat?

PCG_LOCK is for page_cgroup->mem_cgroup, not for stat.


But hmm...how about
{
  PCG_LOCK  /* For CACEH, USED and pc->mem_cgroup */
  PCG_CACHE
  PCG_USED
  PCG_ACCT_LRU /* no lock is used */
  PCG_MOVE_FLAGS_LOCK  /* For MAPPED and I/O flags v.s account_move races*/
  PCG_FILE_MAPPED,
  ..
  PCG_MIGRATION, /* For remembering Page Migration */
}

Anyway, documentation should be updated.
...


> > As I understand, Both are used for stat.
> > One is just used by charge/uncharge and the other is used by
> > pdate_file_stat/move_account.
> > If you guys who are expert in mcg feel it with easy, I am not against.
> > But at least, mcg-not-familiar people like me don't feel it comfortable.
> >
> 
> And I think this patch would be better to be part of Greg Thelen's series.
> 

Hmm. Greg, can you merge my new version (I'll post today) into your series ?

Thanks,
-Kame



