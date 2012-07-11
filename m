Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab2GKPPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:15:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63678 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748Ab2GKPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:15:11 -0400
MIME-Version: 1.0
In-Reply-To: <1342018897.13724.61.camel@joe2Laptop>
References: <1342002808.810.12.camel@mop> <1342018897.13724.61.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 11 Jul 2012 17:14:49 +0200
Message-ID: <CAPXgP11XnrFayb-g5HFu3wPtw8=xLfSY7HNCCbiSoehj8KsGcw@mail.gmail.com>
Subject: Re: pr_cat() + CATSTR(name, size)?
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 5:01 PM, Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-07-11 at 12:33 +0200, Kay Sievers wrote:
> Interesting idea, perhaps workable, but it has
> a few defects I can see.
>
> It works for most uses, but it doesn't work for
> when there are multiple function sites like
>
> void dump_info(struct foo *bar)
> {
>         if (bar->baz)
>                 pr_cont("baz...");
> }
>
> ---
>
>         pr_info("Some initiator: ")
>         dump_info(&descriptor);

Yeah, it's just the common case, not for the "creative" ones. :)

> Another negative is that is uses a local stack
> variable for the entire line which increases
> stack pressure.

The thing is to avoid malloc(), and ~100 bytes are kind of OK for the
time we do the printk, I guess

> It also fails to immediately output after some
> defect unlike your change to output directly to
> console.

Which is really only that important for stuff that causes crashes
between the outputting fragments.

There are _many_ cases the console lock is held, and we don't print
stuff immediately out to the console, and we never ensured that in the
past. There was never a guarantee that stuff ended up on the console,
kmsg was always and needs to be a store+forward model.

> It would require all sites with continuation lines
> be modified.  Because it requires in-situ code
> modifications, I'd prefer a cookie based approach.

Well, it would be mostly for the dev_printk() stuff, which should
ideally never be merged with stuff that could go wrong.

> I think it's more flexible, allows the cookie to be
> passed into extending functions and doesn't demand
> (much) extra stack.
>
> Something like:
> https://lkml.org/lkml/2012/4/3/231
> https://lkml.org/lkml/2011/11/14/349

Hmm, how do we manage memory allocations here? We can get around that
somehow? It's something the common printk() must really avoid.

Kay
