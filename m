Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab1GTVEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1GTVEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:04:22 -0400
Date: Wed, 20 Jul 2011 23:01:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] taskstats: add_del_listener() should ignore !valid
	listener's
Message-ID: <20110720210146.GA6273@redhat.com>
References: <20110720185959.GA21749@redhat.com> <20110720190036.GB21753@redhat.com> <20110720194603.GA3385@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720194603.GA3385@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20, Vasiliy Kulikov wrote:
>
> On Wed, Jul 20, 2011 at 21:00 +0200, Oleg Nesterov wrote:
> > When send_cpu_listeners() finds the orphaned listener it marks
> > it as !valid and drops listeners->sem. Before it takes this sem
> > for wrinting, s->pid can be reused and add_del_listener() can
> > wrongly try to re-use this entry.
> >
> > Change add_del_listener() to check ->valid = T.
>
> I think the current logic is wrong.

me too ;)

still I think this patch makes sense anyway.

> If s was claimed is invalid, it
> then points to a dead task,

I forgot everything I knew about netlink. But, it seems, netlink_bind()
can use nl_pid != current->pid. But even if this is not true,

> it is unknown when it died.  As the same pid
> can be reused by a new process BEFORE add_del_listener(), it is unknown
> whether ->pid points to the actual owner task.

And? Why should we try to reuse the !valid entries? struct listener
is just the "addr" we should send the message to. If someone calls
add_listener() it should works regardless of dead entries with the
same ->pid.

> Rather than optimizing the wrong algorithm it's better to change the
> processes keeping way.

Not sure I understand... This is not optimizing, the patch tries to
fix the unlikely (in fact mostly theoretical) and minor problem. Still
this is the problem, no?

Thanks,

Oleg.

