Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1LaU1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 15:27:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58809 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1LaU1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 15:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <20111231201538.GA29758@srcf.ucam.org>
References: <20111231150133.280130@gmx.net> <CA+55aFyFuKVgzuOuszb+UyCh98R2TZ_QiS0TCWJjJX5zEwLSWw@mail.gmail.com>
 <20111231201538.GA29758@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Dec 2011 12:26:57 -0800
X-Google-Sender-Auth: EpIl0sasiLf3EgWaABAeF_NoGGE
Message-ID: <CA+55aFya-rZkH0OvtxKEyS8+YyFq9tv1x=yNVnwb1MW8SjW91A@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Matthew Garrett <mjg@redhat.com>
Cc: drahemmaps@gmx.net, davej@redhat.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 31, 2011 at 12:15 PM, Matthew Garrett <mjg@redhat.com> wrote:
> On Sat, Dec 31, 2011 at 11:29:56AM -0800, Linus Torvalds wrote:
>
>> But what the driver *should* be doing is to load the firmware at
>> device open time (NOT at "driver load time" - because that can and
>> does happen too early too, for the case of built-in drivers!) and
>> simply keep the firmware around in the case of a suspend/resume event,
>> so that it doesn't have to re-load it off a disk (or network, or
>> whatever) that hasn't been resumed yet!
>
> That doesn't work for the isight firmware loader - there's nothing for
> userspace to open until the device has had the firmware loaded, at which
> point it detaches and reattaches as a UVC device. The code could be
> merged into the UVC driver and a fake v4l device exposed, but even then
> you'd still need to deal with the underlying usb_device suddenly
> changing under you.

Well, what you *could* do is to simply say: this driver has to be a
module, and cannot be built-in. Or, if built-in, the firmware has to
be built-in too (but there are probably licensing issues with that).

At that point, you can load the firmware when you load the isight
driver, since hopefully by then you have a real filesystem (not just
initrd or something - although you could obviously put the firmware in
the initrd image too).

And then, you just keep the firmware in memory as long as the module
is loaded. It's not as good as loading at open time, but at least for
the suspend/resume case it's better than trying to load it at resume
time when it fundamentally cannot work.

> So for this specific case, I'd like to track down why the behaviour has
> changed

That driver isn't all that recent, it may be that what changed is that
you just used to rely on the disk being woken up before the isight
device was, and things just magically happened to work.

We explicitly disallowed the "magically happened to work" case because
it was so often not true, and when it wasn't true, it resulted in
60-second timeouts (or whatever the "failed to load" timeout was) and
non-working devices. So the warning and the failure is actually "new"
(well, by now it's been a year or so), to make developers who write
drivers *see* the failure instead of having a "it works on my
particular hardware and filesystem layout" model.

                           Linus
