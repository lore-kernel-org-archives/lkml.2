Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1CQVgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:36:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab1CQVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:36:22 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=eM3C8kFhov8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=l_Fkke-JbmfrEdolC5gA:9 a=psYsXYnvTj1x4d6M13DLE9xf3FYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] tracing: a proc file to automatically release ring
 buffer memory
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, lizf@cn.fujitsu.com,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimXUDcD5YWAcR=SGa3EBM3+TaMRL1UtF4epxNaP@mail.gmail.com>
References: <AANLkTimXUDcD5YWAcR=SGa3EBM3+TaMRL1UtF4epxNaP@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 17:36:20 -0400
Message-ID: <1300397780.16880.579.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 14:29 -0700, Vaibhav Nagarnaik wrote:
> All
> 
> The current way to release memory from ftrace ring buffer is to:
> echo 0 > /sys/kernel/debug/tracing/buffer_size_kb
> 
> Consider a scenario where ftrace is handled by a user space
> process. Normally, this tracing is done as a low priority task on the
> system. Under memory pressure for high priority tasks, tracing should
> be turned off and the trace ring buffer memory released. The buffer
> allocated is kernel memory and under OOM condition if the user space
> process is oom-killed, there is no way to release the ring buffer
> memory.
> 
> The proposal is to add a proc entry
> /sys/kernel/debug/tracing/buffer_free. Its .release() fileops function
> executes tracing_stop() and then resizes the global trace buffer to
> minimum size (2*BUF_PAGE_SIZE). The user space process opens this file
> and keeps it open. When the process gets killed, the fd gets closed
> and .release() is called. This automatically stops the tracing and
> frees up the ring buffer memory.
> 
> It is optional to use this functionality, since it won't affect
> tracing for current programs. But it provides a way to automatically
> free up memory, if needed. It can also be used on the command line to
> stop tracing and free up memory as a single operation as:
> echo > /sys/kernel/debug/tracing/buffer_free

I don't like adding new files to debug/tracing. If we do add this
feature, I rather have it done with the buffer_size_kb directly. Perhaps
add an ioctl() to the file that will do this.

You can open it and then ioctl(RINGBUF_FREE_ON_CLOSE);

If the process dies, it closes the buffer_size_kb and frees the memory.

-- Steve


