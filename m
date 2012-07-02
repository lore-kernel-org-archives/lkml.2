Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2GBWqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:46:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:59276 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab2GBWqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:46:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187699399"
Date: Mon, 2 Jul 2012 15:46:48 -0700
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        shemminger@vyatta.com
Subject: long boot delays caused by 070ad7e7 floppy change
Message-ID: <20120702224648.GA20361@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

One of my test systems has a new 20s+ boot delay in 3.5rc*
It takes the floppy driver that long to determine I don't 
have a floppy

[    2.386322] calling  floppy_init+0x0/0xe46 @ 1
[    2.448977] Refined TSC clocksource calibration: 2594.106 MHz.
[    2.449021] Switching to clocksource tsc
[   22.371560] floppy0: no floppy controllers found
[   22.371676] initcall floppy_init+0x0/0xe46 returned -19 after 19553621 usecs

In older kernels the delay is only about 3s.

I tracked it down to 

commit 070ad7e793dc6ff753ee682ef7790b3373b471f6
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Fri May 18 13:50:25 2012 +0200

    floppy: convert to delayed work and single-thread wq

The problem is not completely stable, a bisect actually doesn't
find it and reverting the patch on current HEAD also doesn't help.

However when setting the tree manually to one commit before
yours the problem is gone and adding your patch adds it.

I think the floppy init should run asynchronous, but it 
would be still good to make this faster again. Since block
devices need to be synchronized at end of boot there is no
way to hide a 20s delay completely.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
