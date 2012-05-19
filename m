Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2ESDTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 23:19:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272Ab2ESDTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 23:19:15 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=bvAfA6HpYssA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=w0nfZR6-_8xqnvfk7_8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337397553.7562.24.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Merge separate resize loops
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Laurent Chavey <chavey@google.com>, Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Fri, 18 May 2012 23:19:13 -0400
In-Reply-To: <CAL26m8KwqabX1TqOcrVZC1cAFyzbo6fKPB44jcrQfqDytNfANA@mail.gmail.com>
References: <1337372991-14783-1-git-send-email-vnagarnaik@google.com>
	 <1337392560.7562.21.camel@gandalf.stny.rr.com>
	 <CAL26m8KwqabX1TqOcrVZC1cAFyzbo6fKPB44jcrQfqDytNfANA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 20:00 -0700, Vaibhav Nagarnaik wrote:
> On Fri, May 18, 2012 at 6:56 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2012-05-18 at 13:29 -0700, Vaibhav Nagarnaik wrote:
> >>
> >>               /* wait for all the updates to complete */
> >>               for_each_buffer_cpu(buffer, cpu) {
> >>                       cpu_buffer = buffer->buffers[cpu];
> >> -                     if (!cpu_buffer->nr_pages_to_update||
> >> -                         !cpu_online(cpu))
> >> +                     if (!cpu_buffer->nr_pages_to_update)
> >>                               continue;
> >>
> >
> > Why did you make this change? As we only need to wait for completions.
> >
> >> -                     wait_for_completion(&cpu_buffer->update_completion);
> >> -                     /* reset this value */
> >> +                     if (cpu_online(cpu))
> >> +                             wait_for_completion(&cpu_buffer->update_done);
> >>                       cpu_buffer->nr_pages_to_update = 0;
> >
> > Or was the original patch buggy, where we never set nr_page_to_update to
> > zero for the offline case?
> 
> I don't see a bug, since at the start of the resize operation, we
> always recalculate this value. It will be reset to 0, if there are no
> updates. I set it to zero at the end just as a precautionary measure.

But if there were updates on a offline CPU, then the original patch
would not have set this to zero at the end.

Or are you just saying that we don't need to set this to zero, as it
isn't used later on? And when we re-enter this function (where its the
only place, and what it calls, that uses nr_page_to_update), it gets
reset.

IOW, this reset is just a "clean up" of the nr_pages_to_update. Right?

-- Steve


