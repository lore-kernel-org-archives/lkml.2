Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab1FWMXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:23:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33434 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759346Ab1FWMXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:23:37 -0400
Message-ID: <4E033041.9090606@criticallink.com>
Date: Thu, 23 Jun 2011 08:23:29 -0400
From: Michael Williamson <michael.williamson@criticallink.com>
Organization: Critical Link, LLC
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1308640714-17961-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/2011 3:18 AM, Ohad Ben-Cohen wrote:
> Modern SoCs typically employ a central symmetric multiprocessing (SMP)
> application processor running Linux, with several other asymmetric
> multiprocessing (AMP) heterogeneous processors running different instances
> of operating system, whether Linux or any other flavor of real-time OS.
>
> OMAP4, for example, has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP.
> Typically, the dual cortex-A9 is running Linux in a SMP configuration, and
> each of the other three cores (two M3 cores and a DSP) is running its own
> instance of RTOS in an AMP configuration.
>
> AMP remote processors typically employ dedicated DSP codecs and multimedia
> hardware accelerators, and therefore are often used to offload cpu-intensive
> multimedia tasks from the main application processor. They could also be
> used to control latency-sensitive sensors, drive "random" hardware blocks,
> or just perform background tasks while the main CPU is idling.
>
> Users of those remote processors can either be userland apps (e.g.
> multimedia frameworks talking with remote OMX components) or kernel drivers
> (controlling hardware accessible only by the remote processor, reserving
> kernel-controlled resources on behalf of the remote processor, etc..).
>
> This patch set adds a generic AMP/IPC framework which makes it possible to
> control (power on, boot, power off) and communicate (simply send and receive
> messages) with those remote processors.
>
> Specifically, we're adding:
>
> * Rpmsg: a virtio-based messaging bus that allows kernel drivers to
> communicate with remote processors available on the system. In turn,
> drivers could then expose appropriate user space interfaces, if needed
> (tasks running on remote processors often have direct access to sensitive
> resources like the system's physical memory, gpios, i2c buses, dma
> controllers, etc..  so one normally wouldn't want to allow userland to
> send everything/everywhere it wants).
>
> Every rpmsg device is a communication channel with a service running on a
> remote processor (thus rpmsg devices are called channels). Channels are
> identified by a textual name (which is used to match drivers to devices)
> and have a local ("source") rpmsg address, and remote ("destination") rpmsg
> address. When a driver starts listening on a channel (most commonly when it
> is probed), the bus assigns the driver a unique rpmsg src address (a 32 bit
> integer) and binds it with the driver's rx callback handler. This way
> when inbound messages arrive to this src address, the rpmsg core dispatches
> them to that driver, by invoking the driver's rx handler with the payload
> of the incoming message.
>
> Once probed, rpmsg drivers can also immediately start sending messages to the
> remote rpmsg service by using simple sending API; no need even to specify
> a destination address, since that's part of the rpmsg channel, and the rpmsg
> bus uses the channel's dst address when it constructs the message (for
> more demanding use cases, there's also an extended API, which does allow
> full control of both the src and dst addresses).
>
> The rpmsg bus is using virtio to send and receive messages: every pair
> of processors share two vrings, which are used to send and receive the
> messages over shared memory (one vring is used for tx, and the other one
> for rx). Kicking the remote processor (i.e. letting it know it has a pending
> message on its vring) is accomplished by means available on the platform we
> run on (e.g. OMAP is using its mailbox to both interrupt the remote processor
> and tell it which vring is kicked at the same time). The header of every
> message sent on the rpmsg bus contains src and dst addresses, which make it
> possible to multiplex several rpmsg channels on the same vring.
>
> One nice property of the rpmsg bus is that device creation is completely
> dynamic: remote processors can announce the existence of remote rpmsg
> services by sending a "name service" messages (which contain the name and
> rpmsg addr of the remote service). Those messages are picked by the rpmsg
> bus, which in turn dynamically creates and registers the rpmsg channels
> (i.e devices) which represents the remote services. If/when a relevant rpmsg
> driver is registered, it will be immediately probed by the bus, and can then
> start "talking" to the remote service.
>
> Similarly, we can use this technique to dynamically create virtio devices
> (and new vrings) which would then represent e.g. remote network, console
> and block devices that will be driven by the existing virtio drivers
> (this is still not implemented though; it requires some RTOS work as we're
> not booting Linux on OMAP's remote processors). Creating new vrings might
> also be desired by users who just don't want to use the shared rpmsg vrings
> (for performance or any other functionality reasons).
>
> In addition to dynamic creation of rpmsg channels, the rpmsg bus also
> supports creation of static channels. This is needed in two cases:
> - when a certain remote processor doesn't support sending those "name
>   service" announcements. In that case, a static table of remote rpmsg
>   services must be used to create the rpmsg channels.
> - to support rpmsg server drivers, which aren't bound to a specific remote
>   rpmsg address. Instead, they just listen on a local address, waiting for
>   incoming messages. To send a message, those server drivers need to use
>   the rpmsg_sendto() API, so they can explicitly indicate the dst address
>   every time.
>
> There are already several immediate use cases for rpmsg drivers: OMX
> offloading (already being used on OMAP4), hardware resource manager (remote
> processors on OMAP4 need to ask Linux to enable/disable hardware resources
> on its behalf), remote display driver on Netra (dm8168), where the display
> is controlled by a remote M3 processor (and a Linux v4l2/fbdev driver will
> use rpmsg to communicate with that remote display driver).
>
> * Remoteproc: a generic driver that maintains the state of the remote
> processor(s). Simple rproc_get() and rproc_put() API is exposed, which
> drivers can use when needed (first driver to call get() will load a firmware,
> configure an iommu if needed, and boot the remote processor, while last
> driver to call put() will power it down).
>
> Hardware differences are abstracted as usual: a platform-specific driver
> registers its own start/stop handlers in the generic remoteproc driver,
> and those are invoked when its time to power up/down the processor. As a
> reference, this patch set include remoteproc support for both OMAP4's
> cortex-M3 and Davinci's DSP, tested on the pandaboard and hawkboard,
> respectively.
>
> The gory part of remoteproc is the firmware handling. We tried to come up
> with a simple binary format that will require minimum kernel code to handle,
> but at the same time be generic enough in the hopes that it would prove
> useful to others as well. We're not at all hang onto the binary format
> we picked: if there's any technical reason to change it to support other
> platforms, please let us know. We do realize that a single binary firmware
> structure might eventually not work for everyone. it did prove useful for
> us though; we adopted both the OMAP and Davinci platforms (and their
> completely different remote processor devices) to this simple binary
> structure, so we don't have to duplicate the firmware handling code.
>

I'd like to kick the tires on this with a da850 based platform (MityDSP-L138).
Any chance you might be able to share the stuff you did on the remote side
(DSP/BIOS adaptations for rpmsg,  utils for ELF or COFF conversion to
firmware format, etc.) for the DSP side of your tests done with the hawkboard?

It looks like, at least for the da850, this subsumes or obsoletes DSPLINK in order
to drive a more general purpose architecture (which looks great, so far, BTW). 
Is that the intent?

-Mike


