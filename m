Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1AQP1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 10:27:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56477 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1AQP1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 10:27:33 -0500
Subject: RE: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: samu.p.onkalo@nokia.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <90C2C3D80A94B8448891D39FF568E8760760B892@008-AM1MPN1-012.mgdnok.nokia.com>
References: <1295275365.12840.13.camel@kolo>
	 <1295276401.30950.125.camel@laptop>
	 <90C2C3D80A94B8448891D39FF568E8760760B892@008-AM1MPN1-012.mgdnok.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 16:28:04 +0100
Message-ID: <1295278084.30950.127.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 15:15 +0000, samu.p.onkalo@nokia.com wrote:
> 
> >-----Original Message-----
> >From: ext Peter Zijlstra [mailto:peterz@infradead.org]
> >Sent: 17 January, 2011 17:00
> >To: Onkalo Samu.P (Nokia-MS/Tampere)
> >Cc: mingo@elte.hu; linux-kernel@vger.kernel.org; tglx
> >Subject: Re: Bug in scheduler when using rt_mutex
> >
> >On Mon, 2011-01-17 at 16:42 +0200, Onkalo Samu wrote:
> >> Hi
> >>
> >> I believe that there are some problems in the scheduling when
> >> the following happens:
> >> - Normal priority process locks rt_mutex and sleeps while keeping it
> >> locked.
> >
> >There's your fail, don't do that!
> 
> So that is forbidden:
> 
> rt_mutex_lock();
> wait_for_completion(); <--- shared HW finishes its job
> rt_mutex_unlock();

Well, its pointless, its non-deterministic, so you totally void the
usage of rt_mutex. 

> >Why does I2C core use rt_mutex, that's utterly broken.
> 
> To get low priority task finish ongoing I2C access in time under
> heavy load cases I think.

FYI, I'm queueing a revert for that patch. Random driver junk should not
_ever_ use that.

> >> Based on my debugging following sequence occurs (single CPU
> >> system):
> >>
> >> 1) There is some user process running at the background (like
> >> cat /dev/zero..)
> >> 2) User process reads sysfs entry which causes I2C acccess
> >> 3) User process locks rt_mutex in the I2C-core
> >> 4) User process sleeps while it keeps rt_mutex locked
> >> (wait_for_completion in I2C transfer function)
> >
> >That's where things go wrong, there's absolutely nothing you can do to
> >fix the system once you block while holding a mutex.
> 
> Of course other processes are waiting until the (rt_)mutex is unlocked.
> Problem is that after the rt_mutex_unlock is done, the task which  just released
> the lock, may be in some non-running state for minutes.

Yeah, saw that, writing a patch for that, there's more than one problem
there.

