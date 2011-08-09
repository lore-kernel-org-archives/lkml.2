Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1HIVND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:13:03 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:37799 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751149Ab1HIVNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:13:01 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6KoKSZUVM1m59OkD0GGaHVW583kUAgEX6aPvyf2fv8up1Nr
 uQro9rRicrlZJAg_TAFy3KrGKFcQiUTbqOIpjzpcTbaqMcNMiiHVJE1LtmQN
 CdqwYtAXHk_CQuZajHvAbJk60Bn_zIdC8kA6Rmr9bzvb4WJdvzmSUWliP35N
 DvUaMz7SlcdfbTi20VgQrf3tpvwSXcUEm6rDs6dqC1Q2rXthSVjPxPDb13XK
 XLqLrs6vnEn4KM9RasuJSLt8r1O351Y1rkBUIStbLtULdbGHUGsQ0DoXUEA_
 0zHzhqt9bgesG4SVAPvY5uriINerTYDG.x5iqRWqGBAQtBarEfImMy.YZReS
 kRnabR8VSdBeffWCojVGdTRaILTFJJOn6Y_yJ7OkwNV3NvA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110809211221.831975979@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Aug 2011 16:12:21 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tj@kernel.org
Cc: Metathronius Galabant <m.galabant@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Adrian Drzewiecki <z@drze.net>
Cc: linux-kernel@vger.kernel.org
Subject: [slub p4 0/7] slub: per cpu partial lists V4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V3->V4 : Use a single linked per cpu list instead of a per cpu array.
	This results in improvements even for the single threaded
	case. I think this is ready for more widespread testing (-next?)
	The number of partial pages per cpu is configurable via
	/sys/kernel/slab/<name>/cpu_partial

V2->V3 : Work on the todo list. Still some work to be done to reduce
         code impact and make this all cleaner. (Pekka: patch 1-3
         are cleanup patches of general usefulness. You got #1 already
         2+3 could be picked up w/o any issue).

The following patchset introduces per cpu partial lists which allow
a performance increase of around ~10-20% with hackbench on my Sandybridge
processor.

These lists help to avoid per node locking overhead. Allocator latency
could be further reduced by making these operations work without
disabling interrupts (like the fastpath and the free slowpath) but that
is another project.

It is interesting to note that BSD has gone to a scheme with partial
pages only per cpu (source: Adrian). Transfer of cpu ownerships is
done using IPIs. Probably too much overhead for our taste. The approach
here keeps the per node partial lists essentially meaning the "pages"
in there have no cpu owner.

