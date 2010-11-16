Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0KPRIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:08:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:56375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0KPRIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:08:40 -0500
Subject: RE: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <A24693684029E5489D1D202277BE89447382A55A@dlee02.ent.ti.com>
References: <1289925179-17085-1-git-send-email-saaguirre@ti.com>
	 <1289925901.2109.629.camel@laptop>
	 <A24693684029E5489D1D202277BE89447382A55A@dlee02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 18:08:46 +0100
Message-ID: <1289927326.2109.631.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 10:57 -0600, Aguirre, Sergio wrote:

> > > @@ -145,7 +145,10 @@ void irq_work_run(void)
> > >  		 * Clear the BUSY bit and return to the free state if
> > >  		 * no-one else claimed it meanwhile.
> > >  		 */
> > > -		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
> > > +		xchgres = cmpxchg(&entry->next,
> > > +				  next_flags(NULL, IRQ_WORK_BUSY),
> > > +				  NULL);
> > > +		BUG_ON(unlikely(xchgres != next_flags(NULL, IRQ_WORK_BUSY)));
> > 
> > simply adding (void) in front would be much easier.
> 
> But isn't that still leaving the remote possibility of a hidden cmpxchg
> Failure open?

No, we don't care if it fails, read the comment. All we want to know is
that if it still matched, we flipped the bit.
