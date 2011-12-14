Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab1LNSlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:41:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab1LNSll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:41:41 -0500
Date: Wed, 14 Dec 2011 13:41:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nate Custer <nate@cpanel.net>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kvm deadlock
Message-ID: <20111214184134.GC25484@redhat.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111214170347.GA25484@redhat.com>
 <4EE8D863.5000701@kernel.dk>
 <20111214172234.GB25484@redhat.com>
 <20111214181623.GA20380@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214181623.GA20380@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:16:23AM -0800, Tejun Heo wrote:

[..]
> > > > Or may be there is a safer version of pcpu alloc which will return
> > > > without allocation if pcpu_alloc_mutex is already locked.
> 
> pcpu alloc depends on vmalloc allocation, so it isn't trivial.  We can
> try to make percpu keep cache of areas for this type of allocation but
> I personally think doing percpu allocation from atomic context or IO
> path is a bad idea.  Hmmm...

Looks like I am running out of options here.  I can't find a suitable path
where I can allocate these stats out of IO path. Because devices can be
plugged in dynamically (and these stats are per cgroup, per device), and
cgroups can be created dynamically after device creation, I can't do any
static allocation out of IO path. So that kind of makes use of per cpu
memory areas for stats in this case impossible.

For a moment I thought of doing allocation from worker thread after taking
a reference on the original group. Allow the IO submission to continue without
blocking. Just that till per cpu areas are allocated, we will not
collect any stats.

But for locking we rely on request queue lock and request queue might be
gone by the time per cpu areas are allocated. That means we need a group
refenrence on the request queue. Request queue referencing and life time
is already full of bugs. So I don't feel comfortable adding more code
there (till atleast your cleanup patches go in).

Hmm..., is revert of per cpu blkio group stats the only sane choice left
now.

Thanks
Vivek
