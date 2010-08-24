Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0HXNUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:20:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:46873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab0HXNUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:20:33 -0400
Message-ID: <4C73C5EE.2060501@kernel.org>
Date: Tue, 24 Aug 2010 15:15:26 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue destruction BUG_ON
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>	 <4C739DC6.1040309@kernel.org>	 <1282646268.3695.9.camel@jlt3.sipsolutions.net>	 <4C73BC96.6000003@kernel.org>	 <1282655414.3695.25.camel@jlt3.sipsolutions.net>	 <4C73C425.20503@kernel.org> <1282655865.3695.27.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282655865.3695.27.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 13:20:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/24/2010 03:17 PM, Johannes Berg wrote:
> On Tue, 2010-08-24 at 15:07 +0200, Tejun Heo wrote:
> 
>>> [  500.874185] ------------[ cut here ]------------
>>> [  500.875212] kernel BUG at kernel/workqueue.c:2849!
>>
>> Are you sure you're running the patched kernel?  With the patch
>> applied, the BUG_ON() wouldn't be on line 2849 (on both rc1 and 2).
> 
> Yes:
> 
> void destroy_workqueue(struct workqueue_struct *wq)
> {
>         unsigned int cpu;
>    
>         wq->flags |= WQ_DYING;
>         flush_workqueue(wq);
>   
>         /*
>          * wq list is used to freeze wq, remove from list after
>          * flushing is complete in case freeze races us.
>          */
>         spin_lock(&workqueue_lock);
>         list_del(&wq->list);
>         spin_unlock(&workqueue_lock);
> 
>         /* sanity check */
>         for_each_cwq_cpu(cpu, wq) {
>                 struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
>                 int i;
> 
>                 for (i = 0; i < WORK_NR_COLORS; i++)
>                         BUG_ON(cwq->nr_in_flight[i]);
> 2849:           BUG_ON(cwq->nr_active);
>                 BUG_ON(!list_empty(&cwq->delayed_works));
> 
> 
> Applying the patch reported some offset, but the kernel is just rc1 +
> wireless stuff.

I see, thanks for verifying.  I probably got confused about the line
number.  Hmm... weird.  I'll prep further debug patch but can you
please tell me what you did to trigger the bug?

Thanks.

-- 
tejun
