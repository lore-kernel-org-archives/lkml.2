Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab1F1MJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:09:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab1F1MHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:07:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 6/7] serial/8250: sanitize fourport handling
Date: Tue, 28 Jun 2011 14:07:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1309211120-2803-1-git-send-email-arnd@arndb.de> <1309211120-2803-7-git-send-email-arnd@arndb.de> <20110628111035.7bd69c0d@lxorguk.ukuu.org.uk>
In-Reply-To: <20110628111035.7bd69c0d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281407.40446.arnd@arndb.de>
X-Provags-ID: V02:K0:V0vpDzrrOxXDjgQADiJXkVXbxtG0LB3wjE0o6O83TIP
 J9w0s2j5qE+Z4ptTs1fYHrpbYtP/gSEaBCSp3j1Ql4YZwp8pUb
 a1BntiYTPTwkVSNNginXaER2f0TXhOkJCHC+3Z7BR7ypOTO9io
 CeOswVzz3B7rcDaIj4lOFlE8e8YnIBRDfmSoC4AAnTfZ+7ZWrW
 Le860OC/JBxilSWJsoTvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 June 2011, Alan Cox wrote:
> On Mon, 27 Jun 2011 23:45:19 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > Support for AST fourport cards is always built into
> > the 8250 driver, even if CONFIG_SERIAL_8250_FOURPORT
> > is disabled. This introduces a set of macros for
> > accessing the special interrupt control register on
> > the fourport card, so that support is left out
> > when the option is disabled, without adding more #ifdef
> > lines to the driver itself.
> 
> Why not just leave it in - it seems to take almost no code and your
> changes mean people setting the fourport flag are going to get strange
> behaviour when it isn't compiled in.

Mostly to avoid the inb/outb when fourport is disabled. The regular
I/O can be handled using the indirect serial_in/out functions, but
the fourport handling requires some address calculations.

Also, now that you mention users toggling the fourport flag, I can't
see where that would ever do something good. On anything but a real
fourport card, it will lead to writing to ports you shouldn't write
to (0x1f on mmio based uarts, 18 bytes after the requested region
for regular ports).

If you have an actual AST fourport card, you won't be able to use
it unless you load the 8250_fourport driver that registers the correct
addresses, and disabling the fourport flag will then cause the
uart to stop getting interrupts.

	Arnd
