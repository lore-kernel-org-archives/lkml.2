Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab2J2Um1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:42:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407Ab2J2UmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:42:25 -0400
Date: Mon, 29 Oct 2012 13:42:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paton J. Lewis" <palewis@adobe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, <libc-alpha@sourceware.org>,
        <linux-api@vger.kernel.org>, <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] epoll: Support for disabling items, and a self-test
 app.
Message-Id: <20121029134223.81efcc00.akpm@linux-foundation.org>
In-Reply-To: <1351210112-23238-1-git-send-email-palewis@adobe.com>
References: <1351210112-23238-1-git-send-email-palewis@adobe.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012 17:08:32 -0700
"Paton J. Lewis" <palewis@adobe.com> wrote:

> It is not currently possible to reliably delete epoll items when using the
> same epoll set from multiple threads. After calling epoll_ctl with
> EPOLL_CTL_DEL, another thread might still be executing code related to an
> event for that epoll item (in response to epoll_wait). Therefore the deleting
> thread does not know when it is safe to delete resources pertaining to the
> associated epoll item because another thread might be using those resources.
> 
> The deleting thread could wait an arbitrary amount of time after calling
> epoll_ctl with EPOLL_CTL_DEL and before deleting the item, but this is
> inefficient and could result in the destruction of resources before another
> thread is done handling an event returned by epoll_wait.
> 
> This patch enhances epoll_ctl to support EPOLL_CTL_DISABLE, which disables an
> epoll item. If epoll_ctl returns -EBUSY in this case, then another thread may
> handling a return from epoll_wait for this item. Otherwise if epoll_ctl
> returns 0, then it is safe to delete the epoll item. This allows multiple
> threads to use a mutex to determine when it is safe to delete an epoll item
> and its associated resources, which allows epoll items to be deleted both
> efficiently and without error in a multi-threaded environment. Note that
> EPOLL_CTL_DISABLE is only useful in conjunction with EPOLLONESHOT, and using
> EPOLL_CTL_DISABLE on an epoll item without EPOLLONESHOT returns -EINVAL.
> 
> This patch also adds a new test_epoll self-test program to both demonstrate
> the need for this feature and test it.

Thanks.  I queued this for testing and for consideration for 3.8.  I
shall send the revert patches in to Linus to remove this interface
change from 3.7.
