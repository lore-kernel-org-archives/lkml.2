Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0HaV2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:28:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65426 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab0HaV2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f1j6kHAx5+yhjyYfKFHiU6jU8lw6hr9eLuY1n+sv69Nmgq0+X7nK1JoO+v03GiTSJW
         TZAw4nMxZaRsAHzMB4gHHlGGlfwCnLY5pgcRF/uSID4heDAXexJkv4Kv6Fxf7Y2LUTch
         13EaDp20rf+AjlheHuIH70ZilK43sg5bcCQpk=
Subject: Re: [PATCH 03/10] Use percpu stats
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikdhnr12uU8Wp60BygZwH770RBfxyfLNMzUsQje@mail.gmail.com>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	 <1281374816-904-4-git-send-email-ngupta@vflare.org>
	 <alpine.DEB.2.00.1008301114460.10316@router.home>
	 <AANLkTikdhnr12uU8Wp60BygZwH770RBfxyfLNMzUsQje@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 23:28:26 +0200
Message-ID: <1283290106.2198.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 31 août 2010 à 16:31 -0400, Nitin Gupta a écrit :
> On Mon, Aug 30, 2010 at 12:20 PM, Christoph Lameter <cl@linux.com> wrote:
> > On Mon, 9 Aug 2010, Nitin Gupta wrote:
> >
> >> -static void zram_stat_inc(u32 *v)
> >> +static void zram_add_stat(struct zram *zram,
> >> +                     enum zram_stats_index idx, s64 val)
> >>  {
> >> -     *v = *v + 1;
> >> +     struct zram_stats_cpu *stats;
> >> +
> >> +     preempt_disable();
> >> +     stats = __this_cpu_ptr(zram->stats);
> >> +     u64_stats_update_begin(&stats->syncp);
> >> +     stats->count[idx] += val;
> >> +     u64_stats_update_end(&stats->syncp);
> >> +     preempt_enable();
> >
> > Maybe do
> >
> > #define zram_add_stat(zram, index, val)
> >                this_cpu_add(zram->stats->count[index], val)
> >
> > instead? It creates an add in a single "atomic" per cpu instruction and
> > deals with the fallback scenarios for processors that cannot handle 64
> > bit adds.
> >
> >
> 
> Yes, this_cpu_add() seems sufficient. I can't recall why I used u64_stats_*
> but if it's not required for atomic access to 64-bit then why was it added to
> the mainline in the first place?

Because we wanted to have fast 64bit counters, even on 32bit arches, and
this has litle to do with 'atomic' on one entity, but a group of
counters. (check drivers/net/loopback.c, lines 91-94). No lock prefix
used in fast path.

We also wanted readers to read correct values, not a value being changed
by a writer, with inconsistent 32bit halves. SNMP applications want
monotonically increasing counters.

this_cpu_add()/this_cpu_read() doesnt fit.

Even for single counter, this_cpu_read(64bit) is not using an RMW
(cmpxchg8) instruction, so you can get very strange results when low
order 32bit wraps.



