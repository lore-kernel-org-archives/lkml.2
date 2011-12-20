Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1LTQpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:45:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab1LTQpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:45:36 -0500
Subject: Re: trace: multiple ring buffers
From: Steven Rostedt <srostedt@redhat.com>
To: Hiraku TOYOOKA <hiraku.toyooka.gu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        yrl.pp-manager.tt@hitachi.com, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4EF054B4.7050308@hitachi.com>
References: <4EF054B4.7050308@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 20 Dec 2011 11:45:29 -0500
Message-ID: <1324399529.2926.14.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiraku,

Note, it is usually best to contact me at rostedt@goodmis.org (Cc'd) as
I don't always check this email. I especially don't check it when
traveling, and on holidays (like next week).

On Tue, 2011-12-20 at 18:26 +0900, Hiraku TOYOOKA wrote:
> Hello, Steven,
> I'm researching RAS features for real-time systems.
> 
> I'm interested in the multiple ring buffer support on ftrace because of
> following reasons.

Yep, that has been requested before.

> 
> * To preserve particular events such as error or fault over a long time. These
> events are useful for failure analysis. But these events could be lost when
> other trace events are generated in large quantities in one buffer. If there is
> only one buffer, we have to prepare one big buffer so that the particular events
> are not overwritten by other events. It wastes memory as a result.
> 
> * To use the same trace events for different purposes. For example, I'd like to
> collect trace events and detect performance degradation (using sched_switch
> event, etc.), while running flight recorder for failure analysis.
> 
> Multiple buffer support makes these really easy. I'm sure that other users wish
> to use it. Of course, it will introduce some complexities to ftrace code.

Not really. I've always Nack'd the making of the global_ops non-static
for this very reason. The events may need some work, but nothing too
hard.

> 
> So, I'd like to implement following the features on ftrace.
> 
> * A mechanism to increase buffers on demand
> * A mechanism to change destination buffer(s) of each trace event via debugfs
> 
> I have heard from Masami that you have some ideas of multiple buffers. If so,
> could you tell me the ideas? I'd like to cooperate with you to develop multiple
> buffers.

Yeah, basically I figured we create another directory inside the
debugfs/tracing directory. Maybe call it sub_buffers or something.
Inside this directory we could have:

create_buffer - a file that you echo a name into to create a new buffer,
then a directory with that name will appear in this directory.

echo foobar > debugfs/tracing/sub_buffers/create

ls debugfs/tracing/sub_buffers/foobar

buffer_size_kb current_tracer events set_ftrace_filter ...

basically the new directory foobar will be a copy of the debugfs/tracing
directory with a few things possibly missing. Then each of these will be
agnostic to the main tracer.

This was my idea, and I can think of a few issues that will come up, but
nothing that would be a show-stopper.

-- Steve


