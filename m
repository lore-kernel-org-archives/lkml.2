Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab0ESXvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 19:51:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40230 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab0ESXvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 19:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lkzc53A5WAlIwZ7isiJJeQWUVuGiUd0r5eTppLGh/73TmlOSjeP0GfZ0KEwHfE0JW8
         eWzUTtR9LAKx9RfW+6Js+ImtffbUG+VszBKs8FYXgNpDvUDbKCCsbfmVy7le8jIcJZ7t
         u77GGDxkreWnXyyN8ietQTCO8auy2OzXypwnA=
MIME-Version: 1.0
In-Reply-To: <20100519203336.GB3394@redhat.com>
References: <20100519203336.GB3394@redhat.com>
Date: Thu, 20 May 2010 01:51:49 +0200
Message-ID: <AANLkTimL7SjlZW5qxylc2MdygYugTFgDVdMM-N-E0tk0@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: Revert the logic of deep queues
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:33 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> o This patch basically reverts following commit.
>
>        76280af cfq-iosched: idling on deep seeky sync queues
>
> o Idling in CFQ is bad on high end storage. This is especially more true of
>  random reads. Idling works very well for SATA disks with single
>  spindle but harms a lot on powerful storage boxes.
>
>  So even if deep queues can be little unfair to other random workload with
>  shallow depths, treat deep queues as sync-noidle workload and not sync,
>  because with sync workload we dispatch IO from only one queue at a time
>  and idle and we don't drive enough queue depth to keep the array busy.

Maybe we should have a tunable for this behavior, like we have
group_isolation for groups? It seems the same trade off to me
(fairness vs. performance).
And we could let it default off (on NCQ disks), since I guess deep
seeky queues are more frequent on high end hardware than on our
desktops.
Note that on non-NCQ disks there is not only a fairness problem, but
also a latency problem by having those deep queues as noidle (so I
would say that non-NCQ disks should default to on, instead).

Thanks
Corrado
>
> o I am running aio-stress (random reads) as follows.
>
>  aio-stress -s 2g -O -t 4 -r 64k aio5 aio6 aio7 aio8 -o 3
>
>  Following are results with various combinations.
>
>  deadline:             232.94 MB/s
>
>  without patch
>  -------------
>  cfq default           75.32 MB/s
>  cfq, quantum=64       134.58 MB/s
>
>  with patch
>  ----------
>  cfq default           78.37 MB/s
>  cfq, quantum=64       213.94 MB
>
>  Note that with the patch applied, cfq really scales well if "quantum" is
>  increased and comes close to deadline performance.
>
> o Point being that on powerful arrays one queue is not sufficient to keep
>  array busy. This is already a bottleneck for sequential workloads. Lets
>  not aggravate the problem by marking random read queues as sync and
>  giving them exclusive access and hence effectively serializing the
>  access to array.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 5f127cf..3336bd7 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -313,7 +313,6 @@ enum cfqq_state_flags {
>        CFQ_CFQQ_FLAG_sync,             /* synchronous queue */
>        CFQ_CFQQ_FLAG_coop,             /* cfqq is shared */
>        CFQ_CFQQ_FLAG_split_coop,       /* shared cfqq will be splitted */
> -       CFQ_CFQQ_FLAG_deep,             /* sync cfqq experienced large depth */
>        CFQ_CFQQ_FLAG_wait_busy,        /* Waiting for next request */
>  };
>
> @@ -342,7 +341,6 @@ CFQ_CFQQ_FNS(slice_new);
>  CFQ_CFQQ_FNS(sync);
>  CFQ_CFQQ_FNS(coop);
>  CFQ_CFQQ_FNS(split_coop);
> -CFQ_CFQQ_FNS(deep);
>  CFQ_CFQQ_FNS(wait_busy);
>  #undef CFQ_CFQQ_FNS
>
> @@ -3036,11 +3034,8 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>
>        enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>
> -       if (cfqq->queued[0] + cfqq->queued[1] >= 4)
> -               cfq_mark_cfqq_deep(cfqq);
> -
>        if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -           (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
> +           CFQQ_SEEKY(cfqq))
>                enable_idle = 0;
>        else if (sample_valid(cic->ttime_samples)) {
>                if (cic->ttime_mean > cfqd->cfq_slice_idle)
> @@ -3593,11 +3588,6 @@ static void cfq_idle_slice_timer(unsigned long data)
>                 */
>                if (!RB_EMPTY_ROOT(&cfqq->sort_list))
>                        goto out_kick;
> -
> -               /*
> -                * Queue depth flag is reset only when the idle didn't succeed
> -                */
> -               cfq_clear_cfqq_deep(cfqq);
>        }
>  expire:
>        cfq_slice_expired(cfqd, timed_out);
> --
> 1.6.5.2
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
