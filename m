Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572Ab2FVHxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:53:03 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:20075 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761557Ab2FVHxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:53:00 -0400
Date: Fri, 22 Jun 2012 09:53:12 +0200
From: David Jander <david.jander@protonic.nl>
To: =?UTF-8?B?SmVhbi1GcmFuw6dvaXM=?= Dagenais 
	<jeff.dagenais@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: gpio: pca953x: interrupt feature unreliable
Message-ID: <20120622095312.6fda6ae1@archvile>
In-Reply-To: <D58154AE-36F8-45BD-BBB3-CF1AC3F4E610@gmail.com>
References: <8495990E-0B78-4B47-A00D-36D45DC3450F@gmail.com>
	<CACRpkdZZmxqus6jujtq43qD_d_dHxi2wORmC18kGsD3aB1jjAQ@mail.gmail.com>
	<20120604091127.0f95a85c@archvile>
	<73B37CBF-9E2A-49F5-9CA9-8CFBEF3666D6@gmail.com>
	<20120620170126.311b8eef@archvile>
	<9C01B236-B051-40D2-9805-F8B8F308827D@gmail.com>
	<20120621091054.57a69b8c@archvile>
	<D58154AE-36F8-45BD-BBB3-CF1AC3F4E610@gmail.com>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Jean-François,

On Thu, 21 Jun 2012 15:34:07 -0400
Jean-François Dagenais <jeff.dagenais@gmail.com> wrote:
> Uuuh, I'm good myself thanks ;) but the problem is this is not a reliable
> interrupt controller (in the general sense), especially the way the current
> driver works with it.

I still think that the real problem is with the chip itself. The driver should
just do it's best, and if the problem can't be worked around in the driver,
the driver should stay neutral IMHO.
In theory the PCA953x is still an edge triggered interrupt controller, but its
own interrupt output is level.

> > ...
> > Easy: Just release the button and push it again ;-)
> > (I mentioned our application was a gpio_keys keyboard in my previous e-mail.)
> 
> Yeah I had missed that you were doing one key per GPIO... But that's indeed why
> you are fine with it. You are using it more like a keyboard driver with an
> interrupt controller. If you use the 953x as an actual interrupt "controller"
> for a client that has a hardware-logic controlled INT signal, it won't be
> reliable for such an application (with the current driver state), contrary to
> what the driver initially suggests.

I insist. The driver can't really do much about it.

> > That's the kind of applications you can use the PCA953x as interrupt
> > controller for. My patches incorporated support for device-tree bindings and a
> > few fixes for both gpio-pca953x.c and gpio_keys.c, so it became possible to do
> > just this in a device-tree:
> > 		...
> > 
> > Get the idea? There is no other code involved, and it "just works"! I am
> > absolutely amazed by this marvel ;-)
> 
> I wasn't familiar with device-tree, thanks for this intro, I will look into

Be prepared, a device-tree is coming to a SoC near you any day... unless you
are stuck in the x86 world, where such marvel is not likely to appear anytime
soon ;-)

> it more. Not being familiar, I couldn't make this part out properly: are each
> of your keys using their own nested IRQ?

Yes!
Unfortunately gpio_keys.c requests edge-based IRQ's, so if you eliminate edge
functionality from the pca953x driver, my setup will stop working.
And the pca953x really _is_ an edge based interrupt controller (if one really
uses it as such), although a fairly limited (broken if you must) one.

> >> Since the timings of the slave and the OS are factors here, it's quite hard to
> >> reproduce. Even with the best intention and diligence at design, a race is
> >> possible.
> > 
> > Yes, of course. But that is a shortcoming of the extremely simple design of
> > PCA953x gpio expanders. There is not much we can do about this in the driver.
> 
> Well, what about my original suggestion? I know you said you agree with serving
> on only LEVEL, but it had a few other specifics... I guess at this point, my

Sorry. I was wrong. It is not a LEVEL interrupt controller. It doesn't work as
such. Besides, as I said above, this would break my setup, although the
decice-tree where we use this functionality is not mainlined, so I am probably
not allowed to complain about that :-(

> idea would have to be backed by tests and a patch. (Hearing you tell me: Yeah
> JF, why don't you put your money where your mouth is!? ;)

I wasn't about to say that.

> > Maybe we could place a warning in the documentation about the shortcomings of
> > these chips...?
> 
> Ok, now we are starting to agree! ;-) Short of an actual mod patch to the
> driver with results, I think this is a minimum. It could save a lot of people
> a lot of time, and perhaps save some aggravation too.
> 
> > Never mind. I am a hardware designer myself and we all make such mistakes.
> > Just try not to blame someone or something else for it publicly ;-)
> 
> I'm sorry if you felt my interventions here had anything to do with blame,
> to you or anyone. I was merely acting on the behalf of helping others avoid

Well, to me it looked like you wanted to blame the pca953x driver for your
problem with the chip....

> encountering issues with this, and saving other engineers some time from my
> own experiences. And in the spirit of giving back since I take so much from
> the open source community. I know it sounds corny, but it's still true.
> 
> > 
> > Feel free to improve the driver... but please do not remove features that work
> > for others.
> 
> Indeed. Hence why I try to get feedback about my improvement idea. It has
> effects on current users since the interrupt clients would have to adjust
> since instead of providing EDGE based, it would provide only LEVEL, plus, in
> existing designs, the pca953x would now ask that it's own interrupt be
> EDGE(RISING|FALLING) instead of LEVEL_LOW. These changes are important for my
> theory to work correctly. The only remaining trap at this point would be in
> the chip, which says it cannot catch edges that happen too quickly, but the
> minimum length of the edges it detects is sufficiently small not to be of
> anyone's concern.

You are proposing to change the PCA953x's input sensitivity artificially to
LEVEL, and its output sensitivity to EDGE(RISING|FALLING)?
Weird. Quickly sketching a scenario where you have just one level-based
acknowledged interrupt on a PCA953x input, it would generate no less than 4
interrupts to the primary controller (2 for each edge of the input signal)!!
I don't think this will be accepted.... besides it will break my setup and be
pretty much counter-intuitive to anyone else trying to use this chip as
advertised (talking about pitfalls).
And it will generate quite a significant amount of downstream interrupts,
triggering a lot if I2C traffic.

> > I hope my explanation was clear enough this time. As I said, we may put some
> > warnings in the documentation of the driver.

I still think that would be the best option... specially since you are not
going to use your proposed setup anyway.

> Thanks for your participation and work on this driver! ;)

You are welcome. Thanks for the discussion.

Best regards,

-- 
David Jander
Protonic Holland.
