Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0LKARh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:17:37 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34850 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab0LKARg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:17:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UgVg63vYHiFHzJ38BVGlyB0KxIf4Zku/STsHnfODPFk39aehapEewRBU9D0tda9YHL
         Ej45wTFYGgv5qouLawIBxQy6UbUj28P2zRITOAPQt+OUImmQtsZJno33bOnTjZjIG/08
         2et1sD0Q7kSKyQZ45Kj3k8S2NyV1jnVqLRnGg=
Message-ID: <4D02C336.707@lwfinger.net>
Date: Fri, 10 Dec 2010 18:17:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: pali.rohar@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT] OHCI: Fix for regression in 2.6.37-rc1 since commit
 3df7169e7
References: <Pine.LNX.4.44L0.1011041039450.2522-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011041039450.2522-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

The box with the problem has been repaired, and I am trying to debug it.

What I have learned so far:

The "unable to enumerate" message is triggered because PORT_OWNER is not set in
the status register.

So far, I have found that this bit is set in only 4 places:

1. set_owner()
2. store_companion()
3. ehci_hub_control()
4. ehci_relinquish_port()
5. check_reset_complete()

Of these, only #5 is called before the first enumeration message is logged, but
it is only called with arguments that never set the PORT_OWNED bit in the status.

At this point I'm at a loss. Could you please give me ideas on where I might look.

The logged data leading up to the first message are:

[    3.002762] hub 4-0:1.0: USB hub found
[    3.002780] hub 4-0:1.0: 5 ports detected
[    3.088286] ehci_hcd 0000:00:02.1: usb: Entered check_reset_complete with
port_status 0x1005
[    3.088433] ehci_hcd 0000:00:02.1: port 4 high speed
[    3.144061] usb 1-4: new high speed USB device using ehci_hcd and address 2
[    3.200286] ehci_hcd 0000:00:02.1: usb: Entered check_reset_complete with
port_status 0x1005
[    3.200437] ehci_hcd 0000:00:02.1: port 4 high speed
[    3.352298] ehci_hcd 0000:00:02.1: usb: Entered check_reset_complete with
port_status 0x1005
[    3.352304] ehci_hcd 0000:00:02.1: port 5 high speed
[    3.408071] usb 1-5: new high speed USB device using ehci_hcd and address 3
[    3.454449] PM: Starting manual resume from disk
[    3.464305] ehci_hcd 0000:00:02.1: usb: Entered check_reset_complete with
port_status 0x1005
[    3.464449] ehci_hcd 0000:00:02.1: port 5 high speed
[    3.600052] ehci_hcd 0000:00:04.1: usb: Entered check_reset_complete with
port_status 0x1001
[    3.600202] ehci_hcd 0000:00:04.1: port 5 full speed --> companion
[    3.600307] ehci_hcd 0000:00:04.1: Wrote 0x3001 to status reg
[    3.656089] hub 2-0:1.0: unable to enumerate USB device on port 5
[    3.656203] ehci_hcd 0000:00:04.1: In ehci_relinquish_port
[    3.656295] ehci_hcd 0000:00:04.1: In set_owner

Thanks,

Larry
