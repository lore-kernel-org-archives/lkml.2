Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0EXPz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:55:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab0EXPzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:55:54 -0400
Subject: Re: [PATCH] Make sure timers have migrated before killing
 migration_thread
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@in.ibm.com
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, tj@kernel.org,
       Ingo Molnar <mingo@elte.hu>, Gautham R Shenoy <ego@in.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Brian King <brking@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100524151655.GF13808@linux.vnet.ibm.com>
References: <20100519090557.GA15237@amitarora.in.ibm.com>
	 <1274261515.5605.10423.camel@twins>
	 <20100524095951.GA17680@amitarora.in.ibm.com>
	 <1274707726.5605.31932.camel@twins>
	 <20100524151655.GF13808@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 May 2010 17:55:14 +0200
Message-ID: <1274716514.5605.32372.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 20:46 +0530, Srivatsa Vaddagiri wrote:
> On Mon, May 24, 2010 at 03:28:45PM +0200, Peter Zijlstra wrote:
> > On Mon, 2010-05-24 at 15:29 +0530, Amit K. Arora wrote:
> > > since _cpu_up() and _cpu_down() can never run in
> > > parallel, because of cpu_add_remove_lock. 
> > 
> > Ah indeed. I guess your initial patch works then. 
> 
> One thing I found surprising was that a cpu's rt-bandwidth renewal could be
> dependant on another cpu's (rt-bandwidth) timer firing ontime. In this case, we
> had migration/23 pulled over to CPU0 and we hung later waiting for migration/23
> to exit. migration/23 was not exiting because it could not run on CPU0 (as
> CPU0's rt-bandwidth had expired). This situation remained forever. I would have
> expected CPU0's bandwidth to have been renewed independent of some timer on
> CPU23 to fire - maybe I am missing something not obvious in the code?

The bandwidth constraint is per cgroup, and cgroups span cpus.
