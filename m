Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1I0Re1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1I0Re0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:34:26 -0400
Date: Tue, 27 Sep 2011 13:34:13 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "gong.chen@intel.com" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Message-ID: <20110927173413.GJ5795@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 01:14:59PM -0400, Seiji Aguchi wrote:
> Hi,
> 
> [Problem]
> Currently, pstore takes spin_trylock(&psinfo->buf_lock) in NMI context.
> And it takes spin_lock(&psinfo->buf_lock) in other cases.
> 
> If there are some bugs in pstore and kernel panics, spin_lock(&psinfo->buf_lock) causes deadlock 
> and panic_notifier_chain will not work.

Ok, so I missed your 'return' first time through and originally had a
bunch of comments.  So I would suggest adding a comment explaining why we
are returning in that failure.

Personally, I am not sure we want to abort here at the pstore layer, it
should probably be aborted lower.  There isn't any reason why we can't
continue from a pstore perspective (we can just bust the spinlock).

>From an ERST perspective, the state machine might be screwed up, hence
aborting in that layer could make sense.  But I don't think I agree with
the 'return' statement.

So I am opposed to it for now.

Cheers,
Don


> 
> [Patch Description]
> For solving this problem, this patch replaces spin_lock with spin_trylock_irqsave in panic path.
> 
> Dead lock in panic path will not happen by applying this patch.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> 
> ---
>  fs/pstore/platform.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 0472924..9882892 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -97,12 +97,15 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>  	else
>  		why = "Unknown";
>  
> -	if (in_nmi()) {
> -		is_locked = spin_trylock(&psinfo->buf_lock);
> -		if (!is_locked)
> -			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
> +	if (reason == KMSG_DUMP_PANIC) {
> +		is_locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
> +		if (!is_locked) {
> +			pr_err("pstore dump routine skipped in panic path\n");
> +			return;
> +		}
>  	} else
>  		spin_lock_irqsave(&psinfo->buf_lock, flags);
> +
>  	oopscount++;
>  	while (total < kmsg_bytes) {
>  		dst = psinfo->buf;
> @@ -131,11 +134,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>  		total += l1_cpy + l2_cpy;
>  		part++;
>  	}
> -	if (in_nmi()) {
> -		if (is_locked)
> -			spin_unlock(&psinfo->buf_lock);
> -	} else
> -		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> +	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
>  }
>  
>  static struct kmsg_dumper pstore_dumper = {
> --
> 1.7.1
> 
