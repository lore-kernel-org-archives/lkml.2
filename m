Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2GFOeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:34:08 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:46575 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751440Ab2GFOeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:34:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WryC3k4VM1n25qsT3apyilmKSq6CJGMvbmFadMhBYZvsC9i
 1fgq7twJRNDHETADnjzFG1Nwc2Ym7ClMoxhX0rcIN2cJ5I8Bjdj.yXKJJrDo
 gMbSWrAEJXKK4LI_Jvo94gTuUqi4.gNUoXo77fRmnxBovnbfgX7RJPnt_a3V
 FTjlzFKPelHc2_vn7DREOY_1gOcOIe5P8c20xSC5w590LetSd9YIJF98tMiy
 kVaovht8m_FuxPn.7TPWIwqPRvYBKFzQM4T28wPYwcgBUp3w.IFwA1WS5C8C
 zkJwgSRjikRs4lCMCk0dmOu9JeUhcthKKif40JmgClfSr.xN985sse2C82Q7
 W2tJP8HmmL9tbfE.cVbCDTbEITaZ8Gn.5mme2HLN4IgfXmNpGaxIi869vYnH
 u
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 6 Jul 2012 09:34:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] slub: release a lock if freeing object with a lock
 is failed in __slab_free()
In-Reply-To: <CAAmzW4NJyX9e_dMyJBA5zDiVYVmL1vbUkaRHNoSbbhDZWW7iMg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207060928580.26790@router.home>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com> <1340389359-2407-3-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207050924330.4138@router.home> <CAAmzW4NJyX9e_dMyJBA5zDiVYVmL1vbUkaRHNoSbbhDZWW7iMg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, JoonSoo Kim wrote:

> For example,
> When we try to free object A at cpu 1, another process try to free
> object B at cpu 2 at the same time.
> object A, B is in same slab, and this slab is in full list.
>
> CPU 1                           CPU 2
> prior = page->freelist;    prior = page->freelist
> ....                                  ...
> new.inuse--;                   new.inuse--;
> taking lock                      try to take the lock, but failed, so
> spinning...
> free success                   spinning...
> add_partial
> release lock                    taking lock
>                                        fail cmpxchg_double_slab
>                                        retry
>                                        currently, we don't need lock
>
> At CPU2, we don't need lock anymore, because this slab already in partial list.

For that scenario we could also simply do a trylock there and redo
the loop if we fail. But still what guarantees that another process will
not modify the page struct between fetching the data and a successful
trylock?
