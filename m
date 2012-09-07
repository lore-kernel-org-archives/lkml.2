Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2IGTiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:38:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2IGTh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:37:59 -0400
Date: Fri, 7 Sep 2012 12:37:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11 V5] workqueue: Add @bind arguement back without
 change any thing
Message-ID: <20120907193754.GG9426@google.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
 <1346841475-4422-6-git-send-email-laijs@cn.fujitsu.com>
 <20120905194908.GC13737@google.com>
 <5047F686.5010207@cn.fujitsu.com>
 <20120906165145.GE29092@google.com>
 <504957EC.60305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504957EC.60305@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Fri, Sep 07, 2012 at 10:11:56AM +0800, Lai Jiangshan wrote:
> When I read "gcwq->flags & GCWQ_DISASSOCIATED" in create_worker, I
> thought: WTF, gcwq->flags can be change by other, is it
> correct?. When I saw the comments claim it is correct, I have to use
> about 30 mins to check whether it is correct in several places of
> code in workqueue.c(include check does flags has internal state in
> all gcwq->lock).  I'm not good on it, but I think there are some
> reviewers will be confused like me.

The head-scratchy part there is not where it's tested - under
manager_mutex or gcwq->lock.  It's that DISASSOCIATED has an
additional locking restriction while still living in gcwq->flags.
Simply moving DISASSOCIATED test inside gcwq->lock doesn't change
anything including readability.  You still have to verify the flag
changes according to the said locking requirement.

Separating DISASSOCIATED into a separate variable could help it but I
really don't see much point in doing that.  I don't know why it took
you 30 minutes to figure out when it's clearly stated in the constant
definition and there are only two places which modify the flag - one
setting and the other clearing.  Were you worrying about the flag
flipping while other bits are modified?  But even then, there's only
one other flag - GCWQ_FREEZING which again is set and cleared once in
the whole code.

So, either you were hopelessly confused for some reason or I'm missing
something.  If the latter, please enlighten me; otherwise, I actually
like putting the test outside gcwq->lock.  That makes it explicit that
the flag shouldn't be changing outside manager_mutex, which is the
necessary locking requirement.

Thanks.

-- 
tejun
