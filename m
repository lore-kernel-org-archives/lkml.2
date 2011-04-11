Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1DKV6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:58:32 -0400
Received: from kroah.org ([198.145.64.141]:60075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1DKV6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:58:31 -0400
Date: Mon, 11 Apr 2011 14:56:19 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
Message-ID: <20110411215619.GA27943@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
 <20110411210631.GA28559@kroah.com>
 <BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
 <20110411212513.GA17809@kroah.com>
 <BANLkTingqXAWTeOhcL6ER0UJfEdQF5Bo2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTingqXAWTeOhcL6ER0UJfEdQF5Bo2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 11:36:39PM +0200, Rafał Miłecki wrote:
> 2011/4/11 Greg KH <greg@kroah.com>:
> > On Mon, Apr 11, 2011 at 11:19:13PM +0200, Rafał Miłecki wrote:
> >> 2011/4/11 Greg KH <greg@kroah.com>:
> >> > On Mon, Apr 11, 2011 at 11:25:14PM +0200, Rafał Miłecki wrote:
> >> >> +static void axi_release_core_dev(struct device *dev)
> >> >> +{
> >> >> +     /* Silent lack-of-release warning */
> >> >> +}
> >> >
> >> > Ok, WTF!!!!
> >>
> >> Thank you for your kindly words. It's much more enjoyable to work on
> >> kernel that way. I definitely made that on purpose.
> >
> > I can't tell if you are kidding or not.
> 
> That was 100% irony. I swear I don't enjoy publishing bad code and
> getting such a comment.

Ok, you forgot the ':)' then...

> > Please read the documentation for how to do this properly.  I find it
> > really hard to believe that you wrote that comment instead of putting in
> > the 2 lines of code required for this function.
> >
> > Especially as-it-is, your code does not work properly and leaks memory
> > badly.  Why would you do that on purpose?
> 
> I tried to read some documentation about this.
> 
> 1) driver-mode/device.txt says only that:
> > Callback to free the device after all references have
> > gone away. This should be set by the allocator of the
> > device (i.e. the bus driver that discovered the device).
> I *really* do not know how my driver should "free" core on AXI bus.

The structure that you have created, added to the bus, is now ready to
have its memory freed.  So free it.

This usually means something like:
	struct my_obj = to_my_obj(dev);
	kfree(my_obj);
in the release function.

> 2) LDD3 says:
> > The method is called when the last reference to the device is removed; it is called
> > from the embedded kobject’s release method. All device structures registered with
> > the core must have a release method, or the kernel prints out scary complaints.
> Well, I do not register any structs for AXI core.

Yes you did, otherwise you would have never seen that callback warning
you that you needed a release function.

> 3) Example code from LDD3:
> static void ldd_bus_release(struct device *dev)
> {
> printk(KERN_DEBUG "lddbus release\n");
> }
> Yeah, that's what I did...

Wow that's old, sorry.  See the kobject documentation for much more
detail about what you need here.

> 4) SSB in it's ssb_release_dev just calls kfree on struct that was
> allocated when registering drivers. *I do not* allocate such a struct,
> so I believe I do exactly the same memory leak as SSB does.

Well someone allocated it, right?  Who did it?  If it wasn't you, where
did that structure come from and why are you registering it on your bus?

> Can you spend 2 more minues in addition to commenting my ideas and
> help me with writing that 2 lines I missed? Where do I leak memory in
> my driver? Which struct should I kfree?

The structure that you wrap around 'struct device' for your bus.

hope this helps,

greg k-h
