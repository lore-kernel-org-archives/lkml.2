Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2JKUKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:10:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2JKUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:10:25 -0400
Date: Thu, 11 Oct 2012 13:10:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] pidns: limit a size of pid to one page
Message-Id: <20121011131024.719863b4.akpm@linux-foundation.org>
In-Reply-To: <1349864654-1333268-1-git-send-email-avagin@openvz.org>
References: <1349864654-1333268-1-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 14:24:14 +0400
Andrew Vagin <avagin@openvz.org> wrote:

> A size of pid depends on a level of pidns and now a level of pidns
> is not limited, so it can be more than one page.
> 
> Looks reasonable, that it should be limited to a page size.  On x86_64
> it will allow to create 125 nested pid namespaces.  I don't know a
> usecase for which, it will be not enough. When someone finds a
> reasonable use case, we can add a config option or a sysctl parameter.
> 
> In addition it will reduce effect of another problem, when we have many
> nested namespaces and the oldest one starts dying.  zap_pid_ns_processe
> will be called for each namespace and find_vpid will be called for each
> process in a namespace. find_vpid will be called minimum max_level^2 / 2
> times. The reason of that is that when we found a bit in pidmap, we
> can't determine this pidns is top for this process or it isn't.
> 
> vpid is a heavy operation, so a fork bomb, which create many nested
> namespace, can do a system inaccessible for a long time.
> 
> For example my system becomes inaccessible for a few minutes with
> 4000 processes.

This changelog is a bit hard to follow.  After reading the code, I see
that `struct pid' is a "variable sized struct" - a header with an array
of upids at the end.  I suggest this be explained in the changelog so
others don't scratch their heads in the way I did.

Really, what the patch actually does is to limit the nesting depth of
pid namespaces, yes?  If so I think that is the way the patch should be
presented - the restriction of the storage size of a struct pid is an
implementation detail.

> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -70,12 +70,18 @@ err_alloc:
>  	return NULL;
>  }
>  
> +/* Limit a size of pid to one page */
> +#define MAX_PID_NS_LEVEL ((PAGE_SIZE - sizeof(struct pid)) / sizeof(struct upid))

I don't it was a good choice to use PAGE_SIZE here.  PAGE_SIZE can vary
from 4k to 64k, which is a large range.  This choice introduces the
risk that an application will pass testing on one architecture/config
but will later fail when deployed on other archs/configs.  And it means
that large PAGE_SIZE setups might still experience the problems which
you have identified.

And the use of sizeof(struct upid) and sizeof(struct pid) mean that if
we later change the size of those structures, the kernel's userspace
interface will be accidentally changed in subtle and surprising ways.

So I suggest you do

#define MAX_PID_NS_LEVEL 128

and leave it at that?

And the comment for MAX_PID_NS_LEVEL should tell the reader *why* we did
this, not what we did (which is pretty obvious from reading the definition).
