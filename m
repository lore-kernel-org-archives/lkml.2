Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0KJNpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:45:12 -0500
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:50325 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756092Ab0KJNpI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:45:08 -0500
Subject: Re: [PATCH] mce: fix RCU lockdep from mce_poll()
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andi Kleen <andi@firstfloor.org>, paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101108131708.GC2580@linux.vnet.ibm.com>
References: <1288993499.2065.4.camel@cowboy>
	 <20101106185350.GA23824@basil.fritz.box>
	 <20101107133950.GV15561@linux.vnet.ibm.com>
	 <1289215819.2318.3.camel@cowboy> <20101108131708.GC2580@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 10:44:55 -0300
Message-ID: <1289396695.2208.0.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 05:17 -0800, Paul E. McKenney wrote:
> On Mon, Nov 08, 2010 at 08:30:19AM -0300, Davidlohr Bueso wrote:
> > On Sun, 2010-11-07 at 05:39 -0800, Paul E. McKenney wrote:
> > > On Sat, Nov 06, 2010 at 07:53:50PM +0100, Andi Kleen wrote:
> > > > On Fri, Nov 05, 2010 at 06:44:59PM -0300, Davidlohr Bueso wrote:
> > > > > Hi,
> > > > > 
> > > > > Please review this patch, I am not very familiar with MCE/RCU so I'm not sure that this is the correct fix (otherwise consider it a bug report :)).
> > > > > This does "fix" the message though and I can use MCE normally.
> > > > 
> > > > The patch is certainly not correct. The variable needs to be read
> > > > independently of the mutex.
> > > 
> > > This code is simply checking the value of the pointer, and therefore
> > > need not protect any actual dereferences.  So why not replace the
> > > rcu_dereference_check_mce() with rcu_access_pointer()?  If this is
> > > OK, please see the patch below.
> > > 
> > > BTW, assigning the value returned by rcu_access_pointer() into a
> > > variable often indicates a bug.  ;-)
> > > 
> > > 							Thanx, Paul
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > > index 7a35b72..4d29d50 100644
> > > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > > @@ -1625,7 +1625,7 @@ out:
> > >  static unsigned int mce_poll(struct file *file, poll_table *wait)
> > >  {
> > >  	poll_wait(file, &mce_wait, wait);
> > > -	if (rcu_dereference_check_mce(mcelog.next))
> > > +	if (rcu_access_pointer(mcelog.next))
> > 
> > this doesn't compile (mcelog.next is an index):
> > 
> > arch/x86/kernel/cpu/mcheck/mce.c: In function ‘mce_poll’:
> > arch/x86/kernel/cpu/mcheck/mce.c:1628: error: invalid type argument of
> > ‘unary *’ (have ‘unsigned int’)
> > arch/x86/kernel/cpu/mcheck/mce.c:1628: warning: type defaults to ‘int’
> > in declaration of ‘_________p1’
> > arch/x86/kernel/cpu/mcheck/mce.c:1628: error: invalid type argument of
> > ‘unary *’ (have ‘unsigned int’)
> > arch/x86/kernel/cpu/mcheck/mce.c:1628: warning: type defaults to ‘int’
> > in declaration of ‘type name’
> > arch/x86/kernel/cpu/mcheck/mce.c:1628: warning: cast to pointer from
> > integer of different size
> > arch/x86/kernel/cpu/mcheck/mce.c:1628: error: invalid type argument of
> > ‘unary *’ (have ‘unsigned int’)
> > arch/x86/kernel/cpu/mcheck/mce.c:1628: warning: type defaults to ‘int’
> > in declaration of ‘type name’
> > make[4]: *** [arch/x86/kernel/cpu/mcheck/mce.o] Error 1
> > 
> > 
> > Since the mutex is independent, what about this patch?
> 
> Looks good to me!
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

Andi, any further thoughts?

Thanks,
Davidlohr

