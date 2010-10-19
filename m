Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0JSSKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:10:23 -0400
Received: from c-67-162-90-113.hsd1.in.comcast.net ([67.162.90.113]:50446 "HELO
	kosh.dhis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751531Ab0JSSKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:10:23 -0400
Message-ID: <20101019181021.22456.qmail@kosh.dhis.org>
From: pacman@kosh.dhis.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
To: benh@kernel.crashing.org (Benjamin Herrenschmidt)
Date: Tue, 19 Oct 2010 13:10:21 -0500 (GMT+5)
Cc: mel@csn.ul.ie (Mel Gorman), linux-mm@kvack.org,
        akpm@linux-foundation.org (Andrew Morton),
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1287483410.2341.66.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:
> > 
> > I thought of that, but as far as I can tell, this CPU doesn't have DABR.
> 
> AFAIK, the 7447 is just a derivative of the 7450 design which -does-
> have a DABR ... Unless it's broken :-)

Hmm. gdb resorts to single-stepping when I set a watchpoint while debugging
some userspace program, which I assumed was caused by lack of hardware
watchpoint support. But that's not important right now.

I made a new discovery. During a test boot while looking at the usual symptom
of a corrupted page cache, I run md5sum /sbin/e2fsck twice and got 2
different results, neither one of them correct. The third time, yet another
different result. A few dozen more times, a few dozen more unique results. I
had somehow managed to get a usable interactive shell while corruption was
ongoing.

So then I ran
  dd if=/dev/mem bs=4 count=1 skip=$((0xfc5c080/4)) | od -t x4
a few times very fast, plucking the first affected word directly out of
memory by its physical address. The result:

The low 16 bits are always zero as before. The high 16 bits are a counter,
being incremented at about 1000Hz (as close as I could measure with a crude
shell script. 1024Hz would also be within the margin of error). And it's
little-endian.

While I was watching this happen, there were only 5 or 6 userspace processes
running, and 3 of them were shells. So I doubt that anything in userspace was
doing it. It went on for a few minutes before I exited the interactive shell
and allowed the boot to continue, while keeping an extra shell running on
tty2 to continue making observations. It stopped incrementing almost
immediately.

So what type of driver, firmware, or hardware bug puts a 16-bit 1000Hz timer
in memory, and does it in little-endian instead of the CPU's native byte
order? And why does it stop doing it some time during the early init scripts,
shortly after the root filesystem fsck?

I have not yet attempted to repeat the experiment. If it is repeatable, I'll
probe more deeply into those init scripts later. I'm looking hard at
/etc/rcS.d/S11hwclock.sh

-- 
Alan Curry
