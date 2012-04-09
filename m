Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2DIMbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:31:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50308 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2DIMbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:31:02 -0400
Date: Mon, 9 Apr 2012 16:29:50 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] vmevent: Should not grab mutex in the atomic context
Message-ID: <20120409122950.GA21833@lizard>
References: <20120408233550.GA3791@panacea>
 <20120408233802.GA4839@panacea>
 <1333960831.3943.4.camel@jaguar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333960831.3943.4.camel@jaguar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 11:40:31AM +0300, Pekka Enberg wrote:
> On Mon, 2012-04-09 at 03:38 +0400, Anton Vorontsov wrote:
> > vmevent grabs a mutex in the atomic context, and so this pops up:
> > 
> > BUG: sleeping function called from invalid context at kernel/mutex.c:271
> > in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
[...]
> > This patch fixes the issue by removing the mutex and making the logic
> > lock-free.
> > 
> > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> 
> What guarantees that there's only one thread writing to struct
> vmevent_attr::value in vmevent_sample() now that the mutex is gone?

Well, it is called from the timer function, which has the same guaranties
as an interrupt handler: it can have only one execution thread (unlike
bare softirq handler), so we don't need to worry about racing w/
ourselves?

If you're concerned about several instances of timers accessing the 
same vmevent_watch, I don't really see how it is possible, as we
allocate vmevent_watch together w/ the timer instance in vmevent_fd(),
so there is always one timer per vmevent_watch.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
