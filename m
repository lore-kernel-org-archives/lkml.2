Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2CYU2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:28:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51468 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab2CYU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:28:07 -0400
Date: Sun, 25 Mar 2012 16:28:01 -0400 (EDT)
Message-Id: <20120325.162801.524272241373730265.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] PERF fixes
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 13:28:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes the histogram out-of-date map entry issue as well
as other problems I hit or discovered along the way.

To be honest the histogram entry map pointer is completely
superfluous.

When histogram entries are being used when processing a perf
event, we have the computed and most uptodate map already
in the addr_location that has been built, so we can just
pass that map pointer down into perf_top__record_precise_ip()
and similar.

The other cases, when annotating, are also superfluous.  We don't need
the map file at all to compute the address to pass into addr2line and
objdump.  We have exactly two cases:

1) Dynamic object, use the raw unchanged address

2) ET_EXEC or .gnu.prelink_undo section, we can read the ELF file
   PT_LOAD entries or similar to adjust the address properly.

So neither case needs the map pointer at all.  Then all we're
left with are perf internal debugging printf's and those can
be simply removed.

Signed-off-by: David S. Miller <davem@davemloft.net>
