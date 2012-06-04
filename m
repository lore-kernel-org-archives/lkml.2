Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab2FDE3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:29:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38390 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab2FDE3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:29:07 -0400
Message-ID: <4FCC280C.6030103@landley.net>
Date: Sun, 03 Jun 2012 22:14:20 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Sagar Dharia <sdharia@codeaurora.org>
CC: davidb@codeaurora.org, bryanh@codeaurora.org, kheitke@codeaurora.org,
        marc@plastictigers.com, gclemson@audience.com,
        broonie@opensource.wolfsonmicro.com, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ohad@wizery.com, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, rusty@rustcorp.com.au, joerg.roedel@amd.com,
        trenn@suse.de, ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
In-Reply-To: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for taking so long, this is really huge and I get distracted every
5 minutes with other things. Also, you cc'd so many different people and
lists with this I'm reluctant to "reply all"...

I just care about the documentation here, so:

On 05/29/2012 08:11 PM, Sagar Dharia wrote:
> SLIMbus (Serial Low Power Interchip Media Bus) is a specification
> developed by MIPI (Mobile Industry Processor Interface) alliance.
> SLIMbus is a 2-wire implementation, which is used to communicate with
> peripheral components like audio. Commonly used digital audio
> interfaces such as I2S, PCM are intended for point-to-point connection
> between application processor and single audio device and support one
> or two channels. Adding more channels or functions is difficult
> without increasing number of bus structures and hence pin count.
> In parallel to audio channels, control buses such as I2C are typically
> used for low-bandwidth control tasks.
> SLIMbus replaces many digital audio buses and control buses by
> providing flexible and dynamic bus-bandwidth between data-functions
> and control-functions.

So that's a really long way of saying "A bit like I2C but faster"?

> The framework supports message APIs, channel scheduling for SLIMbus.
> Message APIs are used for status/control type of communication with a
> device. Data Channel APIs are used for setting data channels between
> SLIMbus devices.
> 
> Framework supports multiple busses (1 controller per bus) and multiple
> clients/slave devices per controller.
> 
> Signed-off-by: Sagar Dharia <sdharia@codeaurora.org>
> ---
>  Documentation/slimbus/slimbus-framework.txt |  319 +++
>  drivers/Kconfig                             |    2 +
>  drivers/Makefile                            |    1 +
>  drivers/of/of_slimbus.c                     |   89 +
>  drivers/slimbus/Kconfig                     |   10 +
>  drivers/slimbus/Makefile                    |    4 +
>  drivers/slimbus/slimbus.c                   | 3050 +++++++++++++++++++++++++++
>  include/linux/mod_devicetable.h             |    7 +
>  include/linux/of_slimbus.h                  |   34 +
>  include/linux/slimbus/slimbus.h             | 1072 ++++++++++

Slim?

methinks-the-lady-doth-protest-too-much-bus.

> diff --git a/Documentation/slimbus/slimbus-framework.txt b/Documentation/slimbus/slimbus-framework.txt
> new file mode 100644
> index 0000000..8c27597
> --- /dev/null
> +++ b/Documentation/slimbus/slimbus-framework.txt
> @@ -0,0 +1,319 @@
> +Introduction
> +============
> +
> +Slimbus (Serial Low Power Interchip Media Bus) is a specification developed by
> +MIPI (Mobile Industry Processor Interface) alliance. Slimbus is a 2-wire
> +implementation, which is used to communicate with peripheral components like
> +audio.

Fine so far.

> Commonly used digital audio interfaces such as I2S and PCM are intended
> +for point-to-point connection between application processor and single audio
> +device and support one or two channels. Adding more channels or functions is
> +difficult without increasing number of bus structures and hence pin count.
> +In parallel to audio channels, control buses such as I2C are typically used for
> +low-bandwidth control tasks.
> +
> +Slimbus replaces many digital audio buses and control buses by providing
> +flexible and dynamic bus-bandwidth between data-functions and control-functions.

This seems like an advertisement for your hardware choice. You really
don't have to compare yourself to other busses here, we're not hardware
engineers deciding what wires to run. We just want to know how to
program it.

I'm all for a document describing _your_ bus, but the above isn't it.

> +Hardware Description
> +====================
> +
> +Slimbus is a 2-wire multi-drop interface and uses TDM frame structure.
> +The devices communicate over a shared bus using predefined transport protocols.
> +There are 2 different type of transports.
> +
> +The message transport is used for various control functions such as bus
> +management, configuration and status updates. Messages are seen by all devices
> +and the messages can be of unicast and broadcast type. E.g. reading/writing
> +device specific values is typically a unicast message. A data channel
> +reconfiguration sequence is announced to all devices using a broadcast message.

Unicast messages are seen by all devices?

> +A data transport is used for data-transfer between 2 Slimbus devices. Data
> +transport uses dedicated ports on the device. This data-transfer is not seen
> +by all devices.

So data transport only offers unicast, then? Or does "seen by" here mean
that control messages (excuse me, "message messages") are transported in
an electrically different manner that allows any piece of hardware to
snoop on them, although it should never actually react to ones that
aren't addressed to it?

> +Slimbus specification has different types of device classifications based on
> +their capabilities.

I'm trying to figure out if that sentence conveys any information at all.

> A manager device is responsible for enumeration,
> +configuration, and dynamic channel allocation. Every bus has 1 active manager.
> +A framer device is responsible for driving the clock line and placing
> +information on the data line.

It's  nice to know that the 2 wires in the design are 'clock line' and
'data line'. Bit of reading to get to that point...

> Multiple framers may exist on a bus and a manager
> +is responsible for doing framer-handoffs.
> +(Not supported in the SW driver right now).

So each slimbus has 1 manager device that enumerates configures, and
allocates channels for the other devices on the bus. The rest are
"framer" devices that transmit data packets?

> +Per specification,

Ah, I'd assumed that everything in here was in flagrant violation of the
specification. Good to know.

> Slimbus uses "clock gears" to do power management based on
> +current frequency and bandwidth requirements. There are 10 clock gears and each
> +gear changes the Slimbus frequency to be twice its previous gear.

Ok, dynamic clock. Might have been nice to put it in the description.
(Nice of them to choose a range that _wasn't_ a power of 2...)

The base gear is what clock frequency?

> +A generic device is a device providing Slimbus functionality and typically has
> +ports for data-channel support. Its registers are mapped as 'value elements'
> +so that they can be written/read using Slimbus message transport for
> +exchanging control/status type of information. Generic devices are also referred
> +to as 'clients' in this document from here onward.

My eyes glazed over at "Its registers are mapped as 'value elements'"
and I started wondering if the API synergized their core competencies.

It would be nice if you could pick a name for things and stick with it.

> +Each device has a 6-byte enumeration-address and the manager assigns every
> +device with a 1-byte logical address after the devices report present on the
> +bus.
> +
> +Slimbus uses TDM framing at the physical layer and has a variable number of
> +frames used for messaging and data-channels. The TDM framing is out of scope
> +of this document since clients cannot directly access or interfere with it.

THEN WHY DO YOU EVEN MENTION IT HERE?

Please tell us how to program the hardware. Don't try to sell us on
Qualcomm's design choices. (I assume codeaurora is still qualcomm
pretending not to be, because Quic wasn't enough of a potholder for open
source to satisfy the lawyers who run the place? Doesn't matter...)

You refer to "per specification" a lot.  Is the specification online,
and if so would you like to link to it?

The weekend's over and this is as far as I managed to read.  I think
it's as far as I'm going to. Please add a link to the spec and I'll ACK
the doc even if it does seem more concerned with convincing people to
use the technology than explaining how to program it. (If we NAKed
documentation for being badly written we wouldn't have much.)

However, I expect some example code would be far more useful than this
document...

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
