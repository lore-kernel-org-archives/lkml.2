Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2FYD6E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 23:58:04 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55164 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab2FYD6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 23:58:01 -0400
Date: Sun, 24 Jun 2012 20:57:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: tracer_alloc_buffers returned with preemption imbalance
Message-ID: <20120625035733.GU2516@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120623101251.GA10162@localhost>
 <20120623170147.GI2516@linux.vnet.ibm.com>
 <20120623174830.GA5617@localhost>
 <CAM_iQpW-vtnHUOBoROueui-FCrw9zB4U3vwy=PnEOLXP713WWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpW-vtnHUOBoROueui-FCrw9zB4U3vwy=PnEOLXP713WWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062503-5806-0000-0000-0000169CF910
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 04:37:28PM +0800, Cong Wang wrote:
> On Sun, Jun 24, 2012 at 1:48 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >> >  static inline int rcu_blocking_is_gp(void)
> >> >  {
> >> >         might_sleep();  /* Check for RCU read-side critical section. */
> >> > +       preempt_disable();
> >> >         return num_online_cpus() <= 1;
> >> > +       preempt_enable();
> >> >  }
> >>
> >> Thank you!  I have no idea how a preempt_disable() causes that badness
> >> to happen, but this commit is not yet critically important, so I will
> >> drop it.
> >
> > preempt_enable() becomes dead code because of the return statement?
> > I wonder why gcc didn't issue a warning (or I failed to catch it)...
> >
> 
> gcc has an option -Wunreachable-code, but we don't enable it
> when building kernel, nor it will be enabled with -Wall. If we enable it,
> we will have many false-positives as we have lots of debugging code
> which is not reachable unless we enable some debugging option.
> 
> However, when I test it manually with the following code:
> 
> ~% cat /tmp/unreachable.c
> int main(void)
> {
> 	int a = 0;
> 	a++;
> 	return ++a;
> 	a++;
> }
> ~% gcc -Wunreachable-code -O0 -c /tmp/unreachable.c
> 
> gcc still doesn't give me any warning for the last line of the code,
> gcc optimizes it out silently, I am wondering if this is a gcc bug.

But in my case, the trailing preempt_enable() should not have been
optimized away, right?  Wouldn't it be more like the following?

int a = 0;
int main(void)
{
	a++;
	return ++a;
	a++;
}

Hmmm...  But this -still- doesn't emit any warnings.

							Thanx, Paul

