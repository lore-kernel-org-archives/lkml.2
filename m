Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab1LNSQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:16:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55438 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1LNSQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:16:35 -0500
Date: Wed, 14 Dec 2011 10:16:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nate Custer <nate@cpanel.net>,
        kvm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kvm deadlock
Message-ID: <20111214181623.GA20380@google.com>
References: <54FC5923-2123-4BDD-A506-EA57DCE0C1F6@cpanel.net>
 <20111214122511.GD18317@amt.cnet>
 <4EE8A7ED.7060703@redhat.com>
 <4EE8C8EA.9070207@kernel.dk>
 <20111214170347.GA25484@redhat.com>
 <4EE8D863.5000701@kernel.dk>
 <20111214172234.GB25484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214172234.GB25484@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 14, 2011 at 12:22:34PM -0500, Vivek Goyal wrote:
> [..]
> > __GFP_WAIT isn't the problem, you can block in the IO path. You cannot,
> > however, recurse back into IO submission. That's why CFQ is using
> > GFP_NOIO, implying that waiting is OK, but submitting new IO to satisfy
> > the allocation is not.
> 
> Ok. Got it. So even if we implement mutex_is_locked() check, it does not
> protect me from possiblity of per cpu allocation path recursing into
> IO submission. That means, there needs to be a variant of per cpu
> allocation which can take the allocation flags as parameter and honor
> these flags.

Slightly tangential but we actually have a bug here.  Under high
enough memory pressure, ioc or cic allocation can fail which will make
request alloc fail and retry, which isn't guaranteed to make forward
progress.  struct request itself is mempool backed but ioc/cic aren't.
It seems hitting this problem (and thus IO / memalloc deadlock) isn't
too difficult w/ memcg.

An easy fix would be using INSERT_BACK instead of INSERT_SORT if
elevator_set() fails.  I'll soon post patches to fix the problem.

> > > Or may be there is a safer version of pcpu alloc which will return
> > > without allocation if pcpu_alloc_mutex is already locked.

pcpu alloc depends on vmalloc allocation, so it isn't trivial.  We can
try to make percpu keep cache of areas for this type of allocation but
I personally think doing percpu allocation from atomic context or IO
path is a bad idea.  Hmmm...

Thanks.

-- 
tejun
