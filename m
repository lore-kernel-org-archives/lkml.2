Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2BGQyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:54:32 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:57114 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2BGQya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:54:30 -0500
Date: Tue, 7 Feb 2012 17:54:16 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 3.2.5
Message-ID: <20120207165416.GA27342@citd.de>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de>
 <20120207114806.GA15323@citd.de>
 <4F3118F7.8050205@ladisch.de>
 <CA+55aFxLKAN7rBWo_5oFNJdvaDfvvJydgmaHYPF5JQ_enDPe+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxLKAN7rBWo_5oFNJdvaDfvvJydgmaHYPF5JQ_enDPe+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.02.2012 08:29, Linus Torvalds wrote:
> [ Matthew wasn't cc'd for this thread - see lkml or ask me or Greg to
> forward you the relevant emails ]
> 
> On Tue, Feb 7, 2012 at 4:28 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> >
> > According to your logs, 3.2.4 didn't touch device 5:0, while 3.2.5 does
> > disable ASPM.  (Are there any other messages regarding 0000:05:00.0?)
> 
> Actually, if I read things right, I think 3.2.4 did touch the device
> too, just without the message.
> 
> One of the things that the aspm patch does is to remove the code that used to do
> 
> -       if (aspm_clear_state)
> -               return -EINVAL;
> 
> in pcie_aspm_sanity_check(). So what I think happened for Matthias in
> 3.2.4 is that "pcie_aspm_sanity_check()" *always* failed (silently).
> Which caused us to disable ASPM for *every* device, and not even talk
> about it.
> 
> With the new patch in place, 3.2.5 gets past that check, and
> pcie_aspm_sanity_check() now fails (with the message) for *some*
> devices. Which then causes us to disable ASPM for *those* devices, but
> not others. And that just sounds insane. It's sounds very broken for
> this situation, because the BIOS had apparently enabled ASPM for the
> PCIe bridge and the soubdblaster device, but then the "sanity check"
> disabled ASPM for the bridge (and presumably left it on for the
> soubdblaster).
> 
> Resulting in a broken system - aspm on the device, but not the bridge
> leading up to it. Which I do not think is a correct situation.
> 
> So aspm=force fixes the issue because it forces aspm for everything -
> which is fine. And 3.2.4 worked, because it *cleared* aspm for
> everything. But 3.2.5 (and presumably current -git) does not work,
> presumably because it clears ASPM randomly for bridge devices, while
> leaving it on for the devices they bridge to.
> 
> Quite frankly, I think the pcie_aspm_sanity_check() logic is
> fundamentally broken. It's broken because it violates the whole point
> of the new model: it touches ASPM state for devices that firmware has
> set up, and it shouldn't touch it for!
> 
> (It's also broken because it fundamentally makes the aspm disable be
> "per device", which seems totally wrong - aspm is a system issue, you
> can't just willy-nilly randomly enable it for one device without
> taking other devices into account).
> 
> So I suspect the whole pcie_aspm_sanity_check() function should go away.
> 
> Matthias - can you try to trivially just make pcie_aspm_sanity_check()
> always return 0 - remove the contents of that function, and just
> replace them all with just a simple "return 0;". Does that make things
> work for you?

So 3.2.5 with the following patch and without pcie_aspm=force:

- snip -
--- drivers/pci/pcie/aspm.c.orig        2012-02-07 15:17:05.068401852 +0100
+++ drivers/pci/pcie/aspm.c     2012-02-07 17:47:27.304684977 +0100
@@ -500,6 +500,8 @@
        int pos;
        u32 reg32;

+       return 0;
+
        /*
         * Some functions in a slot might not all be PCIe functions,
         * very strange. Disable ASPM for the whole slot
- snip -

Sound works. :-)

dmesg | grep -i aspm
[    0.762726] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.792913] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.627719] e1000e 0000:03:00.0: Disabling ASPM  L1







Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

