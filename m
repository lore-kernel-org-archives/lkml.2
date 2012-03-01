Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2CAPDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 10:03:20 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:25336 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757757Ab2CAPDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 10:03:19 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qfbIvocVM1nhlhctFjmmsmfRY66orQqscVqpQjPlntzAgB6
 8Vzo5jNaAakpstifslJ7m7FeZhweMwEvvMjQeOSybC.sGxYy78Tla.d3pX.B
 BJzx1Zpsrz00IFZqZFzrdNvuDddAD1K_flkppe5ZHyUThQuH4LE0lDozRPWY
 AeP4uNhku1Hn.yE_P2.Wh5EEYMTdsDZN.IsDEhlYt5JAu90Di69H45nfhDr.
 hAMZHNrWIaE6WBUB8rDMpULNzU1l_6XkTWpDi3.5lqUfqRtLwXyMEwbca9G4
 SapjOqs0_MXMLACXyGv6Y6_jyqoLTB6vDXR_kkcvygDRRbc_lp5PS_sqGmvL
 x1YXIa6qzk50xNpNqzi2p0gdmm8lOJUcPgLmg4lqdtsh8piKlGHuRU_yNNrV
 mp5wSAX8grPjr99GzXEvCVXawnUkoxbmo9fko48iUvQdQJJWN.4Ygltk86g-
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 1 Mar 2012 09:03:16 -0600 (CST)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Namhyung Kim <namhyung@gmail.com>
cc: Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] slub: set PG_slab on all of slab pages
In-Reply-To: <1330587031.1762.46.camel@leonhard>
Message-ID: <alpine.DEB.2.00.1203010901020.5004@router.home>
References: <1330505674-31610-1-git-send-email-namhyung.kim@lge.com>  <alpine.DEB.2.00.1202290922210.32268@router.home> <1330587031.1762.46.camel@leonhard>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012, Namhyung Kim wrote:

> > You cannot free a tail page of a compound higher order page independently.
> > You must free the whole compound.
> >
>
> I meant freeing a *slab object* resides in a compound page using buddy
> system API (e.g. free_pages). I know it's definitely a programming
> error. However there's no safety net to protect and/or warn such a
> misbehavior AFAICS - except for head page which has PG_slab set - when
> it happened by any chance.

?? One generally passed a struct page pointer to the page allocator. Slab
allocator takes pointers to object. The calls that take a pointer to an
object must have a page aligned value.

> Without it, it might be possible to free part of tail pages silently,
> and cause unexpected not-so-funny results some time later. It should be
> hard to find out.

Ok then fix the page allocator to BUG() on tail pages. That is an issue
with the page allocator not the slab allocator.

Adding PG_tail to the flags checked on free should do the trick (at least
for 64 bit).

