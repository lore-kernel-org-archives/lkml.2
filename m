Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab1JMR6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:58:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15785 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab1JMR6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:58:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Oct 2011 10:58:00 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Doug Anderson <dianders@chromium.org>, Jiri Slaby <jirislaby@gmail.com>,
        Olof Johansson <olof@lixom.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Allen Martin <AMartin@nvidia.com>, Tom Warren <TWarren@nvidia.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Oct 2011 10:57:59 -0700
Subject: RE: [PATCH] tty/serial: Prevent drop of DCD on suspend for Tegra
 UARTs
Thread-Topic: [PATCH] tty/serial: Prevent drop of DCD on suspend for Tegra
 UARTs
Thread-Index: AcyIcwO59JeRq6FTQ/uZ/Ih3hSP0AQBXfDiQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A0C6@HQMAIL01.nvidia.com>
References: <1318377943-24519-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1318377943-24519-1-git-send-email-dianders@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote at Tuesday, October 11, 2011 6:06 PM:
> On Tegra UARTs (except UART1), the DTR / DCD / DSR lines are not
> externally accessible.  Instead, the DTR line internally appears to be
> looped back to be the input to the DCD and DSR lines.  The net effect
> of this is that when we drop DTR (like when we suspend), we'll see DCD
> drop too.  ...and when we see DCD drop, we treat that as a hangup.
> 
> In order to prevent this hangup from occurring at every sleep, we need
> to force DTR to remain high on Tegra UARTs.
> 
> This patch uses the mcr_mask / mcr_force fields, which were originally
> added for the kludge ALPHA_KLUDGE_MCR.  Using these fields does not
> prevent us from removing ALPHA_KLUDGE_MCR--we can just remove the "if"
> tests I have added and always init mcr_mask / mcr_force from the
> serial8250_config.
> 
> NOTE: If we have people that are using UARTA on a Tegra and need to
> control DTR, we'll need to either add a separate port type for UARTA
> or we'll need to add some tegra-specific code to detect whether the
> DTR needs to be left high.

I did some research on the HW, and here's how everything is hooked up
in Tegra20 and Tegra30. Later chips may have this fixed, or at least
configurable; I don't know the details yet.

All 5 UARTs support the modem signals in the HW block.

In UART A, you can mux the modem signals out using the pinmux. If the
pinmux /doesn't/ route the signals out, the DSR and DCD signals are tied
to an /active/ state.

In UART B, the DTR output is indeed wired back into the DSR and DCD
inputs, as you discovered.

In UARTs C, D, and E, the DSR and DCD signals are tied to an /inactive/
state.

So, I think this particular WAR is only needed on UART B.

-- 
nvpublic

