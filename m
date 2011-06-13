Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1FMRLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:11:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:44730 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab1FMRLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:11:45 -0400
Subject: Re: USB mini-summit at LinuxCon Vancouver
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20110613162912.GA1705@kroah.com>
Date: Mon, 13 Jun 2011 19:11:39 +0200
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libusb-devel@lists.sourceforge.net" 
	<libusb-devel@lists.sourceforge.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "hector@marcansoft.com" <hector@marcansoft.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans de Goede <hdegoede@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <876F6D51-0E82-4FAD-AD9B-A6D336B72A42@suse.de>
References: <20110610002103.GA7169@xanatos> <20110610031805.GA15774@kroah.com> <20110610194815.GA6646@xanatos> <20110610205035.GC13450@kroah.com> <5330D332-119F-40AD-B06F-CEDBD0D02D8D@suse.de> <20110613162912.GA1705@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13.06.2011, at 18:29, Greg KH wrote:

> On Mon, Jun 13, 2011 at 12:44:57PM +0200, Alexander Graf wrote:
>> 
>> Am 10.06.2011 um 22:50 schrieb Greg KH <greg@kroah.com>:
>> 
>>> On Fri, Jun 10, 2011 at 12:48:15PM -0700, Sarah Sharp wrote:
>>>> On Thu, Jun 09, 2011 at 08:18:05PM -0700, Greg KH wrote:
>>>>> On Thu, Jun 09, 2011 at 05:21:03PM -0700, Sarah Sharp wrote:
>>>>>> Topic 1
>>>>>> -------
>>>>>> 
>>>>>> The KVM folks suggested that it would be good to get USB and
>>>>>> virtualization developers together to talk about how to virtualize the
>>>>>> xHCI host controller.  The xHCI spec architect worked closely with
>>>>>> VMWare to get some extra goodies in the spec to help virtualization, and
>>>>>> I'd like to see the other virtualization developers take advantage of
>>>>>> that.  I'd also like us to hash out any issues they have been finding in
>>>>>> the USB core or xHCI driver during the virtualization effort.
>>>>> 
>>>>> Do people really want to virtualize the whole xHCI controller, or just
>>>>> specific ports or devices to the guest operating system?
>>>> 
>>>> A host OS could chose to virtualize the whole xHCI controller if it
>>>> wanted to.  That's part of the reason why xHCI does all the bandwidth
>>>> checking in hardware, not in software.
>>> 
>>> And here I thought it did that so it would be "correct" :)
>>> 
>>>> 
>>>>> If just specific ports, would something like usbip be better for virtual
>>>>> machines, with the USB traffic going over the network connection between
>>>>> the guest/host?
>>>> 
>>>> It could be done that way too.  But that doesn't help if you're trying
>>>> to run Windows under Linux, right?  Only if all the guest OSes use the
>>>> same USB IP protocol then it would work.
>>> 
>>> usbip works on Windows as well as Linux.
>> 
>> Do you have a reliable, working usbip solution at hand that work on
>> Windows and Linux and doesn't require real network access, which can
>> be a no-go for some scenarios?
> 
> What do you mean by "real network access"?  A virtual network connection
> to the guest and host should be sufficient, right?

Yes, which would either mean we inject a second network adapter into the guest which needs to be configured to an IP address, hence possibly colliding with some other IP range that's in use outside, or reuse some real network connection, which is neither always given, nor always desired. We have a full new PV serial protocol (virtio-serial) just for exactly that reason: To be able to run a daemon inside the guest that does not require IP access to talk to the host.

USB/IP really has its own huge set of issues. Sure, it might be good for certain use cases, but it's definitely not a one-size-fits-all solution. But so far, doing FV emulation right has worked out a lot better for most use cases than inventing PV solutions. Real hardware simply seems to be supported by others, while we can't afford to write drivers for all OSs :). So IMHO, PV should be the last resort, when emulating real hardware utterly fails. In this case, I believe the hardware designers finally got the spec usable for us, so it should be good! :)

> 
>>> But how could you run Windows with a xHCI controller in a guest, as
>>> Windows has no xHCI driver?  What would it expect to see?
>> 
>> There are drivers for xhci adapters on Windows.
> 
> Not well-working ones, see the windows driver mailing list as well as
> the libusb mailing list for problems that people are having due to there
> not being any "official" Microsoft xhci drivers shipping yet.

Yes, which is an issue that's hopefully gone when we're finally having xHCI actually properly emulated and all the infrastructure for it laid out. We still have UHCI and OHCI emulation today already to fall back to if really necessary, but installing an xHCI driver inside the guest really isn't more work than installing USB/IP inside the guest.


Alex

