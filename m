Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab0JZMG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:06:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52240 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab0JZMG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:06:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>
Subject: Re: [PATCH 1/9] mfd: Add support for the ST-Ericsson CG2900.
Date: Tue, 26 Oct 2010 14:06:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <AANLkTineXA2ZY0J7+dZhqywz+4aAVgzihu+LDDbsL8mu@mail.gmail.com> <201010221736.57671.arnd@arndb.de> <AANLkTinY0qmt6uFo4PZ3xH2BF5-AJ0C7ptctzNdOkRU2@mail.gmail.com>
In-Reply-To: <AANLkTinY0qmt6uFo4PZ3xH2BF5-AJ0C7ptctzNdOkRU2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010261406.10996.arnd@arndb.de>
X-Provags-ID: V02:K0:p+Gtp0iG1Kq8bcOGOrfJIonuZBQiTYpQyE0GKowabRN
 50XBJUc7+BgdaX3FvgEUlBJ5H7M11yXLdUhS/9ECTMFoD6U6Mj
 6+DHUHl10+miFhSRCg6o4weBfzZ0NFO+5CkpY8hlwV0UdOHzZV
 eL1x9Ejl728yLcprFv1s05KZhUx39UsvfybxPDox7SGx4uZOYo
 f4qVnL2GAzIK/QvQwy/1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 October 2010, Par-Gunnar Hjalmdahl wrote:

> 2010/10/22 Arnd Bergmann <arnd@arndb.de>:
> > On Friday 22 October 2010 12:35:16 Par-Gunnar Hjalmdahl wrote:
> >> This patch adds support for the ST-Ericsson CG2900 Connectivity
> >> Combo controller.
> >> This patch adds the central framework to be able to register CG2900 users,
> >> transports, and chip handlers.
> >>
> >> Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
> >
> > Looks ok from a coding style perspective, but some important information is
> > missing from the description:
> >
> > * What is a CG2900?
> > * Why is it a MFD device rather than e.g. a bus or a subsystem?
> >
> 
> I will add some more info:
>  - CG2900 is a GPS, Bluetooth, FM controller
>  - I do not really know what makes a device qualify as a certain type,
> but at least for us this is a multifunction device. But I can't really
> say that it isn't really a bus (could be stated as multifunction HCI
> bus). I guess it could be qualified as a subsystem as well, but I
> cannot give you a reason to have it as either.

It's not often completely clear, but I would draw the distinction like
this:

* A multi-function device is a single device that sits on a given bus
with one host I/O interface and provides functionality to different
logical subsystems like serial or alsa. A typical case for an MFD would
be a to solve the problem of sharing resources between the child drivers
because you cannot bind one device to two drivers. If CG2900 is a single
piece of silicon that always looks the same way, it's probably an MFD.

* A bus is a much more general abstraction which has multiple devices
and multiple device types behind it. The bus has no idea what devices
are attached to it at compile time, so you either probe the devices at
boot time or define a set of devices in a board definition (platform
devices). Driver modules then register a struct device_driver for the
bus, which gives all matching devices to the bus. If you can have
future CG2900 compatible devices that need to have other drivers, e.g.
for HID or video, it should probably be a bus.

* A subsystem is less clearly defined, I would call bluetooth a subsystem
instead of just a bus because it not only matches devices with drivers
but also has its own user-level interfaces for raw communication.
If you want to be able to have drivers in the kernel and in user space,
you might want to consider starting a new drivers/cg2900 subsystem, or
integrating into the bluetooth subsystem if that makes sense.

> >> +config MFD_CG2900
> >> +     tristate "Support ST-Ericsson CG2900 main structure"
> >> +     depends on NET
> >> +     help
> >> +       Support for ST-Ericsson CG2900 Connectivity Combo controller main structure.
> >> +       Supports multiple functionalities muxed over a Bluetooth HCI H:4 interface.
> >> +       CG2900 support Bluetooth, FM radio, and GPS.
> >> +
> >
> > Can you explain what it means to mux over a H:4 interface? Does this mean
> > you use bluetooth infrastructure that is designed for wireless communication
> > in order to connect on-board or on-chip devices?
> >
> 
> The H:4 protocol is defined in the Bluetooth Core specification. It
> uses a single byte first in the data packet to determine an HCI
> channel. In the Bluetooth Core specification there are 4 channels
> specified, 0x01-0x04 (0x01 is BT command, etc). The rest of the
> channels are reserved, but these have been used on a proprietary basis
> to transport data to different IPs within the controller. In our API
> we have chosen to have a channel separation on an API basis and the
> H:4 byte is then added within the driver. So we have multiple channels
> coming in from the users that we mux onto a single data transport.
> That's what I mean in the text. I guess I could rewrite it a bit to
> make it clearer.

I still don't understand it, though that may be a problem on my side.

Does that mean that cg2900 is to the host side a standard bluetooth HCI,
but it uses extensions to the HCI in order to make the other functions
available to the host?

What chapter in the bluetooth core specification describes this?

> >> +
> >> +/**
> >> + * add_h4_user() - Add H4 user to user storage based on supplied H4 channel.
> >> + * @dev:     Stored CG2900 device.
> >> + * @name:    Device name to identify different devices that are using
> >> + *           the same H4 channel.
> >> + *
> >> + * Returns:
> >> + *   0 if there is no error.
> >> + *   -EINVAL if NULL pointer or bad channel is supplied.
> >> + *   -EBUSY if there already is a user for supplied channel.
> >> + */
> >> +static int add_h4_user(struct cg2900_device *dev, const char * const name)
> >> +{
> >
> > Where does that name come from? Why not just use an enum if the name is
> > only use for strncmp?
> >
> 
> At a point in time we used to have an enum, but from what I can see it
> is easier to keep an API stable if you use name lookup instead. If we
> want to have minimal changes to the API in the future this is quite a
> flexible solution, but this code should be moved to each respective
> chip handler.

You haven't really answered the first question, where the name comes from
(I guess the question was not too clear). Does this e.g. get passed by a
user application, or does it come from a hardware description of some
sort?

It looks a bit like a handcoded version of the code we use for device/driver
matching in drivers/core. If that's the case, it would be better to use
the existing infrastructure and create a bus with devices that can be
matched with drivers.

> >> +static ssize_t test_char_dev_read(struct file *filp, char __user *buf,
> >> +                               size_t count, loff_t *f_pos)
> >> +{
> >> +     struct sk_buff *skb;
> >> +     int bytes_to_copy;
> >> +     int err;
> >> +     struct sk_buff_head *rx_queue = &core_info->test_char_dev->rx_queue;
> >
> > What is this read/write interface used for?
> >
> > The name suggests that this is only for testing and not an essential
> > part of your driver. Could this be made a separate driver?
> >
> > It also looks like you do socket communication here, can't you use
> > a proper AF_BLUETOOTH socket to do the same?
> >
> 
> This interface can be used for module testing where you can have a
> test engine in user space that acts as a chip. Yes, it could be made
> into a separate driver but it would be a very small driver. Don't know
> if it will be worth having it in a separate file...

I don't think file size is a major argument here. If it's used for
testing, I'd make it a separate module that defaults to not being
built, in order to prevent people from relying on what you intended
as a testing interface.

> We use the sk_buffer, which I guess is the reason that you mention
> sockets. We could of course use a socket instead of a char dev, both
> here and in the cg2900_char_dev file (which of course then would be
> renamed). It was just a choice we made during development. We think
> that the transport as such is more like a streaming interface, but I
> see no real problem to have sockets. We already have several users
> using char dev though so I would prefer to keep char dev rather than
> switching to sockets unless you have a strong reason for this.
> I see no reason to use AF_BLUETOOTH though, the transport is not only
> for Bluetooth.

The question here is what is appropriate. My guess was that the frame
format was the one used in bluetooth sockets. If that's not the
case, AF_BLUETOOTH would obviously be wrong.

For the test interface, it doesn't matter that much what you use, but
for the cg2900_char_dev we should make sure that you considered all
the options and made a reasonable decision. What does the data format
look like there? My impression is that the character device might be
too low-level and it could be better to use some structured interface
like a socket, but it really depends on what it actually does.

In particular, if you can address multiple hardware units over one
character device, it may be better to have separate devices for each
of them.

> >> +     CG2900_INFO("test_char_dev_read");
> >> +
> >> +     if (skb_queue_empty(rx_queue))
> >> +             wait_event_interruptible(char_wait_queue,
> >> +                                      !(skb_queue_empty(rx_queue)));
> >> +
> >> +     skb = skb_dequeue(rx_queue);
> >> +     if (!skb) {
> >> +             CG2900_INFO("skb queue is empty - return with zero bytes");
> >> +             bytes_to_copy = 0;
> >> +             goto finished;
> >> +     }
> >> +
> >> +     bytes_to_copy = min(count, skb->len);
> >> +     err = copy_to_user(buf, skb->data, bytes_to_copy);
> >> +     if (err) {
> >> +             skb_queue_head(rx_queue, skb);
> >> +             return -EFAULT;
> >> +     }
> >> +
> >> +     skb_pull(skb, bytes_to_copy);
> >> +
> >> +     if (skb->len > 0)
> >> +             skb_queue_head(rx_queue, skb);
> >> +     else
> >> +             kfree_skb(skb);
> >> +
> >> +finished:
> >> +     return bytes_to_copy;
> >> +}
> >
> > This does not handle short/continued reads.
> >
> 
> As I mentioned above this interface is used for testing and we
> therefore have some restriction of usage. I don't think we need to
> impose all things necessary for a full interface upon it.

This is where it gets complicated. We don't normally add interfaces
to the kernel unless we expect to fully support them for the forseeable
future. It has happened more than enough in the past that somebody
introduced a debugging interface which subsequently became a supported
ABI because some application started relying on it.

Is the code that uses the test interface even publically available?
If not, I would recommend saving the trouble of arguing about it
and leaving out the interface.

> >> +     #define CG2900_ERR(fmt, arg...)                                 \
> >> +     do {                                                            \
> >> +             if (cg2900_debug_level >= 1)                            \
> >> +                     pr_err("CG2900 %s: " fmt "\n" , __func__ , ## arg); \
> >> +     } while (0)
> >> +
> >> +#endif /* NDEBUG */
> >
> > You'll feel relieved when all this is gone...
> >
> 
> The only thing is it's been pretty nice to have it, but I will remove it.
> Is it OK to keep defines so we can have "CG2900" in front and "\n"
> after the text?

Ideally, you would use the dev_* functions instead of the pr_* functions,
which print the name of the device before the message. I also wouldn't
add the "\n" in the macro because all the regular printing functions don't
do it. It will likely only confuse people and the binary remains the same.

	Arnd
