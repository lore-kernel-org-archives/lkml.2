Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab2EIO3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:29:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075Ab2EIO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:29:50 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=0in4RCm__d4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=fITZu9o3ItzPxV5FLo8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336573788.14207.208.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v7 1/3] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 10:29:48 -0400
In-Reply-To: <CAL26m8J9j9oqGRte80Kp7zH8DQr5RuHPS88w7+2hry2E-N7VYg@mail.gmail.com>
References: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
	 <1336096792-25373-1-git-send-email-vnagarnaik@google.com>
	 <1336534682.14207.197.camel@gandalf.stny.rr.com>
	 <CAL26m8J9j9oqGRte80Kp7zH8DQr5RuHPS88w7+2hry2E-N7VYg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 22:00 -0700, Vaibhav Nagarnaik wrote:
> On Tue, May 8, 2012 at 8:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > BTW, why the two loops and not just:
> >
> >                for_each_buffer_cpu(buffer, cpu) {
> >                        cpu_buffer = buffer->buffers[cpu];
> >                        if (!cpu_buffer->nr_pages_to_update)
> >                                continue;
> >
> >                        if (cpu_online(cpu))
> >                                schedule_work_on(cpu, &cpu_buffer->update_pages_work);
> >                        else
> >                                rb_update_pages(cpu_buffer);
> >                }
> >
> > ??
> >
> >
> >>
> >>               /* wait for all the updates to complete */
> >>               for_each_buffer_cpu(buffer, cpu) {
> >>                       cpu_buffer = buffer->buffers[cpu];
> >> -                     if (cpu_buffer->nr_pages_to_update) {
> >> -                             update_pages_handler(cpu_buffer);
> >> -                     }
> >> +                     if (!cpu_buffer->nr_pages_to_update||
> >
> >                              !cpu_buffer->nr_pages_to_update ||
> 
> This schedules work for all online CPUs and the offline CPUs resizing
> (if any) can occur concurrently. It might not be too much of big deal
> to just make it one loop.

This is far from a hot path. In fact, it's quite slow. Lets not uglify
code just to optimize something that's not time critical.

Please combine these two into a single loop. The wait for completion is
fine as a separate loop.

Thanks,

-- Steve

