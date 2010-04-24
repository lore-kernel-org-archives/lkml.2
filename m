Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab0DXAOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 20:14:42 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33197 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843Ab0DXAOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 20:14:41 -0400
Date: Fri, 23 Apr 2010 17:14:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documentation/credentials.txt
Message-ID: <20100424001437.GB2589@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100423235532.GA17804@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423235532.GA17804@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 06:55:33PM -0500, Serge E. Hallyn wrote:
> Hi,
> 
> In the section 'ACCESSING ANOTHER TASK'S CREDENTIALS', the file
> Documentation/credentials.txt says:
> 
> > A function need not get RCU read lock to use __task_cred() if it is holding a
> > spinlock at the time as this implicitly holds the RCU read lock.
> 
> AIUI, that is not actually right any more, is it?  A spinlock does not
> suffice as it does not necessarily imply an RCU read-side critical section
> (anymore).  Of course the spinlock specifically protecting updates would
> suffice, but that's not what this is saying.
> 
> Am I way off base?

You are absolutely correct, good catch!!!

Now, a spinlock still does imply an RCU read-side critical section given
the following configuration options:

o	!CONFIG_PREEMPT

o	CONFIG_PREEMPT && CONFIG_TREE_RCU

o	CONFIG_PREEMPT && CONFIG_TINY_RCU

However, relying on this is usually bad practice, as such code is prone
to failure given the following configuration options:

o	CONFIG_PREEMPT && CONFIG_TREE_PREEMPT_RCU

o	CONFIG_PREEMPT_RT (given the -rt patchset)

And when I get my act together and complete CONFIG_TINY_PREEMPT_RCU,
then CONFIG_PREEMPT && CONFIG_TINY_PREEMPT_RCU will also invalidate
the assumption that holding a spinlock acts as an RCU read-side
critical section.

Did you want to submit a patch for this?

							Thanx, Paul
