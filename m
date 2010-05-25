Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab0EYQUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:20:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:31336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab0EYQUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:20:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=yGpDF9Qyc/C2lFm1tumviysQiG6kSHeJK50+s5K1A1Rvq3GgZa85RpVVH+NCBGEAX
	FmGZ/r2wnmGG6ucj956MA==
MIME-Version: 1.0
In-Reply-To: <1274804315.5882.1821.camel@twins>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	<1274794518.5882.1280.camel@twins>
	<AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
	<1274796225.5882.1389.camel@twins>
	<AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
	<AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
	<1274801531.5882.1670.camel@twins>
	<1274803086.5882.1752.camel@twins>
	<AANLkTilwlZKx0k-Z_6LHVXIM561JLcWV4mX4Wcwgb7r0@mail.gmail.com>
	<1274804315.5882.1821.camel@twins>
Date: Tue, 25 May 2010 18:20:15 +0200
Message-ID: <AANLkTiluTGxqQN4OU9ETAjb1SUD4ry-pewAtuzE1r54U@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by 
	transactional API (take 2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, ming.m.lin@intel.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 6:18 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-05-25 at 18:10 +0200, Stephane Eranian wrote:
>> > Index: linux-2.6/kernel/perf_event.c
>> > ===================================================================
>> > --- linux-2.6.orig/kernel/perf_event.c
>> > +++ linux-2.6/kernel/perf_event.c
>> > @@ -668,15 +668,9 @@ group_sched_in(struct perf_event *group_
>> >                }
>> >        }
>> >
>> > -       if (!txn)
>> > +       if (!txn || !pmu->commit_txn(pmu))
>> >                return 0;
>> >
>> > -       ret = pmu->commit_txn(pmu);
>> > -       if (!ret) {
>> > -               pmu->cancel_txn(pmu);
>> > -               return 0;
>> > -       }
>> > -
>> >  group_error:
>> >        /*
>> >         * Groups can be scheduled in as one unit only, so undo any
>> >
>> Looks okay.
>>
>> I believe you can also drop the txn test in group_sched_in() after group_error:,
>> given you have the if !(txn) return 0.
>
> Can't we still get in the group_error: branch with either scenario?
>
You're right. We must keep it because of failure in the siblings' loop.
