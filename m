Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1FTT4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:56:40 -0400
Received: from relais.videotron.ca ([24.201.245.36]:34924 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1FTT4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:56:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 15:56:38 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alexander Holler <holler@ahsoftware.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <Pine.LNX.4.44L0.1106201436430.2113-100000@iolanthe.rowland.org>
Message-id: <alpine.LFD.2.00.1106201537020.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106201436430.2113-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Alan Stern wrote:

> On Mon, 20 Jun 2011, Alexander Holler wrote:
> 
> > I see it that way: packed is needed to be sure that at least for struct 
> > ehci_regs there are no padding bytes inbetween the members.
> 
> But is it _really_ needed?
> 
> > It might 
> > work without, but that depends on the compiler (-version, architecture, 
> > whatever).
> 
> Have there _ever_ been _any_ combinations of compiler, version, 
> architecture, whatever, that had unwanted padding bytes in this 
> structure?

This can be determined by simple code inspection.

If you must have struct members which are not aligned to their natural 
size then you need __packed.  Example:

struct foo {
	u8  a;
	u16 b;
	u32 c;
	u64 d;
};

Without __packed, there will be padding between a and b, and between c 
and d.  If the order of the members in this struct were reversed, then 
everything would be naturally aligned and no padding between members 
would be inserted.

The size of structures is normally rounded up with padding to the size 
of the largest basic element it contains.  Example:

struct foo {
	u64 a;
	u8 b;
};

Here sizeof(struct foo) would return 16, even if the actual content 
occupies 9 bytes only.  That's because the largest basic element is u64 
i.e. 8 bytes.  Normally this trailing padding is not an issue, unless 
you have an array of such a struct or if it is a member of another 
struct.  If you want to get rid of that padding, you need to use 
__packed again (which of course would make all subsequent instances of 
that structure in your array completely misaligned too).

Two odd exceptions with the old ABI on ARM:

- The alignment of a 64-bit value is always 4 bytes not 8.

- The size of all structures are always rounded up to a 4-byte boundary, 
  irrespective of their content.

If you fall into none of the above issues, then you don't need any 
__packed, period.



Nicolas
