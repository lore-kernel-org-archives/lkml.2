Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0HXK3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:29:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:51464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab0HXK3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:29:11 -0400
Message-ID: <4C739DC6.1040309@kernel.org>
Date: Tue, 24 Aug 2010 12:24:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue destruction BUG_ON
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282640156.3695.5.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 10:29:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/24/2010 10:55 AM, Johannes Berg wrote:
> In our testing with iwlwifi, we keep running into this BUG_ON:
> 
> 	BUG_ON(cwq->nr_active);
> 
> in destroy_workqueue(). This is quite unhelpful, and since the code
> flushes the workqueue I really don't see how this could be happening,
> unless maybe there's cross-talk between this and other workqueues?

Flushing the workqueue doesn't guarantee that the workqueue stays
empty.  It just flushes the currently pending works.  If there are
requeueing works or something else is queueing new works, workqueue
won't be empty.  The check is new.  Previously, workqueue code didn't
check whether the workqueue is actually empty.  Now that the worklist
is shared, we need such check in place.  There was also a similar
report on ath9k.  I think it's most likely that something is queueing
works on a dying wokrqueue in the wireless common code.  I'll prep a
debug patch to print out some details.

Thanks.

-- 
tejun
