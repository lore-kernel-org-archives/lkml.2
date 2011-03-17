Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1CQV3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:29:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab1CQV3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=tVKURBPM+4jCDbUvV9wx4SeglkR55qJsEX0ifN7KOT1jG0KNQ52haeMAb6KXKNQDU4
         C/WhXscEOgMFa8ewx6Ow==
MIME-Version: 1.0
Date: Thu, 17 Mar 2011 14:29:32 -0700
Message-ID: <AANLkTimXUDcD5YWAcR=SGa3EBM3+TaMRL1UtF4epxNaP@mail.gmail.com>
Subject: [RFC] tracing: a proc file to automatically release ring buffer memory
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: rostedt@goodmis.org, mingo@elte.hu, fweisbec@gmail.com,
        lizf@cn.fujitsu.com
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All

The current way to release memory from ftrace ring buffer is to:
echo 0 > /sys/kernel/debug/tracing/buffer_size_kb

Consider a scenario where ftrace is handled by a user space
process. Normally, this tracing is done as a low priority task on the
system. Under memory pressure for high priority tasks, tracing should
be turned off and the trace ring buffer memory released. The buffer
allocated is kernel memory and under OOM condition if the user space
process is oom-killed, there is no way to release the ring buffer
memory.

The proposal is to add a proc entry
/sys/kernel/debug/tracing/buffer_free. Its .release() fileops function
executes tracing_stop() and then resizes the global trace buffer to
minimum size (2*BUF_PAGE_SIZE). The user space process opens this file
and keeps it open. When the process gets killed, the fd gets closed
and .release() is called. This automatically stops the tracing and
frees up the ring buffer memory.

It is optional to use this functionality, since it won't affect
tracing for current programs. But it provides a way to automatically
free up memory, if needed. It can also be used on the command line to
stop tracing and free up memory as a single operation as:
echo > /sys/kernel/debug/tracing/buffer_free


Vaibhav Nagarnaik
