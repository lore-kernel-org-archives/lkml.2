Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0ITSZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:25:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50168 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab0ITSZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:25:10 -0400
Date: Mon, 20 Sep 2010 11:25:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Message-ID: <20100920182504.GD2408@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
 <1284760148.30449.107.camel@pasglop>
 <20100917231222.GA3060@linux.vnet.ibm.com>
 <1284864421.30449.113.camel@pasglop>
 <20100919152638.GF3060@linux.vnet.ibm.com>
 <E1OxQIg-0005Nw-WE@pomaz-ex.szeredi.hu>
 <20100919215909.GG3060@linux.vnet.ibm.com>
 <1284944316.2957.795.camel@mulgrave.site>
 <20100920012915.GI3060@linux.vnet.ibm.com>
 <E1OxioY-0006nd-M9@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OxioY-0006nd-M9@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 06:01:58PM +0200, Miklos Szeredi wrote:
> On Sun, 19 Sep 2010, Paul E. McKenney wrote:
> > > > Again, please put at least an ACCESS_ONCE() in.  Trivial to do now,
> > > > possibly saving much pain and headache later on.
> > > 
> > > OK, lost you here.  ACCESS_ONCE() is only needed in certain situations
> > > (like list traversal) because some compilers can reload cached values
> > > across an explicit barrier (which isn't here).
> > 
> > ACCESS_ONCE() also tells the compiler not to try to guess.
> 
> If the code is written like this:
> 
> 	if (ACCESS_ONCE(dentry->d_inode)) {
> 		blah = dentry->d_inode->i_some_field
> 		...
> 	}
> 
> does the compiler guarantee anything or does it need a full compiler
> barrier to prevent reordering?

>From what I understand, this could do strange things.  The compiler
is forced to access dentry->d_inode for the "if" check, but would be
free to use some previously fetched value for the assignment to "blah".
Unless of course this code was under a lock that prevented any
change to dentry->d_inode.

If the code is to execute in a lockless manner, I would instead suggest
something like the following:

	p = ACCESS_ONCE(dentry->d_inode);
	if (p) {
		blah = p->i_some_field
		...
	}

This would force the compiler to actually fetch dentry->d_inode
and only then dereference it.

This would -not- constrain the CPU in any way, but the only CPU that
I know of that misbehaves in this case is DEC Alpha.

So my version of the above code would do what you expect on most CPUs,
but really could fail on DEC Alpha.  If you don't believe me, please feel
free to take a look at http://www.openvms.compaq.com/wizard/wiz_2637.html.

But do we really care about Alpha anymore?  (I can see it now... The
Alpha portion of the kernel tree moves to staging...)

> Because that pattern is, again, pretty much all over the place.  Yeah
> it can be rewritten but that's not always feasable since it's
> difficult to audit, would possibly need extra function arguments,
> etc...

Again, the pattern is OK if you are preventing the pointer from changing.

							Thanx, Paul
