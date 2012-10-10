Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2JJUyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:54:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2JJUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:54:09 -0400
Date: Wed, 10 Oct 2012 13:54:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns() v5
Message-Id: <20121010135408.515c2e21.akpm@linux-foundation.org>
In-Reply-To: <20121010204256.GD29501@moon>
References: <20121010204256.GD29501@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012 00:42:56 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> The free_pid_ns function done in recursion fashion:
> 
> free_pid_ns(parent)
>   put_pid_ns(parent)
>     kref_put(&ns->kref, free_pid_ns);
>       free_pid_ns
> 
> thus if there was a huge nesting of namespaces the userspace
> may trigger avalanche calling of free_pid_ns leading to
> kernel stack exhausting and a panic eventually.
> 
> This patch turns the recursion into iterative loop.
> 
> v5 (from oleg@):
>  - Drop @ret variable
>  - Make put_pid_ns non-inline since it grows in size,
>    in turn make free_pid_ns static

OK, let's try that.  I'll sit on this until -rc2 to give it a bit of
time to cook.

A -stable backport might be needed.  What capabilities does userspace
need to be able to trigger the kernel stack overflow?
