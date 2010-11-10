Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0KJRpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:45:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51279 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0KJRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sc4EKy1WtSS4l2Ko8V+txWjtnghJNZyONreLQr2mllfaUcvpdpKjGqdj8x2iy03Rw6
         CWW8ZUxNfmMsb2zQiIV6LWIKwLIuqVGnwBfV/8ftokgW/eqryuaRauqQz7zsaSzQqlIB
         qGt85ElR1UgoanNU+o8blE7qEQ2+phptfKMEo=
Date: Wed, 10 Nov 2010 18:45:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Joe Korty <joe.korty@ccur.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        houston.jim@comcast.net
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101110174452.GC5360@nowhere>
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105210059.GA27317@tsunami.ccur.com> <4CD912E9.1080907@cn.fujitsu.com> <20101110155419.GC5750@nowhere> <1289410271.2084.25.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289410271.2084.25.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 06:31:11PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 16:54 +0100, Frederic Weisbecker wrote:
> > run the sched tick and if there was nothing to do
> > for some time and we are in userspace, deactivate it. 
> 
> Not for some time, immediately, have the tick track if it was useful, if
> it was not, have it stop itself, like:
> 
> tick()
> {
>  int stop = 1;
> 
>  if (nr_running > 1)
>   stop = 0;
> 
>  if(rcu_needs_cpu())
>   stop = 0;
> 
>  ...
> 
> 
>  if (stop)
>   enter_nohz_mode();



If we are in userspace then yeah, let's enter nohz immediately.
But if we are in kernelspace, we should probably wait a bit before
switching to nohz, like one HZ, as rcu critical sections are quite
numerous.
We probably don't want to reprogram the timer everytime we enter
a new rcu_read_lock().

