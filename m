Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1CRXAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 19:00:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:59237 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab1CRXAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=NejJ8tHSlAXKIII6L0glbWa3xcnQXD/TE4M2mYMT1uNim/6eFQESs53RuHNwOih3kk
         vXc4XX16m2F6unyEq8mg==
MIME-Version: 1.0
In-Reply-To: <1300397780.16880.579.camel@gandalf.stny.rr.com>
References: <AANLkTimXUDcD5YWAcR=SGa3EBM3+TaMRL1UtF4epxNaP@mail.gmail.com> <1300397780.16880.579.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Fri, 18 Mar 2011 15:59:53 -0700
Message-ID: <AANLkTinPq0hNMnS9_VLUXOQNeQCUAKvoxZfiBoNCzsnX@mail.gmail.com>
Subject: Re: [RFC] tracing: a proc file to automatically release ring buffer memory
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, mingo@elte.hu,
        fweisbec@gmail.com, lizf@cn.fujitsu.com,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 2:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-03-17 at 14:29 -0700, Vaibhav Nagarnaik wrote:
>> All
>>
>> The current way to release memory from ftrace ring buffer is to:
>> echo 0 > /sys/kernel/debug/tracing/buffer_size_kb
>>
>> Consider a scenario where ftrace is handled by a user space
>> process. Normally, this tracing is done as a low priority task on the
>> system. Under memory pressure for high priority tasks, tracing should
>> be turned off and the trace ring buffer memory released. The buffer
>> allocated is kernel memory and under OOM condition if the user space
>> process is oom-killed, there is no way to release the ring buffer
>> memory.
>>
>> The proposal is to add a proc entry
>> /sys/kernel/debug/tracing/buffer_free. Its .release() fileops function
>> executes tracing_stop() and then resizes the global trace buffer to
>> minimum size (2*BUF_PAGE_SIZE). The user space process opens this file
>> and keeps it open. When the process gets killed, the fd gets closed
>> and .release() is called. This automatically stops the tracing and
>> frees up the ring buffer memory.
>>
>> It is optional to use this functionality, since it won't affect
>> tracing for current programs. But it provides a way to automatically
>> free up memory, if needed. It can also be used on the command line to
>> stop tracing and free up memory as a single operation as:
>> echo > /sys/kernel/debug/tracing/buffer_free
>
> I don't like adding new files to debug/tracing. If we do add this
> feature, I rather have it done with the buffer_size_kb directly. Perhaps
> add an ioctl() to the file that will do this.
>
> You can open it and then ioctl(RINGBUF_FREE_ON_CLOSE);
>
> If the process dies, it closes the buffer_size_kb and frees the memory.

Thanks for the feedback Steve. An ioctl on buffer_size_kb sounds fine to me.
