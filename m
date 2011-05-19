Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1ESGBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 02:01:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62142 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1ESGBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 02:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hzd7kcp0PRYwoGRRUxZYqgzobZVPcf3f9jFKELfD1C0K8onIvg6zI4ZBh38SVdOh2C
         BVzbs+v0bL+d6JfiX8kpUFEDmjAS2dLlACvVdsKnQM6kQNkcKVO0CtL10vYGJiV5gY86
         51DIu7ExE361K9Zn5+f/xbu8Gtn77jvlyN0Eg=
Date: Thu, 19 May 2011 08:01:00 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New boot time message: detected capacity change
Message-ID: <20110519060100.GB2904@mtj.dyndns.org>
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
 <BANLkTimY+y3vXa0R7Evs6dYLVjJ==KVq1A@mail.gmail.com>
 <20110519052903.GA2904@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519052903.GA2904@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, May 19, 2011 at 07:29:03AM +0200, Tejun Heo wrote:
> The commit message is incomplete rather than misleading.  The problem
> has been there for a long time but hasn't affected cdrom so not many
> people have noticed it.  The changes to media revalidation exposed the
> bug for cdrom too, so it became a regression for 2.6.38.  Please refer
> to the following thread.
> 
>   https://lkml.org/lkml/2011/3/31/436
> 
> As the root cause was the same as the 2009 bug, I just referenced that
> one.  I should have included the link to the newer thread or explained
> how it affected recent conversion from ->media_changed to
> ->check_events.  My bad.

I was a bit confused here, so there were two separate problems.  One
affected sr, which was fixed by bf2253a6f0 and the other affecting
partition scan on sd fixed by 02e352287a.  The two were mixed in my
head, and I explained the wrong one.

The cdrom problem was a plain kernel regression.  The latter (the one
being shouted at in this thread) is slightly more complex.  Due to the
way devices were polled for media change from userland, the problem
wasn't noticeable.  The kernel misbehaved but userland polling masked
it.  2.6.38 added in-kernel polling and the userland workaround no
longer applied and the problem became visible - similar story with the
cdrom problem but involves userland behavior change too.

Both were very simliar in the cause too.  cdrom was unnecessarily
skipping check_disk_change() while the block layer was unnecessarily
skipping partition check.

Anyways, I'll go to my office and look into the warning message, but
please revert 02e352287a if necessary.  We can do that with -stable
later.

Thanks.

--
tejun
