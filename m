Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1KIXlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:41:20 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:15954 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab1KIXlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:41:19 -0500
Subject: Re: [PATCH net-next v1 0/9] forcedeth: stats & debug enhancements
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <david.decotigny@google.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
In-Reply-To: <cover.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 9 Nov 2011 23:41:13 +0000
Message-ID: <1320882073.2781.20.camel@bwh-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18502.005
X-TM-AS-Result: No--18.988400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 09 Nov 2011 23:41:18.0241 (UTC) FILETIME=[13E1A910:01CC9F39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 14:09 -0800, David Decotigny wrote:
> These changes implement the ndo_get_stats64 API and add a few more
> stats and debugging features for forcedeth. They also ensure that
> stats updates are correct in SMP systems, 32 or 64-bits.
> 
> Regarding the "implement ndo_get_stats64() API" patch, I'm not sure
> I'm using the right way to protect the 64b stats. Ideally, I would
> like them to be non-blocking (u64_stats_sync.h), but as there are
> several sources for updates, I don't think I can do without locking or
> per-CPU stats.

The important thing is that the fast path remains fast, and I think
you've achieved that (due to patch 4/9).  The data path doesn't have to
acquire the stats lock and it only has to use atomic operations in some
error cases.

> Would per-CPU stats be better here (note: I expect the
> contention on netdev_priv(dev)->stats_lock to be _VERY_ low)?
[...]

Only queue-less software devices should maintain per-CPU stats.  For any
device with queues, servicing of each queue must already be serialised
and software stats can be maintained per-queue.  In the single-queue
case this means per-device.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

