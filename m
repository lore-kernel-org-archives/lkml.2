Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2LKBxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 20:53:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2LKBxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:53:53 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DhgVYC8l6PEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=PwOMEcHXvqEA:10 a=fh3e-8mvBssT78kFxY0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355190830.17101.280.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT 3/4] sched/rt: Use IPI to trigger RT task push
 migration instead of pulling
From: Steven Rostedt <rostedt@goodmis.org>
To: frank.rowand@am.sony.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Mon, 10 Dec 2012 20:53:50 -0500
In-Reply-To: <50C68922.5030203@am.sony.com>
References: <20121207235615.206108556@goodmis.org>
	 <20121208000900.613917378@goodmis.org> <50C682F6.5030709@am.sony.com>
	 <50C68922.5030203@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 17:15 -0800, Frank Rowand wrote:

> I should have also mentioned some previous experience using IPIs to
> avoid runq lock contention on wake up.  Someone encountered IPI
> storms when using the TTWU_QUEUE feature, thus it defaults to off
> for CONFIG_PREEMPT_RT_FULL:
> 
>   #ifndef CONFIG_PREEMPT_RT_FULL
>   /*
>    * Queue remote wakeups on the target CPU and process them
>    * using the scheduler IPI. Reduces rq->lock contention/bounces.
>    */
>   SCHED_FEAT(TTWU_QUEUE, true)
>   #else
>   SCHED_FEAT(TTWU_QUEUE, false)
> 

Interesting, but I'm wondering if this also does it for every wakeup? If
you have 1000 tasks waking up on another CPU, this could potentially
send out 1000 IPIs. The number of IPIs here looks to be # of tasks
waking up, and perhaps more than that, as there could be multiple
instances that try to wake up the same task.

Now this patch set, the # of IPIs is limited to the # of CPUs. If you
have 4 CPUs, you'll get a storm of 3 IPIs. That's a big difference.

Now we could even add a flag, and do a test_and_set on it, and send out
an IPI iff the flag wasn't set before. Have the target CPU clear the
flag and then do the pushing. This would limit even further the IPIs
needed to be sent. I didn't add this yet, because I wanted to test the
current code first, and only add this if there is an issue with too many
IPIs.

-- Steve


