Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0JLSXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:23:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40033 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754383Ab0JLSXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:23:32 -0400
Date: Tue, 12 Oct 2010 14:23:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
In-Reply-To: <tkrat.9f585ea47331a2a2@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.1010121207360.1705-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010, Stefan Richter wrote:

> Hi,
> 
> I have got a monitor with built-in hub to which a keyboard, mouse, and
> card reader are connected.  At one occasion when I switched the monitor
> off, the following oops happened.
> 
> I have updated from 2.6.36-rc4 to 2.6.36-rc7 on Saturday evening.  I.e.
> it may be a regression after 2.6.36-rc4, but isn't necessarily so.

I don't think it's a regression.

> Oct 11 22:29:21 stein kernel: usb 1-1.2: USB disconnect, address 14
> Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input0, status -71
> Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -71
> Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input1, status -71
> Oct 11 22:29:21 stein kernel: hub 1-1:1.0: hub_port_status failed (err = -71)
> Oct 11 22:29:21 stein kernel: hub 1-1:1.0: connect-debounce failed, port 2 disabled
> Oct 11 22:29:21 stein kernel: usb 1-1: USB disconnect, address 12
> Oct 11 22:29:21 stein kernel: usb 1-1.1: USB disconnect, address 13
> Oct 11 22:29:21 stein kernel: usb 1-1.1.1: USB disconnect, address 16
> Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -71
> Oct 11 22:29:21 stein kernel: usb 1-1.3: USB disconnect, address 15
> Oct 11 22:29:21 stein kernel: ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5
> Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input0, status -108
> Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -19
> Oct 11 22:29:21 stein kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> Oct 11 22:29:21 stein kernel: IP: [<ffffffff8129dbd8>] ehci_clear_tt_buffer_complete+0x31/0x72

Is this reproducible?  I'd guess that it happens only a fraction of the
times you turn off the monitor.  Maybe it will be more likely to happen 
if you are moving the mouse while you turn off the monitor.

At any rate, I'm baffled.  This log entry:

	ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5

indicates that the ehci-hcd data structures were seriously messed up.  
It means the qh was not on the async list at a time when it should have
been (an URB for that qh was completing).

That led to ehci_clear_tt_buffer_complete crashing with qh == NULL,
which is what that IP address means, right?  You could add a test for
NULL, but that would merely cover up the symptom: qh should never be
NULL at that point.

Alan Stern

