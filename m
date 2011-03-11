Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1CKTrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:47:17 -0500
Received: from www.tglx.de ([62.245.132.106]:57341 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1CKTrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:47:16 -0500
Date: Fri, 11 Mar 2011 20:46:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, johnstul@us.ibm.com
Subject: Re: [PATCH 3/3] Check for write permission on FD based
 posix-clocks
In-Reply-To: <20110304072239.GA8957@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1103112044410.2787@localhost6.localdomain6>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de> <1299173174-348-4-git-send-email-torbenh@gmx.de> <20110304072239.GA8957@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Richard Cochran wrote:

> On Thu, Mar 03, 2011 at 06:26:14PM +0100, Torben Hohn wrote:
> > pc_clock_settime() and pc_clock_adjtime() did not check
> > whether the fd was opened in write mode.
> > 
> > It was possible to set a clock, when we only had read
> > permissions.
> > 
> > for completeness, we would also need to check for Read permissions
> > on the read operations. but that would be a bit paranoid, probably.
> 
> I have no objection to this form of clock access control, but I would
> like to get agreement about it from the list.

Acked-by-me
 
> > diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
> > index 04498cb..25028dd 100644
> > --- a/kernel/time/posix-clock.c
> > +++ b/kernel/time/posix-clock.c
> > @@ -287,11 +287,16 @@ static int pc_clock_adjtime(clockid_t id, struct timex *tx)
> >  	if (err)
> >  		return err;
> >  
> > +	if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
> > +		err = -EACCES;
> 
> Looks like clock_settime and adjtimex are supposed to return EPERM in
> this case.

As Arnd already said -EACCES is sensible for file permission checks
while -EPERM means that you have no permission at all.

Thanks,

	tglx
