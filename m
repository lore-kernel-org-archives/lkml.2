Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2DIWXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:23:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38361 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2DIWXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:23:22 -0400
Date: Mon, 9 Apr 2012 15:22:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michel Machado <michel@digirati.com.br>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] rculist: Made list_first_entry_rcu usable
Message-ID: <20120409222219.GP2430@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1333417354.2412.7.camel@Thor>
 <20120409212440.GL2430@linux.vnet.ibm.com>
 <1334009322.2444.12.camel@Thor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334009322.2444.12.camel@Thor>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040922-7282-0000-0000-0000080EC98E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 06:08:42PM -0400, Michel Machado wrote:
> On Mon, 2012-04-09 at 14:24 -0700, Paul E. McKenney wrote:
> > On Mon, Apr 02, 2012 at 09:42:34PM -0400, Michel Machado wrote:
> > > The macro list_first_entry_rcu assumed that the passed list is not empty
> > > as its counterpart list_first_entry does. However, one can test that a
> > > list is not empty with list_empty before calling list_first_entry,
> > > whereas neither exists list_empty_rcu, nor is advisable to add it as the
> > > example below shows.
> > > 
> > > Assuming that list_empty_rcu is available, one could write the following
> > > snippet:
> > > 
> > > if (!list_empty_rcu(mylist)) {
> > > 	struct foo *bar = list_first_entry_rcu(mylist, struct foo,
> > > 		list_member);
> > > 	do_something(bar);
> > > }
> > > 
> > > The problem with this snippet is the following racing condition: the
> > > list may not be empty when list_empty_rcu checks it, but it may be when
> > > list_first_entry_rcu rereads the ->next pointer.
> > > 
> > > This patch cannot break any upstream code because list_first_entry_rcu
> > > is not being used anywhere in the kernel (tested with grep(1)), and
> > > external code that uses it is probably broken already.
> > 
> > Hello, Michel,
> > 
> > Interesting point!
> > 
> > Are you intending to use list_first_entry_rcu()?  If not, perhaps the
> > best thing to do is to remove it.
> > 
> > 							Thanx, Paul
> 
> Hi Paul,
> 
>    I'd rather keep list_first_entry_rcu(). I've already used it twice in
> the project I'm working on
> (https://github.com/AltraMayor/XIA-for-Linux), and I expect to submit
> this work upstream once it reaches reasonable quality as you can check
> in the roadmap available here:
> 
> https://github.com/AltraMayor/XIA-for-Linux/wiki/Roadmap#wiki-Making_into_Linus_source_tree
> 
>    Not to mention that, given the subtlety of the problem, removing
> list_first_entry_rcu() may introduce the same bug whenever someone tries
> to mimic list_first_entry(), and having it in the kernel helps to guide
> those with an example.

Actually, list_first_entry_rcu() really does mimic list_first_entry()
from what I can see.  Both of them require that the list be non-empty,
which can be checked via !list_empty().

Or is list_first_entry() being converted to check for an empty list?

We really do need both list_first_entry() and list_first_entry_rcu()
to have the same semantics on empty lists, I am sure you would agree.

							Thanx, Paul

> [ ]'s
> Michel Machado
> 
> > 
> > > Signed-off-by: Michel Machado <michel@digirati.com.br>
> > > CC: Dipankar Sarma <dipankar@in.ibm.com>
> > > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > ---
> > > Please CC my e-mail address while replying this message because I don't
> > > subscribe this mailing list due to its high volume; thanks.
> > > 
> > > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > > index d079290..866d3ec 100644
> > > --- a/include/linux/rculist.h
> > > +++ b/include/linux/rculist.h
> > > @@ -233,13 +233,16 @@ static inline void list_splice_init_rcu(struct
> > > list_head *list,
> > >   * @type:       the type of the struct this is embedded in.
> > >   * @member:     the name of the list_struct within the struct.
> > >   *
> > > - * Note, that list is expected to be not empty.
> > > + * Note that if the list is empty, it returns NULL.
> > >   *
> > >   * This primitive may safely run concurrently with the _rcu
> > > list-mutation
> > >   * primitives such as list_add_rcu() as long as it's guarded by
> > > rcu_read_lock().
> > >   */
> > >  #define list_first_entry_rcu(ptr, type, member) \
> > > -	list_entry_rcu((ptr)->next, type, member)
> > > +	({struct list_head *__ptr = ptr; \
> > > +	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
> > > +	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL;
> > > \
> > > +	})
> > > 
> > >  /**
> > >   * list_for_each_entry_rcu	-	iterate over rcu list of given type
> > > 
> > > 
> > 
> 

