Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0HEF0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:26:52 -0400
Received: from mail.pod.cz ([213.155.227.146]:37735 "EHLO mail.pod.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab0HEF0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:26:50 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 01:26:49 EDT
Date: Thu, 5 Aug 2010 07:19:29 +0200
From: Vitezslav Samel <vitezslav@samel.cz>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Subject: Re: [PATCHv3 03/16] pps: fix race in PPS_FETCH handler
Message-ID: <20100805051929.GA14413@pc11.op.pod.cz>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Rodolfo Giometti <giometti@enneenne.com>,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Joonwoo Park <joonwpark81@gmail.com>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
 <033148d225d9e4929fcc02ed8de0fcfa3637cffe.1280952801.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033148d225d9e4929fcc02ed8de0fcfa3637cffe.1280952801.git.lasaine@lvk.cs.msu.su>
User-Agent: Mutt/1.5.20 (2009-08-27)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 01:06:40AM +0400, Alexander Gordeev wrote:
> There was a race in PPS_FETCH ioctl handler when several processes want
> to obtain PPS data simultaneously using sleeping PPS_FETCH. They all
> sleep most of the time in the system call.
> With the old approach when the first process waiting on the pps queue
> is waken up it makes new system call right away and zeroes pps->go. So
> other processes continue to sleep. This is a clear race condition
> because of the global 'go' variable.
> With the new approach pps->last_ev holds some value increasing at each
> PPS event. PPS_FETCH ioctl handler saves current value to the local
> variable at the very beginning so it can safely check that there is a
> new event by just comparing both variables.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/pps/kapi.c         |    4 ++--
>  drivers/pps/pps.c          |   10 +++++++---
>  include/linux/pps_kernel.h |    2 +-
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> index 55f3961..3f89f5e 100644
> --- a/drivers/pps/kapi.c
> +++ b/drivers/pps/kapi.c
> @@ -326,8 +326,8 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
>  
>  	/* Wake up if captured something */
>  	if (captured) {
> -		pps->go = ~0;
> -		wake_up_interruptible(&pps->queue);
> +		pps->last_ev++;
> +		wake_up_interruptible_all(&pps->queue);

  What happens if pps->last_ev overflows? Seems to me it would freeze
pps.

	Cheers,
		Vita
