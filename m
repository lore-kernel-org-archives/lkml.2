Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1CNUyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:54:44 -0400
Received: from kroah.org ([198.145.64.141]:45874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab1CNUym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:54:42 -0400
Date: Mon, 14 Mar 2011 13:54:32 -0700
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
Message-ID: <20110314205432.GA1856@kroah.com>
References: <201103131141.07380.rjw@sisk.pl>
 <4D7CB15A.6030203@linaro.org>
 <201103131353.54612.rjw@sisk.pl>
 <4D7CC4D0.90305@linaro.org>
 <20110313161528.GB10718@kroah.com>
 <4D7CFB3B.8060008@linaro.org>
 <20110313174811.GA11504@kroah.com>
 <4D7D0933.9010502@linaro.org>
 <20110313232612.GA13784@kroah.com>
 <4D7DD41D.1070401@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7DD41D.1070401@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 08:38:53AM +0000, Andy Green wrote:
> On 03/13/2011 11:26 PM, Somebody in the thread at some point said:
> >On Sun, Mar 13, 2011 at 06:13:07PM +0000, Andy Green wrote:
> >>On 03/13/2011 05:48 PM, Somebody in the thread at some point said:
> >>>On Sun, Mar 13, 2011 at 05:13:31PM +0000, Andy Green wrote:
> >>>>So when there's a bit more of Device Tree in evidence, are you going
> >>>>to accept Device-tree based patches in usbnet etc along these lines,
> >>>>or does that trigger the "do it in userspace" response, in which
> >>>>case we are both wasting each others' time continuing to discuss
> >>>>this at all?
> >>>
> >>>As mentioned numerous times before, network naming stuff happens in
> >>>userspace, not in the kernel, so no matter what infrastructure is added,
> >>
> >>The naming of that network interface happens in smsc95xx, in kernel:
> >>it uses a dodgy heuristic to choose between usb%d eth%d and others
> >>and gets it wrong in this case due to stuff outside its view.
> >>There's nothing golden and wonderful about that which needs
> >>protecting from outside hints.
> >
> >Then why not always do this in userspace correctly?  It's the _exact_
> >same problem that the server companies have in naming their network
> >devices in a proper manner (i.e. the port with the 0 label on it wants
> >to always be eth0).  We have the tools today to solve this issue, in a
> >consistant and proper manner, please use them.
> 
> It is not at all the same problem.
> 
> Here, the usbnet driver tries to figure out what kind of device
> label it should use, the numbering is then dependent on the label
> and there's no problem coming from the numbering, nor do the patches
> touch that.
> 
> The first issue for usbnet is right now, it has no real insight into
> what the appropriate interface name is because it is out of its view
> if the USB Ethernet bridge is soldered onboard or not.  You know, it
> is also not in a generic userspace's view what is soldered on that
> board either, so I can only read your pushing of that 'solution' as
> "get this out of my hair".  The one place that can properly know it
> right now is the board definition file in the kernel, maybe Device
> Tree too in the future.

It's not up to the driver to "know" this at all.

> To do it what you are calling the "correct" way in userland, you are
> okay with the driver selecting the wrong interface name, condemning
> userland to regenerate board-specific knowledge from grepping
> /proc/cpuinfo, inferring in userland what can easily and justly be
> known in the board definition file in kernel, and overriding the
> wrong interface name.  In all that, Caesar's hands are clean
> alright, but don't tell me this is a good job and the correct
> solution.

It really is.  How do you know that I don't want to name this device
something else than you feel you should?  Do you really want to tell me
to recompile my kernel just to change the name of the network device?

No, it has been determined a long time ago that network naming things
like this are to be done in userspace.  It's an argument that has come
and gone many years ago, sorry.  See all of the wonderful, and simple,
tools we have today in userspace to handle this type of thing.  Distros
can use them how ever they see fit, and even better, users can configure
them!  That means they don't have to rebuild their kernels, which is a
bit unreasonable, don't you think?

> Despite not having the information, the driver does have go at a
> heuristic, but because net->dev_addr[] is always coming from
> random_ether_addr(), which rightly forces [0] & 2 to 1 indicating
> it's a private namespace MAC address, the heuristic is broken and
> never selects eth%d.
> 
> -               // heuristic:  "usb%d" for links we know are two-host,
> -               // else "eth%d" when there's reasonable doubt.  userspace
> -               // can rename the link if it knows better.
> -               if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
> -                   (net->dev_addr [0] & 0x02) == 0)
> +               /*
> +                * heuristic:  "usb%d" for links we know are two-host,
> +                * else "eth%d" when there's reasonable doubt.  userspace
> +                * can rename the link if it knows better.  Async
> +                * platform_data can also override this if it knows better
> +                * based on knowledge of what this link is wired up to.
> +                */
> +               if ((((dev->driver_info->flags & FLAG_ETHER) != 0 &&
> +                   (net->dev_addr[0] & 0x02) == 0)) ||
> +                   (pdata && pdata->flags &
> + USBNET_PLATDATA_FLAG__FORCE_ETH_IFNAME))
>                         strcpy (net->name, "eth%d");

Perhaps we should just always name these things 'eth%d'?  Oh wait, as it
really is a USB device, they are supposed to be called 'usb%d' as
determined (again) a long time ago.

If a distro/board manufacturer wants to hide the fact that this really
is a usb device by renaming it to eth0, then again, it can.  But don't
force the kernel to have that policy in it.

> 
> static inline void random_ether_addr(u8 *addr)
> {
>         get_random_bytes (addr, ETH_ALEN);
>         addr [0] &= 0xfe;       /* clear multicast bit */
>         addr [0] |= 0x02;       /* set local assignment bit (IEEE802) */
> }
> 
> If you look further down, it is making an attempt to choose the
> right name at interface creation time by taking information from
> other sources already
> 
>                 /* WLAN devices should always be named "wlan%d" */
>                 if ((dev->driver_info->flags & FLAG_WLAN) != 0)
> 
> My patch just has it also look if there is a pdata->flags to see if
> the board definition file is guiding it to choose eth%d.

Ick, well, I'm not saying that cleaning up this driver is not a bad idea
at all, feel free to submit patches for it that are self-contained.

> The second issue for usbnet which the patchset solves is that right
> now, it will always give a random MAC address that differs each
> boot, driving dhpcd insane.
> 
> Now once again, the existing code will take information from other
> sources to guide it about that too.  In smsc95xx usbnet driver, it
> looks to see if there is an EEPROM attached to the chip and will
> replace the random MAC address with the one from there if there is.
> The patch extends that to check usbnet platform_data to see if a MAC
> address has been sent up from the board definition file.
> 
>  static void smsc95xx_init_mac_address(struct usbnet *dev)
>  {
> +       struct usbnet_platform_data *pdata = dev->udev->dev.platform_data;
> +
> +       /*
> +        * if netdev platform data has taken responsibility for forcing
> +        * the MAC then nothing to do here
> +        */
> +
> +       if (pdata && pdata->flags & USBNET_PLATDATA_FLAG__USE_MAC)
> +               return;
> +
>         /* try reading mac address from EEPROM */
>         if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
>                         dev->net->dev_addr) == 0) {
> 
> So given what it already does in a broken way for these valid
> implementations of smsc95xx with no EEPROM, I really do not
> understand what sanctity of these drivers is being violated by
> having it do the same things better using a couple of extra lines
> with platform_data.

You can set MAC addresses from userspace, why not do that here for
systems in which the hardware designers messed things up so bad it takes
a programmer to fix their brokenness?

> For sure, in any other bus, we will never have this discussion about
> if the device driver should use relevant platform_data to be guided
> about what to do, that is what platform_data is for and it is very
> widely used indeed.

Are you sure?  Try me on one of the other "real" busses out there like
PCI and see how all of these same arguments are identical :)

The abuse of platform_data today does not give you the right to persist
in it.  Look at the work of the device tree developers to fix this
problem as proof of this.

> >>So, we don't need to discuss this any further: thanks again for your
> >>time.
> >
> >Ok, so does this mean that you are convinced that I am correct here, or
> >are just giving up and going to keep your patches outside of the kernel,
> >or something else?
> 
> It means I acknowledge you are the guy in the way of solving these
> issues in usbnet, and that these patches will be discarded without
> your approval.

Again, because you can solve them in userspace!  Why is that not a
correct solution?  It should make you even happier as you don't have to
have any kernel patches that are not upstream, you can drop them
entirely and just set up some of your distro's config files and be done
with it.

thanks,

greg k-h
