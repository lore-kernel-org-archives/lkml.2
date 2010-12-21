Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0LUOGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 09:06:47 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:41065 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0LUOGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 09:06:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FYXSbnmaNkku9TaHfqzrtlz+q2QLXvUS+HgJeRqprTxXGnBRmNzGj6jnGDMdnPHfmq
         sCVU7JSODehCsERykymf0u2Bnf2EE3/iw8++22pNXlEXPmh5QMcWfW2LOw8lMfSBYW2m
         I2Lxe/4QahwDTTczDRBFknbiUiEpPQTfaNCxQ=
Date: Tue, 21 Dec 2010 15:06:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 10/15] nohz_task: Enter in extended quiescent state
 when in userspace
Message-ID: <20101221140635.GF1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-11-git-send-email-fweisbec@gmail.com>
 <1292861920.5021.29.camel@laptop>
 <20101221012742.GJ1715@nowhere>
 <1292918694.5021.194.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292918694.5021.194.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 09:04:54AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 02:27 +0100, Frederic Weisbecker wrote:
> > On Mon, Dec 20, 2010 at 05:18:40PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > > > (we check if the local cpu is in nohz mode, which means
> > > > no other task compete on that CPU)
> > > 
> > > You keep repeating that definition, but its not true.. It means there is
> > > not work for the tick to do, the tick does _tons_ more besides
> > > preemption, so nr_running==1 is necessary but not sufficient. 
> > 
> > Sure but the point is that if the tick is not running, it means
> > that the nohz task is the only task running on that CPU.
> 
> No, that too isn't true, the cpu could be idle.
> 
> > Now indeed there are other reasons for the tick to restart like RCU
> > or the effective nohz mode to physically happen or to be delayed,
> > which is decided by tick_nohz_stop_sched_tick().
> 
> You really really really badly need to read through the whole tick path
> and look at all the things it does, put them in a list, then look at the
> current nohz code, mark those it deals with, then go through the nohz
> code again and find the nr_running==0 assumptions, then make sure you've
> covered everything.
> 
> I'm very confident you'll find a number of things to fix. At the very
> least your current patch set totally forgets about task runtime
> accounting (account_process_tick()), the existing NO_HZ doesn't need to
> worry about that because the system is idle so all it needs to do is add
> idle ticks when it wakes up (and possibly steal time for the virt muck).
> 
> You also miss the profile_tick(), and you need to go through the load
> accounting muck (both of them) to see if there are any nr_running==0
> assumptions there.
> 
> You also need to fix the perf counter list rotation stuff, and again,
> check if no_hz load-balancing can deal with the nr_running==1 situation.
> 
> Now, there might be more, this is just a quick one-minute scan through
> the tick code, but the fact that nowhere in this whole patch-set is even
> a mention of these things makes me worry about your whole approach.


Yeah it's right I missed a lot of important things. I'll try to handle
them for the next take.
