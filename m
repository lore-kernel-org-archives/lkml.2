Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab1EXBkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:40:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41726 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab1EXBkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GyZgkII2iSrlLQ9MrdDJmWg4j0ksCRfWOqRD9DdSl1UTycWDBxf2oaqtjRvTa9+KPk
         woRWz2Ldk6Hju/I1ZuAQ==
Date: Mon, 23 May 2011 18:39:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
In-Reply-To: <4DDB0B45.2080507@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105231838420.17729@chino.kir.corp.google.com>
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6207E.1070300@jp.fujitsu.com> <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com> <4DDB0B45.2080507@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, KOSAKI Motohiro wrote:

> > > Also, this patch move finding sacrifice child logic into
> > > select_bad_process(). It's necessary to implement adequate
> > > no root bonus recalculation. and it makes good side effect,
> > > current logic doesn't behave as the doc.
> > > 
> > 
> > This is unnecessary and just makes the oom killer egregiously long.  We
> > are already diagnosing problems here at Google where the oom killer holds
> > tasklist_lock on the readside for far too long, causing other cpus waiting
> > for a write_lock_irq(&tasklist_lock) to encounter issues when irqs are
> > disabled and it is spinning.  A second tasklist scan is simply a
> > non-starter.
> > 
> >   [ This is also one of the reasons why we needed to introduce
> >     mm->oom_disable_count to prevent a second, expensive tasklist scan. ]
> 
> You misunderstand the code. Both select_bad_process() and oom_kill_process()
> are under tasklist_lock(). IOW, no change lock holding time.
> 

A second iteration through the tasklist in select_bad_process() will 
extend the time that tasklist_lock is held, which is what your patch does.  
