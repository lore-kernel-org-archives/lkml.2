Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946198Ab2CQAeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:34:10 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37131 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031537Ab2CQAeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 20:34:08 -0400
MIME-Version: 1.0
In-Reply-To: <201203170123.10599.rjw@sisk.pl>
References: <201203032122.36745.chunkeey@googlemail.com> <201203162357.10770.rjw@sisk.pl>
 <CA+55aFwTZjLHvZLBuNG-aO-+ex_yTYfaqOGqQ+6Krx9Z7EUNQQ@mail.gmail.com> <201203170123.10599.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2012 17:33:45 -0700
X-Google-Sender-Auth: o-wjCDgYhzNxaTECnYNeSn9Pl_A
Message-ID: <CA+55aFxiJABjKJz4J6Dwk8Jy4=Vds2P15XTVtX8_j6TDkTwXEg@mail.gmail.com>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is
 not yet available
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 5:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> OK, but that asynchronous thread needs to know whether or not the system is up.

Sure.

> It can use the usermodehelper_is_disabled() check, but that needs to be done
> under read_lock_usermodehelper() and it can't release the lock before
> calling _request_firmware(), or all that thing would be racy.

Well, I think that it would actually be a good idea to perhaps split
up that existing _request_firmware() a bit. In fact, it might be good
to split up that whole "fw_create_instance()" too - and re-organize
the code a bit so that you end up creating the "firmware_priv" thing
first.

So maybe we could have a helper function that does that first part of
fw_create_instance() (the part that allocates it and does the
__module_get() part and other really basic initialization), and that
can be called unconditionally by the request_firmware_nowait() code
early.

That early part probably should *not* create the device attribute
files etc (although who knows - maybe sysfs is ok at this point).

So I think we really could re-organize the code to do a sane job - and
move just the actual udev setup etc to the final part that needs to be
delayed.

Hmm?

I haven't looked very deeply into it, but my *gut* feel is that it
should be doable pretty cleanly.

But yeah, it would be more than a little one-liner. I think it might
be worth it, though. Clearly separating out the three stages: "setup"
-> "wait for system to be ready" -> "do the actual load".

Then, the regular request_firmware() function would do exactly the
same things, except it would never do the "wait for system to be
ready" part: it would just fail with the warning if it wasn't already
ready. So they'd still share all the basic core code, it would just be
a slightly different organization from what it is now.

                 Linus
