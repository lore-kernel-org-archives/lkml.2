Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0IBAe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:34:59 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:21962 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752793Ab0IBAe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:34:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: C78GaD4VM1nCsm0uUC10drrcEOLibnh_XaXPYyBv0ReYpdC
 PtgzYsGFftD2DoXTvMf8LeBr1Df37WJ5ghyefLBJfDi2vzib8AdWWv1UaQ6O
 xUo7.hetaXp96QBUVCbgGUjyp7pb3ECaq3rpHFJIpWPoltHIQS8YvWH32oHF
 D5ny4J2eaec7HnmJK5ToyPqQICsEPQYcb6IQrBU3y_FLu58g1n_frJJuqB_U
 z
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Sep 2010 19:34:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] Use percpu stats
In-Reply-To: <1283373495.2484.41.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1009011925080.20518@router.home>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>  <1281374816-904-4-git-send-email-ngupta@vflare.org>  <alpine.DEB.2.00.1008301114460.10316@router.home>  <AANLkTikdhnr12uU8Wp60BygZwH770RBfxyfLNMzUsQje@mail.gmail.com>  <1283290106.2198.26.camel@edumazet-laptop>
  <alpine.DEB.2.00.1008311635100.867@router.home>  <1283290878.2198.28.camel@edumazet-laptop>  <alpine.DEB.2.00.1009011501230.16013@router.home> <1283373495.2484.41.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010, Eric Dumazet wrote:

> > The additional advantage would be that for the 64bit case you would have
> > much faster and more compact code.
>
> My implementation is portable and use existing infrastructure, at the
> time it was coded. BTW, its fast on 64bit too. As fast as previous
> implementation. No extra code added. Please double check.

Well if you use the this_cpu_add() on 64 bit you have a single instruction
without the preempt off/on dance.

> If you believe you can do better, please do so.

Its right there in the x86_64 implementation of the this_cpu_ ops.

> Of course, we added 64bit network stats to all 32bit arches only because
> cost was acceptable. (I say all 32bit arches, because you seem to think
> only x86 was the target)

Ok then add your 64 bit on 32 bit implementation as a default for all 32
bit configurations. The point is to not have special implementations for
particular counters. It would be great if the logic you developed for the
network counters could be used in general for all who have issues with 64
bit counter increments.

> Using this_cpu_{add|res}() fallback using atomic ops or spinlocks would
> be slower than actual implemenation (smp_wmb() (nops on x86) and
> increments).

That would be bad. But then I do not see anyone around that wants
to implement such fallback behavior.

The current generic fallback for 64 ops (if the arch does not provide it
which 32 bit arches generally do not) is to switch off preempt and then
perform the 64 bit op. There is also a irqsafe version as well. Have a
look at inclue/linux/percpu.h.



