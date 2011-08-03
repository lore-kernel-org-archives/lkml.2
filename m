Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1HCOIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab1HCOIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:08:50 -0400
Date: Wed, 3 Aug 2011 16:04:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>,
        Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: + shm-fix-a-race-between-shm_exit-and-shm_init.patch added to
	-mm tree
Message-ID: <20110803140456.GA14393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vasiliy Kulikov <segoon@openwall.com>
>
> On thread exit shm_exit_ns() is called, it uses shm_ids(ns).rw_mutex.  It
> is initialized in shm_init(), but it is not called yet at the moment of
> kernel threads exit.  Some kernel threads are created in
> do_pre_smp_initcalls(), and shm_init() is called in do_initcalls().
>
> Static initialization of shm_ids(init_ipc_ns).rw_mutex fixes the race.

Yes, it is safe to call down_right() now.

But the code does

	down_write(rw_mutex);
	if (.in_use)
		idr_for_each(.ipcs_idr);

and thus it relies on the static initializer anyway. it is not safe
to do idr_for_each() before idr_init() in theory.

And since we rely on .in_use == 0, why we can't move this check
outside of down_write/up_right to a) optimize the code and b)
fix the problem?

Oleg.

