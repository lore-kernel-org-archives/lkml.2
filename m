Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1KQVdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:33:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53219 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1KQVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:33:18 -0500
Date: Thu, 17 Nov 2011 13:33:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.2-rc3] cpusets: stall when updating mems_allowed
 for mempolicy or disjoint nodemask
In-Reply-To: <4EC4C603.8050704@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1111171328120.15918@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com> <4EC4C603.8050704@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Miao Xie wrote:

> Oh~, David
> 
> I find these is another problem, please take account of the following case:
> 
>   2-3 -> 1-2 -> 0-1
> 
> the user change mems_allowed twice continuously, the task may see the empty
> mems_allowed.
> 
> So, it is still dangerous.
> 

With this patch, we're protected by task_lock(tsk) to determine whether we 
want to take the exception, i.e. whether need_loop is false, and the 
setting of tsk->mems_allowed.  So this would see the nodemask change at 
the individual steps from 2-3 -> 1-2 -> 0-1, not some inconsistent state 
in between or directly from 2-3 -> 0-1.  The only time we don't hold 
task_lock(tsk) to change tsk->mems_allowed is when tsk == current and in 
that case we're not concerned about intermediate reads to its own nodemask 
while storing to a mask where MAX_NUMNODES > BITS_PER_LONG.

Thus, there's no problem here with regard to such behavior if we exclude 
mempolicies, which this patch does.
