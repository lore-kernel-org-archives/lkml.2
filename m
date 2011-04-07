Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab1DGPru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:47:50 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39487 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1DGPrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:47:48 -0400
Date: Thu, 7 Apr 2011 08:47:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110407154737.GF2262@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1301657749.4859.531.camel@twins>
 <20110405215450.GK2247@linux.vnet.ibm.com>
 <20110405230745.GA5972@linux.vnet.ibm.com>
 <1302077428.2225.1365.camel@twins>
 <20110406192119.GB2265@linux.vnet.ibm.com>
 <20110406201350.GA9378@linux.vnet.ibm.com>
 <1302123970.2207.4.camel@laptop>
 <4D9CDACB.9050705@linux.intel.com>
 <20110407003041.GD2265@linux.vnet.ibm.com>
 <4D9D507F.2040006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9D507F.2040006@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 01:49:51PM +0800, Lai Jiangshan wrote:
> On 04/07/2011 08:30 AM, Paul E. McKenney wrote:
> > On Wed, Apr 06, 2011 at 02:27:39PM -0700, H. Peter Anvin wrote:
> >> On 04/06/2011 02:06 PM, Peter Zijlstra wrote:
> >>> On Wed, 2011-04-06 at 13:13 -0700, Paul E. McKenney wrote:
> >>>> And the following patch builds correctly for defconfig x86 builds,
> >>>> while allowing rcupdate.h to see the sched.h definitions as needed
> >>>> to inline rcu_read_lock() and rcu_read_unlock().
> >>>>
> >>> Looks like an entirely reasonable patch to me ;-)
> >>>
> >>
> >> Quite... a lot better than the original proposal!
> > 
> > Glad you both like it!
> > 
> > When I do an allyesconfig build, I do get errors during the "CHECK"
> > phase, when it is putting things into the usr/include in the build tree.
> > I believe that this is because I am exposing different header files to
> > the library-export scripts.  The following patch silences some of them,
> > but I am really out of my depth here.
> > 
> > Sam, Jan, Michal, help?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> 
> Easy to split rcupdate.h, hard to resolve the dependence problem.
> 
> You can apply the next additional patch when you test:

I am sure that you are quite correct.  ;-)

I am moving _rcu_read_lock() and _rcu_read_unlock() into
include/linux/rcutree.h and include/linux/rcutiny.h, and I am sure that
more pain will ensue.

One thing I don't understand...  How does is it helping to group the
task_struct RCU-related fields into a structure?  Is that generating
better code on your platform due to smaller offsets or something?

Also, does your patchset address the CHECK warnings?

							Thanx, Paul

> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 0b4496a..ccbebeb 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -788,4 +788,10 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
>  #error "Unknown RCU implementation specified to kernel configuration"
>  #endif
> 
> +#include <linux/sched.h>
> +static inline long test_use_task_struct(void)
> +{
> +	return current->state;
> +}
> +
>  #endif /* __LINUX_RCUPDATE_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
