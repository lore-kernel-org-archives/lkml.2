Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1HAPzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:55:49 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:36660 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752464Ab1HAPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:55:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2.oRjxgVM1l7.fvnD7vBPZkHhubIntK8wmkLNtTzGl26n8s
 ZSl1Q0PYuF34HRC.UV52Uuun_iYBGCNGVV6bunyfX.Qe8I0l3StlcAJof4ym
 sfaK5ZsaXrjUuixX6OGJN8_2LvdXhqHZaKEv1_VfMoQr4MptPu_YNY6Zk2WH
 hlhUiC_YIvaQknFAAx7gSKPt9Yzn3YmPqM__XygeGs5Mm1gPfPmLhgT_OgA5
 EzE_b8bhy3XJj2Lhi78AEyyRiFnXc2BSyTeNtOQrv6jrYzUIH0B.NviPQBIj
 wtSp08560Dj1Yt9L2VUzH4sr9wMILdFsbdl1GpHPtcB6B2__xf3Y.8hnK0Ca
 E7FRs.EVgHgbjdBB8Osh98YEa
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 1 Aug 2011 10:55:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
In-Reply-To: <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1108011046230.8420@router.home>
References: <alpine.DEB.2.00.1107290145080.3279@tiger> <alpine.DEB.2.00.1107291002570.16178@router.home> <alpine.DEB.2.00.1107311136150.12538@chino.kir.corp.google.com> <alpine.DEB.2.00.1107311253560.12538@chino.kir.corp.google.com> <1312145146.24862.97.camel@jaguar>
 <alpine.DEB.2.00.1107311426001.944@chino.kir.corp.google.com> <CAOJsxLHB9jPNyU2qztbEHG4AZWjauCLkwUVYr--8PuBBg1=MCA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The future plans that I have for performance improvements are:

1. The percpu partial lists.

The min_partial settings are halved by this approach so that there wont be
any excessive memory usage. Pages on per cpu partial lists are frozen and
this means that the __slab_free path can avoid taking node locks for a
page that is cached by another processor. This causes another significant
performance gain in hackbench of up to 20%. The problem here is to fine
tune the approach and clean up the patchset.

2. per cpu full lists.

These will not be specific to a particular slab cache but shared amoung
all of them. This will reduce the need to keep empty slab pages on the
per node partial lists and therefore also reduce memory consumption.

The per cpu full lists will be essentially a caching layer for the
page allocator and will make slab acquisition and release as fast
as the slub fastpath for alloc and free (it uses the same
this_cpu_cmpxchg_double based approach). I basically gave up on
fixing up the page allocator fastpath after trying various approaches
over the last weeks. Maybe the caching layer can be made available
for other kernel subsystems that need fast page access too.

The scaling issues that are left over are then those caused by

1. The per node lock taken for the partial lists per node.
   This can be controlled by enlarging the per cpu partial lists.

2. The necessity to go to the page allocator.
   This will be tunable by configuring the caching layer.

3. Bouncing cachelines for __remote_free if multiple processors
   enter __slab_free for the same page.




