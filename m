Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0HPNrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:47:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:44814 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0HPNrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:47:14 -0400
Subject: Re: fix BUG: using smp_processor_id() in touch_nmi_watchdog and
 touch_softlockup_watchdog
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100816133452.GS4879@redhat.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
	 <1281946970.1926.998.camel@laptop>  <20100816133452.GS4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 15:46:58 +0200
Message-ID: <1281966418.1926.1421.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 09:34 -0400, Don Zickus wrote:
> > Don/Ingo, remember if we require touch_*_watchdog callers to have
> > preemption disabled? Or is the proposed patch sensible?
> 
> I don't recall any requirement to have preemption disabled when using
> those functions.  It seems sensible to put it in the
> touch_{softlockup|nmi}_watchdog code.

OK, in that case the patch looks sensible.

> I assume the reason for having preemption disabled when using
> smp_processor_id() is that the code could migrate to another cpu when
> rescheduled?

Right, if you can freely schedule, you can get migrated, which means you
can get migrated between having determined the return value and using
it, at which point the computed value is meaningless.

> I don't see a problem with the patch, but my low level understanding of
> the __get_cpu_var vs. per_cpu isn't very strong.

__get_cpu_var() gets you the value on the current cpu, per_cpu() takes a
cpu argument.
