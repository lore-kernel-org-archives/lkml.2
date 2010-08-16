Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0HPIBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:01:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:37329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0HPIBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:01:16 -0400
Subject: Re: [patch 3/3] sched: move sched_avg_update() to update_cpu_load()
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, chris@frostnet.net,
        debian00@aliceadsl.fr, hpa@zytor.com, jonathan.protzenko@gmail.com,
        mans@mansr.com, psastudio@mail.ru, rjw@sisk.pl, stephan.eicher@web.de,
        sxxe@gmx.de, thomas@archlinux.org, venki@google.com, wonghow@gmail.com
In-Reply-To: <20100813193911.999833492@sbsiddha-MOBL3.sc.intel.com>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.999833492@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 10:00:34 +0200
Message-ID: <1281945634.1926.968.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 12:45 -0700, Suresh Siddha wrote:
> plain text document attachment (move_sched_avg_update.patch)
> Currently sched_avg_update() (which updates rt_avg stats in the rq) is getting
> called from scale_rt_power() (in the load balance context) which doesn't take
> rq->lock.

Right, but I think it doesn't need to, as its never accessed cross CPU
(except maybe for /proc/sched_debug, and who cares about that).

The (other) odd case is NO_HZ idle balancing, but there the actual CPU
won't be updating the fields, so the remote CPU doing NO_HZ idle
balancing should be good to touch it.

> Fix it by moving the sched_avg_update() to more appropriate update_cpu_load()
> where the CFS load gets updated aswell.

Right, except it breaks things a bit, at the very least you really need
that update right before reading it, otherwise you can end up with >100%
fractions, which are odd indeed ;-)


