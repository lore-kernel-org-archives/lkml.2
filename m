Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0JORUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:20:21 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:20868 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756161Ab0JORUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:20:18 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: D8569iEVM1k22jZ2X7PhffiUF5okPVfs4UhKRk8QI.Bfj1h
 imz1R7C_IzwFaxLde5BGJ.veDzP7oDad0lUfR2q4k6hOAlMIuJWKMBf5r8.h
 F8xzqy1.LR29qlt33KN0ESyXfDkpWyTeSCPhQwSttBLG.FIiT4_uCOc0pBFd
 dt1i425jO9lZDB6iFVR.rp0IB0MvMGS24gWIcVGHuZbhSiUzsfD.kbQzxF2Q
 czFDNttJm7CxdybRnDY7E.hK4lbCF
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 15 Oct 2010 12:20:13 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Greg Thelen <gthelen@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 1/2] memcg: avoiding unnecessary get_page at
 move_charge
In-Reply-To: <20101015171109.d4575c95.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010151211040.24683@router.home>
References: <20101015170627.e5033fa4.kamezawa.hiroyu@jp.fujitsu.com> <20101015171109.d4575c95.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010, KAMEZAWA Hiroyuki wrote:

> But above is called all under pte_offset_map_lock().
> get_page_unless_zero() #1 is not necessary because we do all under a
> pte_offset_map_lock().

The two (ptl and refcount) are entirely different. The ptl is for
protecting the page table. The refcount handles only the page.

However, if the entry in the page table is pointing to the page then there
must have been a refcount taken on the page. So if you know that the page
is in the page table and you took the ptl then you can be sure that the
page refcount will not become zero. Therefore get_page_unless_zero() will
never fail and there is no need to take additional refcounts as long as
the page table lock is held and the page is not removed from the page
table.

> Index: mmotm-1013/mm/vmscan.c
> ===================================================================
> --- mmotm-1013.orig/mm/vmscan.c
> +++ mmotm-1013/mm/vmscan.c
> @@ -1166,7 +1166,8 @@ static unsigned long clear_active_flags(
>   * found will be decremented.
>   *
>   * Restrictions:
> - * (1) Must be called with an elevated refcount on the page. This is a
> + * (1) Must be called with an elevated refcount on the page, IOW, the
> + *     caller must guarantee that there is a stable reference. This is a
>   *     fundamentnal difference from isolate_lru_pages (which is called
>   *     without a stable reference).
>   * (2) the lru_lock must not be held.

There is no need for this change since you have an elevated refcount.
IMH The words "stable reference" may be confusing since the refcount may
change. The elevated refcount protects against the freeing of the page.

