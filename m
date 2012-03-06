Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030909Ab2CFPbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:31:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:44115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030447Ab2CFPbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:31:39 -0500
Message-ID: <1331047870.11248.314.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Date: Tue, 06 Mar 2012 16:31:10 +0100
In-Reply-To: <CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	 <1331034734.11248.287.camel@twins>
	 <CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 22:44 +0800, Lai Jiangshan wrote:
> >> +                       if ((++idle_loop & 0xF) == 0) {
> >> +                               spin_unlock_irq(&sp->gp_lock);
> >> +                               udelay(1);
> >> +                               spin_lock_irq(&sp->gp_lock);
> >> +                       }
> >
> > The purpose of this bit isn't quite clear to me, is this simply a lock
> > break?
> 
> Yes, the main purpose is:
> make the time of sp->gp_lock short, can be determined. 

either introduce cond_resched_lock_irq() or write something like:

	if (need_resched() || spin_needbreak(&sp->gp_lock)) {
		spin_unlock_irq(&sp->gp_lock);
		cond_resched();
		spin_lock_irq(&sp->gp_lock);
	}

udelay(1) is complete nonsense.. 
