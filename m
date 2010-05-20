Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0ETHiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:38:07 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:39101 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab0ETHhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:37:54 -0400
In-Reply-To: <1274319248.22892.40.camel@concordia>
References: <4BF30793.5070300@us.ibm.com>	 <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com>
	 <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com>	 <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain>
	 <alpine.LFD.2.00.1005192244430.3368@localhost.localdomain> <1274319248.22892.40.camel@concordia>
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
X-KeepSent: 17F8F35C:B09E4797-C1257729:0028292D;
 type=4; name=$KeepSent
To: michael@ellerman.id.au
Cc: Brian King <brking@linux.vnet.ibm.com>, Doug Maxey <doug.maxey@us.ibm.com>,
       dvhltc@linux.vnet.ibm.com, Darren Hart <dvhltc@us.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       niv@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       Will Schmidt <will_schmidt@vnet.ibm.com>
X-Mailer: Lotus Notes Release 8.5 HF58 February 06, 2009
Message-ID: <OF17F8F35C.B09E4797-ONC1257729.0028292D-C1257729.0029E9AC@de.ibm.com>
From: Jan-Bernd Themann <THEMANN@de.ibm.com>
Date: Thu, 20 May 2010 09:37:47 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 8.0.2FP2|June 22, 2009) at
 20/05/2010 09:37:46
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Michael Ellerman <michael@ellerman.id.au> wrote on 20.05.2010 03:34:08:


> Subject:
>
> Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
>
> On Wed, 2010-05-19 at 23:08 +0200, Thomas Gleixner wrote:
> > On Wed, 19 May 2010, Thomas Gleixner wrote:
> > > > I'm still not clear on why the ultimate solution wasn't to
> have XICS report
> > > > edge triggered as edge triggered. Probably some complexity of
> the entire power
> > > > stack that I am ignorant of.
> > > >
> > > > > Apart from the issue of loosing interrupts there is also thefact
that
> > > > > masking on the XICS requires an RTAS call which takes a global
lock.
> > >
> > > Right, I'd love to avoid that but with real level interrupts we'd run
> > > into an interrupt storm. Though another solution would be to issue
the
> > > EOI after the threaded handler finished, that'd work as well, but
> > > needs testing.
> >
> > Thought more about that. The case at hand (ehea) is nasty:
> >
> > The driver does _NOT_ disable the rx interrupt in the card in the rx
> > interrupt handler - for whatever reason.
>
> Yeah I saw that, but I don't know why it's written that way. Perhaps
> Jan-Bernd or Doug will chime in and enlighten us? :)

>From our perspective there is no need to disable interrupts for the RX side
as
the chip does not fire further interrupts until we tell the chip to do so
for a
particular queue. We have multiple receive queues with an own interrupt
each
so that the interrupts can arrive on multiple CPUs in parallel.
Interrupts are enabled again when we leave the NAPI Poll function for the
corresponding
receive queue.

Michael, does this answer your question?

Regards,
Jan-Bernd

