Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0JGRen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:34:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab0JGRem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:34:42 -0400
Subject: Re: Linux 2.6.36-rc7
From: Eric Paris <eparis@redhat.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        agruen@suse.de
In-Reply-To: <201010071815.54303.tvrtko.ursulin@sophos.com>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	 <201010071710.46938.tvrtko.ursulin@sophos.com>
	 <201010071815.54303.tvrtko.ursulin@sophos.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:33:55 -0400
Message-ID: <1286472835.2656.15.camel@dhcp231-98.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 18:15 +0100, Tvrtko Ursulin wrote:
> On Thursday 07 Oct 2010 17:10:46 Tvrtko Ursulin wrote:
> > On Wednesday 06 Oct 2010 22:45:13 Linus Torvalds wrote:

> Priority argument was dropped from the fanotify_init syscall, and since it is
> a syscall once released it is set in stone. Without the priority argument, how
> are multiple clients supposed to be ordered?
> 
> Co-existence between multiple clients was something which was supposed to be
> designed in from the start. Use cases like hierarchical storage management,
> anti-malware and content indexing should all be able to co-exist. Without a
> priority argument I do not see how it can be assured HSM sees the perm event
> before anti-malware, and content indexing after both of them? If there was any
> discussion about dropping priority I missed it. :(

Shit.  I'm trying to remember the logic.  hrmph....   You could have a
real interface issue....  Shit.  Let me think about it for an hour or
two.

Original idea of priorities was to allow multiple permissions decision
makers to co-exist without having the livelock problem of each trying to
grant and deny access to each other.  That was solved with the
O_NONOTIFY hack and I think the priority was then thought to be useless.
But you're absolutely right, it isn't useless if we consider that an HSM
might need to run first to make sure data exists on disk before an
indexer looks at the data.

I see two possibilities off the top of my head:

I could just slap an (unused) priority field onto the end of the
fanotify_init() syscall (assuming Linus doesn't murder me) so we can
build that support out with explicit priorities down the line, which I
think might be overkill, or

The other option (without breaking ABI as it stands today) is to define
some set of the fanotify_init() flags to be a priority field, we've got
32 bits and only use 2 of them so giving 4-8 bits of that as a priority
(next cycle) isn't an issue and can be easily backwards compatible.

-Eric

