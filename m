Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab1GHWO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 18:14:58 -0400
Received: from mx2.netapp.com ([216.240.18.37]:35451 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1GHWO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 18:14:56 -0400
X-IronPort-AV: E=Sophos;i="4.65,500,1304319600"; 
   d="scan'208";a="561411559"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [RFC] sunrpc:  Fix race between work-queue and rpc_killall_tasks.
Date: Fri, 8 Jul 2011 15:14:54 -0700
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430A198E69@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <4E177EA8.60109@candelatech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] sunrpc:  Fix race between work-queue and rpc_killall_tasks.
Thread-Index: Acw9ut45xzPs+rY1Sf2QieF6oMf+rAAABVeQ
References: <1309992581-25199-1-git-send-email-greearb@candelatech.com> <1309995932.5447.6.camel@lade.trondhjem.org> <4E173BE6.9000005@candelatech.com> <2E1EB2CF9ED1CB4AA966F0EB76EAB4430A198C7C@SACMVEXC2-PRD.hq.netapp.com> <4E177EA8.60109@candelatech.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Ben Greear" <greearb@candelatech.com>
Cc: <linux-nfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Jul 2011 22:14:56.0347 (UTC) FILETIME=[780262B0:01CC3DBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p68MF80p002353

> -----Original Message-----
> From: Ben Greear [mailto:greearb@candelatech.com]
> Sent: Friday, July 08, 2011 6:03 PM
> To: Myklebust, Trond
> Cc: linux-nfs@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [RFC] sunrpc: Fix race between work-queue and
> rpc_killall_tasks.
> 
> On 07/08/2011 11:11 AM, Myklebust, Trond wrote:
> >> -----Original Message-----
> >> From: Ben Greear [mailto:greearb@candelatech.com]
> >> Sent: Friday, July 08, 2011 1:19 PM
> >> To: Myklebust, Trond
> >> Cc: linux-nfs@vger.kernel.org; linux-kernel@vger.kernel.org
> >> Subject: Re: [RFC] sunrpc: Fix race between work-queue and
> >> rpc_killall_tasks.
> >>
> >> On 07/06/2011 04:45 PM, Trond Myklebust wrote:
> >>> On Wed, 2011-07-06 at 15:49 -0700, greearb@candelatech.com wrote:
> >>>> From: Ben Greear<greearb@candelatech.com>
> >>>>
> >>>> The rpc_killall_tasks logic is not locked against
> >>>> the work-queue thread, but it still directly modifies
> >>>> function pointers and data in the task objects.
> >>>>
> >>>> This patch changes the killall-tasks logic to set a flag
> >>>> that tells the work-queue thread to terminate the task
> >>>> instead of directly calling the terminate logic.
> >>>>
> >>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
> >>>> ---
> >>>>
> >>>> NOTE:  This needs review, as I am still struggling to understand
> >>>> the rpc code, and it's quite possible this patch either doesn't
> >>>> fully fix the problem or actually causes other issues.  That said,
> >>>> my nfs stress test seems to run a bit more stable with this patch
> >> applied.
> >>>
> >>> Yes, but I don't see why you are adding a new flag, nor do I see
> why
> >> we
> >>> want to keep checking for that flag in the rpc_execute() loop.
> >>> rpc_killall_tasks() is not a frequent operation that we want to
> >> optimise
> >>> for.
> >>>
> >>> How about the following instead?
> >>
> >> Ok, I looked at your patch closer.  I think it can still cause
> >> bad race conditions.
> >>
> >> For instance:
> >>
> >> Assume that tk_callback is NULL at beginning of while loop in
> >> __rpc_execute,
> >> and tk_action is rpc_exit_task.
> >>
> >> While do_action(task) is being called, tk_action is set to NULL in
> >> rpc_exit_task.
> >>
> >> But, right after tk_action is set to NULL in rpc_exit_task, the
> >> rpc_killall_tasks
> >> method calls rpc_exit, which sets tk_action back to rpc_exit_task.
> >>
> >> I believe this could cause the xprt_release(task) logic to be called
> in
> >> the
> >> work-queue's execution of rpc_exit_task due to tk_action != NULL
> when
> >> it should not be.
> >
> > Why would this be a problem? xprt_release() can certainly be called
> multiple times on an rpc_task. Ditto rpbc_getport_done.
> >
> > The only thing that is not re-entrant there is rpcb_map_release,
> which should only ever be called once whether or not something calls
> rpc_killall_tasks.
> 
> 
>  From the trace I posted, this stack trace below is being
> called with the void *data object already freed.
> 
> One way for this to happen would be to have rpc_exit_task call task-
> >tk_ops->rpc_call_done
> more than once (I believe).  Two calls to rpc_exit_task could do that,
> and since the
> rpc_exit_task method is assigned to tk_action, I *think* the race I
> mention above could cause
> rpc_exit_task to be called twice.
> 
>   [<ffffffff81105907>] print_trailer+0x131/0x13a
>   [<ffffffff81105945>] object_err+0x35/0x3e
>   [<ffffffff811077b3>] verify_mem_not_deleted+0x7a/0xb7
>   [<ffffffffa02891e5>] rpcb_getport_done+0x23/0x126 [sunrpc]
>   [<ffffffffa02810df>] rpc_exit_task+0x3f/0x6d [sunrpc]
>   [<ffffffffa02814d8>] __rpc_execute+0x80/0x253 [sunrpc]
>   [<ffffffffa02816ed>] ? rpc_execute+0x42/0x42 [sunrpc]
>   [<ffffffffa02816fd>] rpc_async_schedule+0x10/0x12 [sunrpc]
>   [<ffffffff81061343>] process_one_work+0x230/0x41d
>   [<ffffffff8106128e>] ? process_one_work+0x17b/0x41d
>   [<ffffffff8106379f>] worker_thread+0x133/0x217
>   [<ffffffff8106366c>] ? manage_workers+0x191/0x191
>   [<ffffffff81066f9c>] kthread+0x7d/0x85
>   [<ffffffff81485ee4>] kernel_thread_helper+0x4/0x10
>   [<ffffffff8147f0d8>] ? retint_restore_args+0x13/0x13
>   [<ffffffff81066f1f>] ? __init_kthread_worker+0x56/0x56
>   [<ffffffff81485ee0>] ? gs_change+0x13/0x13

The calldata gets freed in the rpc_final_put_task() which shouldn't ever be run while the task is still referenced in __rpc_execute

IOW: it should be impossible to call rpc_exit_task() after rpc_final_put_task
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
