Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1BKWQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:16:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168Ab1BKWQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:16:51 -0500
Date: Fri, 11 Feb 2011 17:15:50 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110211221550.GA9148@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297460297.5226.99.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:38:17PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-02-11 at 16:13 -0500, Mathieu Desnoyers wrote:
> > 
> > Thoughts ? 
> 
>  #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> +
> +struct jump_label_key {
> +       void *ptr;
> +};
> 
>  struct jump_label_entry {
>         struct hlist_node hlist;
>         struct jump_entry *table;
> -       int nr_entries;
>         /* hang modules off here */
>         struct hlist_head modules;
>         unsigned long key;
> +       u32 nr_entries;
> +       int refcount;
>  };
> 
> #else
> 
> +struct jump_label_key {
> +       int state;
> +};
> 
> #endif
> 
> 
> 
> So why can't we make that jump_label_entry::refcount and
> jump_label_key::state an atomic_t and be done with it?
> 
> Then the enabled case uses if (atomic_inc_return(&key->ptr->refcount) ==
> 1), and the disabled atomic_inc(&key->state).
> 

a bit of history...

For the disabled jump label case, we didn't want to incur an atomic_read() to
check if the branch was enabled.

So, I separated the API, to have one for the non-atomic case, and one
for the atomic case. Nobody liked that.

So now, I'm proposing to leave the core API based around a non-atomic
variable, and have any callers that want to use this atomic interface,
to call into the non-atomic interface. If another user besides perf
wants to use the same type of atomic interface, we can re-visit the
decsion? 

thanks,

-Jason
