Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab0HDTWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:22:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35131 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab0HDTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:22:10 -0400
Date: Wed, 4 Aug 2010 21:22:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804192204.GG13161@basil.fritz.box>
References: <20100804140021.GN3353@redhat.com>
 <1280931093.1923.1194.camel@laptop>
 <20100804145203.GP3353@redhat.com>
 <1280934161.1923.1294.camel@laptop>
 <20100804151858.GB5130@lenovo>
 <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804184806.GL26154@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Only the upper 2 bits in io_61h indicate the nmi reason, so in case of
> (!(reason & 0xc0)) the source simply can not be determined and all nmi
> handlers in the chain must be called (DIE_NMI/DIE_NMI_IPI). The
> perfctr handler then stops it.
> 
> So you can decide to either get an unrecovered nmi panic triggered by
> a perfctr or losing unknown nmis from other sources. Maybe this can be
> fixed by implementing handlers for those sources.

This is a tricky area. Me and Ying have been looking at this recently.

Hardware traditionally signals NMI when it has a uncontained error and really 
expects the OS to shut down to prevent data corruption spreading. i

Unfortunately especially for some older hardware
there can be cases where this is not expressed in port 61.
But the default behaviour of Linux for this today is quite wrong.

Some cases can be also determined with the help of APEI, which
can give you more information about the error (and tell you
if shutdown is needed).

But of course we can still have performance counter and other NMI
users.

So the right flow might be something like

- check software events (like crash dump or reboot)
- check perfctrs
- check APEI
- check port 61 for known events (it's probably a good idea
to check perfctrs first because accessing io ports is quite slow.
But the perfctr handler has to make sure it doesn't eat unknown
events, otherwise error handling would be impacted)
- check other event sources
- shutdown (depending on the chipset likely)

This means the NMI users who cannot determine themselves if a event
happened and eat everything (like oprofile today) would need to be fixed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
