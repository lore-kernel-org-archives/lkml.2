Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0CZVb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0CZVb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:31:27 -0400
Message-ID: <4BAD2782.3010704@redhat.com>
Date: Fri, 26 Mar 2010 17:30:42 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH 2/5] jump label: base patch
References: <cover.1269272444.git.jbaron@redhat.com> <79304b525d61cb0e7516cdee1ddcdb5ac3f2579a.1269272444.git.jbaron@redhat.com>
In-Reply-To: <79304b525d61cb0e7516cdee1ddcdb5ac3f2579a.1269272444.git.jbaron@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
> assembly gcc mechanism, we can now branch to labels from an 'asm goto'
> statment. This allows us to create a 'no-op' fastpath, which can subsequently
> be patched with a jump to the slowpath code. This is useful for code which
> might be rarely used, but which we'd like to be able to call, if needed.
> Tracepoints are the current usecase that these are being implemented for.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/asm-generic/vmlinux.lds.h |   10 ++-
>  include/linux/jump_label.h        |   57 +++++++++++++
>  kernel/Makefile                   |    2 +-
>  kernel/jump_label.c               |  165 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 232 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/jump_label.h
>  create mode 100644 kernel/jump_label.c
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 67e6520..83a469d 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -167,7 +167,8 @@
>  	BRANCH_PROFILE()						\
>  	TRACE_PRINTKS()							\
>  	FTRACE_EVENTS()							\
> -	TRACE_SYSCALLS()
> +	TRACE_SYSCALLS()						\
> +	JUMP_TABLE()							\

Just a minor style issue: no need to add '\' on the last line.

>  
>  /*
>   * Data section helpers
> @@ -206,6 +207,7 @@
>  		*(__vermagic)		/* Kernel version magic */	\
>  		*(__markers_strings)	/* Markers: strings */		\
>  		*(__tracepoints_strings)/* Tracepoints: strings */	\
> +		*(__jump_strings)/* Jump: strings */	\
>  	}								\
>  									\

Just a minor style issue: please align the tab.

[...]
> +static struct jump_label_entry *add_jump_label_entry(const char *name, int nr_entries, struct jump_entry *table)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct jump_label_entry *e;
> +	size_t name_len = strlen(name) + 1;
> +	u32 hash = jhash(name, name_len-1, 0);
> +
> +	head = &jump_label_table[hash & (JUMP_LABEL_TABLE_SIZE - 1)];
> +	hlist_for_each_entry(e, node, head, hlist) {
> +		if (!strcmp(name, e->name))
> +			return ERR_PTR(-EEXIST);
> +	}
> +	e = kmalloc(sizeof(struct jump_label_entry) + name_len, GFP_KERNEL);
> +	if (!e)
> +		return ERR_PTR(-ENOMEM);
> +	memcpy(&e->name[0], name, name_len);

Hmm, why don't you just have a pointer for e->name which points name?
Or, maybe you can find it easily from e->table[0].name (so you can save
some memory).

Thank you,


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
