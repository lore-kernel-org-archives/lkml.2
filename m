Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1JTVYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:24:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15641 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab1JTVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:24:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=OHIEXs5ewebW2HJUrknbbu6U4DwLMX8FyhUe2fuaoERepBUmHlTEl2Fn6EqoVFQ/m
	/08LhwG2Y9NSLS/OZNnAQ==
Date: Thu, 20 Oct 2011 14:24:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
In-Reply-To: <1319106727.8653.3.camel@laptop>
Message-ID: <alpine.DEB.2.00.1110201418140.5552@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net>
 <1316775204.7562.9.camel@marge.simson.net> <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com> <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net> <1318233815.6527.5.camel@marge.simson.net>
 <1318925436.9641.23.camel@marge.simson.net> <1318927355.21167.3.camel@twins> <1318927629.9641.27.camel@marge.simson.net> <1318928763.21167.5.camel@twins> <1318929825.9641.32.camel@marge.simson.net> <1318932693.6748.5.camel@marge.simson.net>
 <alpine.DEB.2.00.1110181336150.2639@chino.kir.corp.google.com> <1319010659.29774.3.camel@twins> <alpine.DEB.2.00.1110191243110.2892@chino.kir.corp.google.com> <1319106727.8653.3.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011, Peter Zijlstra wrote:

> >  though, you could devise a 
> > cgroup to just do monitoring or statistics tracking for an aggregate of 
> > tasks and placing kthreadd in such a cgroup would make perfect sense 
> > because then, since children are forked in the same cgroup, you can 
> > monitor or gather statistics for all kthreads.  This can be your only 
> > cgroup on the system.
> 
> I guess you could, but does it really make sense? Also, you could sort
> this by extending the cgroup interface to explicitly distinct between
> controllers and !controllers.
> 

I don't know what the definition of "controllers" is that would separate 
the two, that's why it's left up to the individual cgroups to define their 
own can_attach() function to ensure that the admin isn't doing something 
potentially harmful.

In terms of controlling the set of allowed nodes, we certainly want to 
prohibit PF_THREAD_BOUND threads for cpusets because cpusets can easily 
change that (and spews a nasty warning if set_cpus_allowed_ptr() fails).

In terms of controlling kthreadd forking threads that become stuck with 
PF_THREAD_BOUND, I think Mike's patch is correct for cpusets, since we 
know we don't want its children to become trapped.  All other cgroups, 
unless they have a similar exemption for PF_THREAD_BOUND threads, would 
allow the child to be reassigned by their can_attach() function.  A grep 
for PF_THREAD_BOUND shows no others.
