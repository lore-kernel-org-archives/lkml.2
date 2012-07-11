Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2GKPsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:48:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36527 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab2GKPsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <1342020647.13724.71.camel@joe2Laptop>
References: <1342002808.810.12.camel@mop> <1342018897.13724.61.camel@joe2Laptop>
 <CAPXgP11XnrFayb-g5HFu3wPtw8=xLfSY7HNCCbiSoehj8KsGcw@mail.gmail.com> <1342020647.13724.71.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 11 Jul 2012 17:48:21 +0200
Message-ID: <CAPXgP13ff+eFH_jJ+0FDX0-GkuZj3RSv7VCp3ftcsGzA412FVQ@mail.gmail.com>
Subject: Re: pr_cat() + CATSTR(name, size)?
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 5:30 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-07-11 at 17:14 +0200, Kay Sievers wrote:
>> On Wed, Jul 11, 2012 at 5:01 PM, Joe Perches <joe@perches.com> wrote:
> []
>> There are _many_ cases the console lock is held, and we don't print
>> stuff immediately out to the console, and we never ensured that in the
>> past. There was never a guarantee that stuff ended up on the console,
>> kmsg was always and needs to be a store+forward model.
>
> I'm less concerned with kmsg than you.
> I think it's more a nicety than anything.

Sure, just saying, that there is never a guarantee that stuff lands
directly on the console  at print time, we never had that. It just
usually gets there directly. There is trylock(console_sem), if we can
not get that, we always leave the data in the buffer and let someone
else push it with the next unlock, and that can be later. That
behaviour was always the case.

>> > It would require all sites with continuation lines
>> > be modified.  Because it requires in-situ code
>> > modifications, I'd prefer a cookie based approach.
>>
>> Well, it would be mostly for the dev_printk() stuff, which should
>> ideally never be merged with stuff that could go wrong.
>
> Perhaps that's ideal, but not practical.
> printk continuations are more prevalent.

We can't have everything. We can not merge the data at least, for
integrity reasons. We can only make it *look* like it belonged
together, like we do when we run into a race or the console is locked
and we can not merge continuation fragments into one record.

>> > I think it's more flexible, allows the cookie to be
>> > passed into extending functions and doesn't demand
>> > (much) extra stack.
>> >
>> > Something like:
>> > https://lkml.org/lkml/2012/4/3/231
>> > https://lkml.org/lkml/2011/11/14/349
>>
>> Hmm, how do we manage memory allocations here? We can get around that
>> somehow? It's something the common printk() must really avoid.
>
> Well, I think the malloc costs are pretty low
> and could devolve pretty easily when OOM.

We need to avoid allocating memory in situations where we want to
printk(), it's just not possible. That's why all the kmsg/printk can
not really do any plain malloc. All printk memory needs to be static,
on the stack or somehow pre-allocated.

> Anyway, interesting idea, keep at it, see what
> comes out of it.

Just depends on us, I guess. :)

Thanks,
Kay
