Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab0EYSjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:39:05 -0400
Received: from www.tglx.de ([62.245.132.106]:42193 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab0EYSjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:39:01 -0400
Date: Tue, 25 May 2010 20:37:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Frans Pop <elendil@planet.nl>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Wireless IBSS on Linux-2.6.34 broken by commit
 3bbb9ec946428b96657126768f65487a48dd090c
In-Reply-To: <alpine.LFD.2.00.1005240754130.3689@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005252034430.2948@localhost.localdomain>
References: <Pine.LNX.4.64.1005240710460.3159@boston.corp.fedex.com> <alpine.LFD.2.00.1005240754130.3689@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010, Linus Torvalds wrote:
> 
> On Mon, 24 May 2010, Jeff Chua wrote:
> > 
> > -	expires_limit = expires + timer->slack;
> > +	expires_limit = expires;
> > 
> > -	if (timer->slack < 0) /* auto slack: use 0.4% */
> > +	if (timer->slack > -1)
> > +		expires_limit = expires + timer->slack;
> > +	else if (time_after(expires, jiffies)) /* auto slack: use 0.4% */
> >  		expires_limit = expires + (expires - jiffies)/256;
> 
> Please don't reload 'jiffies' twice. It's volatile, and the compiler will 
> do a crap job of it. 

Grr, it's even worse. If jiffies increment between the time_after()
check and (expires - jiffies) we might run into the same problem as
before. Sigh, did not notice when I picked it up. ENOTENOUGHCOFFEE.
 
> Also, '0' is a normal number, but '-1' is a rather odd value. Please just 
> test for non-negative by doing ">= 0" rather than "> -1"

Will fix, thanks,

     tglx
