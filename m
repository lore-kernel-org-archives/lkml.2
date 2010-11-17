Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412Ab0KQWLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:11:04 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:22276
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758606Ab0KQWLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:11:02 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h637h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CE452CD.3050001@freescale.com>
Date: Wed, 17 Nov 2010 16:10:21 -0600
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
References: <4CE44B1B.9040709@freescale.com> <20101117215147.GA26792@suse.de>
In-Reply-To: <20101117215147.GA26792@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 22:11:23.0497 (UTC) FILETIME=[5EE44D90:01CB86A4]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> What is ePAPR?

It's a specification for an interface between the boot loader and the operating
system.  It's based on the device tree model that exists on PowerPC today.
ePAPR defines a bunch of extensions, including one for hypervisors.  The byte
channel concept is an example of that.

> Why would you need this mapping?  Just do a first-come-first serve
> assignment of tty minor devices like all other subsystems do (usb,
> serial, acm, etc.)

Without some kind of mapping, there's no way for an application to know which
/dev entry to open.  Each byte channel goes to a different

> 
> sysfs will show the representation between your ePAPR device "handle"
> and the tty device minor just fine, as it does today for those other
> types of devices.

I don't see how.  A byte channel node defines several properties, one of which
could be a text string that acts as a label.  So if an application is looking
for the "channel-to-partition-two" byte channel, it can search for that string
in the device tree.  Once it finds the matching node, it can extract the byte
channel handle.

At this point, the application will want to open a /dev entry that corresponds
to that byte channel handle.  This is the piece I'm missing with the tty layer.

If I want to create a regular character device, I can do this:

bc->dev_id = MKDEV(MAJOR(dev_id), MINOR(dev_id) + i);
device_create(ehv_bc_class, NULL, bc->dev_id, bc, "bc%u", bc->handle);

Here, I control the name of the /dev entry via "bc%u".  I want something similar
for tty devices.

> Bonus being that udev will create a persistant device id for your tty
> device based on that handle so you can just open that if you want to, no
> need to get the kernel involved in sparse minor mappings at all.

I'm not sure I understand that.  In order for udev to do this, I need to tell it
what the byte channel handle actually is.  How do I do that using the tty layer?

-- 
Timur Tabi
Linux kernel developer at Freescale

