Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0IJO1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:27:03 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43842 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0IJO1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:27:02 -0400
Date: Fri, 10 Sep 2010 16:26:58 +0200
From: Florian Mickler <florian@mickler.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
Message-ID: <20100910162658.254b224a@schatten.dmk.lab>
In-Reply-To: <4C8A07B3.1050603@kernel.org>
References: <4C87AE52.70401@kernel.org>
	<4C87B101.2080608@kernel.org>
	<20100909100229.250900f0@schatten.dmk.lab>
	<4C88B55E.90203@kernel.org>
	<20100909205056.1ac7989a@schatten.dmk.lab>
	<4C8A07B3.1050603@kernel.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 12:25:55 +0200
Tejun Heo <tj@kernel.org> wrote:

> +Concurrency Managed Workqueue (cmwq)
> +
> +September, 2010		Tejun Heo <tj@kernel.org>
> +			Florian Mickler <florian@mickler.org>
> +
> +CONTENTS

Thx.


I fumbled a bit with the ordering in the design
description.. ok so?

Cheers,
Flo

diff --git a/Documentation/workqueue.txt b/Documentation/workqueue.txt
index 5317229..3d22821 100644
--- a/Documentation/workqueue.txt
+++ b/Documentation/workqueue.txt
@@ -86,45 +86,44 @@ off of the queue, one after the other.  If no work
is queued, the
 worker threads become idle.  These worker threads are managed in so
 called thread-pools.
 
-Subsystems and drivers can create and queue work items on workqueues
-as they see fit.
-
-By default, workqueues are per-cpu.  Work items are queued and
-executed on the same CPU as the issuer.  These workqueues and work
-items are said to be "bound".  A workqueue can be specifically
-configured to be "unbound" in which case work items queued on the
-workqueue are executed by worker threads not bound to any specific
-CPU.
-
 The cmwq design differentiates between the user-facing workqueues that
 subsystems and drivers queue work items on and the backend mechanism
 which manages thread-pool and processes the queued work items.
 
-The backend mechanism is called gcwq.  There is one gcwq for each
+The backend is called gcwq.  There is one gcwq for each
 possible CPU and one gcwq to serve work items queued on unbound
 workqueues.
 
+Subsystems and drivers can create and queue work items through special
+workqueue API functions as they see fit. They can influence some
+aspects of the way the work items are executed by setting flags on the
+workqueue they are putting the work item on. These flags include
+things like cpu locality, reentrancy, concurrency limits and more. To
+get a detailed overview refer to the API description of
+alloc_workqueue() below. 
+
 When a work item is queued to a workqueue, the target gcwq is
 determined according to the queue parameters and workqueue attributes
-and queued on the shared worklist of the gcwq.  For example, unless
+and appended to the shared worklist of that gcwq.  For example, unless
 specifically overridden, a work item of a bound workqueue will be
-queued on the worklist of the gcwq of the CPU the issuer is running
-on.
+queued on the worklist of exactly that gcwq that is associated to the 
+CPU the issuer is running on.
 
 For any worker pool implementation, managing the concurrency level (how
 many execution contexts are active) is an important issue.  cmwq tries
-to keep the concurrency at minimal but sufficient level.
+to keep the concurrency at a minimal but sufficient level. Minimal to
save
+resources and sufficient in that the system is used at it's full
capacity.
 
 Each gcwq bound to an actual CPU implements concurrency management by
 hooking into the scheduler.  The gcwq is notified whenever an active
 worker wakes up or sleeps and keeps track of the number of the
 currently runnable workers.  Generally, work items are not expected to
-hog CPU cycle and maintaining just enough concurrency to prevent work
-processing from stalling should be optimal.  As long as there is one
-or more runnable workers on the CPU, the gcwq doesn't start execution
-of a new work, but, when the last running worker goes to sleep, it
-immediately schedules a new worker so that the CPU doesn't sit idle
-while there are pending work items.  This allows using minimal number
+hog a CPU and consume many cycles. That means maintaining just enough 
+concurrency to prevent work processing from stalling should be
optimal.  
+As long as there is one or more runnable workers on the CPU, the gcwq 
+doesn't start execution of a new work, but, when the last running
worker goes
+to sleep, it immediately schedules a new worker so that the CPU
doesn't sit 
+idle while there are pending work items.  This allows using a minimal
number
 of workers without losing execution bandwidth.
 
 Keeping idle workers around doesn't cost other than the memory space

