Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2ABK1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 05:27:01 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57690 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab2ABK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 05:26:56 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4F017B34.109@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <87ty4erb01.fsf@abhimanyu.in.ibm.com> <4F017B34.109@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 02 Jan 2012 15:52:40 +0530
Message-ID: <87r4ziqu8f.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12010200-7014-0000-0000-0000005BB63C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jan 2012 11:39:00 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 01/02/2012 06:20 AM, Nikunj A Dadhania wrote:
[...]
> > >     non-PLE - Test Setup:
> > > 
> > >     dbench 8vm (degraded -30%)
> > >     |      dbench|               2.01 |               1.38 |      -30 |
> >
> >
> >     Baseline:
> >     57.75%         init  [kernel.kallsyms]  [k] native_safe_halt
> >     40.88%      swapper  [kernel.kallsyms]  [k] native_safe_halt
> >
> >     Gang V2:
> >     56.25%         init  [kernel.kallsyms]  [k] native_safe_halt
> >     42.84%      swapper  [kernel.kallsyms]  [k] native_safe_halt
> >
> > Similar comparison here.
> >
> 
> Wierd, looks like a mismeasurement... 
>
Getting similar numbers across different runs/reboots with dbench.

> what happens if you add a bash
> busy loop?
> 
Perf output for bash busy loops inside the guest:

     9.93%           sh  libc-2.12.so       [.] _int_free
     8.37%           sh  libc-2.12.so       [.] _int_malloc
     6.14%           sh  libc-2.12.so       [.] __GI___libc_malloc
     6.03%           sh  bash               [.] 0x480e6         


loop.sh
----------------------------------
for i in `seq 1 8`
do
	while :; do :; done &
	pid[$i]=$!;
done
sleep 60

for i in `seq 1 8`
do
	kill -9 ${pid[$i]}
done
----------------------------------

Used the following command to capture the perf events inside the guest:

ssh root@192.168.123.11 'perf record -a -o loop-perf.out  --
/root/loop.sh '

Regards,
Nikunj

