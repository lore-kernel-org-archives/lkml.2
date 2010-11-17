Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab0KQVhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:37:37 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52395
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022Ab0KQVhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:37:36 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h637h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CE44B1B.9040709@freescale.com>
Date: Wed, 17 Nov 2010 15:37:31 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: How do I choose an arbitrary minor number for my tty device?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 21:38:33.0366 (UTC) FILETIME=[C89A2B60:01CB869F]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd and Greg,

I'm working on a TTY driver for a virtual device that we call "byte channels".
This are likes pipes, but they go through an ePAPR hypervisor.

The hypervisor declares byte channels as nodes in a device tree.  Each byte
channel has a unique 32-bit number called a "handle", and this handle is
specified in the node for that device tree.  Applications are expected to scan
the device tree to look for the node they want, and then extract the handle from
that node.

The problem I have is that the handles are, from Linux's perspective, arbitrary
and sparsely assigned.  For example, we could have four byte channels with
handles of 2, 8, 73, and 74.

What I would like is for the minor number for each tty device to be the byte
channel handle.  Or the byte channel could be in the /dev name.  Either way,
applications can figure out which /dev entry to open in order to communicate
with a given byte channel.

Unfortunately, the only way I know how to do this is to create a separate tty
driver instance for each byte channel.  This is because of this code in
tty_register_driver:

	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM) && driver->num) {
		p = kzalloc(driver->num * 2 * sizeof(void *), GFP_KERNEL);
		if (!p)
			return -ENOMEM;
	}

The 'index' passed to tty_register_device() is added to minor_start to create
the /dev entry, and it's added to name_base to create the name.  If I specify a
very large number for driver->num, then tty_register_driver will create a large
but sparsely-populated array.

Would you be okay with creating a separate driver for each byte channel, or is
there a better way to do what I want?

--
Timur Tabi
Linux kernel developer at Freescale

