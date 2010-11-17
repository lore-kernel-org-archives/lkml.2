Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935610Ab0KQWmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:42:53 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:29563
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935070Ab0KQWmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:42:52 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz98dNzz1202hzzz2dh2a8h637h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
Message-ID: <4CE45A4E.70308@freescale.com>
Date: Wed, 17 Nov 2010 16:42:22 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <4CE44B1B.9040709@freescale.com> <20101117215147.GA26792@suse.de> <4CE452CD.3050001@freescale.com> <20101117221903.GA4066@suse.de>
In-Reply-To: <20101117221903.GA4066@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 22:43:23.0999 (UTC) FILETIME=[D799A6F0:01CB86A8]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> I think you are forgetting that your byte channel devices must be
> "devices" in the system here, right?  There is a 'struct bus_id" for
> your bus that these devices live on.

Do you mean "struct bus_type"?  I don't have any concept of a "bus" in my
driver.  I didn't know I needed to create one, and I'm not sure how, either.

I guess my real problem is that I'm not really sure what I should be doing.  I
already have a plain character driver that creates devices for each byte
channel.  First I call alloc_chrdev_region() to get a started dev_id.  Then I
iterate over the byte channels and call device_create() for each one, with NULL
for the parent.  At the end, I call cdev_init() and cdev_add().

Now I'm trying to register these byte channels as tty devices, because I'd like
to use them for the system console, and not just plain character devices.  My
plan was to just call tty_register_device() instead of device_create(), so I
don't understand where the "bus" comes in.  What bus?

>  Then you create a tty device in
> your tty driver that attaches to the byte channel that shows up as a tty
> device on your bus.

Are you saying that when I call tty_register_device(), the third parameter
should be the return value from the previous call to device_create(), like this:

bc->dev_id = MKDEV(MAJOR(dev_id), MINOR(dev_id) + i);
bc->dev = device_create(ehv_bc_class, NULL, bc->dev_id, bc, "bc%u", bc->handle);
tty_register_device(ehv_bc_driver, MINOR(bc->dev_id), bc->dev);

-- 
Timur Tabi
Linux kernel developer at Freescale

