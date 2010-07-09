Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0GID0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:26:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47199 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0GID0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:26:33 -0400
X-Authority-Analysis: v=1.1 cv=iR3a2x+wy8z+UqYHl7KFtKHYySPA0Tf/DXXAzrkvAHo= c=1 sm=0 a=zNANCjgXmV0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=dVnW2BUVe_ivXlVLOmYA:9 a=Xo0_Fc1M0_NHljGtE5tc0V688xAA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.35 regression
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <AANLkTilsXUjNNDcC4ZA9m8hBDqzcoh5NGbNd4XX5xx5s@mail.gmail.com>
References: <loom.20100705T144459-919@post.gmane.org>
	 <20100708132237.GA22830@goodmis.org>
	 <AANLkTilsXUjNNDcC4ZA9m8hBDqzcoh5NGbNd4XX5xx5s@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 08 Jul 2010 23:26:29 -0400
Message-ID: <1278645989.1537.133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 21:53 +0300, Zeev Tarantov wrote:

> With gcc 4.5.1 rev. 161655 objdump shows:
> Disassembly of section .data:
> 
> ffffffff8173c438 <__start_syscalls_metadata>:
>         ...
> 
> ffffffff8173c440 <__syscall_meta__mmap>:
> ffffffff8173c440:       2b ab 5f 81 ff ff       sub    -0x7ea1(%rbx),%ebp

Yeah, this is definitely the issue. It starts off at ffffffff8173c438,
when the first item is really at ffffffff8173c440.

Can you try this patch out:

-- Steve

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7f614ce..13ebb54 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -124,7 +124,8 @@ extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata					\
+	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
 	static struct ftrace_event_call __used				\
@@ -138,7 +139,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static struct syscall_metadata __syscall_meta_##sname;		\
+	static struct syscall_metadata					\
+	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct ftrace_event_call __used				\



