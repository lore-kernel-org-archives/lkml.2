Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0FVQHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:07:54 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:41297 "EHLO
	mrelay1-d.mgt.gandi.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752391Ab0FVQHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:07:52 -0400
X-Originating-IP: 217.70.178.40
X-Originating-IP: 74.107.143.84
Date: Tue, 22 Jun 2010 09:07:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
       584846@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#584846: Detects only 64MB and fails to boot on Intel Green
 City board if e820 hooked by GRUB2
Message-ID: <20100622160741.GC11407@feather>
References: <1276351120.14011.194.camel@localhost>
 <4C13D1E7.7060604@zytor.com>
 <20100612185538.GA4511@feather>
 <4C13F102.7000509@zytor.com>
 <20100612222634.GA1785@feather>
 <4C141214.5050601@zytor.com>
 <20100613000742.GA3469@feather>
 <4C14235B.7030605@zytor.com>
 <20100622052236.GA9130@feather>
 <4C205323.3010509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C205323.3010509@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:07:31PM -0700, H. Peter Anvin wrote:
> On 06/21/2010 10:22 PM, Josh Triplett wrote:
> > 
> > How might I diagnose this further?  What might cause Linux to refuse to
> > use the e820 and e801 results provided by GRUB, but accept the ones
> > provided by the BIOS?
> > 
> 
> This is interesting... you apparently have a ACPI 3-style e820 BIOS as
> evidenced by the [1] markers, but Grub presents it as legacy style.

Interesting!  I didn't know until now that that system supported the
ACPI 3-style e820.  (Looks like it doesn't actually use that mechanism
to disable any regions, though, fortunately.)

And yes, GRUB always provides 20-byte e820 entries, never larger,
regardless of what the caller asks for.

> Now, the kernel shouldn't care, but this at least gives a clue.
> 
> Something that might be worthwhile is to add printf's to the kernel's
> e820-parsing routine (in arch/x86/boot/e820.c) and figure out why it
> doesn't like the output.  It's a bit strange that meminfo would produce
> sensible-looking output (well, legal, at least; presenting a two-byte
> range is rather beyond crazy, and so forth) and the kernel wouldn't
> accept it, as the code is intentionally very similar.

Do you mean arch/x86/kernel/e820.c ?  OK, will do.

In the failure case Linux prints the memory map as "BIOS-88".  It looks
like that can only happen if the call to append_e820_map fails.  That in
turn looks like it can only happen if the number of map entries becomes
less than 2 (and since it shouldn't start that way that would have to
happen in sanitize_e820_map), or if 64-bit overflow occurred in the
memory map when adding the start and size fields.

I'll investigate further and try to figure out exactly what caused Linux
to refuse to use the e820 map.

- Josh Triplett
