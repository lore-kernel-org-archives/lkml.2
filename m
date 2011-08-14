Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1HNMHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 08:07:07 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:41475 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1HNMHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 08:07:03 -0400
MIME-Version: 1.0
Date: Sun, 14 Aug 2011 15:07:02 +0300
Message-ID: <CADjdX0dT4Gj=42drL=Trw9Q_Os9To+N_SYjVffZ=0sGeG13uhA@mail.gmail.com>
Subject: Different concept for drivers?
From: Rein Kadastik <pocketpower@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: pocketpower@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Had this idea in my head for a long time and maybe some less lazy
programmer here will catch on and implement few of the following ideas
about Linux driver concepts.

It all began when I reviewed ALSA soundcard drivers searching the way
to support then malfunctioning ESI MAYA44 soundcard (which is
currently working but dirver was not done by me). What I discovered
was that 95% of all the drivers I went through were EXACTLY the same.
I mean they contained immense amount of identical functionality -
hardware protocol implementations, registry communications etc. But
the problem I saw was that different driver authors reinvented the
wheel at different level of correctness and some implementations were
clean and some were plain ugly. The only reason they reimplemented the
logic was because the variables had different values - the registry
numbers and the meanings of bits were different.

So I started to think about what the driver is and came up with an idea:

===> Idea <===
For hardware to work, there must be an engine that is capable of
operating the hardware given the hardware description exists. That
engine should be part of the kernel or a userland daemon, written once
and available for anybody to use. The hardware description however
should be concern of driver developers - that description would become
the driver.
===> End of idea <===

Let me give you a simple example of my point:

Each and every audio card has number of channels 2-n and each and
every card has the capability to mute individual channels by flipping
some bits. Current audio drivers contain both the flipping logic as
well as the hardcoded values of the registers and the bits to flip and
for each card the values differ while the bit flipping logic remain
constant ( although due different level of logical thinking capability
of different developers result in very weird implementations of the
same simple logic). But what about an engine that contains logic:

To mute audio in channel X, you need to flip the bit Y in registry Z

And then we have description for the specific audio card where it is written:

...
Registry: 12; Bit: 3; Feature: Mute channel 1
Registry: 12; Bit: 4; Feature: Mute channel 2
...

So in this way we could DESCRIBE all the features and capabilities of
the particular piece of hardware WITHOUT writing a single line of
code. The coding part would be written once as the part of the kernel
and the correct description would be selected by PCI ID-s for example
which could even be fetched over the network if desired. That way we
could improve the quality of the drivers SO MUCH.

Security aspect: As the critical coding part would be single entity
and drivers will not contain any code, there would not be possible to
introduce security risk into the system or the driver would not be
able to bring the system down. The engine would be verified code that
simply parses the descriptions and behaves as understood from the
description.

One more thing. If we have the working description for such an engine
on one platform and that engine would be ported to different platform,
the hardware would magically start working there as well. I mean, the
registries and their meanings remain the same no matter what OS you
have installed. So the hardware description remain the same and only
the OS specific parts would change but that would be the concern of
engine developers.

Engines would be specific to hardware category, like soundcard engine
and network interface card engine and storage controller engine etc,
that will understand specific descriptions and have implementations to
operate specific kind of hardware.

Damn, the world would be nice but mybe I am missing something here :)

As I feel, I am still not ready to join the high-volume LKML, I would
like to have replies to this post CC-d to: pocketpower@gmail.com

--
Thank you!
Rein Kadastik
