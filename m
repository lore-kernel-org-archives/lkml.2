Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2F2Gyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:54:51 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:51509 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2F2Gyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:54:50 -0400
Date: Fri, 29 Jun 2012 08:54:31 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] panic: Fix a possible deadlock in panic()
Message-ID: <20120629085431.24771aa2@br98xy6r>
In-Reply-To: <1340926985-8270-1-git-send-email-markivx@codeaurora.org>
References: <1340926985-8270-1-git-send-email-markivx@codeaurora.org>
Organization: IBM
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12062906-1948-0000-0000-0000023E3B89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vikram,

Putting "linux-arch" on cc...

On Thu, 28 Jun 2012 16:43:05 -0700
Vikram Mulukutla <markivx@codeaurora.org> wrote:
> panic_lock is meant to ensure that panic processing takes
> place only on one cpu; if any of the other cpus encounter
> a panic, they will spin waiting to be shut down.
> 
> However, this causes a regression in this scenario:
> 
> 1. Cpu 0 encounters a panic and acquires the panic_lock
>    and proceeds with the panic processing.
> 2. There is an interrupt on cpu 0 that also encounters
>    an error condition and invokes panic.
> 3. This second invocation fails to acquire the panic_lock
>    and enters the infinite while loop in panic_smp_self_stop.
> 
> Thus all panic processing is stopped, and the cpu is stuck
> for eternity in the while(1) inside panic_smp_self_stop.
> 
> To address this, disable local interrupts with
> local_irq_disable before acquiring the panic_lock. This will
> prevent interrupt handlers from executing during the panic
> processing, thus avoiding this particular problem.

Looks good to me.

I re-read the panic lock discussion and in fact one version of my patch
also disabled interrupts:

http://lists.infradead.org/pipermail/kexec/2011-October/005695.html

I think the reason why we later took a version with irqs enabled was
that we did not think about the scenario you described above and
we wanted to make the change as less intrusive as possible. But I am
not really sure about that.

Regarding you patch: Perhaps we could use spin_trylock_irq() instead of
local_irq_disable() and spin_lock().

Michael

