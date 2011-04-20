Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1DTXTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:19:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42767 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1DTXTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lOtUlXjg81HoULCwLbWu6g0M0RuKtPzAgUgdwDHJt7zcZ39Uv/bepZa1A4rKAmyePB
         IU8kRWpKaXNm/k/9GH6w==
Date: Wed, 20 Apr 2011 16:19:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg KH <gregkh@suse.de>, J Freyensee <james_p_freyensee@linux.intel.com>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
In-Reply-To: <20110420161125.3449d4fd.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1104201613270.13948@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com> <1303253889-10074-2-git-send-email-james_p_freyensee@linux.intel.com> <alpine.DEB.2.00.1104191620360.4300@chino.kir.corp.google.com> <1303258222.13457.42.camel@localhost> <alpine.DEB.2.00.1104191817590.8047@chino.kir.corp.google.com>
 <20110420014340.GA21245@suse.de> <1303323083.13457.50.camel@localhost> <20110420191421.GA10306@suse.de> <20110420161125.3449d4fd.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, Andrew Morton wrote:

> > > But as David pointed out, if there is work other than mine coming that
> > > has already been proposed, wouldn't it be good to get this patch in
> > > place now to start the encouragement of future eyes to just call this
> > > function than re-invent the wheel?
> > 
> > No, then those projects submit the patch to export this, if they happen
> > to get to mainline before this one does.
> > 
> > Again, don't export something unless you are using it at the time, no
> > "this is to be used hopefully by something in the future" type stuff
> > please.  Who knows if those future plans ever pan out.
> 
> Well there's an easy solution here.  Send the patch to export
> get_task_comm(), then send along some patches which fix
> 
> z:/usr/src/linux-2.6.39-rc4> grep -r 'current->comm' drivers | wc -l
> 89
> 

If we go this route and continue to support /proc/pid/comm, then we're 
going to need to ensure nothing that dereferences p->comm for any thread p 
is in a blockable context and that it's acceptable for get_task_comm(p) to 
take task_lock(p), and that requires not nesting it with 
write_lock(&tasklist_lock).

I'm thinking that we're going to want to choose something else other than 
p->alloc_lock to protect p->comm since that lock is protecting so many 
different members of struct task_struct that we may not know whether it's 
held when we want to print p->comm.
