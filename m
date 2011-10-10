Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1JJUKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:10:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab1JJUKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:10:49 -0400
Date: Mon, 10 Oct 2011 16:10:28 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
Message-ID: <20111010201027.GC2413@redhat.com>
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com>
 <20111010153631.GA2413@redhat.com>
 <4E934E5B.3000603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E934E5B.3000603@goop.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 12:58:19PM -0700, Jeremy Fitzhardinge wrote:
> > Hi,
> >
> > I just realized that the early call to jump_label_inc(), isn't being
> > honored with this patch until later when we invoke jump_label_init().
> > That strikes me as being inconsistent. When jump_label_inc() returns we
> > should expect the branch to be updated.
> 
> Why is that?  It looks to me like it will unconditionally update the
> instruction, irrespective of whether _init() has been called?
> 

No. jump_label_init(), sets up key->entries, to point into the jump
table...before that jump_label_update(), doesn't know where the table is
located, and will just return, without doing the update.


> > Thus, I think what probably want is to add a new 'int jump_label_init'
> > flag. If its not set we can call 'jump_label_init()' from
> > jump_label_inc()/dec().
> 
> Hm.  I worry that it may end up calling jump_label_init() in an
> unexpected context, especially since it may well be config-dependent, or
> adding a jump_label_inc() later on starts mysteriously failing.

good point.

> 
> >  And jump_label_init() can avoid initialization
> > if its already set.
> 
> That doesn't seem worthwhile in itself.  I suspect the number of "early"
> jump_label_incs will be very small (or we should look at doing the init
> earlier).
> 
>     J

I have it as 'early_initcall()', but perhaps it should be moved into
init/main.c. I don't think there's any reason it can't be done super
early. So I think this might be the best answer. It will also simplify
your series.

Thanks,

-Jason
