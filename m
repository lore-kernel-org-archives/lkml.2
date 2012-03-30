Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734Ab2C3Ut2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:49:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:40967 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934521Ab2C3UtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:49:16 -0400
Date: Fri, 30 Mar 2012 22:49:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@linuxfoundation.org>
cc: Sasha Levin <levinsasha928@gmail.com>, arnd@arndb.de,
        viro@zeniv.linux.org.uk, davej@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
In-Reply-To: <20120330204235.GA883@kroah.com>
Message-ID: <alpine.LFD.2.02.1203302247130.2542@ionos>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com> <20120330153013.GC18488@kroah.com> <CA+1xoqdZnxcWNpL-03xsR+RDcz3=aRbx2LbR6mTJ_gCmwp-0Rw@mail.gmail.com> <20120330164913.GA19946@kroah.com> <alpine.LFD.2.02.1203302225420.2542@ionos>
 <20120330204235.GA883@kroah.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-627557727-1333140552=:2542"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-627557727-1333140552=:2542
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 30 Mar 2012, Greg KH wrote:

> On Fri, Mar 30, 2012 at 10:35:46PM +0200, Thomas Gleixner wrote:
> > On Fri, 30 Mar 2012, Greg KH wrote:
> > > On Fri, Mar 30, 2012 at 07:37:37PM +0300, Sasha Levin wrote:
> > > > On Fri, Mar 30, 2012 at 6:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > On Fri, Mar 30, 2012 at 01:04:27PM -0400, Sasha Levin wrote:
> > > > >> There are no size checks in kmsg_write(), and we try allocating enough
> > > > >> memory to store everything userspace gave us, which may be too much for
> > > > >> kmalloc to allocate.
> > > > >
> > > > > Really?  Have you seen this fail?  As only root can do this, is this
> > > > > really a problem?
> > > > 
> > > > Only root, and a whole bunch of management software that dumps data
> > > > into /dev/kmsg (systemd and friends).
> > > 
> > > Running as root, do any of these cause problems by asking for too much
> > > memory here? 
> > 
> > Running as root is not a guarantee for correctness. So the syscall
> > should cope with bogus requests from user space and not rely on the
> > sanity of anything. Looking at the main users which polute dmesg I'm
> > inclined to assume insanity in the first place.
> > 
> > As Sasha pointed out there is either the variant to use vmalloc and
> > grant any write size or limit the size to something sensible. Though
> > given the users of this, coming up with something sensible might be a
> > problem.
> > 
> > > Is this something that needs to be addressed now, and in
> > > stable kernels, or can it wait for 3.5?
> > 
> > Yes, it want's to be addressed now and it want's to be in stable as
> > well. syscalls which have no bound checking are evil, no matter what.
> 
> So, should we cap the size at something "super large" then as well?

I think so. This is an interface to inject stuff into dmesg. Limiting
that to a reasonable size makes sense. We can probably limit it to
something small like 1024, but I don't know about the "ideas" of those
folks who think that it's a great idea to do it at all.

Thanks,

	tglx
--8323328-627557727-1333140552=:2542--
