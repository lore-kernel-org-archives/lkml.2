Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab1K3C7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:59:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1K3C7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:59:13 -0500
Date: Wed, 30 Nov 2011 13:58:47 +1100
From: NeilBrown <neilb@suse.de>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        Arve =?ISO-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111130135847.68a6e4c6@notabene.brown>
In-Reply-To: <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nwi=tEZawfgP/_CF40.agwt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nwi=tEZawfgP/_CF40.agwt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Nov 2011 18:11:02 +0900 MyungJoo Ham <myungjoo.ham@gmail.com>
wrote:

> 3. Allow the notifiee device drivers to register its specific
> interest. The interface would look like:
> int switch_register_interest(struct switch_dev *sdev, const char
> *cable_name, struct notifier_block *b);
> (the rationale is that the notifiee device does not need to know the
> detail about the switch dev configuration but for the name of the
> switch dev or notifier).
> or even
> int switch_register_interest(const char *switch_name, const char
> *cable_name, struct notifier_block *b);
> and allow notifee to forget about the sdev pointer as well. (and all
> the other APIs are for implementing notifier, not notifiee)

I'm surprised to find "cable_name" in there.  It is saying that multi-switch
is always used for cable-plug events.  If that is the case, then maybe the
name "multiswitch" is too generic.  Maybe this is a "cabledetect" function??

I'm wondering if a switch should be something much simpler - not even a
'device' necessarily.  Maybe it is more like a resource, like gpio or irq or
pwm or region or clock or ...

So each switch on a given board is identified by a number and any code that
wants to know about switch events needs to be given the magic number somehow
(in platform_data?) and does
  request_switch(switch_number)
  switch_register_interest(switch_number, notifier_block)

I don't know exactly how your "cable_name" would fit.  Does that just
identify the particular value that the switch has?  In that case
switch_callback could have an optional 'value' so the call back only happens
when the switch is set to that value (or set from that value).

If you need to make it appear in sysfs, write "switch_export" based on
"gpio_export".
If you want the switch to generate input events, write switch_keys based on
gpio_keys.

I guess my point is that a "switch" - even a "multiswitch" - is an extremely
generic concept and imposing too much semantics on all switches would be a
mistake.



On reflection... I think you said that a switch could have a bit-map of up =
to
32 bits with each bit representing a different cable type, and multiple
cables can be plugged in at the same time - is that correct?
If so, then why not just have multiple switches, one for each cable type.
The thing that detects the cables could then register a "switchchip" (like
gpiochip) that supports a number of switches all handled by the same code. =
 A
client would just register_interest with the individual switches that it
cares about - i.e. the individual cable(s).

Though I might have misunderstood something.

NeilBrown

--Sig_/nwi=tEZawfgP/_CF40.agwt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTtWb7Tnsnt1WYoG5AQJnnA//bVWw6LjrLFKMxB3B+PPcqyphvqoY6JO5
VqZ3ZbER9x42kBacf/CaqUMcxUdm2PyQggEFzYFUtJZsY4GTDGop/wkOnxLg04e/
fTjIFlkSPdGB2Chl71Cw9R2rCTWnSQBqK/xkpuQbNMt3HvQ6ezbb/9fTkJJqth5p
/ujd6fqm4hHomitM8No7ZKf5NHLwuIJbcymi2X1E7/CDrQFEpyi4U7MRwS03Gy4Y
XzNM2+SO+Wl85368mfNgOqN0BP2e+HMTMSjBZr5L/KwGc/YYSFJJw8fOmWsP8oaO
2fnzgSdwlbFgHLsZYmfVFg/eEczSBCG8sTOnkZl3aGl5tgoEKyM7s/wj/QBFdHiM
Pb/YzQd324AxY5V49fqpJx21EdIxXvdr6VLuxP02KefQvD81pUoQRlrgMm/lq9mq
RSYDTCUxA+7phBpbL5Z/oiPgmQvknwobKAQwfj+3REajv7x5eMPfUeRhBqviEWhW
HBqhIAF0nGuMhW0qXInau5Ntj8lpJDUBTZtaXKt31B0Y5dlfvEPET146K+0RZx3l
x/gJqGTjvdqTTuS1oyr3EX4j3DMQXL/zMxWUZ/R+TF60q9CRbFJMlqYbmOicr+ZU
hIKMKioSFNQFjhXtjyjaJDo7Bz5wjUl7PCPdW3DQDng5Ylwu0VKYn48kJGokAjx0
ntfF8UlBeCg=
=tTik
-----END PGP SIGNATURE-----

--Sig_/nwi=tEZawfgP/_CF40.agwt--
