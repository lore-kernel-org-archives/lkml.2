Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0DDWN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 18:13:56 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43528 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0DDWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 18:13:50 -0400
Date: Mon, 5 Apr 2010 00:13:49 +0200
From: Andreas Mohr <andi@lisas.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
Message-ID: <20100404221349.GA18036@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'd some lucky candidates]

Hello,

I was just running
mkfs.ext4 -b 4096 -E stride=128 -E stripe-width=128 -O ^has_journal
/dev/sdb2
on my SSD18M connected via USB1.1, and the result was, well,
absolutely, positively _DEVASTATING_.

The entire system became _FULLY_ unresponsive, not even switching back
down to tty1 via Ctrl-Alt-F1 worked (took 20 seconds for even this key
to be respected).

Once back on ttys, invoking any command locked up for minutes
(note that I'm talking about attempted additional I/O to the _other_,
_unaffected_ main system HDD - such as loading some shell binaries -,
NOT the external SSD18M!!).

Having an attempt at writing a 300M /dev/zero file to the SSD's filesystem
was even worse (again tons of unresponsiveness), combined with multiple
OOM conditions flying by (I/O to the main HDD was minimal, its LED was
almost always _off_, yet everything stuck to an absolute standstill).

Clearly there's a very, very important limiter somewhere in bio layer
missing or broken, a 300M dd /dev/zero should never manage to put
such an onerous penalty on a system, IMHO.


I've got SysRq-W traces of these lockup conditions if wanted.


Not sure whether this is a 2.6.34-rc3 thing, might be a general issue.

Likely the lockup behaviour is a symptom of very high memory pressure.
But this memory pressure shouldn't even be allowed to happen in the first
place, since the dd submission rate should immediately get limited by the kernel's
bio layer / elevators.

Also, I'm wondering whether perhaps additionally there are some cond_resched()
to be inserted in some places, to try to improve coping with such a
broken situation at least.

Thanks,

Andreas Mohr
