Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1HASCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:02:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49485 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1HASB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:01:57 -0400
Date: Mon, 1 Aug 2011 22:01:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        torvalds@linux-foundation.org, Marc Zyngier <maz@misterjones.org>
Subject: initcall dependency problem (ns vs. threads)
Message-ID: <20110801180151.GA26686@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There were reported problems with recent shm changes, by Manuel
Lauss (on MIPS), Richard Weinberger (on UML), and Marc Zyngier (on ARM).

https://lkml.org/lkml/2011/8/1/149
https://lkml.org/lkml/2011/8/1/162
https://lkml.org/lkml/2011/8/1/210

The problem became visible on this patch:

    commit 5774ed014f02120db9a6945a1ecebeb97c2acccb
    Author: Vasiliy Kulikov <segoon@openwall.com>
    Date:   Fri Jul 29 03:55:31 2011 +0400

        shm: handle separate PID namespaces case

It started to use &shm_ids(ns).rw_mutex, which is not initialized yet.
Init IPC namespace is initialized as initcall() and some threads are
created as early_initcall().

I threat it is a dependency bug in the core kernel - kernel threads
should be able to use any namespace information, but currently there is
a race between namespace initialization code (which is initcall) and
kernel threads (which are early_initcall).

I don't feel enough experienced in init code dependencies, so I report
it to you.

    static int __init kernel_init(void * unused)
    {
        ...
        do_pre_smp_initcalls(); << threads start here
        ...
        do_basic_setup();


    static void __init do_basic_setup(void)
    {
        cpuset_init_smp();
        usermodehelper_init();
        init_tmpfs();
        driver_init();
        init_irq_proc();
        do_ctors();
        do_initcalls(); << namespace init here
    }

Thanks,

-- 
Vasiliy
