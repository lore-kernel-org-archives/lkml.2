Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1KYMLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:11:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42032 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1KYMLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:11:24 -0500
MIME-Version: 1.0
In-Reply-To: <20111123041728.GA11864@redhat.com>
References: <20111031143408.GA17152@redhat.com>
	<1321992902.8072.7.camel@wwguy-ubuntu>
	<20111123024545.GA9703@redhat.com>
	<1322015380.11647.82.camel@wwguy-huron>
	<20111123033446.GB9703@redhat.com>
	<1322016965.11647.95.camel@wwguy-huron>
	<20111123041728.GA11864@redhat.com>
Date: Fri, 25 Nov 2011 14:11:22 +0200
Message-ID: <CANUX_P3bFpKyePkgYwQUO0Y3XN=B+7YHSsD81Vt=LwK6ZbrD6g@mail.gmail.com>
Subject: Re: 3.1+ iwlwifi lockup
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dave Jones <davej@redhat.com>, "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I looked again at your stack strace, we need more debug. Please enable
Rx debug flag: 0x1000000.

What is happening here is that the HW (the Flow Handler for instance),
is closing an empty RB (Receive Buffer). The beginning of the buffer
is 0x00005555 which is the maker of "End of Buffer" of the Flow
Handler. The marker helps the driver to understand that there is no
more useful data in the buffer.
So basically what we are seeing here is that the FH is sending an
empty buffer. Which is not nice.
This can very well be a bug in the read / write pointers in the Rx
flow, or something in that region.

On Wed, Nov 23, 2011 at 06:17, Dave Jones <davej@redhat.com> wrote:
> On Tue, Nov 22, 2011 at 06:56:05PM -0800, Guy, Wey-Yi wrote:
>  > Agree, that is why I could not re-produce here after many try. Could you
>  > share your configuration, such as
>
>  > band/channel
>
> Channel:1
> Frequency:2.412 GHz (Channel 1)
>
>  > 32/64 bit system
>
> 64bit. It's a Dell Adamo laptop.
>
>  > 20/40 MHz
>
> not sure how to find out what you're looking for.
>
>  > traffic type
>
> last triggered it with just ssh.
>
>  > open/security
>
> IE: IEEE 802.11i/WPA2 Version 1
>    Group Cipher : CCMP
>    Pairwise Ciphers (1) : CCMP
>    Authentication Suites (1) : PSK
>
>  > power management
>
> nothing special. everything is default.
>
> all messages related to iwlwifi in dmesg are below..
>
>        Dave
>
> [   24.423300] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
> [   24.425560] Copyright(c) 2003-2011 Intel Corporation
> [   24.428667] iwlwifi 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   24.437959] iwlwifi 0000:04:00.0: setting latency timer to 64
> [   24.438108] iwlwifi 0000:04:00.0: pci_resource_len = 0x00002000
> [   24.444058] iwlwifi 0000:04:00.0: pci_resource_base = ffffc90011574000
> [   24.445823] iwlwifi 0000:04:00.0: HW Revision ID = 0x0
> [   24.447695] iwlwifi 0000:04:00.0: irq 46 for MSI/MSI-X
> [   24.447896] iwlwifi 0000:04:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
> [   24.453070] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [   24.486217] iwlwifi 0000:04:00.0: device EEPROM VER=0x120, CALIB=0x4
> [   24.489176] iwlwifi 0000:04:00.0: Device SKU: 0Xf0
> [   24.490778] iwlwifi 0000:04:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> [   24.520548] iwlwifi 0000:04:00.0: loaded firmware version 8.83.5.1 build 33692
> [   39.229498] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [   39.240818] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
> [   39.607327] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [   39.613424] iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
> [  210.248807] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 6
