Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0EYNjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:39:52 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:52409 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab0EYNju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=s9JyFqT75mjQabrjgTyXO53q/yykUQi/Cpll4pI8mO9d/K0ZFGpeQRUjWBM++4y+d9
         ALJ88aCpyQ9O4st3HVtPxJhQgXg1wB+gAlX7CuNYhR7fPUy0mOdNAKBO+HJqRtyVSf00
         zTTZgxivsFH7F1U+FTl5FKM592u50ozE7Epc0=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1274794518.5882.1280.camel@twins>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	 <1274794518.5882.1280.camel@twins>
Date: Tue, 25 May 2010 15:39:48 +0200
Message-ID: <AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by 
	transactional API (take 2)
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       acme@infradead.org, ming.m.lin@intel.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 3:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-05-25 at 15:20 +0200, Stephane Eranian wrote:
>
>> With this patch, you can now overcommit the PMU even with pinned
>> system-wide events present and still get valid counts.
>
> Does this patch differ from the one you send earlier?
>
Yes, it does. It changes the way n_added is updated.

The first version was buggy (perf top would crash the machine).
You cannot delay updating n_added until commit, because there
are paths where you don't go through transactions. This version
instead keeps the number of events last added and speculatively
updates n_added (assuming success). If the transaction succeeds,
then no correction is done (subtracting 0), if it fails, then the number
of events just added to n_added is subtracted.
