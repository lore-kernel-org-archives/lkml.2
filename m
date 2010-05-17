Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0EQMDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:03:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:48945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0EQMDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:03:39 -0400
Subject: Re: [PATCH] perf_events: fix errors path in perf_output_begin()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <AANLkTil2QBjH2qvnH7VKrg6s7RcKvHC1m0HZkDVDPzv5@mail.gmail.com>
References: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
	 <20100517114605.GB5291@nowhere>
	 <AANLkTil2QBjH2qvnH7VKrg6s7RcKvHC1m0HZkDVDPzv5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 May 2010 14:03:00 +0200
Message-ID: <1274097780.5605.4642.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 13:56 +0200, Stephane Eranian wrote:
> >> +     if (!data->nr_pages) {
> >> +             atomic_inc(&data->lost);
> >> +             goto out;
> >> +     }


> Well, nr_pages = 0 means all you have is the sampling buffer
> header page. You cannot save any sample, so you  actually
> loose everything. Perf reports a dozen samples but those
> are synthetic. The kernel cannot reject an mmap() for
> just one page because of the remapped counters, thus it
> has to handle this gracefully and at least report the lost
> samples.

So you want to preserve this state for when you munmap() and mmap()
again? The only user of data->lost is writing the PERF_RECORD_LOST
event, which only ever happens when you have pages, so counting it when
there's no pages seems futile.


