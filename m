Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1LaTaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 14:30:20 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1LaTaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 14:30:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111231150133.280130@gmx.net>
References: <20111231150133.280130@gmx.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Dec 2011 11:29:56 -0800
X-Google-Sender-Auth: 8ZKZmGBQ0KelRT9tOV4Wf6EKHGo
Message-ID: <CA+55aFyFuKVgzuOuszb+UyCh98R2TZ_QiS0TCWJjJX5zEwLSWw@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: drahemmaps@gmx.net
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, mjg@redhat.com,
        gregkh@suse.de, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 31, 2011 at 7:01 AM,  <drahemmaps@gmx.net> wrote:
>>
>> So it's very simple: drivers that load firmware at resume time are
>> buggy. No ifs, buts, or maybes about it.
>
> Or are they?

Yes they are.

> You see, PCMCIA cards [don't know about the pccard express stuff]
> have to deal with a notable exception from this rule since:
>
> pcmcia: improve check for same card in slot after resume
> "88b060d6c03fcb9e4d2018b4349954c4242a5c7f"
>
> This patch changed the way how suspend/resume is handled.

Yes, that's problematic. As is the USB thing making resume a probe event too.

But it doesn't change the fact that if a driver needs to load the
firmware at such an event, then the driver is buggy. The reason really
is very very simple: there is no guarantee at all that the backing
store for the firmware has been resumed first!

It really is that simple.

And as mentioned, I do agree that the underlying *cause* for all these
bugs is that our firmware loading helper routines are totally full of
sh*t. The whole "request_firmware()" logic makes it very very easy for
drivers to get this wrong, and then some bus interfaces (pcmcia and
usb) make it almost impossible for drivers to do it right by turning
"suspend/resume" into "detach/probe".

But what the driver *should* be doing is to load the firmware at
device open time (NOT at "driver load time" - because that can and
does happen too early too, for the case of built-in drivers!) and
simply keep the firmware around in the case of a suspend/resume event,
so that it doesn't have to re-load it off a disk (or network, or
whatever) that hasn't been resumed yet!

And this really does solve all problems.

There are drivers that do this right, so it's not impossible. For a
network driver, for example, you should load the firmware into memory
when the device is opened the first time, and you should unload it
only when the device is downed. If you follow those fairly simple
rules, you're all good - at a resume event you either do nothing at
all about the firmware (network device not up) or you have the
firmware in memory and can just re-load it onto the card.

For an example of this, look at

    drivers/net/ethernet/realtek/r8169.c

and its explicit caching of firmware (see "rtl_request_firmware()" and
the whole "rtl_fw" handling), which actually makes it fairly easy for
the rest of the driver to do things right.

However, I really do think that it's

 (a) very error-prone

 (b) complexity all over

for drivers to have to know to do this on their own. So we have a
*few* drivers that do this correctly (after having done it wrong, and
then fixing it), but most drivers don't. And I really think that the
request_firmware() interface is the problem: the firmware layer should
be doing this kind of caching for the drivers, so that drivers
wouldn't *have* to.

For example, if somebody builds a kernel that doesn't support suspend
or hibernation, then the caching is pointless, so a really *good*
caching model would take that into account and just say "I won't waste
memory on that case". But duplicating that kind of logic for every
driver that needs firmware is just totally crazy. But if we had a good
interface to request_firmware(), we might be able to do that kind of
thing automatically.

                           Linus
