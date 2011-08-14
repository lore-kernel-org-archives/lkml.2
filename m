Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1HNShF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 14:37:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58184 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1HNShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 14:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <CADjdX0dT4Gj=42drL=Trw9Q_Os9To+N_SYjVffZ=0sGeG13uhA@mail.gmail.com>
References: <CADjdX0dT4Gj=42drL=Trw9Q_Os9To+N_SYjVffZ=0sGeG13uhA@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sun, 14 Aug 2011 14:36:19 -0400
Message-ID: <CAF_S4t8gG_28+XYEEUz1=NbA7LqULTByzP93iTE=J927xzYyWg@mail.gmail.com>
Subject: Re: Different concept for drivers?
To: Rein Kadastik <pocketpower@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 08:07, Rein Kadastik <pocketpower@gmail.com> wrote:
> Hi,
>
> Had this idea in my head for a long time and maybe some less lazy
> programmer here will catch on and implement few of the following ideas
> about Linux driver concepts.
>
> It all began when I reviewed ALSA soundcard drivers searching the way
> to support then malfunctioning ESI MAYA44 soundcard (which is
> currently working but dirver was not done by me). What I discovered
> was that 95% of all the drivers I went through were EXACTLY the same.
> I mean they contained immense amount of identical functionality -
> hardware protocol implementations, registry communications etc. But
> the problem I saw was that different driver authors reinvented the
> wheel at different level of correctness and some implementations were
> clean and some were plain ugly. The only reason they reimplemented the
> logic was because the variables had different values - the registry
> numbers and the meanings of bits were different.

That sounds like the common code should be made shared across the ALSA
drivers in question...

> So I started to think about what the driver is and came up with an idea:
>
> ===> Idea <===
> For hardware to work, there must be an engine that is capable of
> operating the hardware given the hardware description exists. That
> engine should be part of the kernel or a userland daemon, written once
> and available for anybody to use. The hardware description however
> should be concern of driver developers - that description would become
> the driver.
> ===> End of idea <===

... but this is not such a good idea. You'd basically have to make an
entirely new programming language, one just as powerful as C. And it
would need to perform as well as C to be accepted.

>
> Let me give you a simple example of my point:
>
> Each and every audio card has number of channels 2-n and each and
> every card has the capability to mute individual channels by flipping
> some bits. Current audio drivers contain both the flipping logic as
> well as the hardcoded values of the registers and the bits to flip and
> for each card the values differ while the bit flipping logic remain
> constant ( although due different level of logical thinking capability
> of different developers result in very weird implementations of the
> same simple logic). But what about an engine that contains logic:
>
> To mute audio in channel X, you need to flip the bit Y in registry Z
>
> And then we have description for the specific audio card where it is written:
>
> ...
> Registry: 12; Bit: 3; Feature: Mute channel 1
> Registry: 12; Bit: 4; Feature: Mute channel 2
> ...

This is nice and simple, but not all operations involve just a single
hardware register bit. With some devices you might need to write to
multiple registers in a specific order. You might need to prepare a
packet to be sent across a bus internal to the device. You need to be
able to detect and handle error conditions; some of these conditions
might require retries, or trying a different approach entirely.

Once you start handling all of this, you end up with something very
similar to C - you have if statement, you have loops, you'll probably
need to be able to allocate memory for some operations, you definitely
need to be able to control locking. But you also need to write all the
bindings to allow this new hardware description language to call into
C (and be called from C), and you need to write the compiler to
convert it to a C driver (or an interpreter, but kernel developers are
likely to frown upon interpreter overhead).

> Security aspect: As the critical coding part would be single entity
> and drivers will not contain any code, there would not be possible to
> introduce security risk into the system or the driver would not be
> able to bring the system down. The engine would be verified code that
> simply parses the descriptions and behaves as understood from the
> description.

It's all too easy to introduce security vulnerabilities into the
hardware description as well :) Sound cards perform DMAs, after all -
if you can get them to DMA to the wrong memory addresses you might
manage to read or overwrite sensitive data. Sure, you could avoid some
classes of issues (buffer overruns, perhaps), but at  what cost?

> One more thing. If we have the working description for such an engine
> on one platform and that engine would be ported to different platform,
> the hardware would magically start working there as well. I mean, the
> registries and their meanings remain the same no matter what OS you
> have installed. So the hardware description remain the same and only
> the OS specific parts would change but that would be the concern of
> engine developers.

LWN has an interesting article on the costs of abstraction layers:
http://lwn.net/SubscriberLink/454716/acf6d97d36960ead/
Basically, you're limiting yourself to the lowest common denominator
of OS functionality there, so at the very least you're losing
performance, and probably functionality as well.

> Engines would be specific to hardware category, like soundcard engine
> and network interface card engine and storage controller engine etc,
> that will understand specific descriptions and have implementations to
> operate specific kind of hardware.

And now we need multiple programming languages, one for each type of device?

> Damn, the world would be nice but mybe I am missing something here :)

To summarize, your proposal boils down to a DSL (Domain Specific
Language) for writing hardware drivers. I'm not convinced you can do
much better than C for this, however. Many of your proposed features
can be implemented in C with appropriate library code - eg, you could
write a layer that binds mute and volume settings to specific hardware
registers; it could take a static table to define the bindings, and
then drivers could just call into it. This, of course, assumes there
are enough devices with such a simple volume control method that this
is worth it.

I do think that this could be an interesting research project, but
finding good abstractions like this is _very_ difficult, and finding
one that does not make maintenance and improvements for the kernel at
large more difficult is even harder. If you do decide to tackle this,
I would recommend treating it as an extension to C to simplify common
tasks, rather than an entirely new language in itself.

>
> As I feel, I am still not ready to join the high-volume LKML, I would
> like to have replies to this post CC-d to: pocketpower@gmail.com

Filter LKML posts to a label, gmail's not going to fill up :) That
said, don't worry - it's normal etiquette on LKML to CC all posters in
a thread by default (ie, use reply to all).
