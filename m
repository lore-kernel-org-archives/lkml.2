Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531Ab0HEAhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:37:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53283 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab0HEAhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:37:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Aug 2010 09:32:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH -mm] hibernation: freeze swap at hibernation v2
Message-Id: <20100805093205.3aa48713.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100804151839.62641a60.akpm@linux-foundation.org>
References: <201007282334.08063.rjw@sisk.pl>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100802150225.851b48fe.kamezawa.hiroyu@jp.fujitsu.com>
	<201008040109.15818.rjw@sisk.pl>
	<20100804083119.8b7cd3f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20100804135739.1d3ed9e2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100804151839.62641a60.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 15:18:39 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 4 Aug 2010 13:57:39 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > At taking memory snapshot in hibernate_snapshot(), all (directly called)
> > memory allocator uses GFP_ATOMIC. And it seems swap-misusage during
> > hibernation never occurs.
> > 
> > But, from pessimistic point of view, there is no guarantee to trust 
> > any page allcation doesn't have __GFP_WAIT. It's better to have an indication
> > "we enter hibernation, don't use swap!".
> > 
> > This patch tries to freeze new-swap-allocation during hibernation.
> > (We can trust all user processes are freezed, then, dont't take care of swapin)
> > 
> > By this, no updates will be happen to swap_map[] among hibernate_snapshot()
> > to save_image(). swap is thawed when swsusp_free() is called.
> > We can trust swap-corruption will never happen without any doubts.
> > 
> 
> Confused (as usual).
> 
Sorry
> The above seems to be saying "there isn't a bug, but perhaps there is
> one that we don't know about so let's fix it in case it's there".  Or
> something.
> 
> But this email thread used to be called "Memory corruption during
> hibernation since 2.6.31" which sounds a heck of a lot more serious.
> 
> Does this patch fix memory corruption?  If so, why was that corruption
> occurring, and under which circumstances?
> 
The corruption we see now is fixed by 
mm-fix-corruption-of-hibernation-caused-by-reusing-swap-during-image-saving.patch
This patch disables swap-reuse by the hibernation code itself and fixes the bug.

But, IIUC, comments from reviewer was "it looks like a temporary-fix. It will work
and be good for backporting...but can't we have a permanent fix which never be
broken by anyone ?" 

IOW, the patch doesn't stop get_swap_page() because we believe all
subsystems related to hibernation works well _now_ and everyone use GFP_ATOMIC.

However, hibernation is a set of complex features. It's coded very carefully and
works well but no one can't see the all of codes in subsystems. So, some safe
system is better rather than believing.

(BTW, one of reasons we can believe we are safe is that critical threads have
 to be frozen before creating snapshot.)

For example, for guaranteeing gfp_mask, we have 
	clear_gfp_allowed_mask()
	set_gfp_allowed_mask()
and clears __GFP_IO|__GFP_FS from all allocation requests via alloc_pages, slab,
slub etc even if someone use a gfp_mask other than GFP_ATOMIC.
These code is for notifying memory allocator that "hibernation is running!".

The idea of this patch is notifying swap-allocator that "hibernation is running!"
(With this, we can believe ourselves even if some tainted modules are loaded.)

This patch's purpose is adding a safe system rather than believing no one does
bad thing. Fortunately, disallowing using swap is easy.



Thanks,
-Kame






