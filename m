Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab2JDCkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:40:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58809 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2JDCkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:40:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk> <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
 <20121003195059.GA13541@kroah.com> <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
 <3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com> <CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 4 Oct 2012 04:39:57 +0200
Message-ID: <CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Walls <awalls@md.metrocast.net>, Greg KH <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 12:58 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> That said, there's clearly enough variation here that I think that for
> now I won't take the step to disable the udev part. I'll do the patch
> to support "direct filesystem firmware loading" using the udev default
> paths, and that hopefully fixes the particular case people see with
> media modules.

If that approach looks like it works out, please aim for full
in-kernel-*only* support. I would absolutely like to get udev entirely
out of the sick game of firmware loading here. I would welcome if we
are not falling back to the blocking timeouted behaviour again.

The whole story would be contained entirely in the kernel, and we get
rid of the rather fragile "userspace transaction" to execute
module_init(), where the kernel has no idea if userspace is even up to
ever responding to its requests.

There would be no coordination with userspace tools needed, which
sounds like a better fit in the way we develop things with the loosely
coupled kernel <-> udev requirements.

If that works out, it would a bit like devtmpfs which turned out to be
very simple, reliable and absolutely the right thing we could do to
primarily mange /dev content.

The whole dance with the fake firmware struct device, which has a 60
second timeout to wait for userspace, is a long story of weird
failures at various aspects.

It would not only solve the unfortunate modprobe lockup with
init=/bin/sh we see here, also big servers with an insane amount of
devices happen to run into the 60 sec timeout, because udev, which
runs with 4000-8000 threads in parallel handling things like 30.000
disks is not scheduled in time to fulfill network card firmware
requests. It would be nice if we don't have that arbitrary timeout at
all.

Having any timeout at all to answer the simple question if a file
stored in the rootfs exists, should be a hint that there is something
really wrong with the model that stuff is done.

Thanks,
Kay
