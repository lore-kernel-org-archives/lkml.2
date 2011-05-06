Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1EFSWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:22:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1EFSWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:22:20 -0400
Date: Fri, 6 May 2011 20:21:51 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, mel@csn.ul.ie,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        kamezawa.hiroyu@jp.fujisu.com, minchan.kim@gmail.com,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH]mm/compation.c: checking page in lru twice
Message-ID: <20110506182151.GG6330@random.random>
References: <1304681575.15473.4.camel@figo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304681575.15473.4.camel@figo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 07:32:46PM +0800, Figo.zhang wrote:
> 
> in isolate_migratepages() have check page in LRU twice, the next one
> at _isolate_lru_page(). 

hugetlbfs or any other compound page won't have PageLRU set and they
may go away from under us leading to compound_order not being reliable
if we remove the PageLRU check before compound_order. So we need to
verify the page is in LRU before running compound_order safely. And if
we hold the lru_lock, the page won't be isolated under us, and we know
it's not going to get splitted either.

We might use compound_trans_order but that's only reliable if run on
the head page so it's not so reliable, and so far it's only used by
memory-failure to "diminish" the risk of races in reading the compound
order, but it's not the best having to use compound_trans_order (and
memory-failure remains unsafe w.r.t to hugetlbfs being released during
hwpoisoning, so compound_trans_order might have to be improved for
it).
