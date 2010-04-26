Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0DZJxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:53:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43344 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0DZJxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:53:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Apr 2010 18:49:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX][mm][PATCH] fix migration race in rmap_walk
Message-Id: <20100426184908.3c277568.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <r2o28c262361004260248s62729484g14a720d37d5916f7@mail.gmail.com>
References: <20100423120148.9ffa5881.kamezawa.hiroyu@jp.fujitsu.com>
	<20100423095922.GJ30306@csn.ul.ie>
	<20100423155801.GA14351@csn.ul.ie>
	<20100424110200.b491ec5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100424104324.GD14351@csn.ul.ie>
	<20100426084901.15c09a29.kamezawa.hiroyu@jp.fujitsu.com>
	<20100426182838.2cab9844.kamezawa.hiroyu@jp.fujitsu.com>
	<r2o28c262361004260248s62729484g14a720d37d5916f7@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 18:48:42 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Mon, Apr 26, 2010 at 6:28 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 26 Apr 2010 08:49:01 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> >> On Sat, 24 Apr 2010 11:43:24 +0100
> >> Mel Gorman <mel@csn.ul.ie> wrote:
> >
> >> > It looks nice but it still broke after 28 hours of running. The
> >> > seq-counter is still insufficient to catch all changes that are made to
> >> > the list. I'm beginning to wonder if a) this really can be fully safely
> >> > locked with the anon_vma changes and b) if it has to be a spinlock to
> >> > catch the majority of cases but still a lazy cleanup if there happens to
> >> > be a race. It's unsatisfactory and I'm expecting I'll either have some
> >> > insight to the new anon_vma changes that allow it to be locked or Rik
> >> > knows how to restore the original behaviour which as Andrea pointed out
> >> > was safe.
> >> >
> >> Ouch.
> >
> > Ok, reproduced. Here is status in my test + printk().
> >
> >  * A race doesn't seem to happen if swap=off.
> >    I need to swapon to cause the bug
> 
> FYI,
> 
> Do you have a swapon/off bomb test?

No. Just running test under swapoff, and running the same test after swapon.


> When I saw your mail, I feel it might be culprit.
> 
> http://lkml.org/lkml/2010/4/22/762.
> 
> It is just guessing. I don't have a time to look into, now.
> 
Hmm. BTW.

==
static int expand_downwards(struct vm_area_struct *vma,
                                   unsigned long address)
{
   ....
       /* Somebody else might have raced and expanded it already */
        if (address < vma->vm_start) {
                unsigned long size, grow;

                size = vma->vm_end - address;
                grow = (vma->vm_start - address) >> PAGE_SHIFT;

                error = acct_stack_growth(vma, size, grow);
                if (!error) {
                        vma->vm_start = address;
                        vma->vm_pgoff -= grow;
                }
        }
==	

I feel this part needs care. No ?

Thanks,
-Kmae



