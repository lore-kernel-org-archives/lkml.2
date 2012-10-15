Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2JOTom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:44:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50749 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab2JOTok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:44:40 -0400
Date: Mon, 15 Oct 2012 15:44:36 -0400 (EDT)
Message-Id: <20121015.154436.753507258899505232.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
CC: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: [BUG] Perf refers to garbage events on 32-bit.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When the perf tool is built 32-bit, it uses a sliding window mechanism
to mmap the events from the perf.data file.

However things stop working once we get past 8 times the 32-bit window
size (which is 32MB).

That's because the session code that reads in the events maintains an
array of 8 mmap'd areas, and wraps around to the first, remapping it,
if it runs through the full set of 8 entries.

But this doesn't work since the perf backends maintain references to
the entry pointers (in iterators, etc.).  But after a remap, that
entry points to a random location in the newly mmap()'d area.

This means any perf.data file larger than 8 * 32MB cannot be correctly
analyzed by the perf tools on 32-bit.

The best solution is probably to make the mmap array variable size,
trying to map everything in sliding window sized chunks, and fail if
we run out of address space.  There are hard dependencies in the perf
code to being able to keep all of the events from a perf.data file
in memory at one time.

