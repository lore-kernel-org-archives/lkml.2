Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab2BJOU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:20:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235Ab2BJOU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:20:28 -0500
Date: Fri, 10 Feb 2012 12:20:15 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Sorin Dumitru <dumitru.sorin87@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH] perf: add sanity check on addr in
	symbol__inc_addr_samples()
Message-ID: <20120210142015.GC4998@infradead.org>
References: <20120209103016.GA1999@quad> <20120209144844.GA4998@infradead.org> <CABPqkBRdbn+UasvWgVco-NZ_LasFeG+7bLzTDVcQO-e6J+AW-Q@mail.gmail.com> <CAB6DaTONEDguW5ivSfSD+vUsKw+6--Z9H2V_LTBYaf_Qf_Jajg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB6DaTONEDguW5ivSfSD+vUsKw+6--Z9H2V_LTBYaf_Qf_Jajg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 09, 2012 at 05:06:57PM +0200, Sorin Dumitru escreveu:
> On Thu, Feb 9, 2012 at 4:53 PM, Stephane Eranian <eranian@google.com> wrote:
> > On Thu, Feb 9, 2012 at 3:48 PM, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> >> Em Thu, Feb 09, 2012 at 11:30:16AM +0100, Stephane Eranian escreveu:

> >>> Check the value of addr against the bounds of the symbol.
> >>> This is needed given we compute an offset:
> >>>       offset = addr - sym->start

> >>> And we don't want the offset to become negative.

> >> I'll try and add a debug option to show the backtrace and values of
> >> addr, sym, etc, so that we can fix the real problem.

> >> I.e. this function shouldn't be receiving any such invalid addresses, as
> >> the symbol lookup was done, the symbol was found to be this one, then
> >> why it would be out of bounds at this point?!

> > I tend to agree with you on this. But then I don't see why the first test
> > was there.
 
> I reported the same problem a couple of weeks ago. From what i can
> tell the problem is in perf_event__process_sample.

> When calling perf_event__process_sample, we set al->sym based on
> al->address.

> The symbol in the hist_entry is set to the one from al but in the call
> to perf_top__record_precise_ip we pass in the address from the event
> struct which is sometimes different than the one in the al structure.

> When this situation occurs, when calculating the offset in
> symbol__inc_addr_samples, because addr is not in the symbol
> [start,end] range, we get a very big value which causes the segfault
> when we use it to index something. I've sent a patch that works for
> me, but i don't know if it's the right solution at [1].
 
> [1] https://lkml.org/lkml/2012/1/29/59

Sorry for not having followed up on that one, now I'm trying to check if
it is valid but:

1. addr_location is set by perf_event__preprocess_sample that will call
   several routines that will figure out if the DSO symtab is loaded,
   load it if not, deal with prelinking, etc.

2. so at the end of this symbol resolution al.addr will point to the
   result of:

	al->map->map_ip(al->map, event->ip.ip)

3. in perf_top__record_precise_ip we'll use:

        he->ms.map->map_ip(he->ms.map, event->ip.ip)

And:

	he->ms.map == al->map

	So yeah, we can, as a worthwhile simplification, just pass
al.addr to perf_top__record_precise_ip as in your patch, but then we
need to remove the call to he->ms.map->map_ip.

	This extra call is harmless for identity mapped DSOs, as it
boils down to:

u64 identity__map_ip(struct map *map __used, u64 ip)
{               
        return ip;
} 

	But if the DSO uses:

u64 map__map_ip(struct map *map, u64 ip)
{                    
        return ip - map->start + map->pgoff;
} 

	Then we would be mapping the IP possibly to a negative one.

	So we need to revisit the details of your case and the one
Stephane (or Roberto) experienced, i.e. what kind of DSO? Prelinked?
etc.

- Arnaldo
