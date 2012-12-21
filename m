Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2LUVci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 16:32:38 -0500
Received: from void.printf.net ([89.145.121.20]:57009 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab2LUVcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 16:32:35 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: zhenpeng.qian@tieto.com, Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc:core:if detect mmc card remove,don't wait for req done
References: <034FBC2C8CCA484FBA5BA5FC707AC8303AD02F0D1E@EXMB02.eu.tieto.com>
	<CA+55aFxbE9G+2NdA_8s1vyjrkNE5mBdYZ5Cy9tYr4AJOdvdivg@mail.gmail.com>
Date: Fri, 21 Dec 2012 16:32:10 -0500
In-Reply-To: <CA+55aFxbE9G+2NdA_8s1vyjrkNE5mBdYZ5Cy9tYr4AJOdvdivg@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 20 Dec 2012 07:49:18 -0800")
Message-ID: <87r4mjay79.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 20 2012, Linus Torvalds wrote:
> On Thu, Dec 20, 2012 at 1:32 AM,  <zhenpeng.qian@tieto.com> wrote:
>>
>>         I find a bug about mmc/core/core.c, and send you a patch which I fix
>> this bug.
>>
>>         In fact, the bug is a low probability of occurrence.
>>
>>         Hope you help me to analyze it and discuss with me.
>
> I've added the proper people - Chris Ball and linux-mmc - to the
> participants list.
>
> I also wanted to check with you: the commit message implies that this
> can cause an IO timeout and then a call to
> msmsdcc_start_command_deferred() with a NULL cmd->mrq. Which I assume
> results in a NULL pointer dereference and Oops, but that wasn't
> spelled out.
>
> Chris, please give it a look, and perhaps edit the commit message a bit.

Thanks, I've queued the patch for 3.8.  I edited the commit message and
modified the patch: adding a check in the host driver to avoid any other
blind dereferences of cmd->mrq, and skipping the unnecessary assignment
to "err".  Here's the updated patch -- Qian, does it look okay to you?

- Chris.


From: Zhenpeng Qian <zhenpeng.qian@tieto.com>
Date: Thu, 20 Dec 2012 16:20:12 +0800
Subject: [PATCH] mmc: core: If card was removed, don't wait for request to
 finish.

mmc_wait_for_req() calls __mmc_start_req().  If __mmc_start_req() detects
that the card's been removed, it will return -ENOMEDIUM and not wait for
the request to be finished.  In this way, it can reduce io_schedule once.

And if io_schedule times out and mmc_card_remove() fails, it will call
host->ops->request (sometimes this occurs by insmod and rmmod fast), then
will get through to msmsdcc_start_command_deferred() finally.  cmd->mrq
will be NULL -- it's created in mmc_start_request() -- and a NULL deref
of cmd->mrq->stop will result.

This was seen in msm_sdcc.c, which dereferenced cmd->mrq blindly; also
add a check to that host driver to stop this happening again in other
potential cases.

10 [<c06e8458>] (__dabt_svc) from [<c04c8c2c>]
11 [<c04c8a44>] (msmsdcc_start_command_deferred) from [<c04c8c2c>]
12 [<c04c8c2c>] (msmsdcc_start_command) from [<c04d1428>]
13 [<c04d1428>] (msmsdcc_request) from [<c04b7c80>]
14 [<c04b7c80>] (mmc_wait_for_req_done) from [<c04b8630>]
15 [<c04b8630>] (mmc_wait_for_cmd) from [<c04c4980>]
16 [<c04c4980>] (get_card_status) from [<c04c5338>]
17 [<c04c5338>] (mmc_blk_err_check) from [<c04b8a78>]
18 [<c04b8a78>] (mmc_start_req) from [<c04c6020>]
19 [<c04c6020>] (mmc_blk_issue_rw_rq) from [<c04c6a1c>]
20 [<c04c6a1c>] (mmc_blk_issue_rq) from [<c04c6c7c>]
21 [<c04c6c7c>] (mmc_queue_thread) from [<c0091d54>]
22 [<c0091d54>] (kthread) from [<c000f028>]

Signed-off-by: Zhenpeng Qian <zhenpeng.qian@tieto.com>
[cjb: Rewrite commit message, add msm_sdcc.c test]
Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/core/core.c     |    5 +++--
 drivers/mmc/host/msm_sdcc.c |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index aaed768..87edbc0 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -470,8 +470,9 @@ EXPORT_SYMBOL(mmc_start_req);
  */
 void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq)
 {
-	__mmc_start_req(host, mrq);
-	mmc_wait_for_req_done(host, mrq);
+	/* If the card's been removed, don't wait for the request. */
+	if (!__mmc_start_req(host, mrq))
+		mmc_wait_for_req_done(host, mrq);
 }
 EXPORT_SYMBOL(mmc_wait_for_req);
 
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 7c0af0e..056ccd0 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -468,7 +468,7 @@ msmsdcc_start_command_deferred(struct msmsdcc_host *host,
 		host->prog_enable = true;
 	}
 
-	if (cmd == cmd->mrq->stop)
+	if (cmd->mrq && (cmd == cmd->mrq->stop))
 		*c |= MCI_CSPM_MCIABORT;
 
 	if (snoop_cccr_abort(cmd))
@@ -559,7 +559,7 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data,
 static void
 msmsdcc_start_command(struct msmsdcc_host *host, struct mmc_command *cmd, u32 c)
 {
-	if (cmd == cmd->mrq->stop)
+	if (cmd->mrq && (cmd == cmd->mrq->stop))
 		c |= MCI_CSPM_MCIABORT;
 
 	host->stats.cmds++;
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
