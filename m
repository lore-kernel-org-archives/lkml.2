Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1HCN4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:56:51 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56591 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab1HCN4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:56:40 -0400
Subject: Re: [PATCH] avr32: use set_current_blocked() in
 handle_signal/sys_rt_sigreturn
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110803133928.GA12990@redhat.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110803130813.GA11708@redhat.com>  <20110803133928.GA12990@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Aug 2011 14:56:37 +0100
Message-ID: <1312379797.10579.59.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 15:39 +0200, Oleg Nesterov wrote:
> On 08/03, Oleg Nesterov wrote:
> >
> > On 08/03, Matt Fleming wrote:
> > >
> > > 	 * Block the signal if we were unsuccessful.
> > > 	 */
> > > 	if (ret != 0 || !(ka->sa.sa_flags & SA_NODEFER)) {
> > > 		spin_lock_irq(&current->sighand->siglock);
> > > 		sigorsets(&current->blocked, &current->blocked,
> > > 			  &ka->sa.sa_mask);
> > > 		sigaddset(&current->blocked, sig);
> > > 		recalc_sigpending();
> > > 		spin_unlock_irq(&current->sighand->siglock);
> > > 	}
> >
> > Agreed, this looks "obviously wrong". We should block the !SA_NODEFER
> > signal it was delivered.
> 
> (I meant, it is was successfully delivered).
> 
> While at it, I'd also suggest another patch on top of Matt's.
> Uncompiled/untested.
> 
> ------------------------------------------------------------------------------
> [PATCH] avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn

Actually this was the reason that I spotted this bug. I'm going through
all the code that sets current->blocked manually and making it use
set_current_blocked() ;-)

Moving most of the recalc_pending() callers into one place
(set_current_blocked()) makes my signal scalability series a lot
smaller.

