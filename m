Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1KWTLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:11:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:61838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab1KWTK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:10:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="79341446"
Date: Wed, 23 Nov 2011 19:22:33 +0000
From: Alan Cox <alan@linux.intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
Message-ID: <20111123192233.44f512b7@bob.linux.org.uk>
In-Reply-To: <1322074412-10873-1-git-send-email-hskinnemoen@google.com>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
	<1322074412-10873-1-git-send-email-hskinnemoen@google.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> This means we need some other way of preventing the device state from
> being freed before we're done cleaning up. Using the existing kref in
> tty_port, we can let the TTY side and the USB side indenpendently
> signal that they're done with the object, and free it when both are
> done.

I would have thought doing a vhangup was the best approach. The way the
USB serial drivers do it on a cable pull is

	take lock
	mark device disconnected
	drop lock
	for each tty on the device {
		tty_port_tty_get
		if (tty) {
			tty_vhangup(tty);
			tty_kref_put(tty);
	}
	then do the USB disconnect processing
	and drop our USB side kref


and on the open side they provide their own install() method which
nicely avoids all the nasty locking problems and lets them use the
standard tty_port_open/close/hangup etc rather than the partial ones.

It might be worth turning the ACM driver to work the same way as it'll
save doing that work later to achieve the same use of
tty_port_open/close/..

The main thing is the use of install - which lets you plug the USB and
tty bits together during the lookup of the device.

Alan
