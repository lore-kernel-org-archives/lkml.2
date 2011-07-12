Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1GLRZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:25:09 -0400
Received: from mx2.netapp.com ([216.240.18.37]:53809 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab1GLRZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:25:07 -0400
X-IronPort-AV: E=Sophos;i="4.65,521,1304319600"; 
   d="scan'208";a="562168731"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [RFC] sunrpc:  Fix race between work-queue and rpc_killall_tasks.
Date: Tue, 12 Jul 2011 10:25:02 -0700
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430A295494@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <4E1C8108.3020006@candelatech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] sunrpc:  Fix race between work-queue and rpc_killall_tasks.
Thread-Index: AcxAt1BZOY7QJsUdQPOnYNfXdpT0owAALvig
References: <1309992581-25199-1-git-send-email-greearb@candelatech.com> <1309995932.5447.6.camel@lade.trondhjem.org> <4E173BE6.9000005@candelatech.com> <2E1EB2CF9ED1CB4AA966F0EB76EAB4430A198C7C@SACMVEXC2-PRD.hq.netapp.com> <4E177EA8.60109@candelatech.com> <2E1EB2CF9ED1CB4AA966F0EB76EAB4430A198E69@SACMVEXC2-PRD.hq.netapp.com> <4E1C8108.3020006@candelatech.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Ben Greear" <greearb@candelatech.com>
Cc: <linux-nfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Jul 2011 17:25:05.0180 (UTC) FILETIME=[A3B7E5C0:01CC40B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p6CHPYpa016236

> -----Original Message-----
> From: Ben Greear [mailto:greearb@candelatech.com]
> Sent: Tuesday, July 12, 2011 1:15 PM
> To: Myklebust, Trond
> Cc: linux-nfs@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [RFC] sunrpc: Fix race between work-queue and
> rpc_killall_tasks.
> 
> On 07/08/2011 03:14 PM, Myklebust, Trond wrote:
> 
> >>    [<ffffffff81105907>] print_trailer+0x131/0x13a
> >>    [<ffffffff81105945>] object_err+0x35/0x3e
> >>    [<ffffffff811077b3>] verify_mem_not_deleted+0x7a/0xb7
> >>    [<ffffffffa02891e5>] rpcb_getport_done+0x23/0x126 [sunrpc]
> >>    [<ffffffffa02810df>] rpc_exit_task+0x3f/0x6d [sunrpc]
> >>    [<ffffffffa02814d8>] __rpc_execute+0x80/0x253 [sunrpc]
> >>    [<ffffffffa02816ed>] ? rpc_execute+0x42/0x42 [sunrpc]
> >>    [<ffffffffa02816fd>] rpc_async_schedule+0x10/0x12 [sunrpc]
> >>    [<ffffffff81061343>] process_one_work+0x230/0x41d
> >>    [<ffffffff8106128e>] ? process_one_work+0x17b/0x41d
> >>    [<ffffffff8106379f>] worker_thread+0x133/0x217
> >>    [<ffffffff8106366c>] ? manage_workers+0x191/0x191
> >>    [<ffffffff81066f9c>] kthread+0x7d/0x85
> >>    [<ffffffff81485ee4>] kernel_thread_helper+0x4/0x10
> >>    [<ffffffff8147f0d8>] ? retint_restore_args+0x13/0x13
> >>    [<ffffffff81066f1f>] ? __init_kthread_worker+0x56/0x56
> >>    [<ffffffff81485ee0>] ? gs_change+0x13/0x13
> >
> > The calldata gets freed in the rpc_final_put_task() which shouldn't
> ever be run while the task is still referenced in __rpc_execute
> >
> > IOW: it should be impossible to call rpc_exit_task() after
> rpc_final_put_task
> 
> I added lots of locking around the calldata, work-queue logic, and
> such, and
> still the problem persists w/out hitting any of the debug warnings or
> poisoned
> values I put in.  It almost seems like tk_calldata is just assigned to
> two
> different tasks.
> 
> While poking through the code, I noticed that 'map' is static in
> rpcb_getport_async.
> 
> That would seem to cause problems if two threads called this method at
> the same time, possibly causing tk_calldata to be assigned to two
> different
> tasks???
> 
> Any idea why it is static?

Doh! That is clearly a typo dating all the way back to when Chuck wrote that function.

Yes, that would definitely explain your problem.

Cheers
  Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
