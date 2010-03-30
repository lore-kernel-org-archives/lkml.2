Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab0CaAcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:32:36 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:24955 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0C3XMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ozgur Yuksel <ozgur.yuksel@oracle.com>
Subject: Re: [Bugme-new] [Bug 15621] New: BUG: unable to handle kernel paging request - comm: pccardd
Date: Tue, 30 Mar 2010 17:10:59 -0600
User-Agent: KMail/1.9.10
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <bug-15621-10286@https.bugzilla.kernel.org/> <20100325170138.GA5424@comet.dominikbrodowski.net> <20100329091241.GA3237@oracle.com>
In-Reply-To: <20100329091241.GA3237@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003301711.00351.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael, this is a regression from 2.6.33, in case it's not on your
list yet.

Ozgur, thanks for attaching the logs.  There's some interesting stuff
there that I don't understand yet, such as this from the pci=nocrs dmesg:

  [    1.577758] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
  [    1.583031] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
  [    1.551889] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
  [    1.557507] pci 0000:03:01.0:   bridge window [io  0x5000-0x50ff]
  [    1.603303] PCI: No. 2 try to assign unassigned res
  [    1.688208] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
  [    1.693826] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]

Apparently we moved that CardBus I/O window from [0x5000-0x5fff] to
[0x0-0xff].  I'm dubious about that because the upstream bridge at
00:1e.0 only positively decodes [0x5000-0x5fff] (though it *is* in
subtractive decode mode, so it will forward more).  I wish we had
a little more debug output about when & why we moved that window.

I'm especially dubious because your /proc/ioports with pci=nocrs
from comment 8 (which is the case that's supposed to be working)
contains this:

  5000-5fff : PCI Bus 0000:03
    0000-00ff : PCI CardBus 0000:04
    0000-00ff : PCI CardBus 0000:04

That looks completely broken in terms of the hierarchy.  It looks
like you have a USB device in the CardBus slot (ohci_hcd 0000:04:00.0).
Maybe the broken hierarchy doesn't cause problems with this device
because it doesn't use I/O ports.

Anyway, I'd like to see the entire dmesg log when booted *without*
pci=nocrs, because that's the case that fails.  Since the system doesn't
boot, you'll have to use a serial console or netconsole to collect the
whole thing.  The serial console log in comment 7 is corrupted; it looks
like all the lines got truncated to 80 columns or something.  And please
boot with "ignore_loglevel" so we see all the debug messages on the console.
Also, no need to tar up and compress your attachments -- I always figure
if bugzilla wants to compress stuff, it can do it internally without
bothering us.
