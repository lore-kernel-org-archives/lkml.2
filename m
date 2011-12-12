Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1LLWwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:52:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1LLWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:52:09 -0500
Date: Mon, 12 Dec 2011 14:52:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, xemul@parallels.com,
        drosenberg@vsecurity.com, linux-kernel@vger.kernel.org,
        eparis@redhat.com, bfields@fieldses.org, jbottomley@parallels.com,
        devel@openvz.org
Subject: Re: [PATCH 1/2] SYSCTL: root unregister routine introduced
Message-Id: <20111212145208.75490b41.akpm@linux-foundation.org>
In-Reply-To: <20111212175000.7084.94219.stgit@localhost6.localdomain6>
References: <20111212174709.7084.54702.stgit@localhost6.localdomain6>
	<20111212175000.7084.94219.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 21:50:00 +0300
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> This routine is required for SUNRPC sysctl's, which are going to be allocated,
> processed and destroyed per network namespace context.
> IOW, new sysctl root will be registered on network namespace creation and
> thus have to unregistered before network namespace destruction.
> 

It's a bit suspicious that such a mature subsystem as sysctl newly
needs its internals exported like this.  Either a) the net namespaces
work is doing something which hasn't been done before or b) it is doing
something wrong.

So, please explain further so we can confirm that it is a) and not b).

> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1701,6 +1701,13 @@ void register_sysctl_root(struct ctl_table_root *root)
>  	spin_unlock(&sysctl_lock);
>  }
>  
> +void unregister_sysctl_root(struct ctl_table_root *root)
> +{
> +	spin_lock(&sysctl_lock);
> +	list_del(&root->root_list);
> +	spin_unlock(&sysctl_lock);
> +}
> +

This requires the addition of a declaration to include/linux/sysctl.h.

Once that is done and review is complete, I'd suggest that these two
patches be joined into a single patch, and that patch become part of
whatever patch series it is which needs them.

