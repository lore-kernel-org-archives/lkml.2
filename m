Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0EYQSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:18:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:43692 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab0EYQSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:18:52 -0400
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by
  transactional API (take 2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, ming.m.lin@intel.com, perfmon2-devel@lists.sf.net
In-Reply-To: <AANLkTilwlZKx0k-Z_6LHVXIM561JLcWV4mX4Wcwgb7r0@mail.gmail.com>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	 <1274794518.5882.1280.camel@twins>
	 <AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
	 <1274796225.5882.1389.camel@twins>
	 <AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
	 <AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
	 <1274801531.5882.1670.camel@twins> <1274803086.5882.1752.camel@twins>
	 <AANLkTilwlZKx0k-Z_6LHVXIM561JLcWV4mX4Wcwgb7r0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 18:18:35 +0200
Message-ID: <1274804315.5882.1821.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 18:10 +0200, Stephane Eranian wrote:
> > Index: linux-2.6/kernel/perf_event.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/perf_event.c
> > +++ linux-2.6/kernel/perf_event.c
> > @@ -668,15 +668,9 @@ group_sched_in(struct perf_event *group_
> >                }
> >        }
> >
> > -       if (!txn)
> > +       if (!txn || !pmu->commit_txn(pmu))
> >                return 0;
> >
> > -       ret = pmu->commit_txn(pmu);
> > -       if (!ret) {
> > -               pmu->cancel_txn(pmu);
> > -               return 0;
> > -       }
> > -
> >  group_error:
> >        /*
> >         * Groups can be scheduled in as one unit only, so undo any
> >
> Looks okay.
> 
> I believe you can also drop the txn test in group_sched_in() after group_error:,
> given you have the if !(txn) return 0.

Can't we still get in the group_error: branch with either scenario?

!txn will get there if ->enable() of a group sibling fails,
txn will get there if either ->enable() or ->commit_txn() fails.

(Although typically ->enable() would not fail for txn)
