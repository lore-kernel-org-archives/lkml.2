Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2ECM5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:57:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2ECM5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:57:22 -0400
X-Authority-Analysis: v=2.0 cv=bcnpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=YECtLpki0LgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=oh7p09fDAAAA:8 a=Zm_B_Y7Yb7E_A1nUUXIA:9 a=PUjeQqilurYA:10 a=S4qrOZZe1UsA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336049840.14207.82.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v6 1/3] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 08:57:20 -0400
In-Reply-To: <CAL26m8KgvuUGhK_T91fM2dNtFt4+KSOb5-C8yNiZ888BZW1PEg@mail.gmail.com>
References: <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
	 <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
	 <1336010118.14207.75.camel@gandalf.stny.rr.com>
	 <CAL26m8KgvuUGhK_T91fM2dNtFt4+KSOb5-C8yNiZ888BZW1PEg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 23:40 -0700, Vaibhav Nagarnaik wrote:
> On Wed, May 2, 2012 at 6:55 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Hmm, something in this patch breaks buffers_size_kb and friends.
> 
> I checked and I guess you are referring to the initial state of the
> buffer_size_kb, which returns:
> 0 (expanded: 1408)
> instead of:
> 7 (expanded: 1408)
> 

No I realized that. That changed with your other patch.

> I found this got in with the earlier patch which added per-cpu
> buffer_size_kb. I will send a small fix-up patch for it.

Yeah, probably should send a fix for that.

> 
> After expanding the ring buffer to various sizes, I couldn't find any
> other breakage. Is there any other behavior that you saw as odd?

The issue I see seems to trigger with trace-cmd:

[root@ixf ~]# cat /debug/tracing/buffer_size_kb 
0 (expanded: 1408)
[root@ixf ~]# trace-cmd start -e sched
/debug/tracing/events/sched/filter
/debug/tracing/events/*/sched/filter
[root@ixf ~]# cat /debug/tracing/buffer_size_kb 
0

But if I enable it via the command line it works:

[root@ixf ~]# cat /debug/tracing/buffer_size_kb 
0 (expanded: 1408)
[root@ixf ~]# echo 1 > /debug/tracing/events/sched/enable 
[root@ixf ~]# cat /debug/tracing/buffer_size_kb 
1408


Without your patch:

[root@ixf ~]# cat /debug/tracing/buffer_size_kb 
0 (expanded: 1408)
[root@ixf ~]# trace-cmd start -e sched
/debug/tracing/events/sched/filter
/debug/tracing/events/*/sched/filter
[root@ixf ~]# cat /debug/tracing/buffer_size_kb 
1408


So it seems to be trace-cmd doing something different that prevents the
expand from happening. Not sure what it is. If I get time, I'll
investigate it a little more.

Thanks,

-- Steve


