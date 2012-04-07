Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2DGAHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:07:45 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54685 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2DGAHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:07:44 -0400
X-Nat-Received: from [202.181.97.72]:57321 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1333757211.8990
To: garlick@llnl.gov
Cc: levinsasha928@gmail.com, ericvh@gmail.com, oleg@redhat.com,
        eric.dumazet@gmail.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: ipv6: tunnel: hang when destroying ipv6 tunnel
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201204011221.GAG51016.JQFSFFOtLOMVHO@I-love.SAKURA.ne.jp>
	<CA+1xoqe+T=iUtUeFdeqmRvMZ7TMCgkLs_1QYv-4YNtn-jCoMCQ@mail.gmail.com>
	<201204052329.EBH52139.FFOLQMOJSVHOFt@I-love.SAKURA.ne.jp>
	<201204062044.EJE13062.OLMQtSVFHOFOJF@I-love.SAKURA.ne.jp>
	<20120406180905.GA10835@llnl.gov>
In-Reply-To: <20120406180905.GA10835@llnl.gov>
Message-Id: <201204070906.HHC13855.QOSFVOMtFFLJOH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 7 Apr 2012 09:06:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 06042012 #7641407, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Garlick wrote:
> > I think this loop is bad with regard to response to SIGKILL.
> > If wait_event_interruptible() was interrupted by SIGKILL, it will
> > spin until req->status >= REQ_STATUS_RCVD becomes true.
> > Rather,
> > 
> > 	if ((c->status == Connected) && (type == P9_TFLUSH))
> > 		err = wait_event_killable(*req->wq,
> > 					  req->status >= REQ_STATUS_RCVD);
> > 	else
> > 		err = wait_event_interruptible(*req->wq,
> > 					       req->status >= REQ_STATUS_RCVD);
> > 
> > would be safer.
> 
> Does that work?  What prevents p9_client_rpc() from recursing via
> p9_client_flush() on receipt of SIGKILL? 

Sorry, I'm not a 9p user and I can't test whether that works or not.
But at least, continuing the loop even after SIGKILL is not good.
If you have to wait for req->status >= REQ_STATUS_RCVD becomes true, can you
use a kernel thread that waits req->status >= REQ_STATUS_RCVD to become true
and delegate the job of notifying the server from a userspace task to the
kernel thread?

> Yes but in the unlikely event that this happens, the effect is a small
> memory leak for the duration of the mount.  On the other hand if the
> fid is destroyed without successfully informing the server, then
> subsequent operations that involve new file references will fail
> when that fid number is reused, and the mount becomes unusable.

I don't know whether Sasha's problem is caused by this patch or not.
But p9_client_clunk() is called from many functions in fs/9p/ directory.
They are assuming that p9_client_clunk() will call p9_fid_destroy() but
this patch is breaking that assumption. I think this is the cause of hang which
Sasha is experiencing because Sasha's trace shows that call_usermodehelper() is
blocked by functions in fs/9p/ directory. Seems inconsistency state problem.
