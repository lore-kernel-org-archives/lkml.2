Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2GPUOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:14:24 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:44739 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752453Ab2GPUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:14:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6srkqZMVM1msMUPQzg_R0yoqqEPAh2Dpk04GT3Qerc.hJ2i
 gPjVd.TTtj0oRzyG.5rFnGm44R2Zm2MQEnGpa9n2cyrDOCB72NiBnwbSPVbL
 rzMQAL6qSFgeSncZRxHogzi6K2DrLyp.boy.TTkzrBx3jAwgkzI1LkJijrfE
 jrQ31v5YLhoQRB54_Iv9ibAILNWNk8Iu3x4PKl10xqeMJPpVUY1K.fMyqB.0
 4K9gDAWJP_P4RPTO63XdliWlhJDvh2TtDAhT6RM9b0n9Ig7t3x.sdtApJWp6
 thmSjkHYvTtiSViH3OylzXJdNDdP_xf8vOfr6SGdRJYPpZ2Pta7U9qH7r65L
 caa.KQDOllq.tLzb.FM11P2KnzOyvE9KtGnRTp_6La0kGsLC1hlEOWdNdtoR
 j
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 16 Jul 2012 15:14:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Shuah Khan <shuah.khan@hp.com>, Pekka Enberg <penberg@kernel.org>,
        glommer@parallels.com, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <alpine.DEB.2.00.1207161253240.29012@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1207161506390.32319@router.home>
References: <1342221125.17464.8.camel@lorien2> <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com> <CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com> <1342407840.3190.5.camel@lorien2> <alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1207160915470.28952@router.home> <alpine.DEB.2.00.1207161253240.29012@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, David Rientjes wrote:

> > These checks are useless for regular kernel operations. They are
> > only useful when developing code and should only be enabled during
> > development. There is no point in testing the size and the name which are
> > typically constant when a slab is created with a stable kernel.
> >
>
> Sounds like a response from someone who is very familiar with slab
> allocators.  The reality, though, is that very few people are going to be
> doing development with CONFIG_DEBUG_VM enabled unless they notice problems
> beforehand.

Kernels are certainly run with CONFIG_DEBUG_VM before merges to mainstream
occur. If the developer does not do it then someone else will.

> Are you seriously trying to optimize kmem_cache_create()?  These checks
> certainly aren't going to hurt your perfromance and it seems appropriate
> to do some sanity checking before blowing up in unexpected ways.  It's
> also the way it's been done for years before extracting common allocator
> functions to their own file.

The kernel cannot check everything and will blow up in unexpected ways if
someone codes something stupid. There are numerous debugging options that
need to be switched on to get better debugging information to investigate
deper. Adding special code to replicate these checks is bad.

Frankly, these checks are there only for legacy reasons in the common code
due to SLAB having them. Checking for NULL pointers is pretty useless
since any dereference will cause a oops that will show where this
occurred.

The other checks are of the same order of uselessness. The interrupt check
f.e. is nonsense since the first attempt to acquire the slab
futex will trigger another exception.

I would suggest to rather drop these checks entirely. SLUB never had these
braindead things in them and has been in use for quite a long time.

