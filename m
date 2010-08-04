Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab0HDOaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:30:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:34604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab0HDOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:30:08 -0400
Date: Wed, 4 Aug 2010 15:29:17 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Mattia Jona-Lasinio <mattia.jona@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lcd-linux-users@lists.sourceforge.net,
        Linux console project <linuxconsole-dev@lists.sourceforge.net>,
        Bernie Thompson <bernie@plugable.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: Introducing the LCD-Linux project
In-Reply-To: <AANLkTi=HZP85cpn2LFDxAOxwR0LE1Etp97EWJYnUd2o+@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1008041454350.31488@casper.infradead.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com> <20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk> <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com> <AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
 <loom.20100724T155117-833@post.gmane.org> <AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com> <AANLkTimHQ5DoqXikCu7=Nse16axKYYTJZEBJsSxFEH2y@mail.gmail.com> <20100728203921.0dd6562d@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1007291659400.16616@casper.infradead.org>
 <20100729190515.6ec85db2@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1007291934310.16616@casper.infradead.org> <AANLkTi=HZP85cpn2LFDxAOxwR0LE1Etp97EWJYnUd2o+@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.LFD.2.00.1008041457321.31488@casper.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I explored the kernel sources dealing with the console emulation,
> framebuffer support and console drivers. I do realize that if we want to fix
> all layers in a clean way there is a lot of work to do.

Yes, but the good news is I have been here before. The good news is that 
the console code has been abstracted out of most low level drivers so it 
makes life much easier this time around. Also today we are starting to 
have a greater amount of hardware that can do multi-seat. Another project 
dealing with these same issues is

http://plugable.com/2009/11/16/setting-up-usb-multiseat-with-displaylink-on-linux-gdm-up-to-2-20/
  
> But before going any further I'd like to know some preliminary things.
> We are talking about a massive rewrite of code, also including a redesign
> of the console layer and (at least) the VGA driver (vgacon) and framebuffer
> driver (fbcon), not just a couple of patches to throw in. Do we have the will
> to do this job? I mean, I personally do but I don't want to spend time and
> effort in something that will be eventually rejected.
> Linux has a console system, so we are not in a hurry and we can
> think about it. So the main question: how do we proceed?

Like before. Bit by bit to avoid massive code drops that could break lots 
of things. Do certain select changes and push them to Andrew Mortons -mm 
tree for wide testing. If we have a successful run then push it main stream.
While in the -mm tree we start the next round of changes. Once the 
previous batch from the -mm tree is pushed main stream then push the next 
batch of changes.

> In case we want to fix this, we should discuss about the design and
> implementation
> to follow. Presently the struct vc_data contains a lot of information
> common to the driver and the
> console layers. We should split this struct in order to have a more
> transparent interface
> between the two parts. Ideally the driver should not know anything
> about the console
> implementation and the members of the vc_data and it should only take care about
> displaying the right thing at the right place.
> The vt_struct should represent a physical device, like a monitor or a
> LCD display.
> Every vt_struct can have one or more vc_data associated to it. All
> available vt_struct
> are physically refreshed but for every vt_struct, only the currently
> visible vc_data on that struct is
> actually updated. The others are just "software updated". I don't know
> if all this is
> the same idea that James was suggesting.

Yes. That is exactly what I had before.

> We should avoid fixed size vectors of pointers to these structs by
> making them elements
> of linked lists.

I think for our case idrs whould be better.

> I agree on the mapping between vc and vt but I'd like to make the
> number of vc per vt
> an option to be passed at boot time or when init is launched (for
> instance), not a
> compile time option.

I had it as a module option. Now ioctl VT_GETSTATE has a problem with more 
tha 16 VCs. So original I made 16 the limitation of VCs per VT.

> I totally agree that all this must be somewhat separated from the tty
> layer, to have
> a console without a tty driver, or at least a very light one.
> 
> What do you think?

We pretty much have the same goals.

> Coming back to LCD-Linux, I will write a module to make it use the
> present framework,
> basically deactivating the terminal emulation and a bunch of other things, but
> keeping the virtual display. Let's see the result ;)

Excellent. Let me see the work once your done.

> BTW, I currently use lcd-linux with a 4x40 LCD display
> which has two controllers onboard. The possibility to drive displays
> with more than one
> (up to 7) controller onboard is a feature of the present hd44780 driver.

I can discuss with you off line about getting a hold of one of these 
boards.

Okay. I have sync my console git tree up to linus latest tree. I started 
last night on the first pass of the console changes. Mostly code cleanup 
to make the second round of changes easier to deal with. I will commit 
them in the next few days after some testing of course.  I will send out a 
email once I haev done the commit.

http://git.infradead.org/users/jsimmons/linuxconsole-2.6.git

