Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2EGUYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:24:11 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:38714 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932115Ab2EGUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:24:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: FL2mYsUVM1n.2EkLgitXAiJCziasRk6lSXVknFOjLxBK2j5
 x9eqawYqif.WmGGdt73YzinYB7njW7q6yU8.p0HfrSm7iyOG461dpDYDEu19
 EIAolrKyBVTEHaaiWnu_KXjNmasTBp5L6FbPV9zljRtWrhFhNGYdYjbiycuh
 jM8qMv59HFM8hSnkPp42w9A.EFKB6tHVbC4aQM6GcDCeqRYaSGqqjDf5c7xr
 lNDPOYnoiXP.Yc35fae8F18c9sntGD0gYU4lVOA0z6ea.QdBJENQ2heUgRw1
 u2Xcjhock0GHolyCAUxe5F3_Vvuz0ZxvtIuTsWh9CY7hP_gvHsRlQ_6thVZn
 o6aYr4PLJmegMRXGD_6dmpek331VKWEws8EsapWu1lQfyw70WXV2DfGqDFX.
 5fXvfUwXZaV23Snn2Qxux1BUM.0I0n_f2kpOI
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 7 May 2012 15:24:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v2
In-Reply-To: <CAOJsxLE36GNJBmdrJqFfoyEve8swVsaBSq_oVgkgXSMEC3oBfA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205071522450.6029@router.home>
References: <1334499755-4399-1-git-send-email-andi@firstfloor.org> <CAOJsxLE36GNJBmdrJqFfoyEve8swVsaBSq_oVgkgXSMEC3oBfA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-638261144-1336422247=:6029"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-638261144-1336422247=:6029
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 3 May 2012, Pekka Enberg wrote:

> (Adding some CC's.)

Uggg... Strange whitespace coming from Pekka again.

> On Sun, Apr 15, 2012 at 5:22 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > slab_node() could access current->mempolicy from interrupt context.
> > However there's a race condition during exit where the mempolicy
> > is first freed and then the pointer zeroed.
> >
> > Using this from interrupts seems bogus anyways. The interrupt
> > will interrupt a random process and therefore get a random
> > mempolicy. Many times, this will be idle's, which noone can change.
> >
> > Just disable this here and always use local for slab
> > from interrupts. I also cleaned up the callers of slab_node a bit
> > which always passed the same argument.

Good idea.

> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index cfb6c86..da79bbf 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1586,8 +1586,9 @@ static unsigned interleave_nodes(struct mempolicy=
 *policy)
> > =A0* task can change it's policy. =A0The system default policy requires=
 no
> > =A0* such protection.
> > =A0*/
> > -unsigned slab_node(struct mempolicy *policy)
> > +unsigned slab_node(void)
> > =A0{
> > + =A0 =A0 =A0 struct mempolicy *policy =3D !in_interrupt() ? current->p=
olicy : NULL;
> > =A0 =A0 =A0 =A0if (!policy || policy->flags & MPOL_F_LOCAL)

Simplify this to if (in_interrupt() || !policy || .... ?

---1463811839-638261144-1336422247=:6029--
