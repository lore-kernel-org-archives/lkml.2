Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0GHOI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:08:57 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:52771 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab0GHOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:08:56 -0400
Date: Thu, 8 Jul 2010 16:08:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zeev Tarantov <zeev.tarantov@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: 2.6.35 regression
Message-ID: <20100708140854.GA11983@merkur.ravnborg.org>
References: <loom.20100705T144459-919@post.gmane.org> <20100708132237.GA22830@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708132237.GA22830@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 		if (start->name && !strcmp(start->name + 3, str + 3))
> 			return start;
> 
> Now the "start" is iterating from: 
> 
> 	start = (struct syscall_metadata *)__start_syscalls_metadata;
> 	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
> 
> 
> If for some reason, gcc did not link the metadata in a nice array,
> this could cause the start to index incorrectly, which would
> make the "start->name" reference be something pointing to left field.

In vmlinux.lds.h we have the following code:
#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .; \
                         *(__syscalls_metadata)                         \
                         VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;

But there is nothing that guarantee that
__syscalls_metadata starts at the address
assigned to __start_syscalls_metadata.

The will align __syscalls_metadata accoding to the
largest member in that section.

We need to do one of two things:
1) Make sure __start_syscalls_metadata is properly aligned
2) or make the code robust against misaligned symbols.

> 
> Zeev, can you try to reproduce it with gcc 4.4.
> 
> And for now could you send me the output of this:
> 
>  objdump -Dr --start-addr 0x`nm vmlinux | grep __start_syscalls_metadata | cut -d' ' -f 1` \
>     --stop-addr 0x`nm vmlinux | grep __stop_syscalls_metadata | cut -d' ' -f 1` vmlinux
> 
This output would be great to have just to check if my assumption above is correct.

	Sam
