Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2AWOs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:48:57 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:32392 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752749Ab2AWOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:48:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: s29geEcVM1nQwjS73C3kbAKwwGPZMMmLmnBU5Cf3udVsvfk
 MspjtBnvX9ebg4L75pMO2jh5DJih7apsJpTwU3KjPaVxlKItx_7y1os5Cs4U
 8RqsZM.xEZ4TPnzW6BPq4i18Zcv_Au6.D1yw6XtwF180.GCL0bDk5ESSuDBp
 5rFC9NtPsuEMhttYIKARTv4HgxyGodWSA_uydFdsE_Ei.DoIECuVwDcL2vei
 YzpcAFIAreG5JsjNeF76l2qYmcuZgSiSx_iyVUCSvE8eQ1EjCm2baG91bx1t
 cOwK34Z7iDLVBShdKxN5UuDVOWCC0PCPO9UV6iH5yLLc0p4ntegNlwJI8Fx7
 ksoTrDtgy8BD32.60ZC.gdSm94VKGJwNEAxcgePcOdCV_EKfpOuohoBcxHqt
 K
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 23 Jan 2012 08:48:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Zhao Jin <cronozhj@gmail.com>, mpm@selenic.com, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2][RESEND] slab: avoid unnecessary touching of a partial
 slab
In-Reply-To: <alpine.LFD.2.02.1201231521340.11844@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1201230846290.7674@router.home>
References: <1314376095-14991-1-git-send-email-cronozhj@gmail.com> <alpine.LFD.2.02.1201231521340.11844@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1201230846292.7674@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012, Pekka Enberg wrote:

> > diff --git a/mm/slab.c b/mm/slab.c
> > index 82e0a0e..2d7a0f4 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -3121,11 +3121,10 @@ retry:
> > 		check_slabp(cachep, slabp);
> >
> > 		/* move slabp to correct slabp list: */
> > -		list_del(&slabp->list);
> > 		if (slabp->free == BUFCTL_END)
> > -			list_add(&slabp->list, &l3->slabs_full);
> > -		else
> > -			list_add(&slabp->list, &l3->slabs_partial);
> > +			list_move(entry, &l3->slabs_full);
> > +		else if (entry != l3->slabs_partial.next)

Why is the check for entry necessary? We are holding a lock that
prevents modifications to the list after all.

Just a list_move when the partial slab is drained seems to be sufficient.
