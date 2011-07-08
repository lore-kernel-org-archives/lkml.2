Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1GHSL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:11:57 -0400
Received: from mx2.netapp.com ([216.240.18.37]:62684 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab1GHSLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:11:55 -0400
X-IronPort-AV: E=Sophos;i="4.65,500,1304319600"; 
   d="scan'208";a="561355876"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [RFC] sunrpc:  Fix race between work-queue and rpc_killall_tasks.
Date: Fri, 8 Jul 2011 11:11:37 -0700
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430A198C7C@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <4E173BE6.9000005@candelatech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] sunrpc:  Fix race between work-queue and rpc_killall_tasks.
Thread-Index: Acw9kxtvn2CdythFTcizo1+h/f6scgABnnwQ
References: <1309992581-25199-1-git-send-email-greearb@candelatech.com> <1309995932.5447.6.camel@lade.trondhjem.org> <4E173BE6.9000005@candelatech.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Ben Greear" <greearb@candelatech.com>
Cc: <linux-nfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Jul 2011 18:11:40.0132 (UTC) FILETIME=[7BFCBA40:01CC3D9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p68ICBJV001731

> -----Original Message-----
> From: Ben Greear [mailto:greearb@candelatech.com]
> Sent: Friday, July 08, 2011 1:19 PM
> To: Myklebust, Trond
> Cc: linux-nfs@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [RFC] sunrpc: Fix race between work-queue and
> rpc_killall_tasks.
> 
> On 07/06/2011 04:45 PM, Trond Myklebust wrote:
> > On Wed, 2011-07-06 at 15:49 -0700, greearb@candelatech.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> The rpc_killall_tasks logic is not locked against
> >> the work-queue thread, but it still directly modifies
> >> function pointers and data in the task objects.
> >>
> >> This patch changes the killall-tasks logic to set a flag
> >> that tells the work-queue thread to terminate the task
> >> instead of directly calling the terminate logic.
> >>
> >> Signed-off-by: Ben Greear<greearb@candelatech.com>
> >> ---
> >>
> >> NOTE:  This needs review, as I am still struggling to understand
> >> the rpc code, and it's quite possible this patch either doesn't
> >> fully fix the problem or actually causes other issues.  That said,
> >> my nfs stress test seems to run a bit more stable with this patch
> applied.
> >
> > Yes, but I don't see why you are adding a new flag, nor do I see why
> we
> > want to keep checking for that flag in the rpc_execute() loop.
> > rpc_killall_tasks() is not a frequent operation that we want to
> optimise
> > for.
> >
> > How about the following instead?
> 
> Ok, I looked at your patch closer.  I think it can still cause
> bad race conditions.
> 
> For instance:
> 
> Assume that tk_callback is NULL at beginning of while loop in
> __rpc_execute,
> and tk_action is rpc_exit_task.
> 
> While do_action(task) is being called, tk_action is set to NULL in
> rpc_exit_task.
> 
> But, right after tk_action is set to NULL in rpc_exit_task, the
> rpc_killall_tasks
> method calls rpc_exit, which sets tk_action back to rpc_exit_task.
> 
> I believe this could cause the xprt_release(task) logic to be called in
> the
> work-queue's execution of rpc_exit_task due to tk_action != NULL when
> it should not be.

Why would this be a problem? xprt_release() can certainly be called multiple times on an rpc_task. Ditto rpbc_getport_done.

The only thing that is not re-entrant there is rpcb_map_release, which should only ever be called once whether or not something calls rpc_killall_tasks.

 
> I have no hard evidence this exact scenario is happening in my case,
> but I
> believe the code is still racy with your patch.
> 
> For that matter, is it safe to modify the flags in rpc_killall_tasks:
> 
> rovr->tk_flags |= RPC_TASK_KILLED;
> 
> Is that guaranteed to be atomic with any other modification of flags?

Task->tk_flags should never change after the rpc_task is set up. The only allowed change is the RPC_TASK_KILLED. We could convert that into an atomic bit in task->tk_runstate, but again, this isn't something that is likely to be responsible for the problem you are seeing.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
