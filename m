Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0KPQ52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:57:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43740 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab0KPQ50 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:57:26 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>
Date: Tue, 16 Nov 2010 10:57:02 -0600
Subject: RE: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
Thread-Topic: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
Thread-Index: AcuFrZcjnJmpnzPWQt6Cbn8fMt8GtwAAZW+Q
Message-ID: <A24693684029E5489D1D202277BE89447382A55A@dlee02.ent.ti.com>
References: <1289925179-17085-1-git-send-email-saaguirre@ti.com>
 <1289925901.2109.629.camel@laptop>
In-Reply-To: <1289925901.2109.629.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> Sent: Tuesday, November 16, 2010 10:45 AM
> To: Aguirre, Sergio
> Cc: LKML; Huang Ying; Martin Schwidefsky; Ingo Molnar; Kyle McMartin
> Subject: Re: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
> 
> On Tue, 2010-11-16 at 10:32 -0600, Sergio Aguirre wrote:
> > Although is very unlikely, it's better to make sure we're not
> > letting this happen.
> >
> > This solves this compilation warning:
> >
> > kernel/irq_work.c: In function 'irq_work_run':
> > kernel/irq_work.c:148: warning: value computed is not used
> >
> 
> > @@ -145,7 +145,10 @@ void irq_work_run(void)
> >  		 * Clear the BUSY bit and return to the free state if
> >  		 * no-one else claimed it meanwhile.
> >  		 */
> > -		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
> > +		xchgres = cmpxchg(&entry->next,
> > +				  next_flags(NULL, IRQ_WORK_BUSY),
> > +				  NULL);
> > +		BUG_ON(unlikely(xchgres != next_flags(NULL, IRQ_WORK_BUSY)));
> 
> simply adding (void) in front would be much easier.

But isn't that still leaving the remote possibility of a hidden cmpxchg
Failure open?

Regards,
Sergio
