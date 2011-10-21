Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1JUFpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 01:45:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61586 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1JUFpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 01:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <29731.1319051397@death>
References: <20111019081757.12455.24788.stgit@ltc219.sdl.hitachi.co.jp>
	<27007.1319047262@death>
	<20111019114129.162d895a@nehalam.linuxnetplumber.net>
	<29731.1319051397@death>
Date: Fri, 21 Oct 2011 13:45:32 +0800
Message-ID: <CAM_iQpV8089aU8gfeo8KotTNXQbx4ficMeBX69Nin_yXzqcEKg@mail.gmail.com>
Subject: Re: [PATCH net -v2] [BUGFIX] bonding: use flush_delayed_work_sync in bond_close
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 3:09 AM, Jay Vosburgh <fubar@us.ibm.com> wrote:
> Stephen Hemminger <shemminger@vyatta.com> wrote:
>
>>On Wed, 19 Oct 2011 11:01:02 -0700
>>Jay Vosburgh <fubar@us.ibm.com> wrote:
>>
>>> Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:
>>>
>>> >The bond_close() calls cancel_delayed_work() to cancel delayed works.
>>> >It, however, cannot cancel works that were already queued in workqueue.
>>> >The bond_open() initializes work->data, and proccess_one_work() refers
>>> >get_work_cwq(work)->wq->flags. The get_work_cwq() returns NULL when
>>> >work->data has been initialized. Thus, a panic occurs.
>>> >
>>> >This patch uses flush_delayed_work_sync() instead of cancel_delayed_work()
>>> >in bond_close(). It cancels delayed timer and waits for work to finish
>>> >execution. So, it can avoid the null pointer dereference due to the
>>> >parallel executions of proccess_one_work() and initializing proccess
>>> >of bond_open().
>>>
>>>      I'm setting up to test this.  I have a dim recollection that we
>>> tried this some years ago, and there was a different deadlock that
>>> manifested through the flush path.  Perhaps changes since then have
>>> removed that problem.
>>>
>>>      -J
>>
>>Won't this deadlock on RTNL.  The problem is that:
>>
>>   CPU0                            CPU1
>>  rtnl_lock
>>      bond_close
>>                                 delayed_work
>>                                   mii_work
>>                                     read_lock(bond->lock);
>>                                     read_unlock(bond->lock);
>>                                     rtnl_lock... waiting for CPU0
>>      flush_delayed_work_sync
>>          waiting for delayed_work to finish...
>
>        Yah, that was it.  We discussed this a couple of years ago in
> regards to a similar patch:
>
> http://lists.openwall.net/netdev/2009/12/17/3
>
>        The short version is that we could rework the rtnl_lock inside
> the montiors to be conditional and retry on failure (where "retry" means
> "reschedule the work and try again later," not "spin retrying on rtnl").
> That should permit the use of flush or cancel to terminate the work
> items.

Yes? Even if we use rtnl_trylock(), doesn't flush_delayed_work_sync()
still queue the pending delayed work and wait for it to be finished?

Maybe I am too blind, why do we need rtnl_lock for cancel_delayed_work()
inside bond_close()?

Thanks.
