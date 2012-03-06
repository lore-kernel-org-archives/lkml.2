Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2CFBQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:16:33 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58001 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab2CFBQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:16:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of minchan.kim@gmail.com designates 10.68.195.99 as permitted sender) smtp.mail=minchan.kim@gmail.com; dkim=pass header.i=minchan.kim@gmail.com
Date: Tue, 6 Mar 2012 10:16:24 +0900
From: Minchan Kim <minchan@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] slub: set PG_slab on all of slab pages
Message-ID: <20120306011624.GA14274@barrios>
References: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com>
 <20120304103446.GA9267@barrios>
 <alpine.DEB.2.00.1203050845380.11722@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203050845380.11722@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, Mar 05, 2012 at 08:48:33AM -0600, Christoph Lameter wrote:
> On Sun, 4 Mar 2012, Minchan Kim wrote:
> 
> > I read this thread and I feel the we don't reach right point.
> > I think it's not a compound page problem.
> > We can face above problem where we allocates big order page without __GFP_COMP
> > and free middle page of it.
> 
> Yes we can do that and doing such a thing seems to be more legitimate
> since one could argue that the user did not request an atomic allocation
> unit from the page allocator and therefore the freeing of individual
> pages in that group is permissible. If memory serves me right we do that
> sometimes.

To be leitimate, user have to handle subpages's ref counter well.
But I think it's not desirable. If user want it, he should use
split_page instead of modifying ref counter directly.

> 
> However if compound pages are requested then such an atomic allocation
> unit *was* requested and the page allocator should not allow to free
> individual pages.

Yes. In fact, I am not sure this problem is related to compound page.
If it is compound page, tail page's ref count should be zero.
When user calls __free_pages in tail page by mistake, it should not pass
into __free_pages_ok but reference count would be underflow.
Later, when head page is freed, we could catch it in free_pages_check.

So I had a question to Namhyung that he can see bad page message by PG_slab when he uses SLUB
with his patch. If the problem still happens, something seems to modify tail page's ref count
directly without get_page. It's apparently BUG.

