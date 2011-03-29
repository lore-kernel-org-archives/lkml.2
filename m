Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1C2LFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:05:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab1C2LFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:05:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Tue, 29 Mar 2011 13:05:02 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: sameo@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com, alan@lxorguk.ukuu.org.uk
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <20110325142648.GC3879@sortiz-mobl> <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Message-Id: <201103291305.02293.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:ULQxW/KHVFR2/Jo8mXSgXrQfJKTDnJLZqcyF2MNY6lw
 27jCZumfl7jEdIjCIjLiSZ1YqSRGpNA+LEv674CbCnUiHV5kos
 MpQN6cwGRjGvHpya9F+5pTBiT/8GEcHsxZ9lRL4F+Bn71mOt6S
 QALssPuQnPPnQC1MKQu4zk0H1D/d7qql7jWfqG1Z83GA4mUvFz
 6lxbf4AtCzsvriyr8w4RQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >Yes, NFC seems to be a good fit for a new socket family. 
> >Especially if we ever want to have a proper NFC p2p support 
> >from the kernel.
> >Sending HCI commands should be done through a dedicated 
> >netlink socket too.
> >
> >I am currently strting to work on such solution, and I hope to 
> >be able to come up with a basic prototype for it in a few weeks.
> 
> What about common drivers interface in this case.
> Should we go for common /dev/nfcX interface as well?

I fear there can only be one. A good implementation of a socket
interface would mean that there is no need for a character device.

The difference between the two is where you keep the common
NFC logic:

If you have a character device, it will be like a serial port
connecting to a modem. Any higher-level protocols live in the
user space and are limited to a single application then, which
is required to have appropriate priviledges to open the device.

In contrast, a socket implementation puts the protocol
stack into the kernel, which requires much more kernel code
but almost no user space library code, aside from perhaps
a small shim layer. It makes it possible to have multiple
applications and/or users concurrently use NFC to make connections
to separate endpoints. Since sockets have no implicit permission
handling, the kernel code then needs to implement a way to enforce
policy.

I still don't understand enough about NFC to judge which of
the two is better suited for the problem, but my feeling is
that a socket based implementation would be better if you expect
a lot of people to use it, while the main advantage of the
character device is its simplicity, so that would be preferred
if you only expect a very small set of possible applications
for this.

	Arnd
