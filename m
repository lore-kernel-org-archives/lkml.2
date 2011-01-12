Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1ALHhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:37:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34640 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab1ALHhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:37:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DgpAc9aox4uMastL4qzIsl8XL9Uf1B3xaDVsSGxK8xvyz3yrDASnB4PgVQx2QxgtEp
         TGaMWmPpd0ilVTxxYXsRQyCrneyh+qKQKxHf1Q0Qvh2ZIoSQy7NNRFXfd7nsZvbhGK2F
         Rmw8hwl0oRc0c9jONMAZgkC1zefc6HsbxMr6g=
Date: Wed, 12 Jan 2011 08:37:28 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH macro
Message-ID: <20110112073728.GA2935@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
 <alpine.LFD.2.00.1101111224280.12146@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101111224280.12146@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 01:57:23PM +0100, Thomas Gleixner wrote:
> I wonder whether we should be a bit more clever here and create an
> extra entry for posix_cpu_timers in the posix_clocks array and do the
> following:
...
> That reduces the code significantly and the MAX_CLOCKS check in
> clock_get_array_id() replaces the invalid_clock() check in the
> syscalls as well. It does not matter whether we check this before or
> after copying stuff from user.

Well, this does reduce the number of LOC, but the number of
comparisons is the same. I think the code size would be also no
different.

> Adding your new stuff requires just another entry in the array, the
> setup of the function pointers and the CLOCKFD check in
> clock_get_array_id(). Everything else just falls in place.

For me, I am not sure if either version is really very pretty or easy
to understand.

My instinct is to keep the posix_cpu_X and pc_X functions out of the
array of static clock id functions, if only to make the distinction
between the legacy static ids and new dynamic ids clear.

The conclusion from the "dynamic clock as file" discussion was that we
don't want to add any more static clock ids, and new clocks should use
the new, dynamic clock API. So, we should discourage any future
attempt to add to that function array!

Having said that, if you insist on it, I won't mind reworking the
dispatch code as you suggested.

> > +
> > +#define CLOCK_DISPATCH(clock, call, arglist) dispatch_##call arglist
> > +
> 
> Can we get rid of this completely please ?

Yes, gladly.

> >  clock_nanosleep_restart(struct restart_block *restart_block)
> >  {
> > -	clockid_t which_clock = restart_block->arg0;
> > -
> 
> How does that compile ?

Because the CLOCK_DISPATCH macro, above, makes no use of the first
argument! I have removed the macro for the next round.

> >  	return CLOCK_DISPATCH(which_clock, nsleep_restart,
> >  			      (restart_block));
> >  }

Thanks,
Richard
