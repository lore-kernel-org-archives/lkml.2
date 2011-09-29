Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab1I2COz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:14:55 -0400
Received: from claw.goop.org ([74.207.240.146]:40330 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab1I2COy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:14:54 -0400
Message-ID: <4E83D49C.9080809@goop.org>
Date: Wed, 28 Sep 2011 19:14:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Jump Label initialization
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm trying to use the jump label machinery as part of the pv ticketlock
work I'm doing on x86.

The problem I'm having at the moment is that I do my spinlock setup in
smp_prepare_boot_cpu(), which happens before jump_label_init() gets
called, and so the latter goes and nops out all my enabled jump label key.

I'm experimenting at the moment with a patch to allow
jump_label_enable() to be called fairly early, and have that be
respected by jump_label_init().  I'm doing this by replacing
arch_jump_label_poke_text_early() with
arch_jump_label_transform_early(), which shares most of its code with
its non-early variant, except that it expects to run in a pre-SMP
environment.

Does this seem plausible? (I haven't tested it yet.)

The x86, mips and sparc patches are fairly simple; I forgot to look at
powerpc, and I didn't fully investigate s390.

While my current use-case is x86-specific, it seems generally useful to
make the jump_label machinery available as early as possible. I wonder
if you have any suggestions about how to handle this?

Thanks,
    J
