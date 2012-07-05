Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2GEOUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:20:09 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:35963 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751206Ab2GEOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:20:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VzU17toVM1lloB12C5VzAyfc04.lB32M9mm0vmYM2LoCEV7
 xkoZjp_oYDYqY5v3wTSgKccFJ5BJmA35fbT4lF_vsXKZqJUtFF89ahF9cjye
 61Er6UNRO60B3e_EEf2_OKUgzpn4iHlKI6lPbtUifw9wYij8odAwboR8WKBg
 rN__3RKJVq5pHRVQH6W821XIQNO7mDheDXJTK1M6OB_9A6JHrgekXfK5q22l
 _DqDVzdD36wJAAdOa3peiouv4Nn2Ew35QCbtiXknrjyqeWhl4BZoIGwK45pv
 MpBdLU6ASAONZh1nFTKFs0nZv6bSaeLwZ_Orn.hGzEj_cGh6b04FTUMPD.Lf
 Zi9jRjlfCI.U4AMxBCMD3EcOpk8.s9bBEzJ70UES7.CvDOrdrh_BYx5GUIAH
 _7kl8UW7LqlXBNSMxXiVcehPBgTkGclIfDUcE
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 5 Jul 2012 09:20:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/3] slub: reduce failure of this_cpu_cmpxchg in
 put_cpu_partial() after unfreezing
In-Reply-To: <CAOJsxLEy++a5R6-7bFaHNG4XqmvJoUTEMMJhpVD5nnxLkAafsw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207050918290.4138@router.home>
References: <1340389359-2407-1-git-send-email-js1304@gmail.com> <1340389359-2407-2-git-send-email-js1304@gmail.com> <CAOJsxLEy++a5R6-7bFaHNG4XqmvJoUTEMMJhpVD5nnxLkAafsw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, Pekka Enberg wrote:

> On Fri, Jun 22, 2012 at 9:22 PM, Joonsoo Kim <js1304@gmail.com> wrote:
> > In current implementation, after unfreezing, we doesn't touch oldpage,
> > so it remain 'NOT NULL'. When we call this_cpu_cmpxchg()
> > with this old oldpage, this_cpu_cmpxchg() is mostly be failed.
> >
> > We can change value of oldpage to NULL after unfreezing,
> > because unfreeze_partial() ensure that all the cpu partial slabs is removed
> > from cpu partial list. In this time, we could expect that
> > this_cpu_cmpxchg is mostly succeed.
> >
> > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 92f1c0e..531d8ed 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1968,6 +1968,7 @@ int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
> >                                 local_irq_save(flags);
> >                                 unfreeze_partials(s);
> >                                 local_irq_restore(flags);
> > +                               oldpage = NULL;
> >                                 pobjects = 0;
> >                                 pages = 0;
> >                                 stat(s, CPU_PARTIAL_DRAIN);
>
> Makes sense. Christoph, David?

Acked-by: Christoph Lameter <cl@linux.com>

