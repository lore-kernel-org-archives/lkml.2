Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab1LFQOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:14:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61014 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1LFQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <4EDDCD6D.1010907@jp.fujitsu.com>
References: <20111123144417.2da5958c@jbarnes-desktop> <CA+55aFyaiJBYmgVCLfPA7q3hqtPHYh9wwsmVTCewbBoxMsDE8A@mail.gmail.com>
 <20111205112256.68e59434@jbarnes-desktop> <4EDDCD6D.1010907@jp.fujitsu.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 08:14:17 -0800
X-Google-Sender-Auth: wXnCp5szptyZq7dzqNprYjcFcqA
Message-ID: <CA+55aFwuZxGZhXyhj+cb5WLnFPDh45Dy6BwgmvEQKAM5swaM6w@mail.gmail.com>
Subject: Re: [git pull] PCI fixes
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 12:08 AM, Kenji Kaneshige
<kaneshige.kenji@jp.fujitsu.com> wrote:
>
> In the past, pciehp waits 100 ms instead of 1 sec after checking the link
> state. This 100 ms was based on PCIe spec.

I would like to point out that these kinds of delays are *really*
annoying to users. And they add up.

One second per se is not a huge problem, but imagine that you're
hotplugging some regular user device (think thunderbolt or something
that we'd expect normal users to see). First one second for the kernel
to even see it, then some random udev rules, then some disk spinup
times or whatever, and soon a few delays here and a few delays there,
and it takes say three seconds for the folder to show up on the
desktop (or whatever acknowledgement of "yes, I see your device now").

That's a *long* time, and it's irritating to the user. It makes the
user think "the machine is slow".

We used to have this exact problem with USB hotplugging with slow
devices, so I know. It's still not necessarily immediate, but it's
better than it has been.

One second *total* is what people will consider pretty much immediate.
Any more than that is "thumb twiddling time".

And quite frankly, an unconditional one-second delay here seems bad.
Two seconds was unacceptable, one second is just bad.

>                                                              This is
> based on the PCIe description "software must allow 1 second after the Data
> Link Layer Link Active bit reads 1b before it is permitted to determine
> that a hot plugged device which fails to return a Successful Completion for
> a Valid Configuration Request is a broken device".

Quite frankly, the way that reads to me says "you must wait at most 1s
before you consider a device broken".

But a *successful* read of the LT bit should abort the wait early. So
that good devices that aren't broken can complete setup much faster.

Please try to make something like that work. Instead of always waiting
for one second, wait for up to one second only for failure cases. Any
possibility of that?

Clearly most devices are perfectly fine almost immediately. It's sad
to wait for good devices for no good reason.

                       Linus
