Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2GTRus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:50:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39577 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2GTRuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:50:46 -0400
Date: Fri, 20 Jul 2012 10:50:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120720175041.GI32763@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <1342799311.2583.7.camel@twins>
 <20120720170255.GE32763@google.com>
 <1342804877.2583.42.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342804877.2583.42.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

On Fri, Jul 20, 2012 at 07:21:17PM +0200, Peter Zijlstra wrote:
> > So, the above was my rationale before this "we need to stop destroying
> > and re-creating kthreads across CPU hotplug events because phones do
> > it gazillion times".  Now, I don't think we have any other way.
> 
> OK, so why can't you splice the list of works from the CPU going down
> onto the list of the CPU doing the down and convert any busy worker
> threads to be bound to the cpu doing down?
> 
> That way there's nothing 'left' to get back to on up.

As I wrote above, per-cpu workqueues don't really interact with each
other and there's no mechanism to transfer work items from one to
another, which unfortunately isn't trivial due to backlinks from work
item to cpu workqueue which is necessary for flush / cancel
operations.  I'm sure it's doable but that part is already pretty
complex (already was before cmwq and untangling it probably requires
bloating work_struct) and I don't think it's wise to complicate usual
hot paths for hotplug support.

Also, re-binding busy workers is easy.  The idle ones are difficult
and we have to do that anyway for PM optimization.  What would be the
benefit of not re-binding busy ones at the risk of continually
transferring workers to another CPU given the right workload + CPU
down/up patterns?

Thanks.

-- 
tejun
