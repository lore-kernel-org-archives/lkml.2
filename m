Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0KOJmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:42:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52084 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab0KOJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NngYLteUtiTxXmLnw1mMMMfybR52/QKRnhNYuEqSt6PUFZXGKLnR/nRdkknouxYcaN
         ZCOUfD1/NpWqzELAUcERzN3IqIP8CZ83abdInSe2ckJMLZqOTGFd+1SLKH770hkctz1g
         KaHpC0Dm90oWt9a3jYbNd0P9NtmSoji8ivS8U=
Date: Mon, 15 Nov 2010 10:41:56 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Message-ID: <20101115094156.GB15936@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
 <1289259423.21487.7.camel@localhost.localdomain>
 <20101109082353.GA2690@riccoc20.at.omicron.at>
 <1289337058.9434.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289337058.9434.39.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 01:10:58PM -0800, john stultz wrote:
> On Tue, 2010-11-09 at 09:23 +0100, Richard Cochran wrote:
> > On Mon, Nov 08, 2010 at 03:37:03PM -0800, john stultz wrote:
> > > So sort of minor nit here, but is there a reason the clockfd
> > > implementation is primary here and the standard posix implementation
> > > gets pushed off into its own function rather then doing something like:
> > > 
> > > clk = clockid_to_clock_device(id)
> > > if(clk)
> > > 	return clockdev_clock_gettime(clk, user_ts);
> > > [existing sys_clock_gettime()] 
> > > 
> > > As you implemented it, it seems to expect the clockdevice method to be
> > > the most frequent use case, where as its likely to be the inverse. So
> > > folks looking into the more common CLOCK_REALTIME calls have to traverse
> > > more code then the likely more rare clockfd cases.
> > 
> > Actually, what I would like to do is refactor the exisiting posix
> > clock code to use the new framework. The idea is to have a set of
> > static global clock_device*, one per fixed clock. The function
> > clockid_to_clock_device() will include a lookup table, like this:
> > 
> > static clock_device *realtime_clock, *monotinic_clock;
> > 
> > switch (id) {
> > case CLOCK_REALTIME:
> > 	return realtime_clock;
> > case CLOCK_MONOTONIC:
> > 	return monotinic_clock;
> > /* and so on ... */
> > }
> 
> This seems a little over-reaching. I'm not sure I see what benefit would
> come from having clock_devices for the static clock_ids? The extra mutex
> locking and status/null checking for the clock_device would would just
> add unnecessary overhead to the performance critical clock_gettime call.

Okay, next time I'll leave the syscall in posix-timers.c and call out
to the clock_device in the unlikely dynamic case.

Thanks,
Richard
