Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2C0ISh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:18:37 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39174 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2C0ISd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:18:33 -0400
Date: Tue, 27 Mar 2012 04:18:20 -0400 (EDT)
Message-Id: <20120327.041820.1291740602811700132.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: perf grows endlessly
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Mar 2012 01:18:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is easy to trigger, just run perf top or similar while something
loops doing "gcc -o foo ...; ./foo; rm foo;"  dsos__find() starts to
move up gradually in the profiles (yes, even if you turn the dso
lists into hash tables, guess what I tried first... :-)

Essentially, the problem is that perf never throws away dsos, so the
dso list grows every iteration of that loop.  This isn't a
manufactured test case, the glibc testsuite does this during it's
conformance test.  It's basically trying to build and execute a
program referencing a symbol, once for every symbol specified in
each and every standard (ISO, ISO99, POSIX, XPG3, etc.)

I suppose you could say this dso issue is indirectly related to the
issue discussed over the weekend where we refer to out-of-date maps
from hist entries.

Hist and thread entries do eventually get collapsed and purged, but
this just never propagates properly.

My initial impression is that we'll need to properly reference count
and periodically sweep dso objects are some point.
