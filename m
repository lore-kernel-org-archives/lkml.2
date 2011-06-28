Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1F1XpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:45:03 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:39233 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752513Ab1F1Xo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:44:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QtQJYBr2EeeO/0Ak7xsG6UOfdhmubmbsUiDl5sudPXT/wDsWoqEDAL4f3+YGwoG4oR08ufrKW+bA7AnGlSsDhpMD5e+NOHmgvlPI+TpvGaWFxioX3ocMjSnSclPwBztT;
Date: Tue, 28 Jun 2011 16:44:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <akpm@linux-foundation.org>,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor
 messaging bus
Message-Id: <20110628164453.aa85c85c.rdunlap@xenotime.net>
In-Reply-To: <1308640714-17961-8-git-send-email-ohad@wizery.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<1308640714-17961-8-git-send-email-ohad@wizery.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011 10:18:33 +0300 Ohad Ben-Cohen wrote:

> Add a virtio-based IPC bus, which enables kernel users to communicate
> with remote processors over shared memory using a simple messaging
> protocol.
> 
> Assign a local address for every local endpoint that is created,
> and bind it to the user's callback. Invoke that callback when the
> destination of an inbound message is the user's address.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-rpmsg |   75 +++
>  Documentation/rpmsg.txt                   |  308 +++++++++
>  drivers/Kconfig                           |    1 +
>  drivers/Makefile                          |    1 +
>  drivers/rpmsg/Kconfig                     |   14 +
>  drivers/rpmsg/Makefile                    |    1 +
>  drivers/rpmsg/virtio_rpmsg_bus.c          | 1036 +++++++++++++++++++++++++++++
>  include/linux/mod_devicetable.h           |   10 +
>  include/linux/rpmsg.h                     |  421 ++++++++++++
>  include/linux/virtio_ids.h                |    1 +
>  10 files changed, 1868 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-rpmsg
>  create mode 100644 Documentation/rpmsg.txt
>  create mode 100644 drivers/rpmsg/Kconfig
>  create mode 100644 drivers/rpmsg/Makefile
>  create mode 100644 drivers/rpmsg/virtio_rpmsg_bus.c
>  create mode 100644 include/linux/rpmsg.h


> diff --git a/Documentation/rpmsg.txt b/Documentation/rpmsg.txt
> new file mode 100644
> index 0000000..0a7c820
> --- /dev/null
> +++ b/Documentation/rpmsg.txt
> @@ -0,0 +1,308 @@
> +Remote Processor Messaging (rpmsg) Framework
> +
> +1. Introduction
> +
> +Modern SoCs typically employ heterogeneous remote processor devices in
> +asymmetric multiprocessing (AMP) configurations, which may be running
> +different instances of operating system, whether it's Linux or any other
> +flavor of real-time OS.
> +
> +OMAP4, for example, has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP.
> +Typically, the dual cortex-A9 is running Linux in a SMP configuration,
> +and each of the other three cores (two M3 cores and a DSP) is running
> +its own instance of RTOS in an AMP configuration.
> +
> +Typically AMP remote processors employ dedicated DSP codecs and multimedia
> +hardware accelerators, and therefore are often used to offload cpu-intensive

prefer:                                                           CPU-
throughout.

> +multimedia tasks from the main application processor.
> +
> +These remote processors could also be used to control latency-sensitive
> +sensors, drive random hardware blocks, or just perform background tasks
> +while the main CPU is idling.
> +
> +Users of those remote processors can either be userland apps (e.g. multimedia
> +frameworks talking with remote OMX components) or kernel drivers (controlling
> +hardware accessible only by the remote processor, reserving kernel-controlled
> +resources on behalf of the remote processor, etc..).
> +
> +Rpmsg is a virtio-based messaging bus that allows kernel drivers to communicate
> +with remote processors available on the system. In turn, drivers could then
> +expose appropriate user space interfaces, if needed.
> +
> +When writing a driver that exposes rpmsg communication to userland, please
> +keep in mind that remote processors might have direct access to the
> +system's physical memory and/or other sensitive hardware resources (e.g. on
> +OMAP4, remote cores (/hardware accelerators) may have direct access to the
> +physical memory, gpio banks, dma controllers, i2c bus, gptimers, mailbox
> +devices, hwspinlocks, etc..). Moreover, those remote processors might be
> +running RTOS where every task can access the entire memory/devices exposed
> +to the processor. To minimize the risks of rogue (/buggy) userland code

What is with the leading / here and above (/hardware) and below?
Looks like they can all be dropped.

> +exploiting (/triggering) remote bugs, and by that taking over (/down) the
> +system, it is often desired to limit userland to specific rpmsg channels (see
> +definition below) it is allowed to send messages on, and if possible/relevant,
> +minimize the amount of control it has over the content of the messages.
> +
> +Every rpmsg device is a communication channel with a remote processor (thus
> +rpmsg devices are called channels). Channels are identified by a textual name
> +and have a local ("source") rpmsg address, and remote ("destination") rpmsg
> +address.
> +
> +When a driver starts listening on a channel, it binds it with a unique
> +rpmsg src address (a 32 bits integer). This way when inbound messages arrive

                     (a 32-bit integer).

> +to this src address, the rpmsg core dispatches them to that driver (by invoking
> +the driver's rx handler with the payload of the incoming message).
> +
> +
> +2. User API
> +
> +  int rpmsg_send(struct rpmsg_channel *rpdev, void *data, int len);
> +   - sends a message across to the remote processor on a given channel.
> +     The caller should specify the channel, the data it wants to send,
> +     and its length (in bytes). The message will be sent on the specified
> +     channel, i.e. its source and destination address fields will be
> +     set to the channel's src and dst addresses.
> +
> +     In case there are no TX buffers available, the function will block until
> +     one becomes available (i.e. until the remote processor will consume

prefer:                             until the remote processor consumes
                    and puts it back on

> +     a tx buffer and put it back on virtio's used descriptor ring),
> +     or a timeout of 15 seconds elapses. When the latter happens,
> +     -ERESTARTSYS is returned.
> +     The function can only be called from a process context (for now).
> +     Returns 0 on success and an appropriate error value on failure.
> +
> +  int rpmsg_sendto(struct rpmsg_channel *rpdev, void *data, int len, u32 dst);
> +   - sends a message across to the remote processor on a given channel,
> +     to a destination address provided by the caller.
> +     The caller should specify the channel, the data it wants to send,
> +     its length (in bytes), and an explicit destination address.
> +     The message will then be sent to the remote processor to which the
> +     channel belongs to, using the channel's src address, and the user-provided

        channel belongs,

> +     dst address (thus the channel's dst address will be ignored).
> +
> +     In case there are no TX buffers available, the function will block until
> +     one becomes available (i.e. until the remote processor will consume

                                    until the remote processor consumes
        a tx buffer and puts it back on

> +     a tx buffer and put it back on virtio's used descriptor ring),
> +     or a timeout of 15 seconds elapses. When the latter happens,
> +     -ERESTARTSYS is returned.
> +     The function can only be called from a process context (for now).
> +     Returns 0 on success and an appropriate error value on failure.
> +
> +  int rpmsg_send_offchannel(struct rpmsg_channel *rpdev, u32 src, u32 dst,
> +							void *data, int len);
> +   - sends a message across to the remote processor, using the src and dst
> +     addresses provided by the user.
> +     The caller should specify the channel, the data it wants to send,
> +     its length (in bytes), and explicit source and destination addresses.
> +     The message will then be sent to the remote processor to which the
> +     channel belongs to, but the channel's src and dst addresses will be

        channel belongs,

> +     ignored (and the user-provided addresses will be used instead).
> +
> +     In case there are no TX buffers available, the function will block until
> +     one becomes available (i.e. until the remote processor will consume

                                    until the remote processor consumes
        a tx buffer and puts it back on

> +     a tx buffer and put it back on virtio's used descriptor ring),
> +     or a timeout of 15 seconds elapses. When the latter happens,
> +     -ERESTARTSYS is returned.
> +     The function can only be called from a process context (for now).
> +     Returns 0 on success and an appropriate error value on failure.
> +
> +  int rpmsg_trysend(struct rpmsg_channel *rpdev, void *data, int len);
> +   - sends a message across to the remote processor on a given channel.
> +     The caller should specify the channel, the data it wants to send,
> +     and its length (in bytes). The message will be sent on the specified
> +     channel, i.e. its source and destination address fields will be
> +     set to the channel's src and dst addresses.
> +
> +     In case there are no TX buffers available, the function will immediately
> +     return -ENOMEM without waiting until one becomes available.
> +     The function can only be called from a process context (for now).
> +     Returns 0 on success and an appropriate error value on failure.
> +
> +  int rpmsg_trysendto(struct rpmsg_channel *rpdev, void *data, int len, u32 dst)
> +   - sends a message across to the remote processor on a given channel,
> +     to a destination address provided by the user.
> +     The user should specify the channel, the data it wants to send,
> +     its length (in bytes), and an explicit destination address.
> +     The message will then be sent to the remote processor to which the
> +     channel belongs to, using the channel's src address, and the user-provided

        channel belongs,

> +     dst address (thus the channel's dst address will be ignored).
> +
> +     In case there are no TX buffers available, the function will immediately
> +     return -ENOMEM without waiting until one becomes available.
> +     The function can only be called from a process context (for now).
> +     Returns 0 on success and an appropriate error value on failure.
> +
> +  int rpmsg_trysend_offchannel(struct rpmsg_channel *rpdev, u32 src, u32 dst,
> +							void *data, int len);
> +   - sends a message across to the remote processor, using source and
> +     destination addresses provided by the user.
> +     The user should specify the channel, the data it wants to send,
> +     its length (in bytes), and explicit source and destination addresses.
> +     The message will then be sent to the remote processor to which the
> +     channel belongs to, but the channel's src and dst addresses will be

        channel belongs,

> +     ignored (and the user-provided addresses will be used instead).
> +
> +     In case there are no TX buffers available, the function will immediately
> +     return -ENOMEM without waiting until one becomes available.
> +     The function can only be called from a process context (for now).
> +     Returns 0 on success and an appropriate error value on failure.
> +
> +  struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
> +		void (*cb)(struct rpmsg_channel *, void *, int, void *, u32),
> +		void *priv, u32 addr);
> +   - every rpmsg address in the system is bound to an rx callback (so when
> +     inbound messages arrive, they are dispatched by the rpmsg bus using the
> +     appropriate callback handler) by means of an rpmsg_endpoint struct.
> +
> +     This function allows drivers to create such an endpoint, and by that,
> +     bind a callback, and possibly some private data too, to an rpmsg address
> +     (either one that is known in advance, or one that will be dynamically
> +     assigned for them).
> +
> +     Simple rpmsg drivers need not call rpmsg_create_ept, because an endpoint
> +     is already created for them when they are probed by the rpmsg bus
> +     (using the rx callback they provide when they registered to the rpmsg bus).
> +
> +     So things should just work for simple drivers: they already have an
> +     endpoint, their rx callback is bound to their rpmsg address, and when
> +     relevant inbound messages arrive (i.e. messages which their dst address
> +     equals to the src address of their rpmsg channel), the driver's handler
> +     is invoked to process it.
> +
> +     That said, more complicated drivers might do need to allocate
> +     additional rpmsg addresses, and bind them to different rx callbacks.
> +     To accomplish that, those drivers need to call this function.
> +     Driver should provide their channel (so the new endpoint would bind

        Drivers

> +     to the same remote processor their channel belongs to), an rx callback
> +     function, an optional private data (which is provided back when the
> +     rx callback is invoked), and an address they want to bind with the
> +     callback. If addr is RPMSG_ADDR_ANY, then rpmsg_create_ept will
> +     dynamically assign them an available rpmsg address (drivers should have
> +     a very good reason why not to always use RPMSG_ADDR_ANY here).
> +
> +     Returns a pointer to the endpoint on success, or NULL on error.
> +
> +  void rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
> +   - destroys an existing rpmsg endpoint. user should provide a pointer
> +     to an rpmsg endpoint that was previously created with rpmsg_create_ept().
> +
> +  int register_rpmsg_driver(struct rpmsg_driver *rpdrv);
> +   - registers an rpmsg driver with the rpmsg bus. user should provide
> +     a pointer to an rpmsg_driver struct, which contains the driver's
> +     ->probe() and ->remove() functions, an rx callback, and an id_table
> +     specifying the names of the channels this driver is interested to
> +     be probed with.
> +
> +  void unregister_rpmsg_driver(struct rpmsg_driver *rpdrv);
> +   - unregisters an rpmsg driver from the rpmsg bus. user should provide
> +     a pointer to a previously-registerd rpmsg_driver struct.

                                  registered

> +     Returns 0 on success, and an appropriate error value on failure.
> +
> +
> +3. Typical usage
> +
> +The following is a simple rpmsg driver, that sends an "hello!" message
> +on probe(), and whenever it receives an incoming message, it dumps its
> +content to the console.
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/rpmsg.h>
> +
> +static void rpmsg_sample_cb(struct rpmsg_channel *rpdev, void *data, int len,
> +						void *priv, u32 src)
> +{
> +	print_hex_dump(KERN_INFO, "incoming message:", DUMP_PREFIX_NONE,
> +						16, 1, data, len, true);
> +}
> +
> +static int rpmsg_sample_probe(struct rpmsg_channel *rpdev)
> +{
> +	int err;
> +
> +	dev_info(&rpdev->dev, "chnl: 0x%x -> 0x%x\n", rpdev->src, rpdev->dst);
> +
> +	/* send a message on our channel */
> +	err = rpmsg_send(rpdev, "hello!", 6);
> +	if (err) {
> +		pr_err("rpmsg_send failed: %d\n", err);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __devexit rpmsg_sample_remove(struct rpmsg_channel *rpdev)
> +{
> +	dev_info(&rpdev->dev, "rpmsg sample client driver is removed\n");
> +}
> +
> +static struct rpmsg_device_id rpmsg_driver_sample_id_table[] = {
> +	{ .name	= "rpmsg-client-sample" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(rpmsg, rpmsg_driver_sample_id_table);
> +
> +static struct rpmsg_driver rpmsg_sample_client = {
> +	.drv.name	= KBUILD_MODNAME,
> +	.drv.owner	= THIS_MODULE,
> +	.id_table	= rpmsg_driver_sample_id_table,
> +	.probe		= rpmsg_sample_probe,
> +	.callback	= rpmsg_sample_cb,
> +	.remove		= __devexit_p(rpmsg_sample_remove),
> +};
> +
> +static int __init init(void)
> +{
> +	return register_rpmsg_driver(&rpmsg_sample_client);
> +}
> +
> +static void __exit fini(void)
> +{
> +	unregister_rpmsg_driver(&rpmsg_sample_client);
> +}
> +module_init(init);
> +module_exit(fini);
> +
> +
> +4. API for implementors
> +
> +Adding rpmsg support for a new platform is relatively easy; one just needs
> +to register a VIRTIO_ID_RPMSG virtio device with the usual virtio_config_ops
> +handlers.
> +
> +For simplicity, it is recommended to register a single virtio device for
> +every physical remote processor we have in the system, but there are no

                  remote processor in the system,

> +hard rules here, and this decision largely depends on the use cases,
> +platform capabilities, performance requirements, etc.
> +
> +OMAP4, e.g., registers two virtio devices to communicate with the remote dual
> +Cortex-M3 processor, because each of the M3 cores executes its own OS instance
> +(see omap_rpmsg.c for reference).
> +This way each of the remote cores may have different rpmsg channels, and the
> +rpmsg core will treat them as completely independent processors (despite
> +the fact that both of are part of the same physical device, and they are

                 both of them are part

> +powered on/off together).
> +
> +Notable virtio implementation bits:
> +
> +* virtio features: VIRTIO_RPMSG_F_NS should be enabled if the remote
> +  processor supports dynamic name service announcement messages.
> +
> +  Enabling this means that rpmsg device (i.e. channel) creation is
> +  completely dynamic: the remote processor announces the existence of a
> +  remote rpmsg service by sending a name service message (which contains
> +  the name and rpmsg addr of the remote service, see struct rpmsg_ns_msg).
> +
> +  This message is then handled by the rpmsg bus, which in turn dynamically
> +  creates and registers an rpmsg channel (which represents the remote service).
> +  If/when a relevant rpmsg driver is registered, it will be immediately probed
> +  by the bus, and can then start sending messages to the remote service.
> +
> +* virtqueue's notify handler: should inform the remote processor whenever
> +  it is kicked by virtio. OMAP4 is using its mailbox device to interrupt
> +  the remote processor, and inform it which virtqueue number is kicked
> +  (the index of the kicked virtqueue is written to the mailbox register).
> +
> +* virtio_config_ops's ->get() handler: the rpmsg bus uses this handler
> +  to request for platform-specific configuration values.
> +  see enum rpmsg_platform_requests for more info.

> diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
> new file mode 100644
> index 0000000..41303f5
> --- /dev/null
> +++ b/drivers/rpmsg/Kconfig
> @@ -0,0 +1,14 @@
> +# RPMSG always gets selected by whoever wants it
> +config RPMSG
> +	tristate
> +	select VIRTIO
> +	select VIRTIO_RING
> +
> +if RPMSG
> +
> +# OK, it's a little counter-intuitive to do this, but it puts it neatly under
> +# the rpmsg menu (and it's the approach preferred by the virtio folks).
> +
> +source "drivers/virtio/Kconfig"

It seems odd to have that Kconfig file sourced in multiple places.
Are the kconfig tools happy with that?

> +
> +endif # RPMSG


Sorry about the delay.  I had most of this in my drafts folder and
forgot about it...

HTH.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
