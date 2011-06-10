Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1FJHTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:19:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab1FJHTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:19:51 -0400
Message-ID: <4DF1C57F.10801@redhat.com>
Date: Fri, 10 Jun 2011 09:19:27 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <20110610002103.GA7169@xanatos>
In-Reply-To: <20110610002103.GA7169@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/10/2011 02:21 AM, Sarah Sharp wrote:
> I'm pleased to announce a USB mini-summit at LinuxCon Vancouver.
>
> What:	USB mini-summit
> When:	Tuesday, August 16th, all day
> Where:	At the conference venue, room TBD pending confirmation from
> 	Angela Brown.
>
> Proposed topics include USB virtualization, and improved bandwidth APIs
> between the USB core and drivers (especially webcam drivers).  See the
> detailed topic list below.  Anyone is also welcome to propose or show up
> with a USB related topic.  MUSB?  USB 3.0 gadget drivers?  USB-IP?
>

I would like to give a short presentation on / demo off the usb redirection
over the network (USB-IP replacement with a less dumb protocol) I've been
working on, followed by a questions and answers session.

For those who want to give this a try now, see:
http://hansdegoede.livejournal.com/9682.html

Sheets from the presentation I gave on this at FOSDEM:
http://people.fedoraproject.org/~jwrdegoede/usb-redir.pdf

> The USB mini-summit does overlap with the virtualization mini-summit by
> a day, but I'm hoping we can schedule talks so some of the
> virtualization folks can make it to the USB mini-summit.  The other
> option was on Friday during the conference which was not ideal.
>
> Proposed topics:
>
> Topic 1
> -------
>
> The KVM folks suggested that it would be good to get USB and
> virtualization developers together to talk about how to virtualize the
> xHCI host controller.  The xHCI spec architect worked closely with
> VMWare to get some extra goodies in the spec to help virtualization, and
> I'd like to see the other virtualization developers take advantage of
> that.  I'd also like us to hash out any issues they have been finding in
> the USB core or xHCI driver during the virtualization effort.

I'm not really happy with how the management / hand over of userspace
to kernel space drivers and vice versa works. This is a problem when
doing usb-redirection to a virtual machine. I think this is best discussed
in a separate thread, and then if needed further discussed during the
mini summit. I'll send a mail on this shortly. I'll use the same address
list as this mail, except that I'm going to cut linux-kernel from the CC list.


> Topic 2
> -------
>
> I'd also like to get the V4L and audio developers who work with USB
> devices together with the core USB folks to talk about bandwidth
> management under xHCI.
>
> One of the issues is that since the xHCI hardware does bandwidth
> management, not the xHCI driver, a schedule that will take too much
> bandwidth will get rejected much sooner than any USB driver currently
> expects (during a call to usb_set_interface).  This poses issues, since
> most USB video drivers negotiate the video size and frame rate after
> they call usb_set_interface, so they don't know whether they can fall
> back to a less bandwidth-intensive setting.  Currently, they just submit
> URBs with less and less bandwidth until one interval setting gets
> accepted that won't work under xHCI.
>
> A second issue is that that some drivers need less bandwidth than the
> device advertises, and the xHCI driver currently uses whatever periodic
> interval the device advertises in its descriptors.  This is not what the
> video/audio driver wants, especially in the case of buggy high speed
> devices that advertise the interval in frames, not microframes.  There
> needs to be some way for the drivers to communicate their bandwidth
> needs to the USB core.  We've known about this issue for a while, and I
> think it's time to get everyone in the same room and hash out an API.

Interesting, being able to tell the core how much bandwidth a device
will actually use (versus what it claims as maxpacketsize in its
descriptors) is something which we really need. I know of at least
2 usb1 webcam chipsets (and drivers) which have only 1 altsetting which
claim 1023 bytes maxpacketsize. But they also have a register which
allows the driver to configure how large the largest (iso) packet it
sends will actually be.

Currently these drivers have this "beauty" to be able to tell the
linux usb core that they won't be using 1023 as maxpacketsize but
something else, and thus function without needing full usb1 bandwidth:

struct usb_host_interface *alt;
alt = &gspca_dev->dev->config->intf_cache[0]->altsetting[1];
alt->endpoint[0].desc.wMaxPacketSize = cpu_to_le16(packet_size);
ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, 1);

Yes they are overwriting the kernels cached descriptors ...

###

Something which I would also like to bring to everyone's attention
is that we really need to fix the ehci schedule code wrt scheduling
usb1 transfers over usb2 hubs.

The current code is very broken when it comes to periodic transfers,
it basically disallows using the last microframe (let alone the
crossing of the frame boundary and using the first microframe of
the next frame).

This means that trying to submit isoc transfers with a size of 1023
will just plain fail, even if this is the only device on the entire
bus. This is one of the reasons I ended up doing the hack above, so
that these devices will at least work (be it at a decreased framerate)
through a usb2 hub.

Things become even messier when the device has a build in usb audio
microphone, often this will just not work.

Finally fixing this has become more important now then ever since
sandybridge machines (and maybe generation one core i# machines too,
I don't know) no longer have a companion controller, but instead
have an integrated usb2 hub.

Regards,

Hans
