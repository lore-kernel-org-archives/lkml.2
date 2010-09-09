Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab0IIVk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:40:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:38486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0IIVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:40:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=iQaF8H65HZacFGDmXrU9yHK6GWnF1hncOon69Em8GHUrNK/OsjkDGD7EBASYr1T4F
	EMoWVcM/+GbMZCCuj69ow==
Date: Thu, 9 Sep 2010 14:40:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch -rc] oom: always return a badness score of non-zero for
 eligible tasks
In-Reply-To: <1284066608.7586.8189.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1009091419230.23194@chino.kir.corp.google.com>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org> <1284053081.7586.7910.camel@nimitz> <alpine.DEB.2.00.1009091152090.5556@chino.kir.corp.google.com> <1284061683.7586.8100.camel@nimitz> <alpine.DEB.2.00.1009091351090.19800@chino.kir.corp.google.com>
 <1284066608.7586.8189.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, Dave Hansen wrote:

> > Hmm, could you very that /proc/sys/vm/oom_dump_tasks is set?  Perhaps it's 
> > getting cleared by something else before you use zram.  The sysctl should 
> > default to on as of 2.6.36-rc1.
> 
> I double-checked.  It defaults to on and remains that way.
> 

Ok, I assume you aren't getting the typical "cat invoked oom-killer..." 
message, the memory state dump, etc., either, so there's something strange 
with your log level such that nothing under KERN_WARNING is getting 
through or you can't access the actual kernel log due to the panic.  I can 
capture all that information with a netdump on panic with 2.6.36-rc3.

> I'll give the patch a shot and see if I get any better behavior.  But, I
> really do think the root cause here is compcache exhausting the system
> when you feed incompressible pages into it.  We can kill all the tasks
> we want, but I think it'll continue to gobble memory up as fast as we
> free it.
> 

That certainly seems to be the case and is the true topic of this thread, 
so I don't want to hijack it any further since it's outside the scope of 
the oom killer :)

But I'm still curious as to why the machine is hanging and not eventually 
panicking when we run out of killable tasks.  It seems as though something 
is hanging in the exit path, meaning memory reserves aren't even safe from 
compcache, or there's something wrong in the oom killer retry logic, or 
you're simply forking more tasks, perhaps as a response to threads getting 
killed by the kernel, than we can kill.

We'd certainly prefer to panic the machine if no work is getting done than 
simply killing everything that gets forked.  The problem before was that 
we panicked too early before we killed anything and now we don't know when 
to panic appropriately.

> > Agreed, we'll need to address hugepages specifically because they don't 
> > get accounted for in rss but do free memory when the task is killed.
> 
> They do sometimes.  But, if they're preallocated, or stuck in a linked
> file on the filesystem, killing the task doesn't do any good.
> 

Indeed you're right, I meant s/hugepages/transparent hugepages/, sorry.  
It appears as though they get included in the rss of the allocating task, 
though, via MM_ANONPAGES, so this is already represented in the task's 
badness score.

Thanks for trying the patch out, Dave, I hope we can add your Tested-by 
line and it can get pushed to the rc-series.
