Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2CFRB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:01:28 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:42296 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932139Ab2CFRBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:01:25 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XU_JhCEVM1n7TRtPzbuIu0g7.JyGgwBeYaz1FerliO4XvOA
 .6zMgIHGaELdSvUb4Cyb5EUwkOhvP8qii90cIqNBcVvVyRCq_DO.mriJtrsb
 pzmayn4VoQjMdJre0vgjyou22mWjOejfS9DXvIMAovk9NG8uV9QWKrIo178J
 7iGxz2rRzya5JC6.S0IWJLK.PHAiYFfSz5yI.DkhtgctTJk8JkVbvyENWZJy
 vkHASPqA9lYrJQXVFV8pfdRvzBHL3co9iRpi4KJX8HL2NDKrIwO3viqQlw1G
 KeclAy4SIpqE3W1odZ6uvgy7dn.miffyx9jtRLs9LRGK_VtUNs8x6cjf7bEe
 UTXKoOWuU8CPze4yKCO.2UWD91IoPWY3UhI.zl56LsjLS6980O7weEAJP5ey
 lyQXLSC2J_KGFFM9qHL4QPjDMBa0MoksgJOYJ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 6 Mar 2012 10:33:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        hpa@zytor.com, alex.shi@intel.com, sfr@canb.auug.org.au, tj@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 5/8] x86: use this_cpu_xxx to replace percpu_xxx funcs
In-Reply-To: <20120306075740.GF23669@elte.hu>
Message-ID: <alpine.DEB.2.00.1203061015060.20871@router.home>
References: <20120305230515.A9238A02AE@akpm.mtv.corp.google.com> <20120306074601.GD23669@elte.hu> <20120305235532.28f407bf.akpm@linux-foundation.org> <20120306075740.GF23669@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Ingo Molnar wrote:

> > All percpu_xxx() functions get removed.
>
> Fair enough - then please see my namespace comments for the
> other patch, before we start spreading these APIs to hundreds of
> places ...

Its already almost everywhere... This removes some of the last holdouts.

> Also, IMHO the lack of debugging API is troubling as well.

For that there would need to be some basic understanding as to what is
going on here. These are fundamentally atomic style operations and I keep
hearing that people want to check if they are in a preempt section etc.
I do not see how that is possible for the this_cpu_ops.

However, checks could be done this for the __this_cpu_ops (which rely on
the processor not changing during their execution for their fallback
implementation, therefore preempt should be off) by simply adding a check
to the basic macros (add to __this_cpu_ptr for example). The problem is
then that there needs to be an audit first to see if there are cases where
we run into trouble with such an approach. There are situations in which
the use of __this_cpu ops is legitimate for other reasons if no concurrent
per cpu access can occur or we cannot be moved to a different processor
(because the process pinned to a processor f.e.)

> Thomas found a couple of really, really hairy this_cpu related
> bugs.

Well yeah if one uses per cpu operations and then allows execution to
occur on a different processor then one will not operate on the same
entity. The same issue would have occurred if they had used the old
percpu operations.
