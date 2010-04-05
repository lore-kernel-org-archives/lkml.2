Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0DETWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:22:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35856
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755141Ab0DETWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:22:31 -0400
Date: Mon, 05 Apr 2010 12:22:33 -0700 (PDT)
Message-Id: <20100405.122233.188421941.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100405065701.GC5127@nowhere>
References: <20100404122113.GD5177@nowhere>
	<20100404.180057.109331958.davem@davemloft.net>
	<20100405065701.GC5127@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 5 Apr 2010 08:57:04 +0200

> It seems to happen after an unaligned access fixup.

You shouldn't be getting the unaligned fixup in the first place,
especially in the locations where you see them.  I suspect that
once you see first fixup, all of the registers in the cpu have
been corrupted in one way or another.

I suspect something fundamental gets corrupted, for example the
current register window (%cwp) is corrupted and that screws up all of
the registers so every single function starts accessing garbage.

My suspicions lie in three places, the ftrace mcount()
stubs, stack_trace_flush(), or the new perf_arch_save_caller_regs()
since those are the three places offhand that could make
us potentially make us return to function in the wrong
register window.
