Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab0HPWhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:37:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40601 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab0HPWhc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PYo1bxvvc7P89LrshTVoLFukqH2ilkFtAEsOtkazbs7lnsIWgfGahqR+fnOSxA/+dS
         7cb7I1IDCD31W3KWA7YdRqhA6rZQKl1tF2RhpugMLueROiPA24GlSCh2krbnX2ql251w
         ESI/Mo3YHhGs5pcIwCKossGK/tRH0mH39mi/4=
MIME-Version: 1.0
In-Reply-To: <20100809172719.GG3026@linux.vnet.ibm.com>
References: <AANLkTimULDfJ9n2XxNmtq8yUcNRfAywHpiDDXRKtev10@mail.gmail.com>
	<20100809172719.GG3026@linux.vnet.ibm.com>
Date: Mon, 16 Aug 2010 15:37:30 -0700
Message-ID: <AANLkTi=5dc82RTtr_MEwLnBk9hojj=3DvP_uDyJ5rG_P@mail.gmail.com>
Subject: Re: 2.6.35 - INFO: kernel/exit.c:1387 invoked rcu_dereference_check()
 without protection!
From: Miles Lane <miles.lane@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul and friends,

Now in 2.6.36-rc1:

[    7.295797] ===================================================
[    7.295801] [ INFO: suspicious rcu_dereference_check() usage. ]
[    7.295805] ---------------------------------------------------
[    7.295810] kernel/exit.c:1390 invoked rcu_dereference_check()
without protection!
[    7.295813]
[    7.295814] other info that might help us debug this:
[    7.295816]
[    7.295819]
[    7.295820] rcu_scheduler_active = 1, debug_locks = 1
[    7.295825] 2 locks held by init/1:
[    7.295827]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8103e31c>]
do_wait+0xa5/0x1fa
[    7.295843]  #1:  (&(&sighand->siglock)->rlock){......}, at:
[<ffffffff8103de60>] wait_consider_task+0x5e1/0x9f8
[    7.295854]
[    7.295855] stack backtrace:
[    7.295860] Pid: 1, comm: init Not tainted 2.6.36-rc1 #3
[    7.295864] Call Trace:
[    7.295872]  [<ffffffff81061999>] lockdep_rcu_dereference+0x9d/0xa6
[    7.295878]  [<ffffffff8103deef>] wait_consider_task+0x670/0x9f8
[    7.295884]  [<ffffffff8103e388>] do_wait+0x111/0x1fa
[    7.295890]  [<ffffffff8103e5b9>] sys_waitid+0x7f/0x178
[    7.295898]  [<ffffffff81002a5c>] ? sysret_check+0x27/0x62
[    7.295904]  [<ffffffff8103cbc6>] ? child_wait_callback+0x0/0x53
[    7.295911]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b


On Mon, Aug 9, 2010 at 10:27 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Aug 03, 2010 at 11:20:58PM -0400, Miles Lane wrote:
>> [ INFO: suspicious rcu_dereference_check() usage. ]
>> ---------------------------------------------------
>> kernel/exit.c:1387 invoked rcu_dereference_check() without protection!
>>
>> other info that might help us debug this:
>>
>> rcu_scheduler_active = 1, debug_locks = 1
>> 2 locks held by init/1:
>>  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff81045ca8>] do_wait+0xa9/0x1fa
>>  #1:  (&(&sighand->siglock)->rlock){......}, at: [<ffffffff810457e8>]
>> wait_consider_task+0x5e1/0x9f8
>>
>> stack backtrace:
>> Pid: 1, comm: init Not tainted 2.6.35 #15
>> Call Trace:
>>  [<ffffffff8106759c>] lockdep_rcu_dereference+0x9d/0xa6
>>  [<ffffffff81045877>] wait_consider_task+0x670/0x9f8
>>  [<ffffffff81045d14>] do_wait+0x115/0x1fa
>>  [<ffffffff81045f41>] sys_waitid+0x7f/0x178
>>  [<ffffffff81009cba>] ? sysret_check+0x2e/0x69
>>  [<ffffffff8104454e>] ? child_wait_callback+0x0/0x53
>>  [<ffffffff81009c82>] system_call_fastpath+0x16/0x1b
>
> This one is interesting.  The ->sighand->siglock is held, but the
> rcu_dereference_check() check condition requires that either the
> task is dead or that we are in an RCU read-side critical section.
> The comment preceding the call to __task_cred() claims that we
> "don't need the RCU readlock here as we're holding a spinlock."
> This comment dates back to 2008, so might be obsolete.
>
> David, should we enclose the __task_cred() in wait_task_stopped()
> with rcu_read_lock()?  Or would it be better to add a check to
> __task_cred() checking for ->sighand->siglock?  Or do we need to
> do something else entirely?  ;-)
>
>                                                        Thanx, Paul
>
