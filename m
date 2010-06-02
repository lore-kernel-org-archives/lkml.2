Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0FBDDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:03:14 -0400
Received: from ozlabs.org ([203.10.76.45]:37560 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab0FBDDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:03:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Brandon Philips <brandon@ifup.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Wed, 2 Jun 2010 12:33:05 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1006011638540.8175@i5.linux-foundation.org> <20100602021029.GD10332@jenkins.ifup.org>
In-Reply-To: <20100602021029.GD10332@jenkins.ifup.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021233.09140.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 11:40:29 am Brandon Philips wrote:
> On 16:51 Tue 01 Jun 2010, Linus Torvalds wrote:
> > On Tue, 1 Jun 2010, Brandon Philips wrote:
> > > When I tested a Kernel with Rusty's modules branch pulled onto
> > > 2.6.35-rc1 I got duplicate sysfs path errors:
> > Hmm. Yeah, the module_mutex used to be held across the whole "find -> add" 
> > state, but isn't any more.
> 
> Right.
> 
> > > To fix this we need to make sure that we only have one copy of a
> > > module going through load_module at a time.  Patch suggestion
> > > follows which boots without errors. I am sure there is a better
> > > way to do what it does ;)
> > 
> > I think Rusty may have made the lock a bit _too_ finegrained there,
> > and didn't add it to some places that needed it. It looks, for
> > example, like PATCH 1/2 actually drops the lock in places where it's
> > needed ("find_module()" is documented to need it, but now
> > load_module() didn't hold it at all when it did the find_module()).
> 
> Right, I noticed that too and held the lock in the patch I sent.
> 
> > Rather than adding a new "module_loading" list, I think we should be
> > able to just use the existing "modules" list, and just fix up the
> > locking a bit.
> >
> > In fact, maybe we could just move the "look up existing module" a
> > bit later - optimistically assuming that the module doesn't exist,
> > and then just undoing the work if it turns out that we were wrong,
> > just before adding ourselves to the list.
> >
> > A patch something like the appended (TOTALLY UNTESTED!)
> 
> FWIW, I tried this same idea initially and it breaks because the
> kobject EEXIST is coming from mod_sysfs_init() which happens further
> up in load_module() before the list_add_rcu().

I'll take a look.  Linus was right that my lock reduction was overzealous.

The kobject error should be harmless.

I have a simplified version of your problem (see testing patch); I'll
see what I can fix...

Thanks!
Rusty.
