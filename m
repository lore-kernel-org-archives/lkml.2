Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0HCMWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:22:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34447 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0HCMWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 08:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KyAtmFPxjCVaQKic1mOpqDTgy4HoFcEEuJoyi8YIlS6zDX42JPNRCeLm/sU/D2cCuy
         3qrxIMJ2/tRNif3xXCQsCSxKfdAcWJd0oYfR0oiP6r/tjJNyzYBDrUC3fjB1ipmCrvpM
         9+hZ1+iENxd2Dx6VTmiaJtnn/RizN/qAlDe10=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007291934310.16616@casper.infradead.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
	<20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
	<AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
	<AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
	<loom.20100724T155117-833@post.gmane.org>
	<AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com>
	<AANLkTimHQ5DoqXikCu7=Nse16axKYYTJZEBJsSxFEH2y@mail.gmail.com>
	<20100728203921.0dd6562d@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1007291659400.16616@casper.infradead.org>
	<20100729190515.6ec85db2@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1007291934310.16616@casper.infradead.org>
Date: Tue, 3 Aug 2010 14:22:29 +0200
Message-ID: <AANLkTi=HZP85cpn2LFDxAOxwR0LE1Etp97EWJYnUd2o+@mail.gmail.com>
Subject: Re: Introducing the LCD-Linux project
From: Mattia Jona-Lasinio <mattia.jona@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, lcd-linux-users@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I explored the kernel sources dealing with the console emulation,
framebuffer support and console drivers. I do realize that if we want to fix
all layers in a clean way there is a lot of work to do.

But before going any further I'd like to know some preliminary things.
We are talking about a massive rewrite of code, also including a redesign
of the console layer and (at least) the VGA driver (vgacon) and framebuffer
driver (fbcon), not just a couple of patches to throw in. Do we have the will
to do this job? I mean, I personally do but I don't want to spend time and
effort in something that will be eventually rejected.
Linux has a console system, so we are not in a hurry and we can
think about it. So the main question: how do we proceed?

In case we want to fix this, we should discuss about the design and
implementation
to follow. Presently the struct vc_data contains a lot of information
common to the driver and the
console layers. We should split this struct in order to have a more
transparent interface
between the two parts. Ideally the driver should not know anything
about the console
implementation and the members of the vc_data and it should only take care about
displaying the right thing at the right place.
The vt_struct should represent a physical device, like a monitor or a
LCD display.
Every vt_struct can have one or more vc_data associated to it. All
available vt_struct
are physically refreshed but for every vt_struct, only the currently
visible vc_data on that struct is
actually updated. The others are just "software updated". I don't know
if all this is
the same idea that James was suggesting.

We should avoid fixed size vectors of pointers to these structs by
making them elements
of linked lists.

I agree on the mapping between vc and vt but I'd like to make the
number of vc per vt
an option to be passed at boot time or when init is launched (for
instance), not a
compile time option.

I totally agree that all this must be somewhat separated from the tty
layer, to have
a console without a tty driver, or at least a very light one.

What do you think?

Coming back to LCD-Linux, I will write a module to make it use the
present framework,
basically deactivating the terminal emulation and a bunch of other things, but
keeping the virtual display. Let's see the result ;)

BTW, I currently use lcd-linux with a 4x40 LCD display
which has two controllers onboard. The possibility to drive displays
with more than one
(up to 7) controller onboard is a feature of the present hd44780 driver.

Greetings

Mattia


On Thu, Jul 29, 2010 at 8:39 PM, James Simmons <jsimmons@infradead.org> wrote:
>
>> > 3) Invert the VT layer. Currently the console/printk driver is on top of
>> >    the tty layer. It would be nice to be able to only use a very light
>> >    weight vt printk without the VT tty on top for embedded platforms.
>>
>> No. printk hits console drivers why may or may not be frame buffer
>> interfaces. Has done for a very long time. Keith Packard has also been
>> doing stuff with crash time oops displays etc over an X display.
>
> Correct. What I mean is have the ability to just register the console
> driver but not the tty driver.
>
>> > 4) Seperate out the VT emulation layer. Related to 3.
>>
>> Separate from what ?
>
> We can still have a basic tty layer without the control characters, think
> do_con_trol in vt.c, junk compiled into the kernel. Make it a options for
> userland to do the vt100 emulation.
>
>> > 5) Multiple independent VT support. Which brings up the question what
>> >    should the mapping of VCs to a VT look like.
