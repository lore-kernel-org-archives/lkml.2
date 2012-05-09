Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760551Ab2EIRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:25:29 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:42403 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755260Ab2EIRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:25:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: dpzYez8VM1kGy4E4lG4z81djHUbxyJqFWlFufi3sFN_7kww
 CYjdPSFVSyNjfpUKxw20jxK5GEYr_sVnNaieTXgzxY7mQ9YgvH27cN9IHsSM
 ttp6TwK0mz7NqujbmcLOplKBLgEBluT5nzRLK3u8hZ0LTsqnZ8hmn_8pJ4OR
 amXdGP3BLK56ZC.dUTeevQtcUHGpoSAkLBnwacyapC75JSzklXFO.dY2dK8c
 CWmMwfuK6_4omBSPfjNuwYFI.usKhi9JgwIlfm93awW9rszphIBEszSGx17Q
 eVNdRevgTwyaxlhrxEUY9erilJ19z1knRz.AnKA.cewgEKW9l9KfqyJRZ1Os
 DgyOLw1_79fnWYNokM9djl1wg1.trYWgoozo5O_zOBkJBXXae4ydyz975tcE
 I
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 9 May 2012 12:25:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pravin Shelar <pshelar@nicira.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com
Subject: Re: [PATCH] mm: sl[auo]b: Use atomic bit operations to update
 page-flags.
In-Reply-To: <CALnjE+pExzAS4bk89RD4XJtHtSyB2g0qMsqdrGWPuD27axiNBw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205091224460.11225@router.home>
References: <1336503339-18722-1-git-send-email-pshelar@nicira.com> <1336504276.3752.2600.camel@edumazet-glaptop> <alpine.DEB.2.00.1205081417120.27713@router.home> <CALnjE+pExzAS4bk89RD4XJtHtSyB2g0qMsqdrGWPuD27axiNBw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Pravin Shelar wrote:

> On Tue, May 8, 2012 at 12:22 PM, Christoph Lameter <cl@linux.com> wrote:
> > On Tue, 8 May 2012, Eric Dumazet wrote:
> >
> >> On Tue, 2012-05-08 at 11:55 -0700, Pravin B Shelar wrote:
> >> > Transparent huge pages can change page->flags (PG_compound_lock)
> >> > without taking Slab lock. So sl[auo]b need to use atomic bit
> >> > operation while changing page->flags.
> >> > Specificly this patch fixes race between compound_unlock and slab
> >> > functions which does page-flags update. This can occur when
> >> > get_page/put_page is called on page from slab object.
> >>
> >>
> >> But should get_page()/put_page() be called on a page own by slub ?
> >
> > Can occur in slab allocators if the slab memory is used for DMA. I dont
> > like the performance impact of the atomics. In particular slab_unlock() in
> > slub is or used to be a hot path item. It is still hot on arches that do
> > not support this_cpu_cmpxchg_double. With the cmpxchg_double only the
> > debug mode is affected.
> >
>
> I agree this would impact performance. I am not sure how else we can
> fix this issue. As far as slab_unlock in hot path case is concerned,
> it is more likely to corrupt page->flags in that case.

Dont modify any page flags from THP logic if its a slab page? THP cannot
break up or merge slab pages anyways.


