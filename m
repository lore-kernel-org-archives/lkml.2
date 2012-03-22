Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2CVLuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:50:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56163 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2CVLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:50:06 -0400
X-Nat-Received: from [202.181.97.72]:59376 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1332416914.8445
To: bharrosh@panasas.com
Cc: akpm@linux-foundation.org, oleg@redhat.com, rjw@sisk.pl,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, Trond.Myklebust@netapp.com,
        sbhamare@panasas.com, dhowells@redhat.com, eparis@redhat.com,
        srivatsa.bhat@linux.vnet.ibm.com, kay.sievers@vrfy.org,
        jmorris@namei.org, ebiederm@xmission.com, gregkh@linuxfoundation.org,
        rusty@rustcorp.com.au, tj@kernel.org, rientjes@google.com
Subject: Re: [RFC 4/4] {RFC} kmod.c: Add new call_usermodehelper_timeout()API
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4F691059.30405@panasas.com>
	<4F691383.5040506@panasas.com>
	<4F6A92FC.6060702@panasas.com>
In-Reply-To: <4F6A92FC.6060702@panasas.com>
Message-Id: <201203222048.HDB56245.JFOMVHQFSOOtLF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 22 Mar 2012 20:48:31 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 22032012 #7374757, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> > @@ -452,22 +459,27 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
> >  
> >  	sub_info->complete = &done;
> >  	sub_info->wait = wait;
> > +	if (!sub_info->wait_timeout)
> > +		sub_info->wait_timeout = MAX_SCHEDULE_TIMEOUT;
> >  
> > +	/* Balanced in __call_usermodehelper or wait_for_helper */
> > +	kref_get(&sub_info->kref);
> >  	queue_work(khelper_wq, &sub_info->work);
> >  	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
> >  		goto unlock;
> > -	wait_for_completion(&done);
> > -	retval = sub_info->retval;
> > -
> > +	if (likely(wait_for_completion_timeout(&done, sub_info->wait_timeout)))
> > +		retval = sub_info->retval;
> > +	else
> > +		retval = -ETIMEDOUT;

This patch is incomplete because sub_info->complete refers on-stack variable.
Returning without waiting for completion will overwrite stack memory later.

> Anyway I thought that we are not
> suppose to use xhcg() since it is not portable to all ARCHs. ;-)

Don't worry. xchg() is used in many places. ;-)
http://tomoyo.sourceforge.jp/cgi-bin/lxr/ident?i=xchg

> But basically we both need support for the waiter to be returning before
> the child has completed.

I think basically we should not give up unless fatal events (e.g. SIGKILL or
TIF_MEMDIE) occur. Thus, I feel UMH_KILLABLE is sufficient.
