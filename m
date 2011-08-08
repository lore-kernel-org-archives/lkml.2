Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1HHXgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:36:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42619 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHXgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:36:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110808110658.31053.55013.stgit@localhost6>
References: <20110808110658.31053.55013.stgit@localhost6>
Date: Tue, 9 Aug 2011 08:36:37 +0900
Message-ID: <CAEwNFnBS0BqwnxdC3GDnEVsjm8SVy6tZvcpV7Cy0E=HvkU28=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] vmscan: promote shared file mapped pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 8:06 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> Commit v2.6.33-5448-g6457474 (vmscan: detect mapped file pages used only once)
> greatly decreases lifetime of single-used mapped file pages.
> Unfortunately it also decreases life time of all shared mapped file pages.
> Because after commit v2.6.28-6130-gbf3f3bc (mm: don't mark_page_accessed in fault path)
> page-fault handler does not mark page active or even referenced.
>
> Thus page_check_references() activates file page only if it was used twice while
> it stays in inactive list, meanwhile it activates anon pages after first access.
> Inactive list can be small enough, this way reclaimer can accidentally
> throw away any widely used page if it wasn't used twice in short period.
>
> After this patch page_check_references() also activate file mapped page at first
> inactive list scan if this page is already used multiple times via several ptes.
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Looks good to me.
But the issue is that we prefer shared mapped file pages aggressively
by your patch.

Shared page already have bigger chance to promote than single page
during same time window as many processes can touch the page.

The your concern is when file LRU is too small or scanning
aggressively, shared mapping page could lose the chance to activate
but it is applied single page, too. And still, shared mapping pages
have a bigger chance to activate compared to single page.  So, our
algorithm already reflect shared mapping preference a bit.

Fundamental problem is our eviction algorithm consider only recency,
not frequency. It's very long time problem and it's not easy to fix it
practically.

Anyway, it's a not subject it's right or not but it's policy thing and
I support yours.

Acked-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
