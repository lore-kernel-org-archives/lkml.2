Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab0I2RWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:22:19 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33520 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751089Ab0I2RWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:22:18 -0400
Date: Wed, 29 Sep 2010 07:22:06 -0500
From: Jack Steiner <steiner@sgi.com>
To: yinghai@kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Problem: scaling of /proc/stat on large systems
Message-ID: <20100929122206.GA30317@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for suggestions on how to fix a scaling problem with access to
/proc/stat.

On a large x86_64 system (4096p, 256 nodes, 5530 IRQs), access to
/proc/stat takes too long -  more than 12 sec:

	# time cat /proc/stat >/dev/null
	real	12.630s
	user	 0.000s
	sys	12.629s

This affects top, ps (some variants), w, glibc (sysconf) and much more.


One of the items reported in /proc/stat is a total count of interrupts that
have been received. This calculation requires summation of the interrupts
received on each cpu (kstat_irqs_cpu()).

The data is kept in per-cpu arrays linked to each irq_desc. On a
4096p/5530IRQ system summing this data requires accessing ~90MB.


Deleting the summation of the kstat_irqs_cpu data eliminates the high
access time but is an API breakage that I assume is unacceptible.

Another possibility would be using delayed work (similar to vmstat_update)
that periodically sums the data into a single array. The disadvantage in
this approach is that there would be a delay between receipt of an
interrupt & it's count appearing /proc/stat. Is this an issue for anyone?
Another disadvantage is that it adds to the overall "noise" introduced by
kernel threads.

Is there a better approach to take?


--- jack
