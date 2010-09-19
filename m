Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0ISP0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 11:26:49 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37658 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab0ISP0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 11:26:46 -0400
Date: Sun, 19 Sep 2010 08:26:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Message-ID: <20100919152638.GF3060@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <6383.1284647456@redhat.com>
 <20100916150356.GD2462@linux.vnet.ibm.com>
 <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
 <20100916163708.GG2462@linux.vnet.ibm.com>
 <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
 <1284656978.26423.11.camel@mulgrave.site>
 <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
 <1284760148.30449.107.camel@pasglop>
 <20100917231222.GA3060@linux.vnet.ibm.com>
 <1284864421.30449.113.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284864421.30449.113.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 12:47:01PM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2010-09-17 at 16:12 -0700, Paul E. McKenney wrote:
> > On Sat, Sep 18, 2010 at 07:49:08AM +1000, Benjamin Herrenschmidt wrote:
> > > 
> > > > Right but in the concrete namei example I can't see how a compiler
> > > > optimization can make a difference.  The order of the loads is quite
> > > > clear:
> > > > 
> > > >    LOAD inode = next.dentry->inode
> > > >    if (inode != NULL)
> > > >    	LOAD inode->f_op
> > > > 
> > > > What is there the compiler can optimize?
> > > 
> > > Those two loads depend on each other, I don't think any implementation
> > > can re-order them. In fact, such data dependency is typically what is
> > > used to avoid having barriers in some cases. The second load cannot be
> > > issued until the value from the first one is returned.
> > 
> > Sufficiently sadistic compiler and CPU implementations could do value
> > speculation, for example, driven by profile-feedback optimization.
> > Then the guess might initially incorrect, but then a store by some other
> > CPU could make the subsequent test decide (wrongly) that the guess had
> > in fact been correct.
> > 
> > Needless to say, I am not a fan of value speculation.  But other people
> > do like it a lot.
> 
> Well, this verges on insanity... we get to a point where nobody's going
> to get any code right :-)
> 
> I don't think the powerpc arch allows that, that leaves us with the
> compiler, but so far I don't think gcc is -that- crazy. Those constructs
> are common enough...

Give it a few years.  There are reportedly already other compilers that do
this, which is not too surprising given that the perception of insanity
is limited to lockless parallel code.  If you have single-threaded code,
such as code and data under a lock (where the data is never accessed
without holding that lock), then this sort of optimization is pretty safe.
I still don't like it, but the compiler guys would argue that this is
because I am one of those insane parallel-programming guys.

Furthermore, there are other ways to get into trouble.  If the code
continued as follows:

   LOAD inode = next.dentry->inode
   if (inode != NULL)
   	LOAD inode->f_op
	do_something_using_lots_of_registers();
	LOAD inode->some_other_field

and if the code expected ->f_op and ->some_other_field to be from the
same inode structure, severe disappointment could ensue.  This is because
the compiler is within its rights to reload from next.dentry->inode,
especially given register pressure.  In fact, the compiler would be within
its rights to reload from next.dentry->inode in the "LOAD inode->f_op"
statement.  And it might well get NULL from such a reload.

This code sequence therefore needs -at- -least- an ACCESS_ONCE() to keep
the compiler in line.

Remember, by default, the compiler is permitted to assume that it is
generating single-threaded code.

							Thanx, Paul
