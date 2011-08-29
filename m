Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1H2QHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:07:53 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:34301 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1H2QHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:07:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Greg Freemyer <greg.freemyer@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] [RFC 000/118] drbd: part 1 of adding multiple volume support to drbd
Date: Mon, 29 Aug 2011 18:07:43 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: drbd-dev@lists.linbit.com
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com> <201108291346.29847.philipp.reisner@linbit.com> <CAGpXXZK4wSCoVfyGpwt7ygN_8mqQ1cNzuVD4XsWXunJzUvEX+g@mail.gmail.com>
In-Reply-To: <CAGpXXZK4wSCoVfyGpwt7ygN_8mqQ1cNzuVD4XsWXunJzUvEX+g@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201108291807.43402.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. August 2011, 15:26:16 schrieb Greg Freemyer:
> On Mon, Aug 29, 2011 at 7:46 AM, Philipp Reisner
> 
> <philipp.reisner@linbit.com> wrote:
> > Am Freitag, 26. August 2011, 15:20:51 schrieb Greg Freemyer:
> >> On Thu, Aug 25, 2011 at 11:06 AM, Philipp Reisner <
> >> 
> >> philipp.reisner@linbit.com> wrote:
> >> > This the first request for review of drbd-8.4. The complete set has
> >> > 500 patches. In this first series there are only 118 of these.
> >> 
> >> Lars,
> >> 
> >> I've only taken a quick glance, but is drbd functional between applying
> >> each patch?
> >> 
> >> It doesn't look like it to me, but I didn't look that close.  I also saw
> >> at least one patch that introduced a new function with no caller to
> >> test it.
> >> 
> >> The idea is that a patch series leave a testable / functional kernel
> >> after each patch in the series is applied sequentially.
> >> 
> >> That is the only way git bisect can do its job.
> >> 
> >> ie. Introducing a new function but no new caller makes a change, but
> >> there is no way to test it.  Therefore there is no real value in not
> >> merging that patch with one that has the new call in it.
> > 
> > Greg,
> > 
> > You replied to mail 000. Please point out to which patch/function you
> > refer, so that we can fix this.
> > 
> > Best,
> >  Phil
> 
> Phillip,
> 
> Take a look at patch 115 of 118 in your series.  I did not review the
> whole series, I just poked around briefly and noticed this one.
> 
> Greg

Ok, I merged 115 into 117, that gives a new 116:

>From dbe9017ffee428c11cbbf4243fbcf9ed633d7b82 Mon Sep 17 00:00:00 2001
From: Philipp Reisner <philipp.reisner@linbit.com>
Date: Tue, 15 Feb 2011 11:09:33 +0100
Subject: [PATCH 116/117] drbd: implemented receiving of P_CONN_ST_CHG_REQ

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    1 +
 drivers/block/drbd/drbd_main.c     |   10 ++++++++++
 drivers/block/drbd/drbd_receiver.c |   10 ++++++++--
 drivers/block/drbd/drbd_state.h    |    1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 0cf5196..26ea665 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1219,6 +1219,7 @@ extern int drbd_send_ov_request(struct drbd_conf *mdev,sector_t 
sector,int size)
 extern int drbd_send_bitmap(struct drbd_conf *mdev);
 extern int _drbd_send_bitmap(struct drbd_conf *mdev);
 extern int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode);
+extern int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
 extern void drbd_mdev_cleanup(struct drbd_conf *mdev);
 void drbd_print_uuids(struct drbd_conf *mdev, const char *text);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index d8fd6dd..910dff7 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -990,6 +990,16 @@ int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv 
retcode)
        return drbd_send_cmd(mdev, USE_META_SOCKET, P_STATE_CHG_REPLY, &p.head, sizeof(p));
 }
 
+int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
+{
+       struct p_req_state_reply p;
+       enum drbd_packet cmd = tconn->agreed_pro_version < 100 ? P_STATE_CHG_REPLY : 
P_CONN_ST_CHG_REPLY;
+
+       p.retcode    = cpu_to_be32(retcode);
+
+       return conn_send_cmd(tconn, 0, USE_META_SOCKET, cmd, &p.head, sizeof(p));
+}
+
 int fill_bitmap_rle_bits(struct drbd_conf *mdev,
        struct p_compressed_bm *p,
        struct bm_xfer_ctx *c)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index bdd3f00..e346245 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3235,9 +3235,14 @@ static int receive_req_state(struct drbd_conf *mdev, enum 
drbd_packet cmd,
        mask = convert_state(mask);
        val = convert_state(val);
 
-       rv = drbd_change_state(mdev, CS_VERBOSE, mask, val);
+       if (cmd == P_CONN_ST_CHG_REQ) {
+               rv = conn_request_state(mdev->tconn, mask, val, CS_VERBOSE | 
CS_LOCAL_ONLY);
+               conn_send_sr_reply(mdev->tconn, rv);
+       } else {
+               rv = drbd_change_state(mdev, CS_VERBOSE, mask, val);
+               drbd_send_sr_reply(mdev, rv);
+       }
 
-       drbd_send_sr_reply(mdev, rv);
        drbd_md_sync(mdev);
 
        return true;
@@ -3771,6 +3776,7 @@ static struct data_cmd drbd_cmd_handler[] = {
        [P_CSUM_RS_REQUEST] = { 1, sizeof(struct p_block_req), receive_DataRequest },
        [P_DELAY_PROBE]     = { 0, sizeof(struct p_delay_probe93), receive_skip },
        [P_OUT_OF_SYNC]     = { 0, sizeof(struct p_block_desc), receive_out_of_sync },
+       [P_CONN_ST_CHG_REQ] = { 0, sizeof(struct p_req_state), receive_req_state },
        /* anything missing from this table is in
         * the asender_tbl, see get_asender_cmd */
        [P_MAX_CMD]         = { 0, 0, NULL },
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index d312d84..5fdbdf0 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -63,6 +63,7 @@ enum chg_state_flags {
        CS_SERIALIZE    = 8,
        CS_ORDERED      = CS_WAIT_COMPLETE + CS_SERIALIZE,
        CS_NO_CSTATE_CHG = 16, /* Do not display changes in cstate. Internal to 
drbd_state.c */
+       CS_LOCAL_ONLY = 32, /* Do not consider a device pair wide state change */
 };
 
 extern enum drbd_state_rv drbd_change_state(struct drbd_conf *mdev,
-- 
1.7.4.1

-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
