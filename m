Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab2HQJWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:22:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:48726 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933797Ab2HQJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:22:08 -0400
Message-ID: <502E0D3B.10006@linutronix.de>
Date: Fri, 17 Aug 2012 11:22:03 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Joel Becker <jlbec@evilplan.org>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] USB gadget - configfs
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com> <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com> <000501cd5e79$a770be50$f6523af0$%p@samsung.com> <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com> <000101cd7bb1$73f36050$5bda20f0$%p@samsung.com> <502CF9E3.2010608@linutronix.de> <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com>
In-Reply-To: <20120817014609.GB2949@dhcp-172-17-9-228.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 03:46 AM, Joel Becker wrote:
>> The configuration has to remain unchanged until the "connect" attribute
>> is changed (i.e. unconnected). That means the gadget can only be
>> reconfigured once it is not active.
>
> 	Yes, that's my understanding of the driver code.  What I'm
> trying to understand is the trigger for setting connect=1.  See, all of
> the other configfs steps you outlined make sense to me as "part of the
> gadget's internal state".  While I don't know what C1 and F1 are (I
> assume G1 is Gadget1), I don't know that it matters.

That is part of the abstracted configuration from the UDC [0] side:

- You have at least one "gadget" denoted as G1 here. You could have
   more of them. The second would be named G2 in this example. Each
   gadget requires one UDC.

- each gadget has at least one configuration descriptor denoted as C1
   here. It contains information like VID/PID numbers. You could have
   two configurations, where the first one is used if you have a lot of
   current available (on host's USB port) and the second where you can
   only use the minimum current which is "required" by the USB spec.

- each configuration has at least one function or interface. Denoted as
   F1 here. A function is for instance a "mass storage" or a "network"
   gadget.

So you _could_ have C1 with F1 as storage and F2 as network and C2 with
F1 as network. Within a config (C*) the functions are independent (that
means F1 und C1 can be != to F1 in C2)

The practical use case would to have a gadget with storage and network
available but if there is not much current available (and you can't
power the disk), the host would select C2 and have only the network
function.

> 	What changes the state to "active"?  That is, what triggers
> setting connect=1?

First, the user on the UDC side (the script on UDC side) has to
configure the gadget i.e. assign the LUN property to the mass storage
gadget or the MAC address for the network gadget.
Once all configuration is complete, the gadget can be considered as
"ready". configfs will be notified once gadget is considered as ready.

 From this point on, the user (of the host) can take a USB cable, plug
into his host and the UDC (gadget) will be enumerated.

Plugging the cable prior the "ready" point would result either in
"nothing" (the host wouldn't notice that a cable has been plugged) or
with a message "the device can't be enumerated".

So back to your question: "connect=1" is triggered by the person that
has the physical power over the cable. But you should have the gadget
configured prior this point _or_ ignore the host and configure the
gadget later.

To give you another example: Your cellphone does not have a gadget in
"ready" state and you plug the cable ("connect=1") into it. The
cellphone notices the plug and gives you the following and the screen:
"Hello good sir. Please choose: a) mass storage or b) MTP something".

Once you pick a or b on your cellphone, the script would activate one
of the two gadgets (sym link it to the UDC in configfs probably) and
it would be seen by the host.

> Is it just part of the flow of power-up, or is there
> some separation between "setting myself up" and "seeing that a host
> wants to talk to me"?

There is a separation between "setting myself up" and "seeing that a
host wants to talk to me". You are a woman. And if you not done yet
done you ignore the host until you are ready. Can also be ready before
the host wants to talk to you. It depends on your mood / use case (give
the use the choice between storage & network and offer always both
because we are self powered).

However it is important that once the configuration on UDC side is done
(or ready) it remains unchanged until you remove it from UDC ("de-ready
it to configfs) and change all attributes.
You shouldn't change the LUN attribute of the mass storage device while
it is active as it has no way to tell the host so.

[0] USB Device Controller. This part where the USB gadget is running.

> Joel

Sebastian
