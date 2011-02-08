Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1BHTse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:48:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1BHTsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:48:33 -0500
Date: Tue, 8 Feb 2011 14:48:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, ctalbott@google.com, mrubin@google.com,
        jmoyer@redhat.com, guijianfeng@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't wait if queue already has requests.
Message-ID: <20110208194826.GC29081@redhat.com>
References: <1297192697-29978-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297192697-29978-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:18:17AM -0800, Justin TerAvest wrote:
> Commit 7667aa0630407bc07dc38dcc79d29cc0a65553c1 added logic to wait for
> the last queue of the group to become busy (have at least one request),
> so that the group does not lose out for not being continuously
> backlogged. The commit did not check for the condition that the last
> queue already has some requests. As a result, if the queue already has
> requests, wait_busy is set. Later on, cfq_select_queue() checks the
> flag, and decides that since the queue has a request now and wait_busy
> is set, the queue is expired.  This results in early expiration of the
> queue.

Hi Justin,

wait_busy will be set only if slice has expired or about to be expired. So
even if we are setting wait_busy flag, it is not a huge deal even if
select_queue() expires it? Anyway queue has consumed or almost consumed
its allocated slice?

Having said that, it does not make sense to set wait_busy flag if
cfqq has requests. So I would be fine with the patch. I am just
curious that how did you see a difference in practice.

> 
> This patch fixes the problem by adding a check to see if queue already
> has requests. If it does, wait_busy is not set. As a result, time slices
> do not expire early.
> 
> The queues with more than one request are usually buffered writers.
> Testing shows improvement in isolation between buffered writers.

Upstream code puts all the buffered WRITES in root cgroup. So there
is no isolation between buffered WRITES?

Thanks
Vivek

> 
> Signed-off-by: Justin TerAvest <teravest@google.com>
> ---
>  block/cfq-iosched.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 501ffdf..5dcc353 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3432,6 +3432,10 @@ static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
>  	struct cfq_io_context *cic = cfqd->active_cic;
>  
> +	/* If the queue already has requests, don't wait */
> +	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
> +		return false;
> +
>  	/* If there are other queues in the group, don't wait */
>  	if (cfqq->cfqg->nr_cfqq > 1)
>  		return false;
> -- 
> 1.7.3.1
