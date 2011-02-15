Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab1BOWx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:53:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab1BOWx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:53:27 -0500
Date: Tue, 15 Feb 2011 23:52:34 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110215225234.GP5935@random.random>
References: <20110203024838.GI5843@random.random>
 <4D4B1392.5090603@goop.org>
 <20110204012109.GP5843@random.random>
 <4D4C6F45.6010204@goop.org>
 <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <alpine.LFD.2.00.1102152125180.26192@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102152125180.26192@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 09:26:35PM +0100, Thomas Gleixner wrote:
> Another thing. You check for in_interrupt(), but what makes sure that
> the code which takes pgd_lock is never taken with interrupts disabled
> except during early boot ?

It's perfectly fine to take pgd_lock with irq disabled, as long as you
don't pretend to take the page_table_lock too after that. So that's
not a concern.

I removed _irqsave from all pgd_lock, and I doubt there's any code
protected by pgd_lock that runs with irq disabled, but if there is,
it's still ok and it especially shouldn't have used _irqsave.

The only real issue here to sort out, is if pgd_lock is ever taken
from irq or not, and to me it looks like in_interrupt() should trigger
if it is ever taken from irq, so it won't go unnoticed for long if
this isn't ok.
