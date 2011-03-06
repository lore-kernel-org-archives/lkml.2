Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1CFWEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 17:04:11 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22327 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1CFWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 17:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=O2TiKoUIfnM9Z0nV75FjeX+fM1NG3WiTBzNBEmhpYQ1ahb/oat8Q1+fGTD4OF6nmgf
         i6DRjjWdJrr7RSu2zxOw==
Date: Sun, 6 Mar 2011 14:03:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: skip zombie in OOM-killer
In-Reply-To: <20110306193519.49DD.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1103061400170.23737@chino.kir.corp.google.com>
References: <1299286307-4386-1-git-send-email-avagin@openvz.org> <20110306193519.49DD.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011, KOSAKI Motohiro wrote:

> > When we check that task has flag TIF_MEMDIE, we forgot check that
> > it has mm. A task may be zombie and a parent may wait a memor.
> > 
> > v2: Check that task doesn't have mm one time and skip it immediately
> > 
> > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> 
> This seems incorrect. Do you have a reprodusable testcasae?
> Your patch only care thread group leader state, but current code
> care all thread in the process. Please look at oom_badness() and 
> find_lock_task_mm(). 
> 

That's all irrelevant, the test for TIF_MEMDIE specifically makes the oom 
killer a complete no-op when an eligible task is found to have been oom 
killed to prevent needlessly killing additional tasks.  oom_badness() and 
find_lock_task_mm() have nothing to do with that check to return 
ERR_PTR(-1UL) from select_bad_process().

Andrey is patching the case where an eligible TIF_MEMDIE process is found 
but it has already detached its ->mm.  In combination with the patch 
posted to linux-mm, oom: prevent unnecessary oom kills or kernel panics, 
which makes select_bad_process() iterate over all threads, it is an 
effective solution.

Thanks.
