Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab0F1UBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:01:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab0F1UBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:01:53 -0400
Date: Mon, 28 Jun 2010 13:00:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees.cook@canonical.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
Message-Id: <20100628130028.73757a46.akpm@linux-foundation.org>
In-Reply-To: <20100623202335.GA4424@x200>
References: <20100623181129.GM5876@outflux.net>
	<20100623194145.GA19628@redhat.com>
	<20100623202335.GA4424@x200>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 23:23:35 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Jun 23, 2010 at 09:41:45PM +0200, Oleg Nesterov wrote:
> > On 06/23, Kees Cook wrote:
>  
> > > -extern char *get_task_comm(char *to, struct task_struct *tsk);
> > > +#define get_task_comm(buf, task) get_task_comm_size(buf, sizeof(buf), task)
> > > +extern char *get_task_comm_size(char *to, size_t len, struct task_struct *tsk);
> > 
> > Oh, but this means that get_task_comm(ptr, task) doesn't work?
> 
> The number of users is so small, and everyone uses TASK_COMM_LEN,
> so maybe nothing should be done or "char buf[TASK_COMM_LEN]"?

Yup, it would take an act of wilful daftness to pass anything other
than a TASK_COMM_LEN array into get_task_comm().

I can't say I like the patch much - going in and altering a task's
comm[] behind its back seems fraught with all sorts of problems which I
can't immediately think of.  Do we corrupt (err, "fix")
/proc/pid/cmdline as well?

Surely it would be better to fix the tools which display this info
rather than making the kernel tell fibs.
