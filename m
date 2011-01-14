Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab1ANHst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:48:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64643 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1ANHsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nnTh2Ur/KA0pK7RTaSxeO2NX/5ZgHtraMPW/4dTKbpnP5S9vloExd2QT0aNY/Lfgsq
         H9jPGYipg9iMjlUQ8lUfUM4lc4Hk0bEa7LDUaBVQGpdTb9E8cKFaAayVlxAIS9vBF+Br
         /j9Xb00H16cf70gcqaWpuggdyi/Kh2UAl1ctM=
Date: Fri, 14 Jan 2011 08:48:37 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V9 08/13] posix clocks: cleanup the CLOCK_DISPTACH macro
Message-ID: <20110114074837.GA8077@riccoc20.at.omicron.at>
References: <cover.1294917347.git.richard.cochran@omicron.at>
 <90b2beef441615d01c93fcad029c44af4e505c5f.1294917348.git.richard.cochran@omicron.at>
 <alpine.LFD.2.00.1101131745400.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101131745400.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 06:03:24PM +0100, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Richard Cochran wrote:
> >  int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
> >  int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
> > -int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
> > +int posix_cpu_clock_set(const clockid_t which_clock, struct timespec *ts);
> 
> Shouldn't we change the clock_set function to have *ts const in all places ?

Yes, your are right.

> > @@ -293,6 +261,11 @@ static __init int init_posix_timers(void)
> >  		.clock_adj = do_posix_clock_noadjtime,
> >  		.timer_create = no_timer_create,
> >  		.nsleep = no_nsleep,
> > +		/* defaults: */
> > +		.nsleep_restart	= common_nsleep_restart,
> > +		.timer_del	= common_timer_del,
> > +		.timer_get	= common_timer_get,
> > +		.timer_set	= common_timer_set,
> 
> Hmm, we do not need to set functional entries for clocks which neither
> implement timer_create nor nsleep.

I know, but I wanted to be really pendantic about what the previous
code was, and what the new code does.

Before: By leaving the k_clock function pointer NULL, the clock
        selects common_xyz. This common function may or may make
        sense for that clock.

After:  By leaving the k_clock function pointer NULL, the clock will
        return EINVAL for that syscall.

Maybe it would be better to leave the cleaning up of the common crud
as a follow up patch. What do you think?

Richard
