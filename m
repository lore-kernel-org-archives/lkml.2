Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0CVAcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:32:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56964 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab0CVAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:32:50 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] irq: Start the transition of irq_chip methods taking a desc
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
	<1267697339-5491-7-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003041142460.2014@localhost.localdomain>
	<4B900250.8020100@kernel.org>
	<Pine.LNX.4.64.1003050847170.21768@ask.diku.dk>
	<m1eije71et.fsf@fess.ebiederm.org>
	<Pine.LNX.4.64.1003211153470.7805@ask.diku.dk>
	<m1eijd3jl7.fsf_-_@fess.ebiederm.org>
	<alpine.LFD.2.00.1003211541120.3147@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 21 Mar 2010 17:32:41 -0700
In-Reply-To: <alpine.LFD.2.00.1003211541120.3147@localhost.localdomain> (Thomas Gleixner's message of "Sun\, 21 Mar 2010 15\:43\:47 +0100 \(CET\)")
Message-ID: <m17hp5yz4m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tglx@linutronix.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, julia@diku.dk, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> Eric,
>
> On Sun, 21 Mar 2010, Eric W. Biederman wrote:
>> 
>> With SPARSE_IRQ irq_to_desc becomes an unnecessary lookup operation on
>> the fast path of dispatching irqs to their handlers.  We can avoid
>> this cost by passing an irq_desc pointer instead of using an integer
>> irq token to the irq_chip methods.
>> 
>> A single patch to convert all of the architectures is an unreviewable
>> 2000+ line patch.  A gradual transition scenario with two sets of
>> irq_chip methods in irq_chip is an unmanageable mess in kernel/irq.
>> 
>> So instead I define some macros so the generic irq code in kernel/irq/
>> can compile either way based on a boolean Kconfig variable
>> CONFIG_CHIP_PARAM_DESC.  This allows us to convert one architecture at
>> a time, reducing the follow on patches to manageable proportions.  It
>> is a little bit ugly but it is much better than the alternatives, and
>> as soon as we finish the transition we can kill the macros.
>> 
>> I introduce the macros CHIP_ARG, CHIP_VAR, and CHIP_PARAM where
>> appropriate.  I change a few declarations of irq as int to unsigned
>> int.  I normalize the variables names in the functions that call
>> chip methods to ensure that I have the variables irq and desc present
>> allowing CHIP_ARG to work properly.  Most importantly none of the irq
>> logic changes with this patch.
>
> I like that approach very much. Is the output binary equivivalent?

Depends on what you mean.
- If you are concerned about ABI changes, non exist.
- If the question is will the compiler generate the same instruction sequences,
  I don't expect it will.

  In particular the bug fixes to use unsigned int instead of int should affect
  the tests used in the for_each_irq_desc.  Of less avoid-ability is the change
  to ack_bad to use desc->irq instead of cached irq value.

  Since this is the only patch in the entire series that could
  possibly be binary equivalent I don't find it a particularly
  interesting test.

Eric

