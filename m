Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab2BMBOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 20:14:05 -0500
Received: from mail.betterlinux.com ([199.58.199.50]:36103 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2BMBOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 20:14:03 -0500
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com E232982A1F
Date: Mon, 13 Feb 2012 02:13:19 +0100
From: Andrea Righi <andrea@betterlinux.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH v5 0/3] fadvise: support POSIX_FADV_NOREUSE
Message-ID: <20120213011319.GB2052@thinkpad>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
 <CAJd=RBBQFuxUC4XvS7OaajzKq1Xh0yRjY62PaceWprob26N9QA@mail.gmail.com>
 <20120212115834.GA1548@thinkpad>
 <87sjigx7ho.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sjigx7ho.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 11:24:27PM +0530, Aneesh Kumar K.V wrote:
> On Sun, 12 Feb 2012 12:58:34 +0100, Andrea Righi <andrea@betterlinux.com> wrote:
> > On Sun, Feb 12, 2012 at 03:16:07PM +0800, Hillf Danton wrote:
> > > Hello Andrea
> > > 
> > > On Sun, Feb 12, 2012 at 8:21 AM, Andrea Righi <andrea@betterlinux.com> wrote:
> > > [...]
> > > >  - Some of the routines to implement the generic interval tree has been taken
> > > >   from the x86 PAT code, that uses interval trees to keep track of PAT ranges
> > > >   (in the future it would be interesting to convert also the x86 PAT code to
> > > >   use the generic interval tree implementation).
> > > >
> > > Perhaps the tree implemented in this work could also be used in tracking
> > > regions in mm/hugetlb.c.
> > > 
> > > Thanks
> > > Hillf
> > 
> > Thanks, Hillf.
> > 
> > Yes, I quickly looked at the hugtlb code, it seems another potential
> > user of the interval tree. Now all the hugetlb regions are stored in a
> > list, the interval tree is a more efficient structure for lookups -
> > O(log(n)), so there are probably advantages in presence of many
> > different disjoint intervals.
> > 
> > mmh... at the moment there's not a way to map region_count() with the
> > current kinterval API, but we can easily extend it to provide also this
> > feature (count the overlap size of two intervals).
> > 
> 
> I am also extending the hugetlb region list in the hugetlb cgroup
> patchset i recently posted to make sure we don't merge region if the
> associated private data doesn't match (in my case it is the pointer to
> hugetlb cgroup). Ref:
> http://article.gmane.org/gmane.linux.kernel.mm/73829
> 
> The goal is to make sure a region add with different private value
> results in below.
> 
> 
>     old
>       |       hcg1      |
>       -------------------
> 
> new
> |             hcg2               |
> ----------------------------------
> 
> results in 
> 
>  | hcg2   | |     hcg1       | |   hcg2 |
>  ---------  __________________ ----------
> 
> 
> -aneesh

Yep! This is different from my case, at least according to the current
implementation. Using kintervals the new range hcg2 will completely
overwrite hcg1, because the default behavior is that new ranges
overwrite old ranges.

To get the same result the new range (hcg2) should be defined inside
the old range (hcg1):

     new
       |       hcg2      |
       -------------------

 old
 |             hcg1               |
 ----------------------------------

In this case result will be:

  | hcg1   | |     hcg2       | |   hcg1 |
  ---------  __________________ ----------

mmmh.. I'm wondering if there's a better way to make the intervals even
more generic, so that it would be possible to specify also a different
behavior in case of conflicts... (i.e., new wins vs old wins).

Thanks,
-Andrea
