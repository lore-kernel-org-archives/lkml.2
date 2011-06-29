Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab1F2Xut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:50:49 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:46650 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758268Ab1F2Xul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:50:41 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 7/10 v6] PM / Domains: Don't stop wakeup devices during system sleep transitions
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <201106252324.13454.rjw@sisk.pl>
	<201106252329.24342.rjw@sisk.pl>
Date: Wed, 29 Jun 2011 16:50:35 -0700
In-Reply-To: <201106252329.24342.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 25 Jun 2011 23:29:24 +0200")
Message-ID: <87fwmsnqno.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Devices that are set up to wake up the system from sleep states
> should not be stopped and power should not be removed from them
> when the system goes into a sleep state.  

I don't think this belongs in the generic layer since the two
assumptions above are not generally true on embedded systems, and would
result in rather significant power consumption unnecessarily.

First, whether the device should be stopped on device_may_wakeup():

Some IP blocks (at least on OMAP) have "asynchronous" wakeups.  Meaning
that they can generate wakeups even when they're not clocked (a.k.a
stopped).  So in this case, even after a ->stop_device (which clock
gates the IP), it can still generate wakeups.

Second, whether the device should be powered off if device_may_wakeup():

Embedded SoCs have other ways to wakeup than device-level wakeups.

For example, on OMAP, every pad on the SoC can be configured as a wakeup
source So, for example, you could completely power down the UART IP
blocks (and the enclosing power domain), configure the UART RX pad as a
wakeup source, and still wakeup the system on UART activity.  The OMAP
docs call these IO pad wakeups.

On OMAP in fact, this is the common, default behavior when we enable
"off-mode" in idle and/or suspend, since most of the IPs are powered off
but can still wake up the system.

So in summary, even if device_may_wakeup() is true, many devices (with
additional SoC magic) can still generate wakeups even when stopped and
powered off.

Kevin
