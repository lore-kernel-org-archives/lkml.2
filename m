Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2GURbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 13:31:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37104 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2GURbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 13:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Jul 2012 10:31:17 -0700
X-Google-Sender-Auth: nmEpbpzz_EypuJUczZCQzkCwC38
Message-ID: <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 5:33 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> The RFC patch is just for discussing if the idea of deferring
> request_firmware is doable for addressing the issue of
> request_firmware in resume path, which is caused by driver
> unbind/rebind during resume.

NAK.

It really *has* to be handled some other way.

This whole approach seems to actively try to *silently* fix up broken
drivers. And it's wrong.

There's a reason we warn, and there's a reason we *have* to warn: to
let driver writers know that what they are attempting to do MAY NOT
WORK.

Really.

Sure, for a lot of devices it's fine to load the firmware later. But
some devices may be part of the resume sequence in very critical ways,
and deferring the firmware loading will just mean that the resume will
fail.

This we *need* the WARN_ON() - so that even in the case where it
happens to work, people are very much told that "sure, your
suspend/resume may have worked, but it was doing fundamentally wrong
things that may mean that for other people it *won't* work".

For example, maybe it's a USB network dongle, and for *YOU* it is
perfectly fine to defer the firmware loading, so that the network
comes back up a few seconds after the system is up and running.

But in another machine, that exact same USB network dongle may
actually be hardwired on the motherboard (it's fairly common to use
USB as a "system bus" in some laptop and embedded devices), and maybe
that other machine actually is a thin client that has some tiny rdinit
thing, and then everything else is NFS-mounted, and if you resume
without networking, the machine is simply *dead*.

Ok, so that was a completely made-up example, but we have actually had
situations kind of like that, where a device is just not that
important for lots of people, but in other situations it's critical
for the rest of the suspend/resume to succeed.

This is why I'm so vehemently against silently "hiding" these issues.

If you have a driver that has problems, make THAT ONE PARTICULAR
driver do the deferral explicitly. Don't make some generic "silently
defer if there are problems" patch.

See what I'm saying? You're solving things in exactly the wrong place,
and in exactly the wrong way. You're papering things over, and making
the generic code silently just make broken cases work. That's really
really bad, because it makes it *easier* for driver writers to do the
wrong thing without even thinking about it, and without ever seeing
the problem. And then when people say "suspend/resume doesn't work",
the driver author says "it works for me" and ignores the problem.
Because you've systemically made it easy to ignore the problem, and
made it easy to do the wrong thing by default.

So we should make driver writers do the right thing by default, and if
they cannot do the right thing (and the "isight" camera always comes
up, and f*ck it, just fix that driver) then they should do extra work.

Seriously. People should load their firmware *before* the
suspend/resume cycle. And if that isn't possible, then the system
should ABSOLUTELY NOT silently say "whatever" and defer it until
later.  We should have that big failure and the big noisy warning, and
drivers that need to defer need to do so themselves, so that we never
*ever* have that silent automatic defer situation.

                          Linus
