Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab2BGQ3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:29:54 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40300 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2BGQ3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:29:52 -0500
MIME-Version: 1.0
In-Reply-To: <4F3118F7.8050205@ladisch.de>
References: <20120206181622.GA28811@kroah.com> <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de> <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de> <20120207114806.GA15323@citd.de> <4F3118F7.8050205@ladisch.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Feb 2012 08:29:32 -0800
X-Google-Sender-Auth: wizg2GbmAu1YyLexitNPR5a45Os
Message-ID: <CA+55aFxLKAN7rBWo_5oFNJdvaDfvvJydgmaHYPF5JQ_enDPe+Q@mail.gmail.com>
Subject: Re: Linux 3.2.5
To: Clemens Ladisch <clemens@ladisch.de>, Matthew Garrett <mjg@redhat.com>,
        Matthias Schniedermeyer <ms@citd.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Matthew wasn't cc'd for this thread - see lkml or ask me or Greg to
forward you the relevant emails ]

On Tue, Feb 7, 2012 at 4:28 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
>
> According to your logs, 3.2.4 didn't touch device 5:0, while 3.2.5 does
> disable ASPM.  (Are there any other messages regarding 0000:05:00.0?)

Actually, if I read things right, I think 3.2.4 did touch the device
too, just without the message.

One of the things that the aspm patch does is to remove the code that used to do

-       if (aspm_clear_state)
-               return -EINVAL;

in pcie_aspm_sanity_check(). So what I think happened for Matthias in
3.2.4 is that "pcie_aspm_sanity_check()" *always* failed (silently).
Which caused us to disable ASPM for *every* device, and not even talk
about it.

With the new patch in place, 3.2.5 gets past that check, and
pcie_aspm_sanity_check() now fails (with the message) for *some*
devices. Which then causes us to disable ASPM for *those* devices, but
not others. And that just sounds insane. It's sounds very broken for
this situation, because the BIOS had apparently enabled ASPM for the
PCIe bridge and the soubdblaster device, but then the "sanity check"
disabled ASPM for the bridge (and presumably left it on for the
soubdblaster).

Resulting in a broken system - aspm on the device, but not the bridge
leading up to it. Which I do not think is a correct situation.

So aspm=force fixes the issue because it forces aspm for everything -
which is fine. And 3.2.4 worked, because it *cleared* aspm for
everything. But 3.2.5 (and presumably current -git) does not work,
presumably because it clears ASPM randomly for bridge devices, while
leaving it on for the devices they bridge to.

Quite frankly, I think the pcie_aspm_sanity_check() logic is
fundamentally broken. It's broken because it violates the whole point
of the new model: it touches ASPM state for devices that firmware has
set up, and it shouldn't touch it for!

(It's also broken because it fundamentally makes the aspm disable be
"per device", which seems totally wrong - aspm is a system issue, you
can't just willy-nilly randomly enable it for one device without
taking other devices into account).

So I suspect the whole pcie_aspm_sanity_check() function should go away.

Matthias - can you try to trivially just make pcie_aspm_sanity_check()
always return 0 - remove the contents of that function, and just
replace them all with just a simple "return 0;". Does that make things
work for you?

                      Linus
