Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab1JVA7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 20:59:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51580 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1JVA7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 20:59:14 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: netdev@vger.kernel.org
cc: =?us-ascii?Q?=3D=3Fus-ascii=3FQ=3F=3D3D=3D3FUTF-8=3D3FQ=3D3FAm=3D3DC3?=
	 =?us-ascii?Q?=3D3DA9rico=3D5FWang=3D3F=3D3D=3F=3D?= 
	<xiyou.wangcong@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH net -v2] [BUGFIX] bonding: use flush_delayed_work_sync in bond_close
In-reply-to: <17144.1319178396@death>
References: <20111019081757.12455.24788.stgit@ltc219.sdl.hitachi.co.jp> <27007.1319047262@death> <20111019114129.162d895a@nehalam.linuxnetplumber.net> <29731.1319051397@death> <CAM_iQpV8089aU8gfeo8KotTNXQbx4ficMeBX69Nin_yXzqcEKg@mail.gmail.com> <17144.1319178396@death>
Comments: In-reply-to Jay Vosburgh <fubar@us.ibm.com>
   message dated "Thu, 20 Oct 2011 23:26:36 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 21 Oct 2011 17:59:02 -0700
Message-ID: <14766.1319245142@death>
x-cbid: 11102200-6078-0000-0000-000001F3F068
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Vosburgh <fubar@us.ibm.com> wrote:

>Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
>>On Thu, Oct 20, 2011 at 3:09 AM, Jay Vosburgh <fubar@us.ibm.com> wrote:
>>> Stephen Hemminger <shemminger@vyatta.com> wrote:
>>>
>>>>On Wed, 19 Oct 2011 11:01:02 -0700
>>>>Jay Vosburgh <fubar@us.ibm.com> wrote:
>>>>
>>>>> Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:
>>>>>
>>>>> >The bond_close() calls cancel_delayed_work() to cancel delayed works.
>>>>> >It, however, cannot cancel works that were already queued in workqueue.
>>>>> >The bond_open() initializes work->data, and proccess_one_work() refers
>>>>> >get_work_cwq(work)->wq->flags. The get_work_cwq() returns NULL when
>>>>> >work->data has been initialized. Thus, a panic occurs.
>>>>> >
>>>>> >This patch uses flush_delayed_work_sync() instead of cancel_delayed_work()
>>>>> >in bond_close(). It cancels delayed timer and waits for work to finish
>>>>> >execution. So, it can avoid the null pointer dereference due to the
>>>>> >parallel executions of proccess_one_work() and initializing proccess
>>>>> >of bond_open().
>>>>>
>>>>>      I'm setting up to test this.  I have a dim recollection that we
>>>>> tried this some years ago, and there was a different deadlock that
>>>>> manifested through the flush path.  Perhaps changes since then have
>>>>> removed that problem.
>>>>>
>>>>>      -J
>>>>
>>>>Won't this deadlock on RTNL.  The problem is that:
>>>>
>>>>   CPU0                            CPU1
>>>>  rtnl_lock
>>>>      bond_close
>>>>                                 delayed_work
>>>>                                   mii_work
>>>>                                     read_lock(bond->lock);
>>>>                                     read_unlock(bond->lock);
>>>>                                     rtnl_lock... waiting for CPU0
>>>>      flush_delayed_work_sync
>>>>          waiting for delayed_work to finish...
>>>
>>>        Yah, that was it.  We discussed this a couple of years ago in
>>> regards to a similar patch:
>>>
>>> http://lists.openwall.net/netdev/2009/12/17/3
>>>
>>>        The short version is that we could rework the rtnl_lock inside
>>> the montiors to be conditional and retry on failure (where "retry" means
>>> "reschedule the work and try again later," not "spin retrying on rtnl").
>>> That should permit the use of flush or cancel to terminate the work
>>> items.
>>
>>Yes? Even if we use rtnl_trylock(), doesn't flush_delayed_work_sync()
>>still queue the pending delayed work and wait for it to be finished?
>
>	Yes, it does.  The original patch wants to use flush instead of
>cancel to wait for the work to finish, because there's evidently a
>possibility of getting back into bond_open before the work item
>executes, and bond_open would reinitialize the work queue and corrupt
>the queued work item.
>
>	The original patch series, and recipe for destruction, is here:
>
>	http://www.spinics.net/lists/netdev/msg176382.html
>
>	I've been unable to reproduce the work queue panic locally,
>although it sounds plausible.
>
>	Mitsuo: can you provide the precise bonding configuration you're
>using to induce the problem?  Driver options, number and type of slaves,
>etc.
>
>>Maybe I am too blind, why do we need rtnl_lock for cancel_delayed_work()
>>inside bond_close()?
>
>	We don't need RTNL for cancel/flush.  However, bond_close is an
>ndo_stop operation, and is called in the dev_close path, which always
>occurs under RTNL.  The mii / arp monitor work functions separately
>acquire RTNL if they need to perform various failover related
>operations.
>
>	I'm working on a patch that should resolve the mii / arp monitor
>RTNL problem as I described above (if rtnl_trylock fails, punt and
>reschedule the work).  I need to rearrange the netdev_bonding_change
>stuff a bit as well, since it acquires RTNL separately.
>
>	Once these changes are made to mii / arp monitor, then
>bond_close can call flush instead of cancel, which should eliminate the
>original problem described at the top.

	Just an update: there are three functions that may deadlock if
the cancel work calls are changed to flush_sync.  There are two
rtnl_lock calls in each of the bond_mii_monitor and
bond_activebackup_arp_mon functions, and one more in the
bond_alb_monitor.

	Still testing to make sure I haven't missed anything, and I
still haven't been able to reproduce Mitsuo's original failure.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

