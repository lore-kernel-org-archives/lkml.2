Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2A0UPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:15:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab2A0UPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:15:52 -0500
Date: Fri, 27 Jan 2012 12:15:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] readahead: add /debug/readahead/stats
Message-Id: <20120127121551.acd256aa.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1201271006480.16756@router.home>
References: <20120127030524.854259561@intel.com>
	<20120127031327.159293683@intel.com>
	<alpine.DEB.2.00.1201271006480.16756@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 10:21:36 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> > +
> > +static void readahead_stats_reset(void)
> > +{
> > +	int i, j;
> > +
> > +	for (i = 0; i < RA_PATTERN_ALL; i++)
> > +		for (j = 0; j < RA_ACCOUNT_MAX; j++)
> > +			percpu_counter_set(&ra_stat[i][j], 0);
> 
> for_each_online(cpu)
> 	memset(per_cpu_ptr(&ra_stat, cpu), 0, sizeof(ra_stat));

for_each_possible_cpu().  And that's one reason to not open-code the
operation.  Another is so we don't have tiresome open-coded loops all
over the place.

But before doing either of those things we should choose boring old
atomic_inc().  Has it been shown that the cost of doing so is
unacceptable?  Bearing this in mind:

> The accounting code will be compiled in by default
> (CONFIG_READAHEAD_STATS=y), and will remain inactive by default.

I agree with those choices.  They effectively mean that the stats will
be a developer-only/debugger-only thing.  So even if the atomic_inc()
costs are measurable during these develop/debug sessions, is anyone
likely to care?


