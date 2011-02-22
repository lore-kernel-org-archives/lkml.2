Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1BVAZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:25:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:25107 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1BVAZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=yvZdaUJt8oBYHHZQXEKzLVO10Eboj1gZddDV/+v3rd7lyxwOTLO7CH50XzwikiFHiQ
         OjAo7g9S5CWaCL7K+YGA==
Date: Mon, 21 Feb 2011 16:25:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        miaox@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
In-Reply-To: <4D61DA04.4060007@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1102211617510.23557@chino.kir.corp.google.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7ED1.2070601@cn.fujitsu.com> <alpine.DEB.2.00.1102191745180.27722@chino.kir.corp.google.com> <4D61DA04.4060007@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Li Zefan wrote:

> Unfortunately, as I looked into the code again I found cpuset_change_nodemask()
> is called by other functions that use the global cpuset_mems, so I
> think we'd better check the refcnt of cpuset_mems.
> 
> How about this:
> 
> [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
> 
> Those functions that use NODEMASK_ALLOC() can't propogate errno
> to users, so might fail silently.
> 
> Based on the fact that all of them are called with cgroup_mutex
> held, we fix this by using a global nodemask.
> 

If all of the functions that require a nodemask are protected by 
cgroup_mutex, then I think it would be much better to just statically 
allocate them within the function and avoid any nodemask in file scope.  
cpuset_mems cannot be shared so introducing it with a refcount would 
probably just be confusing.
