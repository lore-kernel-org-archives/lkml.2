Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2A3F7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:59:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62619 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2A3F7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:59:12 -0500
Date: Mon, 30 Jan 2012 06:59:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120130055906.GC22447@somewhere>
References: <1326912275-26405-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-1-git-send-email-jolsa@redhat.com>
 <1327776209-4883-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327776209-4883-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 07:43:24PM +0100, Jiri Olsa wrote:
> Adding a way to temporarily enable/disable ftrace_ops. The change
> follows the same way as 'global' ftrace_ops are done.
> 
> Introducing 2 global ftrace_ops - control_ops and ftrace_control_list
> which take over all ftrace_ops registered with FTRACE_OPS_FL_CONTROL
> flag. In addition new per cpu flag called 'disabled' is also added to
> ftrace_ops to provide the control information for each cpu.
> 
> When ftrace_ops with FTRACE_OPS_FL_CONTROL is registered, it is
> set as disabled for all cpus.
> 
> The ftrace_control_list contains all the registered 'control' ftrace_ops.
> The control_ops provides function which iterates ftrace_control_list
> and does the check for 'disabled' flag on current cpu.
> 
> Adding 3 inline functions:
>   ftrace_function_local_disable/ftrace_function_local_enable
>   - enable/disable the ftrace_ops on current cpu
>   ftrace_function_local_disabled
>   - get disabled ftrace_ops::disabled value for current cpu
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/ftrace.h |   65 ++++++++++++++++++++++++++++
>  kernel/trace/ftrace.c  |  111 +++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/trace/trace.h   |    2 +
>  3 files changed, 171 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index f33fb3b..5cb3a51 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -31,16 +31,32 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  
>  typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
>  
> +/*
> + * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
> + * set in the flags member.
> + *
> + * ENABLED - set/unset when ftrace_ops is registered/unregistered
> + * GLOBAL  - set manualy by ftrace_ops user to denote the ftrace_ops
> + *           is part of the global tracers sharing the same filter
> + *           via set_ftrace_* debugfs files.
> + * DYNAMIC - set when ftrace_ops is registered to denote dynamically
> + *           allocated ftrace_ops which need special care
> + * CONTROL - set manualy by ftrace_ops user to denote the ftrace_ops
> + *           could be controled by following calls:
> + *           ftrace_function_enable, ftrace_function_disable

Should be ftrace_function_local_enable.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
