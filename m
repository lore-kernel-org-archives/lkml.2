Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab0G1VXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:23:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab0G1VXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:23:03 -0400
Date: Wed, 28 Jul 2010 14:22:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>, linux-kernel@vger.kernel.org,
        apw@canonical.com, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] timer: Added usleep[_range] timer
Message-Id: <20100728142239.d8dd468b.akpm@linux-foundation.org>
In-Reply-To: <4C509B6F.8000200@linux.intel.com>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
	<1280345587-19725-2-git-send-email-ppannuto@codeaurora.org>
	<20100728132314.29cd68c5.akpm@linux-foundation.org>
	<4C509772.1070407@codeaurora.org>
	<20100728135857.2a0ab8bd.akpm@linux-foundation.org>
	<4C509B6F.8000200@linux.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 14:04:47 -0700
Arjan van de Ven <arjan@linux.intel.com> wrote:

> On 7/28/2010 1:58 PM, Andrew Morton wrote:
> >
> > My main concern is that someone will type usleep(50) and won't realise
> > that it goes and sleeps for 100 usecs and their code gets slow as a
> > result.  This sort of thing takes *years* to discover and fix.  If we'd
> > forced them to type usleep_range() instead, it would never have happened.
> >
> >
> >
> > Another question: what is the typical overhead of a usleep()?  IOW, at
> > what delay value does it make more sense to use udelay()?  Another way
> > of asking that would be "how long does a usleep(1) take"?  If it
> > reliably consumes 2us CPU time then we shouldn't do it.
> >
> > But it's not just CPU time, is it?  A smart udelay() should put the CPU
> > into a lower power state, so a udelay(3) might consume less energy than
> > a usleep(2), because the usleep() does much more work in schedule() and
> > friends?
> >    
> 
> for very low values of udelay() you're likely right.... but we could and 
> should catch that inside usleep imo and fall back to a udelay
> it'll likely be 10 usec or so where we'd cut off.
> 
> now there is no such thing as a "low power udelay", not really anyway....

Yup.  I can't find any arch which tries to do anything fancy.

x86's rep_nop() tries to save a bit of juice, doesn't it?  Should we be
using that?

Because we use udelay() in many places - it wouldn't surprise me if
some people's machines were consuming significant amounts of
time/energy in there, if they have suitably broken hardware or drivers.

> but the opposite is true; the cpu idle code will effectively do the 
> equivalent of udelay() if you're asking for a very short delay, so
> short that any power saving thing isn't giong to be worth it. ( + 
> hitting scheduler overhead

hm, point.
