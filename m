Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab1D1AcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:32:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34171 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab1D1AcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:32:16 -0400
Subject: Re: [PATCH 1/2] break out page allocation warning code
From: john stultz <johnstul@us.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1104271641350.25369@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104201317410.31768@chino.kir.corp.google.com>
	 <1303331695.2796.159.camel@work-vm>
	 <20110421103009.731B.A69D9226@jp.fujitsu.com>
	 <1303846026.2816.117.camel@work-vm>
	 <alpine.DEB.2.00.1104271641350.25369@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 17:32:08 -0700
Message-ID: <1303950728.2971.35.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 16:51 -0700, David Rientjes wrote:
> On Tue, 26 Apr 2011, john stultz wrote:
> > In the meantime, I'll put some effort into trying to protect unlocked
> > current->comm acccess using get_task_comm() where possible. Won't happen
> > in a day, and help would be appreciated. 
> > 
> 
> We need to stop protecting ->comm with ->alloc_lock since it is used for 
> other members of task_struct that may or may not be held in a function 
> that wants to read ->comm.  We should probably introduce a seqlock.

Agreed. My initial approach is to consolidate accesses to use
get_task_comm(), with special case to skip the locking if tsk==current,
as well as a lock free __get_task_comm() for cases where its not current
being accessed and the task locking is already done.

Once that's all done, the next step is to switch to a seqlock (or
possibly RCU if Dave is still playing with that idea), internally in the
get_task_comm implementation and then yank the special __get_task_comm. 

But other suggestions are welcome.

thanks
-john


