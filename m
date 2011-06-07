Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1FGPUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:20:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:52813 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab1FGPUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:20:46 -0400
Subject: Re: [PATCH] sched: correct testing need_resched in
 mutex_spin_on_owner()
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTi=XTpYTZvetOUDgobRa_S4Cb=+syA@mail.gmail.com>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	 <1307454439.2322.260.camel@twins>
	 <BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
	 <1307456680.2322.270.camel@twins>
	 <BANLkTim1htraTXtGMcyAuH1Wa-G+J05i_g@mail.gmail.com>
	 <1307457646.2322.273.camel@twins>
	 <BANLkTi=XTpYTZvetOUDgobRa_S4Cb=+syA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 17:20:40 +0200
Message-ID: <1307460040.2322.279.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 22:47 +0800, Hillf Danton wrote:
> Oh, it looks you are willing to rethink about testing need_resched?

Dude, however did you come up with that deduction?

mutex_spin_on_owner() does two things:

 - it validates that owner is in fact still running (if so it must be on
another cpu, since we're running on this one).

 - it ensures we play nice and reschedule when we need to, so we don't
hog our cpu.

Testing TIF_NEED_RESCHED on owner like you propose is wrong because:

 - owner is not a stable pointer you can dereference, see
owner_running(), you first need to validate that its still a valid
pointer and then keep it valid while dereferencing it.

 - if owner were to reschedule, it would leave the cpu and we'd break
out of the loop anyway by means of owner_running() failing, so its
superfluous.

Please, get a grip on reality and stop sending endless streams of
patches based on wrong assumptions and mis-understandings.


