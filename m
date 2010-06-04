Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0FDONl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:13:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:57447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0FDONk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:13:40 -0400
Date: Sat, 5 Jun 2010 00:13:18 +1000
From: Nick Piggin <npiggin@suse.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [patch 2/4] lglock: introduce special lglock and brlock spin
 locks
Message-ID: <20100604141318.GC26335@laptop>
References: <20100604064307.737085373@suse.de>
 <20100604072618.400686656@suse.de>
 <1275638163.2482.2.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1275638163.2482.2.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 09:56:03AM +0200, Eric Dumazet wrote:
> Le vendredi 04 juin 2010 à 16:43 +1000, Nick Piggin a écrit :
> > pièce jointe document texte brut (kernel-introduce-brlock.patch)
> > This patch introduces "local-global" locks (lglocks). These can be used to:
> > 
> > - Provide fast exclusive access to per-CPU data, with exclusive access to
> >   another CPU's data allowed but possibly subject to contention, and to provide
> >   very slow exclusive access to all per-CPU data.
> > - Or to provide very fast and scalable read serialisation, and to provide
> >   very slow exclusive serialisation of data (not necessarily per-CPU data).
> > 
> > Brlocks are also implemented as a short-hand notation for the latter use
> > case.
> > 
> > Thanks to Paul for local/global naming convention.
> > 
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: Al Viro <viro@ZenIV.linux.org.uk>
> > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > Cc: Frank Mayhar <fmayhar@google.com>,
> > Cc: John Stultz <johnstul@us.ibm.com>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > ---
> >  include/linux/lglock.h |  165 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 165 insertions(+)
> > 
> 
> IMHO some changes in Documentation/ would be needed

I wonder where, and what?

 
> > + void name##_global_lock(void) {					\
> > +	int i;								\
> > +	preempt_disable();						\
> > +	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
> > +	for_each_online_cpu(i) {					\
> 
> for_each_possible_cpu()

Oh good spotting. brlock does not need this but lglock does if it
protects offline cpu data too. Maybe better to move file handles in
the event of hotplug.

