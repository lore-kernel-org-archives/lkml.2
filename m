Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab1LNWGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:06:49 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:51096 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758242Ab1LNWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:06:47 -0500
Date: Wed, 14 Dec 2011 17:06:42 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Massive log spam loading modules on ARM after 3.2-rc5
 (regression)
Message-ID: <20111214220642.GA20822@elliptictech.com>
References: <20111214215133.GA7780@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111214215133.GA7780@elliptictech.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Copying LKML because linux-arm-kernel is bouncing my mails.]

On 2011-12-14 16:51 -0500, Nick Bowler wrote:
> Hi folks,
> 
> With latest Linus' master, I'm faced with massive log spam on our ARM
> Versatile Express platform when using modules.  Here's an example:
> 
>   # modprobe sp805-wdt
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   sp805-wdt mb:wdt: registration successful
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
>   unwind: Unknown symbol address 7f802009
>   unwind: Index not found 7f802009
> 
> The message only seem to get printed at module load time.  Other than
> the noise, things _seem_ to be working.  Nevertheless, it's a regression
> introduced after 3.2-rc5 by the following commit:
> 
>   de66a979012dbc66b1ec0125795a3f79ee667b8a is the first bad commit
>   commit de66a979012dbc66b1ec0125795a3f79ee667b8a
>   Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>   Date:   Mon Dec 5 09:39:59 2011 +0100
> 
>       ARM: 7187/1: fix unwinding for XIP kernels
> 
>       The linker places the unwind tables in readonly sections. So when using
>       an XIP kernel these are located in ROM and cannot be modified.
>       For that reason the current approach to convert the relative offsets in
>       the unwind index to absolute addresses early in the boot process doesn't
>       work with XIP.
> 
>       The offsets in the unwind index section are signed 31 bit numbers and
>       the structs are sorted by this offset. So it first has offsets between
>       0x40000000 and 0x7fffffff (i.e. the negative offsets) and then offsets
>       between 0x00000000 and 0x3fffffff. When seperating these two blocks the
>       numbers are sorted even when interpreting the offsets as unsigned longs.
> 
>       So determine the first non-negative entry once and track that using the
>       new origin pointer. The actual bisection can then use a plain unsigned
>       long comparison. The only thing that makes the new bisection more
>       complicated is that the offsets are relative to their position in the
>       index section, so the key to search needs to be adapted accordingly in
>       each step.
> 
>       Moreover several consts are added to catch future writes and rename the
>       member "addr" of struct unwind_idx to "addr_offset" to better match the
>       new semantic. (This has the additional benefit of breaking eventual
>       users at compile time to make them aware of the change.)
> 
>       In my tests the new algorithm was a tad faster than the original and has
>       the additional upside of not needing the initial conversion and so saves
>       some boot time and it's possible to unwind even earlier.
> 
>       Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>       Acked-by: Nicolas Pitre <nico@fluxnic.net>
>       Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>       Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
>   :040000 040000 9c4363228515808d71dac84a4a16e0aa0cf4ceaa 65b80d4e51fabf0a3142a880be795f4b38f4d9fe M	arch
> 
> I am *not* using XIP.  Reverting this commit resolves the issue.
> 
> Let me know if you need any more info,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
