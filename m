Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1HWXYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:24:50 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:53615 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755110Ab1HWXYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:24:44 -0400
Date: Tue, 23 Aug 2011 16:24:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org, arnd@arndb.de,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-Id: <20110823162441.4a412869.rdunlap@xenotime.net>
In-Reply-To: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Aug 2011 17:31:28 -0600 Kenneth Heitke wrote:

> From: Sagar Dharia <sdharia@codeaurora.org>
> 
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
> 
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
>  Documentation/slimbus/slimbus-framework.txt |  282 +++
>  drivers/Kconfig                             |    2 +
>  drivers/Makefile                            |    1 +
>  drivers/slimbus/Kconfig                     |   10 +
>  drivers/slimbus/Makefile                    |    4 +
>  drivers/slimbus/slimbus.c                   | 2629 +++++++++++++++++++++++++++
>  include/linux/mod_devicetable.h             |    9 +
>  include/linux/slimbus/slimbus.h             |  939 ++++++++++
>  8 files changed, 3876 insertions(+), 0 deletions(-)
>  create mode 100755 Documentation/slimbus/slimbus-framework.txt
>  create mode 100644 drivers/slimbus/Kconfig
>  create mode 100644 drivers/slimbus/Makefile
>  create mode 100644 drivers/slimbus/slimbus.c
>  create mode 100644 include/linux/slimbus/slimbus.h
> 
> diff --git a/Documentation/slimbus/slimbus-framework.txt b/Documentation/slimbus/slimbus-framework.txt
> new file mode 100755
> index 0000000..a091417
> --- /dev/null
> +++ b/Documentation/slimbus/slimbus-framework.txt
> @@ -0,0 +1,282 @@
> +Introduction
> +============
> +
> +Slimbus (Serial Low Power Interchip Media Bus) is a specification developed by
> +MIPI (Mobile Industry Processor Interface) alliance. Slimbus is a 2-wire
> +implementation, which is used to communicate with peripheral components like
> +audio. Commonly used digital audio interfaces such as I2S, PCM are intended for

                                                         I2S and PCM

> +point-to-point connection between application processor and single audio device
> +and support one or two channels. Adding more channels or functions is difficult
> +without increasing number of bus structures and hence pin count. In parallel to
> +audio channels, control buses such as I2C are typically used for low-bandwidth
> +control tasks.
> +
> +Slimbus replaces many digital audio buses and control buses by providing
> +flexible and dynamic bus-bandwidth between data-functions and control-functions.
> +
> +
> +
> +Hardware Description
> +====================
> +
> +Slimbus is a 2-wire multi-drop interface and uses TDM frame structure.
> +The devices communicate over a shared bus using predefined transport protocols.
> +There are 2 different type of transports.
> +
> +The message transport is used for various control functions such as bus
> +management, configuration and status updates. Messages are seen by all devices
> +and the messages can be of unicast and broadcast type. e.g. Reading/writing

                                                          E.g., reading/writing

> +device specific values is typically a unicast message. A data channel
> +reconfiguration sequence is announced to all devices using broadcast message.

                                                        using a broadcast message.

> +
> +A data transport is used for data-transfer between 2 Slimbus devices. Data
> +transport uses dedicated ports on the device. This data-transfer is not seen
> +by all devices.
> +
> +Slimbus specification has different types of device classifications based on
> +their capabilities. Manager device is responsible for enumeration,

                       A manager device

> +configuration, and dynamic channel allocation. Every bus has 1 active manager.
> +Framer device is responsible for driving clock line and placing information on

   A framer device is responsible for driving the clock line

[There are lots of missing article adjectives here for some reason.]

> +data line. Multiple framers may exist on a bus and manager is responsible for

   the data line.                                 and a manager is

> +doing framer-handoffs. (Not supported in the SW driver right now).
> +
> +Per specification, Slimbus uses "clock gears" to do power management based on
> +current frequency and bandwidth requirements. There are 10 clock gears and each
> +gear changes the Slimbus frequency to be twice of its previous gear.

                                      to be twice its previous gear.

> +
> +Generic device is a device providing Slimbus functionality and typically has

   A generic device

> +ports for data-channel support. Its registers are mapped as 'value elements'
> +so that they can be written/read using Slimbus message transport for
> +exchanging control/status type of information. Generic devices are also referred
> +to as 'clients' in this document from here-onwards.

                                         here onward.

> +
> +Each device has a 6-byte elemental-address and the manager assigns every device
> +with a 1-byte logical address after the devices report present on the bus.
> +
> +Slimbus uses TDM framing at the physical layer and has variable number of

                                                  and has a variable

> +frames used for messaging and data-channels. The TDM framing is out of scope
> +of this document since clients can not directly access or interfere with it.

                                  cannot

> +
> +
> +
> +Software Description:
> +====================
> +
> +Initialization/Bringup:
> +-----------------------
> +Each bus has one active manager and that is represented by slim_controller
> +data structure. The controller is probed during initial kernel bring-up and it
> +is responsible to probe other "Generic Devices" and "Framer Devices". All
> +devices report present (Broadcast message) after they are probed and
> +manager stores their elemental addresses and assigns logical addresses. Clients

  the manager

> +get their logical address by calling a public API in case they don't get
> +interrupt after receiving the message.

   an interrupt

> +
> +Clients are added using similar logic to I2C. (There is one controller per

                     using logic similar to I2C.

> +Slimbus who does active-manager duties. Each controller has a bus-number and
> +the clients are populated in boards file on that controller). This way, it is
> +more target-independent. In addition, clients can be added to the controller
> +using add_device API. This is useful if the client is to be added later

   using the add_device API.

> +(as a module). It is also useful if each slave can have multiple elemental
> +generic devices but only one driver. The generic device (slave) driver can then
> +add more devices per its capability and still have 1 driver.
> +
> +Framers are also added per numbered controller and they are expected to
> +initialize/enable clock related hardware in their probe. It may be common to
> +have 1 driver for manager (controller) and framer. In that case, separate framer

                                                                    a separate

> +device and/or driver is not needed. Framer handover can be used by controller to

                                                                   by {a | the} controller

> +change framer per Slimbus spec, but the capability is not currently implemented

   change the framer

> +in this framework yet.
> +
> +Message-based APIs:
> +-------------------
> +As described earlier, control and status information can be exchanged on
> +Slimbus. Slimbus client device driver can write/read control registers using the

            A Slimbus client

> +message-based APIs for doing elemental accesses. Per Slimbus specification,
> +there are two type of elements in every device. Value based (values can be

                                  in every device:

> +read/written) and information based (bit-wise information can be set/cleared).
> +Slimbus slave device driver can call these APIs. This typically replaces I2C

   A Slimbus slave

> +type of control/status transaction. Framework makes sanity checks based on

                                       The framework

> +Slimbus specification and then calls controller specific message transfer

                         and then calls a controller-specific

> +function pointer. The sanity checks make sure that accesses to reserved-address
> +space are not allowed, or the size of message isn't out-of-bounds per the
> +specification.
> +
> +Messages are queued in a work-queue (per controller). Slimbus specification has

                                                         The Slimbus specification has a

> +transaction identification number (TID) for each transaction expecting response.

                                                                expecting a response.

> +The transaction message is kept per controller until response is received, or

                                                  until a response

> +write-acknowledgement is received.
> +
> +Client can request to reserve certain bandwidth for messaging if it anticipates

   A client

> +heavy messaging-traffic on the bus. Slimbus framework tries to reserve the

                                       The Slimbus framework

> +messaging bandwidth and may decide to change clock frequency (clock gear)
> +based on existing data-channels on the bus and current frequency (clock gear),
> +and pre-existing reserved-message bandwidth. Reserving bandwidth will fail if
> +clock gear is already maximum and pre-existing data channels and the newly


   the clock gear

> +requested reserved bandwidth cannot be satisfied.
> +
> +Data Channel based APIs:
> +------------------------
> +Data channels can be setup between 2 devices using their data ports. Per
> +Slimbus specification, there can be multiple sources and one sink per one data
> +channel. Each data channel is uniquely defined by its location in the TDM frame.
> +Every manager device also typically has many ports and they are used for data
> +transfer between software and the device. Ports have different configuration and
> +request types. For each half-duplex port, 2 adjacent physical ports are located.
> +
> +A port can have source or sink flow. Port has events/errors associated with it.

                                        A port

> +Typically, client requests ports on manager and slave devices. That causes a

              a client

> +Slimbus specification message to be sent to the device (connect-source or
> +connect-sink). Once the port allocation is done, client requests for channel to

                                                    the client requests

> +be allocated using the ports it has. Data channel has different protocols
> +(such as isochronous, soft-isochronous, asynchronous) based on the clock at
> +which Slimbus runs and the channel bandwidth requirements. Clients specify rate
> +and the protocol to allocate channel. Clients then call transfer on the port

                    to allocate a channel.

> +with the input/output vectors and specify completion structure to be notified.
> +Clients then call channel activation API to activate the channel.
> +
> +Channels with common parameters can benefit from grouping. Grouping channels
> +helps to schedule/deactive a set of channels at the same time. (e.g. 5.1 audio).

                     deactivate                 at the same time (e.g., 5.1 audio).

> +Framework signals completion when the buffers are done and it's upto client to

   The framework                                                   up to the client to

> +supply more buffers and/or deactivate the channel. Completion signal is also
> +used to communicate port errors to the client. It's upto the client to act

                                                       up to

> +according to the error.  Activation/Deactivation can be done on a pre-existing

                                                                on pre-existing

> +channels. Clients can call deallocation APIs on channels and/or ports when they
> +no longer need the resources.
> +
> +Clients use "commit" flag in the control channel APIs to group their requests.
> +This avoids sending the expensive reconfiguration sequence on the bus too
> +frequently. Once the "commit" flag is set, all channel-requests pending on that
> +client are acted upon (active-channels are scheduled, remove-channels are
> +removed from scheduling etc.)

           from scheduling, etc.).

> +
> +Scheduling of channels: Controller and/or framework will call API to reschedule
> +TDM framing as it is deemed necessary. This is internally implemented by the
> +framework based on current data-channel and message bandwidth requirements.
> +Controller may also change scheduling of already active-channels to use TDM
> +effectively.
> +
> +
> +
> +Design
> +======
> +Bus-type:
> +---------
> +Slimbus is represented as a bus and different type of devices listed above hang

                                                 types

> +on it. The bus registers with Linux kernel in early stages of kernel bringup.
> +Every Slimbus typically has one manager device, one framer device, and multiple
> +generic devices (clients). When a device is added/registered, Slimbus matches a
> +driver (registered earlier) and calls the driver probe.
> +
> +Message transactions:
> +---------------------
> +For faster and efficient transaction management, Linux framework uses tid for
> +every transaction irrespective of whether it expects a response. This helps in
> +O(1) search of the transaction when it's complete, or its response is received,
> +or it needs to be resent due to collision/NACK. Once transaction is complete,

                                                   Once a transaction

> +its resources are just marked unused and not deleted. A transaction is allocated
> +if an unused transaction is not found. Per Slimbus specification, TID is 8-bit

                                                                            8 bits

> +long and cannot exceed 256. So this won't cause a lot of memory usage and

            cannot exceed 256, so

> +allocation for transactions won't be required to be done too often.
> +
> +Ports and channels:
> +-------------------
> +Manager-ports and channels are allocated as arrays. This helps faster access
> +based on channel/port number. Typically number of ports and channels are limited

                                 Typically the number

> +and having this as a list won't gain significant memory advantage.
> +
> +For effective scheduling, 2 most commonly used frequency-channels (4KHz and

                             the 2 most

> +12KHz) are grouped in 2 sorted lists. The lists only have pointers (to channel
> +elements allocated above).
> +
> +
> +Power Management
> +================
> +Slimbus hardware uses only 2 wires for managing multiple devices, multiple
> +channels and control/status messaging. This is power efficient. In addition,
> +clock gears are used to go to lower clock gears when low-bandwidth messaging
> +is used and/or limited data channels are used. Controller will call clock-pause
> +API to pause the slimbus clock if no channels are active.

                    Slimbus

> +
> +Runtime suspend/resume will be used from Linux kernel power management
> +framework to implement power management functionality.
> +
> +
> +
> +SMP/multi-core
> +==============
> +Board initialization list for listing devices, framers use a board-specific
> +mutex. This mutex is common to all controllers.
> +
> +Controllers are listed in the framework using idr list. The list is protected by
> +a common mutex.
> +
> +Controller data structures (channel, port, address-table, transaction-id table)
> +are protected using a controller mutex.
> +
> +Reconfiguration mutex per controller is used to make sure that only one
> +reconfiguration sequence is in progress per controller.
> +
> +Client structure has a mutex to protect the pending data channel request-lists
> +per client.
> +
> +
> +
> +Security
> +========
> +None at this point.
> +
> +
> +
> +Interface
> +=========
> +There is no plan of exporting slimbus functionality to user space right now.
> +
> +Kernel space APIs:
> +include/linux/slimbus/slimbus.h
> +-----------------------
> +
> +
> +
> +Driver parameters
> +=================
> +None.
> +
> +
> +
> +Config options
> +==============
> +Slimbus in drivers/Kconfig
> +
> +
> +
> +Dependencies
> +============
> +None.
> +
> +
> +
> +User space utilities
> +====================
> +None at this point. No user space access is expected for Slimbus at this point.
> +If need be, a client can be implemented to manage all use-space accesses

                                                         user-space

> +using ioctl.
> +
> +
> +
> +Known issues
> +============
> +None.
> +
> +
> +
> +To do
> +=====
> +Framer handoff is not supported right now. This is required when a bus has
> +multiple framers and active framer needs to be decided on the fly.

                    and the active

> +
> +Specific logical address request is not supported right now. Client drivers may
> +request for specific logical address and that may change logical addresses of
> +other preexisting devices on the bus.
> +
> +Debugfs will be used to debug channel management and bandwidth usage in future.


> diff --git a/drivers/slimbus/slimbus.c b/drivers/slimbus/slimbus.c
> new file mode 100644
> index 0000000..313837a
> --- /dev/null
> +++ b/drivers/slimbus/slimbus.c
> @@ -0,0 +1,2629 @@
> +/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.

> +/*
> + * slim_driver_register: Client driver registration with slimbus
> + * @drv:Client driver to be associated with client-device.

This is very close to kernel-doc notation.
Can you just make it be kernel-doc, please?
(same comment for many such cases in the source code)


> + * This API will register the client driver with the slimbus
> + * It is called from the driver's module-init function.
> + */
> +int slim_driver_register(struct slim_driver *drv)
> +{
> +	drv->driver.bus = &slimbus_type;
> +	if (drv->probe)
> +		drv->driver.probe = slim_drv_probe;
> +
> +	if (drv->remove)
> +		drv->driver.remove = slim_drv_remove;
> +
> +	if (drv->shutdown)
> +		drv->driver.shutdown = slim_drv_shutdown;
> +
> +	return driver_register(&drv->driver);
> +}
> +EXPORT_SYMBOL_GPL(slim_driver_register);

> +/*
> + * slim_add_device: Add a new device without register board info.
> + * @ctrl: Controller to which this device is to be added to.

    * @sbdev: <description>

> + * Called when device doesn't have an explicit client-driver to be probed, or
> + * the client-driver is a module installed dynamically.
> + */
> +int slim_add_device(struct slim_controller *ctrl, struct slim_device *sbdev)
> +{



> diff --git a/include/linux/slimbus/slimbus.h b/include/linux/slimbus/slimbus.h
> new file mode 100644
> index 0000000..79dabce5
> --- /dev/null
> +++ b/include/linux/slimbus/slimbus.h
> @@ -0,0 +1,939 @@
> +/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
> + */
> +
> +#ifndef _LINUX_SLIMBUS_H
> +#define _LINUX_SLIMBUS_H
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/mutex.h>
> +#include <linux/mod_devicetable.h>
> +
> +/*

   /**
    * struct slim_ele_access - <description>

> + * @start_offset: Specifies starting offset in information/value element map
> + * @num_bytes: Can be 1, 2, 3, 4, 6, 8, 12, 16 per spec. This ensures that the
> + *	message will fit in the 40-byte message limit and the slicesize can be
> + *	compatible with values in table 21 (slimbus spec 1.01.01)
> + * @comp: Completion to indicate end of message-transfer. Used if client wishes
> + *	to use the API asynchronously.
> + */
> +struct slim_ele_access {
> +	u16			start_offset;
> +	u8			num_bytes;
> +	struct completion	*comp;
> +};


> +/*
> + * slim_register_board_info: Board-initialization routine.
> + * @info: List of all devices on all controllers present on the board.
> + * @n: number of entries.
> + * API enumerates respective devices on corresponding controller.
> + * Called from board-init function.
> + */
> +#ifdef CONFIG_SLIMBUS
> +extern int slim_register_board_info(struct slim_boardinfo const *info,
> +					unsigned n);
> +#else
> +int slim_register_board_info(struct slim_boardinfo const *info,
> +					unsigned n)

static inline ?

> +{
> +	return 0;
> +}
> +#endif


[Sorry about my delayed comments.]

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
