Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab2ALGqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:46:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60412 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2ALGqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:46:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120109080806.GH22134@opensource.wolfsonmicro.com>
References: <20120109112113.07882ed9@notabene.brown> <20120109040802.GG29065@opensource.wolfsonmicro.com>
 <20120109161058.6834da0d@notabene.brown> <20120109062231.GM29065@opensource.wolfsonmicro.com>
 <20120109182800.3086fd84@notabene.brown> <20120109080806.GH22134@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Jan 2012 23:45:46 -0700
X-Google-Sender-Auth: 43i1nIZVUmLnE0YR123ielM5HlI
Message-ID: <CACxGe6t=57asGHjFVj_D-+jg6LieqXn634=UajH7o6wwSp4o3A@mail.gmail.com>
Subject: Re: [RFC/PATCH] Multithread initcalls to auto-resolve ordering issues.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: NeilBrown <neilb@suse.de>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 1:08 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jan 09, 2012 at 06:28:00PM +1100, NeilBrown wrote:
>> On Sun, 8 Jan 2012 22:22:31 -0800 Mark Brown
>> > On Mon, Jan 09, 2012 at 04:10:58PM +1100, NeilBrown wrote:
>
>> > So, my general inclination is that given the choice between parallel and
>> > serial solutions I'll prefer the serial solution on the basis that it's
>> > most likely going to be easier to think about and less prone to getting
>> > messed up.
>
>> Surely anyone doing kernel work needs to be able to understand parallel
>> solutions at least enough to place locks in appropriate places ???
>
> You'd expect people to be able to work it out but there's no sense in
> doing something hard if something easy works just as well - concurrency
> can bring problems with things like reproducibility which make life
> harder than it might otherwise be.

+1

>> I thought about doing a serial retry solution the error from the ->probe
>> function doesn't percolate all the way up the the initcall.
>> In particular, when a driver is registered driver_attach is called for each
>> unattached device on the bus.  This is done in __driver_attach which discard
>> the error return from driver_probe_device().
>
> There's code for doing the retries floating around, Grant Likely was
> working on it initially then someone from Linaro picked it up and I'm
> not sure what happened.

I'm going to pick up the patch again next week and get it ready for
possible 3.4 merging.  I've gotten a lot of requests to get this work
finished.  The latest posted version of the patch can be found here[1]
and the lwn article is here[2]:

[1]https://lkml.org/lkml/2011/10/7/17
[2]http://lwn.net/Articles/450460/

I (obviously) prefer the deferred probe approach over using threaded
initcalls.  I originally did look at doing exactly what is proposed
here, but I didn't like that it required each subsystem to be
explicitly modified to provide blocking request calls, and I also
discovered that it's been tried and failed several times before.  It
appears that there are a lot of undeclared dependencies and
concurrency issues between device drivers that are pretty much
impossible to track down.

I like the deferred probe approach because it is conceptually simple,
it is minimally invasive, and it works for all subsystems without
needing to implement blocking infrastructure.

As far as the device tree aspects go, it is true that whether or not a
resource will exist is described by device tree data.  However, the
best place to interpret that data is not with the resource provider
driver, but with the resource consumer because the consumer's driver
understands how resources are bound for that specific device. (a
provider node generally doesn't have any information about or way to
determine which consumer nodes will be using it).

[...]
>> Is single-threading really worth all the churn deep inside the drivers/base
>> code that is would probably require?
>
> I don't see why it'd require much churn to be honest - the patches that
> I looked at weren't that invasive, basically just shove devices that
> fail with a particular code into a retry list and iterate through it
> whenever it seems useful to do so.

There is very little churn.  The driver model already did /almost/
everything that was needed.  I pretty much just needed to add the list
and an iterator for it.

g.
