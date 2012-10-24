Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab2JXAPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:15:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59648 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463Ab2JXAPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
	<1350925299.8609.978.camel@edumazet-glaptop>
	<CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
	<CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
Date: Tue, 23 Oct 2012 17:15:49 -0700
X-Google-Sender-Auth: nj4ZV9LPmvH9U5veKKXb39haJTo
Message-ID: <CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com>
Subject: Re: Process Hang in __read_seqcount_begin
From: Peter LaDow <petela@gocougs.wsu.edu>
To: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the subject change, but I wanted to try and pull in those
who work on RT issues, and the subject didn't make that obvious.
Please search for the same subject without the RT Linux trailing
text.)

Well, more information.  Even with SMP enabled (and presumably the
migrate_enable having calls to preempt_disable), we still got the
lockup in iptables-restore.  I did more digging, and it looks like the
complete stack trace includes a call from iptables-restore (through
setsockopt with IPT_SO_SET_ADD_COUNTERS).  This seems to be a
potential multiple writer case where the counters are updated through
the syscall and the kernel is updating the counters as it filters
packets.

I think there might be a race on the update to xt_recseq.sequence,
since the RT patches remove the spinlock in seqlock_t.  Thus multiple
writers can corrupt the sequence count.  And I thought the SMP
configuration would disable preemption when local_bh_disable() is
called.  And indeed, looking at the disassembly, I see
preempt_disable() (though optimized, goes to add_preempt_count() ) is
being called.

Yet we still see the lockup in the get_counters() in iptables.  Which,
it seems, is because of some sort of problem with the sequence.  It
doesn't appear to be related to the preemption, and perhaps there is
some other corruption of the sequence counter happening.  But the only
places I see it modified is in xt_write_recseq_begin and
xt_write_recseq_end, which is only in the netfilter code
(ip6_tables.c, ip_tables.c, and arp_tables.c).  And every single call
is preceeded by a call to local_bh_disable().

This problem is a huge one for us.  And so far I'm unable to track
down how this is occurring.

Any other tips?  I presume this is the proper place for RT issues.

Thanks,
Pete
