Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0LQX4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:56:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab0LQX43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:56:29 -0500
Date: Fri, 17 Dec 2010 15:55:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delay.h: add __must_check to msleep_interruptible
Message-Id: <20101217155531.89efe13f.akpm@linux-foundation.org>
In-Reply-To: <20101217154947.3e95488c.akpm@linux-foundation.org>
References: <aed7ab07576c307653723b9bea04516879b3a3ed.1288860894.git.baruch@tkos.co.il>
	<20101217154947.3e95488c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 15:49:47 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu,  4 Nov 2010 10:55:41 +0200
> Baruch Siach <baruch@tkos.co.il> wrote:
> 
> > Code calling msleep_interruptible() must be aware that sleep time might be
> > shorter than intended as a result of a signal being caught. Code not checking
> > the return value of msleep_interruptible() is probably buggy, unless it's doing
> > the signal_pending() check itself, which is redundant.
> > 
> 
> True.  But there are around 250 callsites which don't check the
> msleep_interruptible() return value.

One quick way of fixing this would be to add

/*
 * Used by callsites which are supposed to be calling msleep_interruptible(),
 * but which were failing to properly handle msleep_interruptible()'s return
 * value
 */
static inline void msleep_you_suck_fixme_please(unsigned int msecs)
{
	msleep(msecs);
}

and then patch all the offending msleep_interruptible() callsites to
use msleep_you_suck_fixme_please().  Then add the __must_check to
msleep_interruptible().

And note that 250 msleep_interruptible() -> msleep() changes will
probably fix lots of bugs.
