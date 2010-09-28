Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168Ab0I1BD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:03:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:11984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0I1BDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:03:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="611027826"
Subject: Re: [PATCH -v2 4/7] x86, NMI, Rewrite NMI handler
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927132537.GO13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-4-git-send-email-ying.huang@intel.com>
	 <20100927094136.GB32222@erda.amd.com>
	 <AANLkTimTg1uqXdAJ+GyZ3_B6n2xKWdqFL96jvv18JBM+@mail.gmail.com>
	 <20100927132537.GO13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 09:03:52 +0800
Message-ID: <1285635832.20791.119.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 21:25 +0800, Robert Richter wrote:
> On 27.09.10 08:39:24, huang ying wrote:
> 
> Looking at all you comments below I would vote for the following:
> 
> We implement all handlers using DIE_NMI and set its priority
> accordingly in struct notifier_block when registering the the nmi
> handler. We define NMI priorities as macros such as
> NMI_PRIORITY_LOCAL, NMI_PRIORITY_WATCHDOG, NMI_PRIORITY_IO, etc. and
> require all handlers to set the priority. register_die_notifier() with
> (!nb->priority) should return -EINVAL. DIE_NMI_UNKNOWN should only be
> used if there is a handler for the case when all others fail such as
> implemented in the perf nmi handler or when reporting an unknown nmi.
> 
> This will avoid all the confusion below and also makes the code much
> cleaner.

Use priority to enforce the order has some issues except what Don
pointed out (two registers for two call in chain):

- Almost all direct call in default_do_nmi() must be turned into
notifier_block. I know this is what you want. But I am not a big fan of
notifier chain :)

- This makes order of notifier call more implicitly. And I think the
order is important for NMI handler to work properly.

- In your scheme, both die_val (DIE_NMI or DIE_NMI_UNKNOWN) and priority
are used to determine the order of call. This makes code more complex
and no additional benefit.

So I think it is better to use different die_val to determine the order,
and insert some direct call between them.

Best Regards,
Huang Ying


