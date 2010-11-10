Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab0KJRbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:31:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:42866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab0KJRbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:31:18 -0500
Subject: Re: [PATCH] a local-timer-free version of RCU
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Joe Korty <joe.korty@ccur.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        houston.jim@comcast.net
In-Reply-To: <20101110155419.GC5750@nowhere>
References: <20101104232148.GA28037@linux.vnet.ibm.com>
	 <20101105210059.GA27317@tsunami.ccur.com> <4CD912E9.1080907@cn.fujitsu.com>
	 <20101110155419.GC5750@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 18:31:11 +0100
Message-ID: <1289410271.2084.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 16:54 +0100, Frederic Weisbecker wrote:
> run the sched tick and if there was nothing to do
> for some time and we are in userspace, deactivate it. 

Not for some time, immediately, have the tick track if it was useful, if
it was not, have it stop itself, like:

tick()
{
 int stop = 1;

 if (nr_running > 1)
  stop = 0;

 if(rcu_needs_cpu())
  stop = 0;

 ...


 if (stop)
  enter_nohz_mode();
}


