Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2KMP0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:26:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab2KMP0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:26:11 -0500
Date: Tue, 13 Nov 2012 15:50:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + fs-epoll-add-procfs-fdinfo-helper.patch added to -mm tree
Message-ID: <20121113145050.GA13691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  struct signalfd_ctx {
> +	seqcount_t cnt;
>  	sigset_t sigmask;
>  };
> ...
> @@ -278,7 +302,9 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sig
>  			return -EINVAL;
>  		}
>  		spin_lock_irq(&current->sighand->siglock);
> +		write_seqcount_begin(&ctx->cnt);
>  		ctx->sigmask = sigmask;
> +		write_seqcount_end(&ctx->cnt);
>  		spin_unlock_irq(&current->sighand->siglock);

This doesn't look right.

The problem is, the current locking is broken, ->siglock can not serialize
->sigmask changes. Just suppose the the child inherits sigfd from parent
and they both do sys_signalfd4() at the same time.

Nothing really bad can happen, that is why nobody bothers to fix this.
But this patch makes the thing worse, write_seqcount_begin() must be
serialized correctly.

Oleg.

