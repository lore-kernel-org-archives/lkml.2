Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2FMX1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 19:27:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2FMX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 19:27:11 -0400
Date: Wed, 13 Jun 2012 16:27:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paton Lewis <palewis@adobe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH] epoll: Improved support for multi-threaded clients
Message-Id: <20120613162710.ab1d1cd8.akpm@linux-foundation.org>
In-Reply-To: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
References: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Let's cc Davide.

On Mon, 11 Jun 2012 15:34:49 -0700
Paton Lewis <palewis@adobe.com> wrote:

> 
> It is not currently possible to reliably delete epoll items when using the
> same epoll set from multiple threads. After calling epoll_ctl with
> EPOLL_CTL_DEL, another thread might still be executing code related to an
> event for that epoll item (in response to epoll_wait). Therefore the deleting
> thread does not know when it is safe to delete resources pertaining to the
> associated epoll item because another thread might be using those resources.

We often solve this sort of thing with refcounting - the EPOLL_CTL_DEL
will drop the refcount and, if that fell to zero, remove the object. 
So if the object is in use by another thread, that other thread will
hold a refcount and that other thread will do the object removal when
dropping its refcount.

I don't know if that model can be used here?

> The deleting thread could wait an arbitrary amount of time after calling
> epoll_ctl with EPOLL_CTL_DEL and before deleting the item, but this is
> inefficient and could result in the destruction of resources before another
> thread is done handling an event returned by epoll_wait.
> 
> This patch introduces the new epoll_ctl command EPOLL_CTL_DISABLE, which
> disables the associated epoll item and returns -EBUSY if the epoll item is not
> currently in the epoll ready queue. This allows multiple threads to use a
> mutex to determine when it is safe to delete an epoll item and its associated
> resources. This allows epoll items to be deleted and closed efficiently and
> without error.
> 
> This patch has been tested against the following checklist:
> http://kernelnewbies.org/UpstreamMerge/SubmitChecklist
> 
> The following psuedocode attempts to illustrate the problem as well as the
> solution provided by this patch.
> 
> 
> Pseudocode for the deleting thread:

It would be nice to start accumulating epoll test code in
tools/testing/selftests/epoll.  If you have something which can be used
to kick that off, please do consider preparing it.

Also, a user-visible feature wuch as this should be documented in Linux
manpages.  So please do cc Michael Kerrisk <mtk.manpages@gmail.com> as
we work on this.
