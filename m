Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab2IEPW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:22:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2IEPW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
References: <s5hd3222azc.wl%tiwai@suse.de>
	<CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	<s5hd32122hw.wl%tiwai@suse.de>
	<CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	<s5hpq61j9qx.wl%tiwai@suse.de>
	<CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
	<20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
Date: Wed, 5 Sep 2012 23:22:55 +0800
Message-ID: <CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
Subject: Re: A workaround for request_firmware() stuck in module_init
From: Ming Lei <ming.lei@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 9:03 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> If the driver is built in kernel, the request_firmware in .probe() may
>> prolong kernel init, and it might be a problem. But looks it is not a
>> big deal since most of drivers are built as module.
>
> Doing it by deferring the load also fixes that. The built in ones will
> defer their final probe until the firmware appears and all will be well.

Yes, deferring the load may fix the built in case, but which also
introduces much work on changes of current drivers. In fact,
there are few guys who complained the built in case.

The current complaint is from that udev may timeout request inside probe()
when drivers are built as module. As pointed by Linus and Benjamin,
it is better to fix it in udev, and looks not good to introduce great changes
(such as Takashi's defer probe patch) in kernel to workaround the problem.

>
> If your rootfs needs firmware not in your initrd you already broke it and
> there is a certain level beyond which you just have to give up trying to
> save people from themselves.
>
> It may actually make sense to push more of it into the core driver layer
> and take some of the ability to make mistakes away from driver authors.
> For the general case of "load firmware if we see one" there isn't really
> any reason we can't have a firmware_name entry in the probe table
> entries themselves. If that was present the core bus probe would kick a

Linus has said that he doesn't like to load firmware in probe(), but in some
situation the drivers have to load firmware in its probe():

        http://marc.info/?l=linux-kernel&m=134592122811866&w=2

In fact, it is better for drivers to load firmware just when user wants to use
the device, and some drivers have already changed to load firmware in
the open() callback.

So looks loading firmware always before probe in driver core is
against the above idea.

> firmware load off and only when the firmware had loaded would it call
> ->probe with dev->firmware pointing at a refcounted firmware struct.

IMO, introduce refcount for the firmware doesn't make sense. The lifetime
of firmware is completely different with lifetime of driver or device:

    - firmware needn't be kept in memory in the device/driver's lifetime, and
      should be loaded just in need, and be released after downloading
      it into device.

   - sometimes devices may disappear, but it is better to keep the
     firmware in memory, for example, device may be disconnected
     during resume but will come back later.

>
> At that point it should be much faster to fix existing drivers and much
> harder for a random device driver to get it wrong. We can even add
> helpers which manage dev->firmware, and free the relevant objects when
> needed, plus doing automatic ref/deref on probe/remove so that for a

As said above, ref/deref on probe/remove is not a good idea since
we needn't to keep the firmware in memory during the whole device/driver
lifetime.

Thanks,
--
Ming Lei
