Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1EYXuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:50:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32074 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab1EYXuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=KKqEqxY4ncCn3fPte2ZEbD4m/9OIMbKriviJUqieVMRNn8dWtOHTxZX6i6vX4hIR+E
         pdWPo2l6bfxkNzZtUfww==
Date: Wed, 25 May 2011 16:50:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
In-Reply-To: <4DDB11F4.2070903@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105251645270.29729@chino.kir.corp.google.com>
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6207E.1070300@jp.fujitsu.com> <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com> <4DDB0B45.2080507@jp.fujitsu.com> <alpine.DEB.2.00.1105231838420.17729@chino.kir.corp.google.com>
 <4DDB1028.7000600@jp.fujitsu.com> <alpine.DEB.2.00.1105231856210.18353@chino.kir.corp.google.com> <4DDB11F4.2070903@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, KOSAKI Motohiro wrote:

> > I don't care if it happens in the usual case or extremely rare case.  It
> > significantly increases the amount of time that tasklist_lock is held
> > which causes writelock starvation on other cpus and causes issues,
> > especially if the cpu being starved is updating the timer because it has
> > irqs disabled, i.e. write_lock_irq(&tasklist_lock) usually in the clone or
> > exit path.  We can do better than that, and that's why I proposed my patch
> > to CAI that increases the resolution of the scoring and makes the root
> > process bonus proportional to the amount of used memory.
> 
> Do I need to say the same word? Please read the code at first.
> 

I'm afraid that a second time through the tasklist in select_bad_process() 
is simply a non-starter for _any_ case; it significantly increases the 
amount of time that tasklist_lock is held and causes problems elsewhere on 
large systems -- such as some of ours -- since irqs are disabled while 
waiting for the writeside of the lock.  I think it would be better to use 
a proportional privilege for root processes based on the amount of memory 
they are using (discounting 1% of memory per 10% of memory used, as 
proposed earlier, seems sane) so we can always protect root when necessary 
and never iterate through the list again.

Please look into the earlier review comments on the other patches, refresh 
the series, and post it again.  Thanks!
