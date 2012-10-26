Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966607Ab2JZVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:25:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46365 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965612Ab2JZVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <1351285552.30380.20.camel@edumazet-glaptop>
References: <CAN8Q1EdobyFuAvtajGRSqNsCG+XoPA+FkwN=2j_H126mmfEjTQ@mail.gmail.com>
	<1350925299.8609.978.camel@edumazet-glaptop>
	<CAN8Q1EeqmHMHD-VUgr7Wzv0Z_DAD1SrEniftg==L14d+hGwu+Q@mail.gmail.com>
	<CAN8Q1EcTRsHjCJD90q0bKRJFMvi7Vn8YRsyQTAHNtTFVuuNdWQ@mail.gmail.com>
	<CAN8Q1EeB2kC6A_YP9zdtp_qYHMG5FF7-Usjx7Rz5pv--bjhqkQ@mail.gmail.com>
	<1351053164.6537.95.camel@edumazet-glaptop>
	<CAN8Q1Ef9sCAG8-KNWXEeuRUcmFNcg93mMG=HRQw6i3UuGtJCVg@mail.gmail.com>
	<1351270087.30380.9.camel@edumazet-glaptop>
	<CAN8Q1Ed1J-jmO9LppcA=rFXPvxFkk-J9mMb2-NhDYyAQKO2jvQ@mail.gmail.com>
	<1351285552.30380.20.camel@edumazet-glaptop>
Date: Fri, 26 Oct 2012 14:25:52 -0700
X-Google-Sender-Auth: RpK6w1qNu3fDa-8WcD_OarFvL1Y
Message-ID: <CAN8Q1Ecx-pDR=NBQm4O=VaynQsxBU1wku9e_kcKkWB=xU0OtMA@mail.gmail.com>
Subject: Re: Process Hang in __read_seqcount_begin
From: Peter LaDow <petela@gocougs.wsu.edu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        netfilter@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 2:05 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Do you know what is per cpu data in linux kernel ?

I sorta did.  But since your response, I did more reading, and now I
see what you mean.  But I don't think this is a per cpu issue.  More
below.

> Because its not needed. Really I dont know why you want that.
>
> Once you are sure a thread cannot be interrupted by a softirq, and
> cannot migrate to another cpu, access to percpu data doesnt need other
> synchronization at all.

Because there are multiple entry points on the same CPU.  In
net/ipv4/netfilter/ip_tables, there are two entries to
xt_write_recseq_begin().  The first is in ipt_do_table and the other
is in get_counters.  Where we are seeing the lockup is with a
getsockopt syscall leading to do_counters.  The other path is through
ipt_do_table, which is installed as a hook.  I'm not sure from what
context the hooks are called, but it is certainly from a different
context than the syscall.

> Following sequence is safe :
>
> addend = (__this_cpu_read(xt_recseq.sequence) + 1) & 1;
> /*
>  * This is kind of a write_seqcount_begin(), but addend is 0 or 1
>  * We dont check addend value to avoid a test and conditional jump,
>  * since addend is most likely 1
>  */
> __this_cpu_add(xt_recseq.sequence, addend);

If this were safe, we wouldn't be seeing this lockup and your patch
wouldn't be needed.  So it seems that your patch doesn't really
address the issue that we are not "sure a thread cannot be interrupted
by a softirq, and cannot migrate to another cpu".  Well, we know it
cannot migrate to another CPU, because there isn't another CPU.  So
apparently, it can be interrupted by a softirq.  So local_bh_disable
isn't doing anything useful in the RT patches with regard to this.

As I mentioned earlier, I think perhaps what your patch did was ensure
an atomic update of the sequence counter.  But it does nothing to
synchronize two writers.  If they were already synchronized (such as
via the call to local_bh_disable), then we wouldn't see sequence
counter corruption, no?

Pete
