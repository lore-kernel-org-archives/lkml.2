Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2BLRlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:41:42 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53622 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab2BLRlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:41:40 -0500
Date: Sun, 12 Feb 2012 09:41:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tony.luck@intel.com,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcos.mage@gmail.com, prasad@linux.vnet.ibm.com
Subject: Re: [PATCH] x86, mce: Fix rcu splat in drain_mce_log_buffer()
Message-ID: <20120212174133.GL3737@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120111142213.16610.85866.stgit@srivatsabhat.in.ibm.com>
 <20120111161153.GA2925@linux.vnet.ibm.com>
 <4F102353.1040109@linux.vnet.ibm.com>
 <20120113214435.GC2909@linux.vnet.ibm.com>
 <20120206161802.GC31237@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206161802.GC31237@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021217-3352-0000-0000-00000291DE89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 05:18:02PM +0100, Borislav Petkov wrote:
> On Fri, Jan 13, 2012 at 01:44:35PM -0800, Paul E. McKenney wrote:
> > Looks good to me, but I do need to defer to people who know this code
> > better than do I.  The key thing that (from what I can see) makes
> > rcu_dereference() unnecessary is that the smp_rmb() used in conjunction
> > with polling the .finished field takes care of ordering.
> 
> Right, this was me trying hard not to screw up touching mcelog.next,
> thus trying to use the rcu_dereference_index_check() primitive without
> thinking it through too much. But you're right, I'm polling the
> ->finished field 4 times (totally arbitrary, btw) which should suffice
> while the mce_log() routine above writes those entries.
> 
> Although, the question still remains, since mce_log() accesses
> mcelog.next through the rcu_dereference_index_check() primitive,
> shouldn't I do it the same way?

I don't claim to be an mce_log() expert, but when I looked it over,
I didn't see a need for rcu_dereference_index_check().  Unless I am
confused (quite possible), the memory barriers are sufficient.

The rcu_read_lock() and rcu_read_unlock() seem to be needed to avoid
premature freeing, though.

							Thanx, Paul

