Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1BTBwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 20:52:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46657 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1BTBvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 20:51:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dPT7uPX95AO2FypIxb299n0Xc0dAVt7oqf0Di+tXdGpEE0YuL7JSVKUOWaJu0j44BG
         qa5DUyOqZBecH1EWUZRg==
Date: Sat, 19 Feb 2011 17:51:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        miaox@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
In-Reply-To: <4D5C7ED1.2070601@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1102191745180.27722@chino.kir.corp.google.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7ED1.2070601@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011, Li Zefan wrote:

> Those functions that use NODEMASK_ALLOC() can't propogate errno
> to users, but will fail silently.
> 
> Since all of them are called with cgroup_mutex held, here we use
> a global nodemask_t variable.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

I like the idea and the comment is explicit enough that we don't need any 
refcounting to ensure double usage under cgroup_lock.  I think each 
function should be modified to use cpuset_mems directly, though, instead 
of defining local variables that indirectly access it which only serves to 
make this patch smaller.  Then we can ensure that all occurrences of 
cpuset_mems appear within the lock without being concerned about other 
references.
