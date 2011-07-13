Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1GMPrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:47:17 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:31553 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755998Ab1GMPrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:47:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5Vc32acVM1l_5cP974j7Rztq2NcV2plK4hnq1JC12py0SuT
 nNos_nG4UTR.QvDzBgGSYMU0QL9t8kHMCTKyUODrrVbmm5SU6d31mV77_egx
 mxNdgupdgN6_Le3Yc7DiZSap4gXJNxMoeu9yC8bGbK319noy1ZpZrqrf3Pdv
 pfi_mDbm2rLKQJCSs2S.YlHx3jEIeRe_LE9h1h6cPweQZRqYSIDUScfVUBr7
 8pSCR0VvyFLGZ8gOJMlJqvVroFHZaZsB6gbJlQ_4tuuOiwuQ.4iYBRIwvMyi
 LAJLlZuLTzoLb5Bo0BkpWFd46T5IXgeTmhJ9Xtl8wlRnPJ_SCIOFd57QF.bL
 M4sTo99hI.Bm8suHhIfia9AC8
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 13 Jul 2011 10:47:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
In-Reply-To: <alpine.LSU.2.00.1107130357560.4184@sister.anvils>
Message-ID: <alpine.DEB.2.00.1107131041170.29034@router.home>
References: <alpine.LSU.2.00.1107111156310.13035@sister.anvils> <1310413167.2860.3.camel@edumazet-laptop> <4E1BE5F9.10401@kernel.org> <alpine.DEB.2.00.1107121010060.1672@router.home> <alpine.DEB.2.00.1107121046000.2530@router.home>
 <alpine.LSU.2.00.1107130357560.4184@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011, Hugh Dickins wrote:

> As I reported in Fengguang's more_io thread, I couldn't get this patch
> to apply, unsurprisingly to mmotm, more surprisingly to Pekka's for-next
> (which adds in the _count build fix).  Did you try to tidy up the
> indentations a little in between?

Nope. There are multiple patches that fix up thing in mm_types now and
they need to be stacked. I will try to avoid that.

> At the bottom I've put the patch against mmotm which I started testing
> instead on ppc64 a few hours ago.  It again seized up in __slab_free()
> after two and a half hours.  So either I screwed up my transliteration
> of your patch, or your patch is still wrong.  Please check mine out.
>
> Is yours actually tested on PowerPC or ARM, say?  I wonder if you're
> making endianness or bitfield ordering assumptions; but I've made no
> attempt to work it out.  Anything I can send you?  Disassembly of
> __slab_free()?

No I dont have PowerPC or ARM here. The problem is that without the
cmpxchg_double we fall back to slab_lock/slab_unlock. That code is not
that well tested. It is also used for slub_debug and that is how I tested
it.

The patch looks fine. I suspect that the reason lies elsewhere.

__slab_free does not disable interrupts. The use of cmpxchg_double_slab
would have to disable them if it falls back to the pagelock. Sigh.



