Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab1LGMaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:30:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab1LGMaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:30:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sjur =?utf-8?q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: Re: [PATCH 0/9] XSHM: Shared Memory Driver for ST-E Thor M7400 LTE modem
Date: Wed, 7 Dec 2011 12:30:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
In-Reply-To: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201112071230.08019.arnd@arndb.de>
X-Provags-ID: V02:K0:hIwI+s8LMB83qrzV4LB8pSh/zue34/IsjnrsrqzAlEV
 Zsl1V0pTcasb2wL7Da428QmNAG3SRKKkH3vHMKAaeXHonQcUlw
 Y803fvqtU5t1dWoD+bBNfP3/cF+TMG0NOC9Hsu1gjp8Pm77/4x
 bpDBqpbhHfoFHwC7q5JBx2dmbAQXfg3Edl92pX7oGZcffBHfCG
 NS16nxK7jEulcqIvlMTknSYm9ZSUOrc33yJdIxpt6ULTNGCS0g
 DWGjFQKkV/HuWbx8Fi7CwkbqUlkP6EaSgPr/wIvPxhjYVYGhsd
 ImjfwrwN/yl3tJINfOcfiVt8zkG8kkaXvPZqHMtORhT4jKkdqA
 UMunB50g1q+BsQxMVRbA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

I've tried to do a review of your code, but I really need to understand
more of the background first, to be able to tell if it's using the
right high-level approach. There are a lot of details I could
comment on, but let's first look at the overall design.

On Wednesday 07 December 2011, Sjur Brændeland wrote:
> Introduction:
> ~~~~~~~~~~~~~
> This patch-set introduces the Shared Memory Driver for ST-Ericsson's
> Thor M7400 LTE modem.
> The shared memory model is implemented for Chip-to-chip and
> uses a reserved memory area and a number of bi-directional
> channels. Each channel has it's own designated data area where payload
> data is copied into.

Can you explain what the scope of this framework is? What I don't
understand from the code is whether this is meant to be very
broadly applicable to a lot of devices and competing with e.g.
rpmsg from Ohad Ben-Cohen, or whether this is really speciific
to one hardware implementation for caif.

Also, to what degree is the protocol design flexible? Is the modem
side fixed, so you have to live with any shortcomings of the interface,
or are you at this point able to improve both sides when something
is found to be lacking?

> Two different channel types are defined, one stream channel which is
> implemented as a traditional ring-buffer, and a packet channel which
> is a ring-buffer of fix sized buffers where each buffer contains
> an array of CAIF frames.
> 
> The notification of read and write index updates are handled in a
> separate driver called c2c_genio. This driver will be contributed separately,
> but the API is included in this patch-set.
> 
> The channel configuration is stored in shared memory, each channel
> has a designated area in shared memory for configuration data,
> read and write indexes and a data area.

How many channels will there be on of each type in a typical system,
and respectively in the maximum you can realistically expect over
the next 10 years?

> Stream data
> ~~~~~~~~~~~
> The driver for the stream channel is implemented as a character device
> interface to user space. The character device implements non-blocking open
> and non-blocking IO in general. The character device is implementing
> a traditional circular buffer directly in the shared memory region for
> the channel.

It seems unusual to have both a socket interface and a character device
interface. What is the motivation behind this? Why can't you use the
socket for non-blocking I/O?

> Driver model
> ~~~~~~~~~~~~~~
> Current implementation is using the platform bus for XSHM devices.
> The packet channels are named "xshmp", and stream channel "xshms".
>
> /sys/devices:
> |-- platform
> |   |-- uevent
> |   `-- xshm
> |       |-- bootimg
> |       |-- caif_ready
> |       |-- ipc_ready
> |       |-- subsystem -> ../../../bus/platform
> |       |-- xshmp.1
> |       |   |-- driver -> ../../../../bus/platform/drivers/xshmp
> |       |   |-- subsystem -> ../../../../bus/platform
> |       `-- xshms.0
> |           |-- driver -> ../../../../bus/platform/drivers/xshms
> |           |-- misc
> |           |   `-- xshm0
> |           |       |-- device -> ../../../xshms.0
> |           |       |-- subsystem -> ../../../../../../class/misc
> `-- virtual
>     |-- net
>     |   |-- cfshm0

Why are the channels /platform/ devices? With all the infrastructure
you have in the xshm driver, I would think that you should be
able to probe the available channels yourself instead of relying the
board to define them. If you cannot, that is something that I think
needs to be fixed in the interface to the modem. If you can, you
probably should not be using the platform_bus but instead create
your own bus_type.

	Arnd
