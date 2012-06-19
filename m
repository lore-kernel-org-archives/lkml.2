Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2FSXmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:42:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2FSXmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:42:07 -0400
Date: Tue, 19 Jun 2012 16:42:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paton J. Lewis" <palewis@adobe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] epoll: Improved support for multi-threaded clients
Message-Id: <20120619164206.5588f749.akpm@linux-foundation.org>
In-Reply-To: <6.2.5.6.2.20120618141747.022ca4a8@adobe.com>
References: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
	<20120613162710.ab1d1cd8.akpm@linux-foundation.org>
	<6.2.5.6.2.20120618141747.022ca4a8@adobe.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 14:58:44 -0700
"Paton J. Lewis" <palewis@adobe.com> wrote:

> cc Michael Kerrisk as recommended below.
> 
> At 6/13/2012 04:27 PM, Andrew Morton wrote:
> 
> >Let's cc Davide.
> >
> >On Mon, 11 Jun 2012 15:34:49 -0700
> >Paton Lewis <palewis@adobe.com> wrote:
> >
> > >
> > > It is not currently possible to reliably delete epoll items when using the
> > > same epoll set from multiple threads. After calling epoll_ctl with
> > > EPOLL_CTL_DEL, another thread might still be executing code related to an
> > > event for that epoll item (in response to epoll_wait). Therefore 
> > the deleting
> > > thread does not know when it is safe to delete resources pertaining to the
> > > associated epoll item because another thread might be using those 
> > resources.
> >
> >We often solve this sort of thing with refcounting - the EPOLL_CTL_DEL
> >will drop the refcount and, if that fell to zero, remove the object.
> >So if the object is in use by another thread, that other thread will
> >hold a refcount and that other thread will do the object removal when
> >dropping its refcount.
> >
> >I don't know if that model can be used here?
> 
> Andrew, thank you for your response.
> 
> First, I should point out that the fundamental problem we are trying 
> to solve is that userspace code needs to know whether or not an epoll 
> item was in the ready queue at the time EPOLL_CTL_DEL was executed. 
> Furthermore, we want to transfer that information back to userspace 
> in a way that won't break existing code that uses epoll.
> 
> We could use a refcount to track whether the epoll item was in the 
> ready list or not at the time EPOLL_CTL_DEL was received, but we 
> still need a way to transfer that information back to userspace. 
> Since the refcount would only ever be zero or one, epoll_ctl could 
> set a bit in epoll_event.events (perhaps called EPOLLNOTREADY). 
> However, this could cause a problem with any legacy code that relies 
> on the fact that the epoll_ctl epoll_event parameter is ignored for 
> EPOLL_CTL_DEL. Any such code which passed an invalid pointer for that 
> parameter would suddenly generate a fault when running on the new 
> kernel code, even though it worked fine in the past.
> 
> It seems that there are two ways to send information from the kernel 
> back to userspace via the epoll_ctl API: via the return value or by 
> modifying the epoll_event structure. In either case we are wary of 
> changing the behavior of epoll_ctl in response to the existing 
> control commands for fear of breaking legacy code. Therefore we 
> recommended adding a new control word (EPOLL_CTL_DISABLE) to ensure 
> that legacy code would not be affected.
> 
> I should point out that an alternative possibility would be to add a 
> new control word, perhaps called EPOLL_CTL_DEL_AND_REPORT, that would 
> function exactly like EPOLL_CTL_DEL except that it could return 
> -EBUSY if the deleted item was not originally in the ready queue.

hm, OK, thanks.

I need to take a closer look at this - Davide appears to have gone awol
and nobody else regularly works on epoll.  Please resend when covenient.

> >Also, a user-visible feature wuch as this should be documented in Linux
> >manpages.  So please do cc Michael Kerrisk <mtk.manpages@gmail.com> as
> >we work on this.
> 
> Added, thank you.
> 
> Since we're discussing a possible userspace kernel API change, is 
> there someone on the GCC team who we should also cc?

That would be glibc.  glibc does have epoll support and getting
feedback from the glibc developers would be valuable.  Please cc
libc-alpha@sourceware.org for this.

