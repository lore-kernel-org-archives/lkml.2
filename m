Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab1LTRbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:31:42 -0500
Received: from mga10.intel.com ([192.55.52.92]:9424 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258Ab1LTRbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:31:36 -0500
MIME-Version: 1.0
In-Reply-To: <1324396727-2840-1-git-send-email-tm@tao.ma>
References: <4EF0940D.7070304@kernel.dk>
	<1324396727-2840-1-git-send-email-tm@tao.ma>
Date: Tue, 20 Dec 2011 09:31:33 -0800
Message-ID: <CABE8wwtEn6D8HoW75iapv0BzfhepjQeTiW-5eMipPs-qrGu81w@mail.gmail.com>
Subject: Re: [PATCH] block: warn the wrong tag only if it is greater than real_max_depth.
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        Meelis Roos <mroos@ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding original bug reporters ]

On Tue, Dec 20, 2011 at 7:58 AM, Tao Ma <tm@tao.ma> wrote:
> From: Tao Ma <boyu.mt@taobao.com>
>
> In queue depth decreases, we could meet with a tag greater than max_depth,
> but it should never be greater than real_max_depth. So only WARN if
> it is greater than real_max_depth and let it complets if it is greater
> than max_depth.
>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  block/blk-tag.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/block/blk-tag.c b/block/blk-tag.c
> index e74d6d1..1c50d34 100644
> --- a/block/blk-tag.c
> +++ b/block/blk-tag.c
> @@ -286,12 +286,12 @@ void blk_queue_end_tag(struct request_queue *q, struct request *rq)
>
>        BUG_ON(tag == -1);
>
> -       if (unlikely(tag >= bqt->max_depth)) {
> +       if (unlikely(tag >= bqt->real_max_depth)) {
>                /*
> -                * This can happen after tag depth has been reduced.
> -                * But tag shouldn't be larger than real_max_depth.
> +                * tag shouldn't be larger than real_max_depth.
>                 */
> -               WARN_ON(tag >= bqt->real_max_depth);
> +               WARN(1, "tag %d, bqt->real_max_depth %d\n",
> +                    tag, bqt->real_max_depth);
>                return;
>        }

You can use the WARN macro in the if() statement, and maybe it should
only trigger once??

diff --git a/block/blk-tag.c b/block/blk-tag.c
index 918d82c..19cdde4 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -291,12 +291,13 @@ void blk_queue_end_tag(struct request_queue *q,
struct request *rq)

        BUG_ON(tag == -1);

-       if (unlikely(tag >= bqt->max_depth)) {
+       if (WARN_ONCE(tag >= bqt->real_max_depth,
+                     "%s: tag %d greater than tag map size: %d\n",
+                     __func__, tag, bqt->real_max_depth)) {
                /*
                 * This can happen after tag depth has been reduced.
                 * But tag shouldn't be larger than real_max_depth.
                 */
-               WARN_ON(tag >= bqt->real_max_depth);
                return;
        }
