Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0DAIcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:32:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37235 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab0DAIcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:32:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LmChHhrQ8l3JMpZELY6gj2rNerU9w7frfJsXC3wkETpGxIaAyak9kBuO0v3SeTVM7
	ULHlEiF0CcMJi0ZQH5eUw==
Date: Thu, 1 Apr 2010 01:32:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] proc: don't take ->siglock for /proc/pid/oom_adj
In-Reply-To: <20100331230032.GB4025@redhat.com>
Message-ID: <alpine.DEB.2.00.1004010128050.6285@chino.kir.corp.google.com>
References: <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com>
 <20100330163909.GA16884@redhat.com> <20100330174337.GA21663@redhat.com> <alpine.DEB.2.00.1003301329420.5234@chino.kir.corp.google.com> <20100331185950.GB11635@redhat.com> <alpine.DEB.2.00.1003311408520.31252@chino.kir.corp.google.com>
 <20100331230032.GB4025@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Oleg Nesterov wrote:

> > That doesn't work for depraceted_mode (sic), you'd need to test for
> > OOM_ADJUST_MIN and OOM_ADJUST_MAX in that case.
> 
> Yes, probably "if (depraceted_mode)" should do more checks, I didn't try
> to verify that MIN/MAX are correctly converted. I showed this code to explain
> what I mean.
> 

Ok, please cc me on the patch, it will be good to get rid of the duplicate 
code and remove oom_adj from struct signal_struct.

> > There have been efforts to reuse as much of this code as possible for
> > other sysctl handlers as well, you might be better off looking for
> 
> David, sorry ;) Right now I'd better try to stop the overloading of
> ->siglock. And, I'd like to shrink struct_signal if possible, but this
> is minor.
> 

Do we need ->siglock?  Why can't we just do

	struct sighand_struct *sighand;
	struct signal_struct *sig;

	rcu_read_lock();
	sighand = rcu_dereference(task->sighand);
	if (!sighand) {
		rcu_read_unlock();
		return;
	}
	sig = task->signal;

	... load/store to sig ...

	rcu_read_unlock();

instead?
