Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410Ab2JCRY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:24:57 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56057 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965396Ab2JCRYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:24:55 -0400
MIME-Version: 1.0
In-Reply-To: <20121003165726.GA24577@kroah.com>
References: <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi>
 <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <CAPXgP11UQUHyCAo=GbAigQMqKWta12L19EsVaocU0ia6JKmd1Q@mail.gmail.com>
 <20121003165726.GA24577@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 3 Oct 2012 19:24:34 +0200
Message-ID: <CAPXgP120SFAV4ZF_fYC3EdW0P6ZfaHFuLFFeNArgM5C9K7WXqA@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Tom Gundersen <tomegun@archlinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 6:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

>> It's the same in the current release, we still haven't wrapped our
>> head around how to fix it/work around it.
>
> Ick, as this is breaking people's previously-working machines, shouldn't
> this be resolved quickly?

Nothing really "breaks", It's "slow" and it will surely be fixed when
we know what's the right fix, which we haven't sorted out at this
moment.

> module_init() can do lots of "bad" things, sleeping, asking for
> firmware, and lots of other things.  To have userspace block because of
> this doesn't seem very wise.

Not saying that it is right or nice, but it's the kernel itself that
blocks. Run init=/bin/sh and do a modprobe of one of these drivers and
it hangs un-interruptible until the kernel's internal firmware loading
request times out, just because userspace is not there.

> But previously this all "just worked" as we ran 'modprobe' in a new
> thread/process right?

No, we used to un-queue events which had a timeout specified in the
environment, that code caused other issues and was removed.

> it can do without worrying about stopping anything else in the system that might
> want to happen at the same time (like load multiple modules in a row).

It should not be an issue, the serialization is strictly parent <->
child, everything else runs in parallel.

>> If that unfortunate module_init() lockup can't be solved properly in
>> the kernel, we need to find out if we need to make the modprobe
>> handling in udev async, or let firmware events bypass dependency
>> resolving. As mentioned, we haven't decided as of now which road to
>> take here.
>
> It's not a lockup, there have never been rules about what a driver could
> and could not do in its module_init() function.  Sure, there are some
> not-nice drivers out there, but don't halt the whole system just because
> of them.

It is a kind of lock up, just try modprobe with the init=/bin/sh boot.

> I recommend making module loading async, like it used to be, and then
> all should be fine, right?

That's the current idea, and Tom is looking into it how it could look like.

I also have no issues at all if the kernel does load the firmware from
the filesystem on its own; it sounds like the simplest and most robust
solution from a general look at the problem. It would also make the
difference between in-kernel firmware and out-of-kernel firmware less
visible, which sounds good.
Honestly, requiring firmware-loading userspace-transactions to
successfully link a module into the kernel sounds like a pretty bad
idea to start with. Unlike module loading which needs the depmod alias
database and userspace configuration; with firmware loading, there is
no policy involved where userspace would add any single additional
value to that step.

Thanks,
Kay
