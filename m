Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab1C3PhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:37:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647Ab1C3PhI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:37:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103301648460.22418@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103301648460.22418@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 08:36:13 -0700
Message-ID: <AANLkTinnGfpVeugk4WOKeDAUQEuzBo75yCq_E73=w66V@mail.gmail.com>
Subject: Re: [GIT pull] irq fixes for .39.rc
To: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 7:51 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Please pull the latest irq-fixes-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

Hmm. This has a fundamental merge  conflict with BenH's tree that I just pulled.

You guys did different things in arch/powerpc/include/asm/qe_ic.h:

 - BenH has:

        -       struct qe_ic *qe_ic = get_irq_desc_data(desc);
        +       struct qe_ic *qe_ic = irq_desc_get_chip_data(desc);

 - Thomas has:

        -       struct qe_ic *qe_ic = get_irq_desc_data(desc);
        +       struct qe_ic *qe_ic = irq_desc_get_handler_data(desc);

Note the "chip_data" vs "handler_data" difference.

And when I tried to figure out which one is the correct one, I see that

 - qe_ic_host_map does:

        irq_set_chip_data(virq, qe_ic);

 - qe_ic_init does:

        irq_set_handler_data(qe_ic->virq_low, qe_ic);
        ...
                irq_set_handler_data(qe_ic->virq_high, qe_ic);

which just makes me go "Somebody is really really confused".

The whole thing may mean that both handler_data and chip_data contains
the right thing, but it still makes me go "WTF?".

Which way should I resolve it?

                         Linus
