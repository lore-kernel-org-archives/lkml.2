Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0JSVEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:04:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:34395 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab0JSVD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:03:59 -0400
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: pacman@kosh.dhis.org, Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <56111.84.105.60.153.1287521237.squirrel@gate.crashing.org>
References: <20101019181021.22456.qmail@kosh.dhis.org>
	 <56111.84.105.60.153.1287521237.squirrel@gate.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 08:02:48 +1100
Message-ID: <1287522168.2198.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 22:47 +0200, Segher Boessenkool wrote:
> 
> It looks like it is the frame counter in an USB OHCI HCCA.
> 16-bit, 1kHz update, offset x'80 in a page.
> 
> So either the kernel forgot to call quiesce on it, or the firmware
> doesn't implement that, or the firmware messed up some other way.

I vote for the FW being on crack. Wouldn't be the first time with
Pegasos.

It's an OHCI or an UHCI in there ?

Can you try in prom_init.c changing the prom_close_stdin() function to
also close "stdout" ? 

         if (prom_getprop(_prom->chosen, "stdin", &val, sizeof(val)) > 0)
                 call_prom("close", 1, 0, val);
+        if (prom_getprop(_prom->chosen, "stdout", &val, sizeof(val)) > 0)
+               call_prom("close", 1, 0, val);

See if that makes a difference ?

Last option would be to manually turn the thing off with MMIO in yet-another
pegasos workaround in prom_init.c.

Cheers,
Ben.


