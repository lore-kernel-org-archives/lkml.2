Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1AEKEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:04:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:36357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1AEKEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:04:07 -0500
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        Darren Hart <dvhart@linux.intel.com>, tglx <tglx@linutronix.de>
In-Reply-To: <20110105110837.B62A.A69D9226@jp.fujitsu.com>
References: <20110104151345.3BC2.A69D9226@jp.fujitsu.com>
	 <4D230C90.6060104@redhat.com> <20110105110837.B62A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 11:04:22 +0100
Message-ID: <1294221862.2016.218.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 11:39 +0900, KOSAKI Motohiro wrote:

> After calling pthread_cond_signal(), T1 which cond_signal caller and T2
> which waked start to GIL grab race. But usually T1 is always win because
> lock variable is in T1's cpu cache. Why kernel and userland have so much
> different result? One of a reason is glibc doesn't have any ticket lock scheme. 

The problem is that making locks strictly fair is that that sucks for
performance, iirc most futex ops are fifo-ordered when they his the
block path, but we do allow for lock-stealing.

Lock-stealing greatly improves performance since it avoids lots of
block/wakeup cycles, but it does make things unfair.

I'm not sure we have a futex option to disable lock-stealing, nor do I
think you really want to, performance suffers really badly.

[This btw is the reason why people reported a performance improvement
when they wrapped all mmap() calls in a pthread_mutex, the
rwsem_down_write() thing doesn't allow for lock-stealing since it needs
to be strict fifo-fair]
