Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1FSPCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 11:02:40 -0400
Received: from relais.videotron.ca ([24.201.245.36]:11251 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1FSPCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 11:02:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 19 Jun 2011 11:02:18 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <201106162220.02185.arnd@arndb.de>
Message-id: <alpine.LFD.2.00.1106191048040.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106161541260.1697-100000@iolanthe.rowland.org>
 <4DFA634D.6000907@ahsoftware.de> <201106162220.02185.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Arnd Bergmann wrote:

> On Thursday 16 June 2011 22:10:53 Alexander Holler wrote:
> > Using packed doesn't seem to be necessary (at least not with those 
> > versions of gcc I'm using here), I've tried both versions (on arm, 
> > without packed and with packed, aligned(4)) and both are working. I've 
> > only posted the patch because I found the usage of packed, aligned(4) 
> > much clearer than without packed. And It might help avoiding such 
> > discussions like this with people like me who aren't that deep involved 
> > in gcc-specific implementation details. ;)
> > 
> > Anyway, feel free to nack that patch. I don't really care and just 
> > thought I should post it (e.g. as an alternative to removing that packed).
> 
> At least I would be happier without the patch. I'm trying to convince
> people to not use these attributes unless required because too much
> harm is done when they are used without understanding the full
> consequences. I also recommend using __packed as localized as possible,
> i.e. set it for the members that need it, not the entire struct.
> 
> I agree that your patch is harmless, it's just the opposite of
> a cleanup in my opinion.

The question is: does the structure really has to be packed?

If it does, then the follow-up question is: is a packing on word 
boundaries sufficient?

If the answer is yes in both cases, then having packed,aligned(4) is not 
a frivolity but rather a correctness issue.  We can of course provide a 
define in include/linux/compiler-gcc.hto hide the ugliness of it 
somewhat:

#define __packed_32  __attribute__((packed,aligned(4)))

I suspect that the vast majority of the __packed uses in the kernel 
would be better with this __packed_32 instead, the actual need and 
intent would be more clearly expressed, and the generated code in the 
presence of those GCC changes would then be way more efficient and still 
correct.


Nicolas
