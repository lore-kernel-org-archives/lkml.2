Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2JCOhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:37:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61557 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab2JCOhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <20121002221239.GA30990@kroah.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <20121002221239.GA30990@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 3 Oct 2012 16:36:53 +0200
Message-ID: <CAPXgP11UQUHyCAo=GbAigQMqKWta12L19EsVaocU0ia6JKmd1Q@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 12:12 AM, Greg KH <gregkh@linuxfoundation.org> wrote:

> Mauro, what version of udev are you using that is still showing this
> issue?
>
> Kay, didn't you resolve this already?  If not, what was the reason why?

It's the same in the current release, we still haven't wrapped our
head around how to fix it/work around it.

Unlike what the heated and pretty uncivilized and rude emails here
claim, udev does not dead-lock or "break" things, it's just "slow".
The modprobe event handling runs into a ~30 second event timeout.
Everything is still fully functional though, there's only this delay.

Udev ensures full dependency resolution between parent and child
events. Parent events have to finish the event handling and have to
return, before child event handlers are started. We need to ensure
such things so that (among other things) disk events have finished
their operations before the partition events are started, so they can
rely and access their fully set up parent devices.

What happens here is that the module_init() call blocks in a userspace
transaction, creating a child event that is not started until the
parent event has finished. The event handler for modprobe times out
then the child event loads the firmware.

Having kernel module relying on a running and fully functional
userspace to return from module_init() is surely a broken driver
model, at least it's not how things should work. If userspace does not
respond to firmware requests, module_init() locks up until the
firmware timeout happens.

This all is not so much about how probe() should behave, it's about a
fragile dependency on a specific userspace transaction to link a
loadable module into the kernel. Drivers should avoid such loops for
many reasons. Also, it's unclear in many cases how such a model should
work at all if the module is compiled in and initialized when no
userspace is running.

If that unfortunate module_init() lockup can't be solved properly in
the kernel, we need to find out if we need to make the modprobe
handling in udev async, or let firmware events bypass dependency
resolving. As mentioned, we haven't decided as of now which road to
take here.

Thanks,
Kay
