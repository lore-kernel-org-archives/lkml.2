Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308Ab2CWA0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:26:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2CWA0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:26:44 -0400
Date: Thu, 22 Mar 2012 17:30:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Message-Id: <20120322173000.f078a43f.akpm@linux-foundation.org>
In-Reply-To: <4F6BC166.80407@jp.fujitsu.com>
References: <4F69A4C4.4080602@jp.fujitsu.com>
	<20120322143610.e4df49c9.akpm@linux-foundation.org>
	<4F6BC166.80407@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 09:18:46 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> >> +#ifdef CONFIG_SWAP
> >> +	/*
> >> +	 * Avoid lookup_swap_cache() not to update statistics.
> >> +	 */
> > 
> > I don't understand this comment - what is it trying to tell us?
> > 
> 
> 
> High Dickins advised me to use find_get_page() rather than lookup_swap_cache()
> because lookup_swap_cache() has some statistics with swap.

ah.

--- a/mm/memcontrol.c~memcg-change-behavior-of-moving-charges-at-task-move-fix
+++ a/mm/memcontrol.c
@@ -5137,7 +5137,8 @@ static struct page *mc_handle_swap_pte(s
 		return NULL;
 #ifdef CONFIG_SWAP
 	/*
-	 * Avoid lookup_swap_cache() not to update statistics.
+	 * Use find_get_page() rather than lookup_swap_cache() because the
+	 * latter alters statistics.
 	 */
 	page = find_get_page(&swapper_space, ent.val);
 #endif

> >> +	page = find_get_page(&swapper_space, ent.val);
> > 
> > The code won't even compile if CONFIG_SWAP=n?
> > 
> 
> mm/built-in.o: In function `mc_handle_swap_pte':
> /home/kamezawa/Kernel/next/linux/mm/memcontrol.c:5172: undefined reference to `swapper_space'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Ah...but I think this function (mc_handle_swap_pte) itself should be under CONFIG_SWAP.
> I'll post v2.

Confused.  The new reference to swapper_space is already inside #ifdef
CONFIG_SWAP.
