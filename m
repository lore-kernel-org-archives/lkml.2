Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab1ASPqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:46:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1ASPqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:46:04 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=44vUGAvzfu8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=a5GEMpU4B_xSjz_rPp0A:9 a=-QfksepMsKhnUdp3wBYA:7 a=z5t0zjHgpyR9LOnzSd5i3iZ0SW0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: mathieu.desnoyers@efficios.com, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
In-Reply-To: <20110118.232045.58440904.davem@davemloft.net>
References: <1295382144.12215.123.camel@gandalf.stny.rr.com>
	 <20110119050844.GA8776@Krystal>
	 <20110118.223247.241909079.davem@davemloft.net>
	 <20110118.232045.58440904.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 19 Jan 2011 10:46:00 -0500
Message-ID: <1295451961.12215.1291.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After applying David's "remove align" patch, I got it to boot on x86_64
with the following two patches. I thought just adding the "align" to the
structure declaration would work, but it still failed on the syscall for
init_module. By removing the double "declaration" of event_exit_##sname,
removed this problem.

I'll test this on x86 32bit and PPC 64. If it works there, I'll push all
of them out for 38. Should these go to 37 stable too?

-- Steve

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index cacc27a..0e3bce6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -142,8 +142,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static struct syscall_metadata					\
 	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
-	static struct ftrace_event_call					\
-	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\


Index: linux-trace.git/include/linux/ftrace_event.h
===================================================================
--- linux-trace.git.orig/include/linux/ftrace_event.h
+++ linux-trace.git/include/linux/ftrace_event.h
@@ -194,7 +194,7 @@ struct ftrace_event_call {
 	int				perf_refcount;
 	struct hlist_head __percpu	*perf_events;
 #endif
-};
+} __attribute__((__aligned__(32)));
 
 #define PERF_MAX_TRACE_SIZE	2048
 


