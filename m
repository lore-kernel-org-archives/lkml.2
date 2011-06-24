Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1FXUQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 16:16:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19816 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1FXUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 16:16:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6387"; a="99750991"
Message-ID: <4E04F0B0.4030408@codeaurora.org>
Date: Fri, 24 Jun 2011 13:16:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1308640714-17961-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 12:18 AM, Ohad Ben-Cohen wrote:
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
[snip]
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

This sounds a lot like SMD (shared memory driver) on MSM. The main
difference I see is that SMD uses the platform bus instead of the virtio
bus and it has its own protocol for channel allocation.

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

This remote proc code is eerily similar to PIL (peripheral image loader,
yes we love our acronyms) which I posted a few months back[1]. Was it
inspiration for this patch series?

In terms of API, s/pil/rproc/ and it would be 95% identical. There are
some low-level differences though (see below).

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

This is an important difference between remote proc and PIL. In PIL, we
do image authentication in addition to processor boot. In this case, we
need to give the authentication engine the elf header and program
headers for the firmware so that it knows what parts of memory need to
be authenticated. Instead of devising a new firmware format, we decided
to just stick with elf and parse the headers in the kernel because we
needed them for authentication anyway. Is this reason enough to move to
an ELF format instead?

Another difference is inter-processor dependencies. For example, on
msm8660 the modem can't boot until the dsp has been booted. I suppose we
could hide this detail in the platform specific get() implementation by
calling rproc_get() on the dependent processor (hopefully no locking
issues arise). I'd rather have it built into the core though as it isn't
really specific to the hardware.

If we can resolve these differences I think we can easily support remote
processor boot on MSM via remoteproc.

[1] https://lkml.org/lkml/2011/3/9/490

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

