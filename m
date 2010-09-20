Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0ITB3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 21:29:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38793 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab0ITB3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 21:29:20 -0400
Date: Sun, 19 Sep 2010 18:29:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, benh@kernel.crashing.org,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Message-ID: <20100920012915.GI3060@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
 <1284656978.26423.11.camel@mulgrave.site>
 <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
 <1284760148.30449.107.camel@pasglop>
 <20100917231222.GA3060@linux.vnet.ibm.com>
 <1284864421.30449.113.camel@pasglop>
 <20100919152638.GF3060@linux.vnet.ibm.com>
 <E1OxQIg-0005Nw-WE@pomaz-ex.szeredi.hu>
 <20100919215909.GG3060@linux.vnet.ibm.com>
 <1284944316.2957.795.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284944316.2957.795.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 07:58:36PM -0500, James Bottomley wrote:
> On Sun, 2010-09-19 at 14:59 -0700, Paul E. McKenney wrote:
> > On Sun, Sep 19, 2010 at 10:15:51PM +0200, Miklos Szeredi wrote:
> > > On Sun, 19 Sep 2010, Paul E. McKenney wrote:
> > > > Give it a few years.  There are reportedly already other compilers that do
> > > > this, which is not too surprising given that the perception of insanity
> > > > is limited to lockless parallel code.  If you have single-threaded code,
> > > > such as code and data under a lock (where the data is never accessed
> > > > without holding that lock), then this sort of optimization is pretty safe.
> > > > I still don't like it, but the compiler guys would argue that this is
> > > > because I am one of those insane parallel-programming guys.
> > > > 
> > > > Furthermore, there are other ways to get into trouble.  If the code
> > > > continued as follows:
> > > > 
> > > >    LOAD inode = next.dentry->inode
> > > >    if (inode != NULL)
> > > >    	LOAD inode->f_op
> > > > 	do_something_using_lots_of_registers();
> > > > 	LOAD inode->some_other_field
> > > > 
> > > > and if the code expected ->f_op and ->some_other_field to be from the
> > > > same inode structure, severe disappointment could ensue.  This is because
> > > > the compiler is within its rights to reload from next.dentry->inode,
> > > > especially given register pressure.  In fact, the compiler would be within
> > > > its rights to reload from next.dentry->inode in the "LOAD inode->f_op"
> > > > statement.  And it might well get NULL from such a reload.
> > > 
> > > Except the VFS doesn't allow that.  dentry->inode can go from NULL to
> > > non-NULL anytime but will only go from non-NULL to NULL when there are
> > > no possible external references to the dentry.
> > > 
> > > The compiler and the CPU cannot move the "LOAD inode->some_field"
> > > before the "LOAD dentry->inode", because of the conditional, right?
> > 
> > Other than Alpha, the CPU cannot.  The standard -does- permit the
> > compiler to guess the value of the pointer, thus effectively moving the
> > load prior to the conditional.  At present, as far as I know, gcc does
> > not actually do this.
> 
> I believe the standard only allows this if the compiler can *prove* (not
> guess) the result of the if test.  Even on Parisc where this can be
> expressed as a nullified instruction pair, the architectural rules
> forbid speculation of the latter before the former (the only time they
> can be executed out of order is when the CPU can prove the values
> internally, i.e. they're both cached)

Agreed, but unless you tell it otherwise, the compiler is allowed to
assume that the code it is generating is the only thread running in
the address space in question.  That is most definitely not the case
here, so we might need to let the compiler in on this information.

> > Again, please put at least an ACCESS_ONCE() in.  Trivial to do now,
> > possibly saving much pain and headache later on.
> 
> OK, lost you here.  ACCESS_ONCE() is only needed in certain situations
> (like list traversal) because some compilers can reload cached values
> across an explicit barrier (which isn't here).

ACCESS_ONCE() also tells the compiler not to try to guess.

							Thanx, Paul
