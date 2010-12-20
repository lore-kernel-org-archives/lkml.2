Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0LTP5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:57:49 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:65090 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023Ab0LTP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:57:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q29Bjg8b3UoYZ9Eha2QTnoP/aZGhcZIQbShli53WA6qfLrpwOMimszXhulqGavXmI1
         oZAa9+mftJml1JJBaWCa1ujuHV2TQcl52KjI3ERZFahAu0rGmUTtm2BSeSzaG2K22BrG
         FvF1q25xVFOFt+BucteaJ+C2Vbva+l7no9bCw=
Date: Mon, 20 Dec 2010 16:57:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
Message-ID: <20101220155737.GA1742@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-16-git-send-email-fweisbec@gmail.com>
 <1292859744.5021.4.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292859744.5021.4.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:42:24PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > This implements the /proc/pid/nohz file that enables the
> > nohz attribute of a task.
> > 
> > Synchronization is enforced so that:
> > 
> > - A CPU can have only one nohz task
> 
> Why?


This is because of the hooks we have with entering/exiting userspace.
The "wants to enter extended quiescent" variable (nohz_task_ext_qs)
is per CPU and applies to any nohz task.

If A and B are nohz task bound to the same CPU,

A enters userspace, says it can enter extended quiescent state
(nohz_task_ext_qs = 1).
B preempts it and enters kernel, hence saying that it doesn't want
extended quiescent state (nohz_task_ext_qs = 0). B sleeps, we return
to A which said that it wants extended quiescent state but the per cpu
var has been screwed (nohz_task_ext_qs == 0).

But this can be solved using a per task variable. I just thought it
wouldn't be very useful to have two nohz task on a same CPU, but actually
why not.
 
> > - A nohz task can be only affine to a single CPU
> 
> Why?

Same problem, we need to make some things per task. That's fixable,
This will may be add a bit of complexity and since I couldn't find
a usecase for migratable nohz tasks, I did not handled that case.

Should I?

> > For now this is only possible to write on /proc/self but probably
> > allowing it from another task would be a good idea and wouldn't
> > increase so much the complexity of the code. 
> 
> ptrace rules might match that.

You think I should use the ptrace interface? Hmm, dunno if it's
appropriate.
