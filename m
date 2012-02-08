Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2BHWb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:31:26 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:40659 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751098Ab2BHWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:31:25 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Er9xAD4VM1nHdZu9h5O.oN4IiDK84mDp_Xx6SXBfvdgDkxE
 vF.9MOXnv4vYnliOYnI9j4T2lLeTFXOgtqpzp_Qws_.9p4IT1Pxl8PtXx2Do
 pB_3QqE3nev26JVgRD6Tfpm9Ve3ksYwYkA3mKoyDORSSc_DSKiW7DuNRdhPZ
 oyuLqEnk6AUsv2Y3_JjtKMrvNQ2Ywei8QldPVcH53W98QAewbmWN.3WT9vhf
 E17dTqCmcKBz4Qk5orvn2gWORKaZO89QAdN9gOwn0sRtKc2hxfm2IYlZ6dih
 QFhUedc0emSHk5s3jqgvKJZxInybwpo9JdIuALtUiMBJDIQ4OpTMLOIyxcM_
 Jp5R6sXcCE6Br4vlAK_JxZIS2KZ8VcqQvKkfKTJXCt5ytJ2GXLkXWuGUxv9B
 fp3Mmfp41qugqsyiqD9Itew.MUfQNiQm2MCDc
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 8 Feb 2012 16:13:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/15] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
In-Reply-To: <20120208212323.GM5938@suse.de>
Message-ID: <alpine.DEB.2.00.1202081557540.5970@router.home>
References: <1328568978-17553-1-git-send-email-mgorman@suse.de> <1328568978-17553-3-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1202071025050.30652@router.home> <20120208144506.GI5938@suse.de> <alpine.DEB.2.00.1202080907320.30248@router.home>
 <20120208163421.GL5938@suse.de> <alpine.DEB.2.00.1202081338210.32060@router.home> <20120208212323.GM5938@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012, Mel Gorman wrote:

> On Wed, Feb 08, 2012 at 01:49:05PM -0600, Christoph Lameter wrote:
> > On Wed, 8 Feb 2012, Mel Gorman wrote:
> >
> > > Ok, I looked into what is necessary to replace these with checking a page
> > > flag and the cost shifts quite a bit and ends up being more expensive.
> >
> > That is only true if you go the slab route.
>
> Well, yes but both slab and slub have to be supported. I see no reason
> why I would choose to make this a slab-only or slub-only feature. Slob is
> not supported because it's not expected that a platform using slob is also
> going to use network-based swap.

I think so far the patches in particular to slab.c are pretty significant
in impact.

> > Slab suffers from not having
> > the page struct pointer readily available. The changes are likely already
> > impacting slab performance without the virt_to_page patch.
> >
>
> The performance impact only comes into play when swap is on a network
> device and pfmemalloc reserves are in use. The rest of the time the check
> on ac avoids all the cost and there is a micro-optimisation later to avoid
> calling a function (patch 12).

We have been down this road too many times. Logic is added to critical
paths and memory structures grow. This is not free. And for NBD swap
support? Pretty exotic use case.

> Ok, are you asking that I use the page flag for slub and leave kmem_cache_cpu
> alone in the slub case? I can certainly check it out if that's what you
> are asking for.

No I am not asking for something. Still thinking about the best way to
address the issues. I think we can easily come up with a minimally
invasive patch for slub. Not sure about slab at this point. I think we
could avoid most of the new fields but this requires some tinkering. I
have a day @ home tomorrow which hopefully gives me a chance to
put some focus on this issue.

> I did come up with a way: the necessary information is in ac and slabp
> on slab :/ . There are not exactly many ways that the information can
> be recorded.

Wish we had something that would not involve increasing the number of
fields in these slab structures.

