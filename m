Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1EXRek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:34:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53238 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab1EXRei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FolSxiC6a9JfX7XzwWVbT4O9ItmvyhHqJSkeo7ID1kTCzoxn0E/b4OSixXUJDaWTUk
         85tBPNfO0x37gDiCaDwQ==
MIME-Version: 1.0
In-Reply-To: <1306207131-2296-2-git-send-email-namhyung@gmail.com>
References: <1306207131-2296-1-git-send-email-namhyung@gmail.com> <1306207131-2296-2-git-send-email-namhyung@gmail.com>
From: Justin TerAvest <teravest@google.com>
Date: Tue, 24 May 2011 10:34:16 -0700
Message-ID: <BANLkTi=kur2RMzUNC4V1R-R86qJZrk1n6Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] cfq-iosched: reduce bit operations in cfq_choose_req()
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why make this change? Are we that sensitive to the number of operations?

It makes the code a bit harder to read, I think.

On Mon, May 23, 2011 at 8:18 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> Reduce the number of bit operations in cfq_choose_req() on average
> (and worst) cases.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  block/cfq-iosched.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 151a050e692c..a79e62063144 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -665,15 +665,11 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
>        if (rq2 == NULL)
>                return rq1;
>
> -       if (rq_is_sync(rq1) && !rq_is_sync(rq2))
> -               return rq1;
> -       else if (rq_is_sync(rq2) && !rq_is_sync(rq1))
> -               return rq2;
> -       if ((rq1->cmd_flags & REQ_META) && !(rq2->cmd_flags & REQ_META))
> -               return rq1;
> -       else if ((rq2->cmd_flags & REQ_META) &&
> -                !(rq1->cmd_flags & REQ_META))
> -               return rq2;
> +       if (rq_is_sync(rq1) != rq_is_sync(rq2))
> +               return rq_is_sync(rq1) ? rq1 : rq2;
> +
> +       if ((rq1->cmd_flags ^ rq2->cmd_flags) & REQ_META)
> +               return rq1->cmd_flags & REQ_META ? rq1 : rq2;
>
>        s1 = blk_rq_pos(rq1);
>        s2 = blk_rq_pos(rq2);
> --
> 1.7.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
