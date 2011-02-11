Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab1BKWUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:20:31 -0500
Received: from blu0-omc1-s12.blu0.hotmail.com ([65.55.116.23]:9032 "EHLO
	blu0-omc1-s12.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756829Ab1BKWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:20:30 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP4078FDA13D3CAAEA18602E96EF0@phx.gbl>
Date: Fri, 11 Feb 2011 17:20:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1297460297.5226.99.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:10:50 up 310 days,  8:00,  5 users,  load average: 0.06, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Feb 2011 22:20:29.0688 (UTC) FILETIME=[E3F8EF80:01CBCA39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
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
> So why can't we make that jump_label_entry::refcount and
> jump_label_key::state an atomic_t and be done with it?
> 
> Then the enabled case uses if (atomic_inc_return(&key->ptr->refcount) ==
> 1), and the disabled atomic_inc(&key->state).
> 

OK, by "enabled" you mean #if defined(CC_HAVE_ASM_GOTO) &&
defined(CONFIG_JUMP_LABEL), and "disabled", the #else.

I guess the only downside is the extra volatile for the atomic_read for
the fallback case, which is not really much of problem realistically
speaking: anyway, the volatile is a good thing to have in the fallback
case to force the compiler to re-read the variable. Let's go with your
idea.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
