Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab0ELGYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:24:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958Ab0ELGX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:23:59 -0400
Date: Tue, 11 May 2010 23:22:15 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       Paul Menage <menage@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] cpuset,mm: fix no node to alloc memory when
 changing cpuset's mems
Message-Id: <20100511232215.4c8b4318.akpm@linux-foundation.org>
In-Reply-To: <4BEA47CA.2020508@cn.fujitsu.com>
References: <4BDFFCCA.3020906@cn.fujitsu.com>
	<20100511184900.8211b6f9.akpm@linux-foundation.org>
	<4BEA47CA.2020508@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 14:16:42 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:

> >>  #include <linux/security.h>
> >>  #include <linux/cpu.h>
> >> +#include <linux/cpuset.h>
> >>  #include <linux/acct.h>
> >>  #include <linux/tsacct_kern.h>
> >>  #include <linux/file.h>
> >> @@ -1003,8 +1004,10 @@ NORET_TYPE void do_exit(long code)
> >>  
> >>  	exit_notify(tsk, group_dead);
> >>  #ifdef CONFIG_NUMA
> >> +	task_lock(tsk);
> >>  	mpol_put(tsk->mempolicy);
> >>  	tsk->mempolicy = NULL;
> >> +	task_unlock(tsk);
> >>  #endif
> >>  #ifdef CONFIG_FUTEX
> >>  	if (unlikely(current->pi_state_cache))
> > 
> > Given that this function is already holding task_lock(tsk), this
> > didn't work very well.
> 
> Sorry for replying late.
> 
> Thanks for your patch that removes task_lock(tsk).
> 
> I made this patch against the mainline tree, and do_exit() in the mainline tree
> doesn't hold task_lock(tsk), so I took task_lock(tsk). But I didn't take notice
> that do_exit() in the mmotm tree had been changed, and I made this mistake.

Ah, hang on.  Yes, I had to manually fix that a lot of times.  The code
you were patching has moved from do_exit() over to exit_mm().  AFACIT
my change is still OK though.  Please carefully review latest -mm?


