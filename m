Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2FSSRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:17:23 -0400
Received: from edge.cmeerw.net ([84.200.12.152]:36284 "EHLO edge.cmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2FSSRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:17:22 -0400
Date: Tue, 19 Jun 2012 20:17:11 +0200
From: Christof Meerwald <cmeerw@cmeerw.org>
To: "Paton J. Lewis" <palewis@adobe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH] epoll: Improved support for multi-threaded clients
Message-ID: <20120619181711.GE1281@edge.cmeerw.net>
References: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
 <20120616184707.GA22656@edge.cmeerw.net>
 <6.2.5.6.2.20120618161807.031eb6c8@adobe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.2.5.6.2.20120618161807.031eb6c8@adobe.com>
X-PGP-Key: 1024D/2B10BE68, 1998-06-29
X-PGP-Fingerprint: 0289 5466 C1F5 B03C DBA7  6304 8CAF 9782 2B10 BE68
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paton,

On Mon, Jun 18, 2012 at 04:24:35PM -0700, Paton J. Lewis wrote:
> We believe that EPOLLONESHOT is required in order to make any
> sensible use of calling epoll_wait on a single epoll set
> concurrently in multiple threads.

I guess we have to disagree here - though it might be more difficult.


> >On Mon, 11 Jun 2012 15:34:49 -0700, Paton Lewis wrote:
> >> This patch introduces the new epoll_ctl command EPOLL_CTL_DISABLE, which
> >> disables the associated epoll item and returns -EBUSY if the
> >epoll item is not
> >> currently in the epoll ready queue. This allows multiple threads to use a
> >> mutex to determine when it is safe to delete an epoll item and
> >its associated
> >> resources. This allows epoll items to be deleted and closed efficiently and
> >> without error.

Maybe I am missing something here (as I am not really familiar with
the kernel internals), but I don't really understand the logic behind
your patch. Isn't the "expected" case that the item is not on the
ready list and no I/O is being processed for that item?

So I think instead of checking for the item being on the ready list,
checking for the event mask would make more sense for me, e.g.

  if (!(epi->event.events & ~EP_PRIVATE_BITS))


But, taking one step back - wouldn't an alternative approach be to add
some mechanism to allow a thread to post a user-event for an fd? So in
delete_epoll_item you would post a user event (e.g. EPOLLUSER) for the
fd which you can then handle in your epoll_wait processing thread -
with no additional synchronisation necessary.

However, this would still require EPOLLONESHOT to be useful for memory
management.


Christof

-- 

http://cmeerw.org                              sip:cmeerw at cmeerw.org
mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org
