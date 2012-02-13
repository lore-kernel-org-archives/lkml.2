Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab2BMU2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:28:00 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:39205 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757957Ab2BMU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:27:59 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KUYJJqYVM1mM.Y9LK530X9UIBJ3kYKO.a76_.5Ifcnvc.yZ
 v0irRFhwJlyLJSOTDMY3Ub2cW5twlTTxNBA1J3LqVMt_SEd29brnevY.Gc5j
 bx.5muyDDhfXx7ujHdK7B8LsXYQBeLCMWUJRapmriif24S8J1ObS9WeBvckJ
 Q3viG_ndx3GubSQn5az93O8l6PGU7bSO45Ul5y6qUlwvUC8b.EcG5KMGIfOy
 YdGi9gPaw3oZVnfjORXLkEmeYiz4ORkzHv1GQMxRWBTp9DCyGrf5.HKuCmeQ
 bufXffpfcaYuj_TfUAtFw.zfGVjwvtubHjR6RjK12fsfPPleRY.xD2uQvrU6
 9P882FkITbBJbdf2p.1664JEbxeUz1vc7pxW__BGCltgFdfNq3YdsdtslLWp
 Z
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 13 Feb 2012 14:27:55 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Xi Wang <xi.wang@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
In-Reply-To: <20120213194446.GD26353@mwanda>
Message-ID: <alpine.DEB.2.00.1202131424020.25908@router.home>
References: <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com>
 <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net> <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012, Dan Carpenter wrote:

>
> The point was that there are a bunch of places where we have had
> integer overflows caused by doing kmalloc(x * sizeof(struct whatever)).
> For kzalloc(x * sizeof(struct whatever)), you just write it like
> kcalloc(x, sizeof(struct whatever)) and avoid the overflow, but we
> don't have a non-zeroing version of kcalloc() to do that.
>
> Probably once we have the kmalloc_array() and people start using it,
> we get a bunch of overflow checking automatically and it's a kernel
> hardenning thing.  As well we could remove the duplicative checking
> so it's a cleanup.

Could you just do a macro that can be used in any location where the
size of an array needs to be calculation. For example:

	SAFE_ARRAY_SIZE(<nr>,<struct>)

So you'd do

	kmalloc_node(SAFE_ARRAY_SIZE(10, struct page), 2, GFP_KERNEL)

or if you want multiple dimensions

	SAFE_ARRAY_SIZE_2(<nr1>,<nr2>,<struct>)

?

> > If you add these variants then please think
> > about the necessity to add other variants (like the kmalloc_node() NUMA
> > call) etc in the future.
> >
>
> We don't have a kcalloc_node(), so I don't think this is likely to
> be a big issue.

Yes and so if you need to allocate on a particular node then you need to
do the calculation manually and therefore may not check for overflows.

Get rid of kcalloc and replace it with

	kzalloc(SAFE_ARRAY_SIZE(x, y), ....)

?


