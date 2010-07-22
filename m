Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0GVFsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:48:13 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47956 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab0GVFsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:48:09 -0400
Date: Thu, 22 Jul 2010 14:43:56 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 1/2][memcg] moving memcg's node info array to
 virtually contiguous array
Message-Id: <20100722144356.b9681621.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100721195831.6aa8dca5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100721195831.6aa8dca5.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 19:58:31 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> These are just a _toy_ level patches yet. My final purpose is to use indexed array
> for mem_cgroup itself, it has IDs.
> 
> Background:
>   memory cgroup uses struct page_cgroup for tracking all used pages. It's defined as
> ==
> struct page_cgroup {
>         unsigned long flags;
>         struct mem_cgroup *mem_cgroup;
>         struct page *page;
>         struct list_head lru;           /* per cgroup LRU list */
> };
> ==
>   and this increase the cost of per-page-objects dramatically. Now, we have
>   troubles on this object.
>   1.  Recently, a blkio-tracking guy wants to add "blockio-cgroup" information
>       to page_cgroup. But our concern is extra 8bytes per page.
>   2.  At tracking dirty page status etc...we need some trick for safe access
>       to page_cgroup and memcgroup's information. For example, a small seqlock.
> 
> Now, each memory cgroup has its own ID (0-65535). So, if we can replace
> 8byte of pointer "pc->mem_cgroup" with an ID, which is 2 bytes, we may able
> to have another room. (Moreover, I think we can reduce the number of IDs...)
> 
> This patch is a trial for implement a virually-indexed on-demand array and
> an example of usage. Any commetns are welcome.
> 
So, your purpose is to:

- make the size of mem_croup small(by [2/2])
- manage all the mem_cgroup in virt-array indexed by its ID(it would be faster
  than using css_lookup)
- replace pc->mem_cgroup by its ID and make the size of page_cgroup small

right?

Thanks,
Daisuke Nishimura.
