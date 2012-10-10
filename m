Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2JJVOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 17:14:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35085 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2JJVOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 17:14:33 -0400
Date: Thu, 11 Oct 2012 01:14:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns() v5
Message-ID: <20121010211429.GF12859@moon>
References: <20121010204256.GD29501@moon>
 <20121010135408.515c2e21.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010135408.515c2e21.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 01:54:08PM -0700, Andrew Morton wrote:
> On Thu, 11 Oct 2012 00:42:56 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > The free_pid_ns function done in recursion fashion:
> > 
> > free_pid_ns(parent)
> >   put_pid_ns(parent)
> >     kref_put(&ns->kref, free_pid_ns);
> >       free_pid_ns
> > 
> > thus if there was a huge nesting of namespaces the userspace
> > may trigger avalanche calling of free_pid_ns leading to
> > kernel stack exhausting and a panic eventually.
> > 
> > This patch turns the recursion into iterative loop.
> > 
> > v5 (from oleg@):
> >  - Drop @ret variable
> >  - Make put_pid_ns non-inline since it grows in size,
> >    in turn make free_pid_ns static
> 
> OK, let's try that.  I'll sit on this until -rc2 to give it a bit of
> time to cook.
> 
> A -stable backport might be needed.  What capabilities does userspace
> need to be able to trigger the kernel stack overflow?

I believe it'll apply on stable even in current form. As Eric mentioned
CAP_SYS_ADMIN is required (so it's not that urgent i think).
