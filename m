Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2KQAka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:40:30 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:33051 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab2KQAk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:40:28 -0500
Message-ID: <50A6DCF6.2030707@linux.vnet.ibm.com>
Date: Fri, 16 Nov 2012 18:40:22 -0600
From: Trey Ramsay <tramsay@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Rich Rattanni <rattanni@gmail.com>,
        Radovan Lekanovic <lekanovic@gmail.com>
Subject: Re: [PATCH 1/1] mmc: Bad device can cause mmc driver to hang
References: <87k3tpkz53.fsf@octavius.laptop.org> <1353079901-8773-1-git-send-email-tramsay@linux.vnet.ibm.com> <876255bluf.fsf@octavius.laptop.org>
In-Reply-To: <876255bluf.fsf@octavius.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111700-7408-0000-0000-00000A549D57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 09:37 AM, Chris Ball wrote:
> Hi Trey,
> 
> On Fri, Nov 16 2012, Trey Ramsay wrote:
>> There are infinite loops in the mmc code that can be caused by bad hardware.
>> The code will loop forever if the device never comes back from program mode,
>> R1_STATE_PRG, and it is not ready for data, R1_READY_FOR_DATA.
>>
>> A long timeout will be added to prevent the code from looping forever.
>> The timeout will occur if the device never comes back from program
>> state or the device never becomes ready for data.
>>
>> Signed-off-by: Trey Ramsay <tramsay@linux.vnet.ibm.com>
> 
> Thanks, looks good!
> 
> Have you thought about what's going to happen after this path is hit?
> Are we just going to start a new request that begins a new ten-minute
> hang, or do we notice the bad card state somewhere and refuse to start
> new I/O?
> 
> - Chris.
> 

You're welcome, and thanks for the help!

Good question.  In regards to the original problem were it was hung in
mmc_blk_err_check, the new code path will timeout after 10 minutes, log
an error, issue a hardware reset and abort the request. Is the hardware
reset enough or will that even work when the device isn't coming out of
program state? Should we try to refuse all new I/O?


Below are just some notes I took about the code path for
mmc_blk_err_check and mmc_do_erase.
=============================
mmc_blk_err_check
                        int err = get_card_status(card, &status, 5);
                        if (err) {
                                pr_err("%s: error %d requesting status\n",
                                       req->rq_disk->disk_name, err);
                                return MMC_BLK_CMD_ERR;
                        }
+
+                       /* Timeout if the device never becomes ready for
data
+                        * and never leaves the program state.
+                        */
+                       if (time_after(jiffies, timeout)) {
+                               pr_err("%s: Card stuck in programming
state!"\
+                                       " %s %s\n",
mmc_hostname(card->host),
+                                       req->rq_disk->disk_name, __func__);
+
+                               return MMC_BLK_CMD_ERR;
+                       }

Stack
-----------------
mmc_blk_err_check
mmc_start_req
mmc_blk_issue_rw_rq
mmc_blk_issue_rq
mmc_queue_thread

We return MMC_BLK_CMD_ERR the same way as we return MMC_BLK_CMD_ERR if
the get_card_status failed. The code which returns to mmc_start_req
which sets the error status and returns to mmc_blk_issue_rw_rq with a
status of MMC_BLK_CMD_ERR where it calls mmc_blk_reset which calls
mmc_hw_reset. The code then return so mmc_queue_thread which does not
check the return code.

=============================
mmc_do_erase
+
+               /* Timeout if the device never becomes ready for data and
+                * never leaves the program state.
+                */
+               if (time_after(jiffies, timeout)) {
+                       pr_err("%s: Card stuck in programming state! %s\n",
+                               mmc_hostname(card->host), __func__);
+                       err =  -EIO;
+                       goto out;
+               }
+

        err = mmc_erase(card, from, nr, arg);
out:
        if (err == -EIO && !mmc_blk_reset(md, card->host, type))
                goto retry;


The mmc_do_erase function is called by mmc_erase which is called from 3
locations in the block.c code.

    1) mmc_blk_issue_discard_rq--->mmc_erase--->mmc_do_erase    line 848
    2) mmc_blk_issue_secdiscard_rq--->mmc_erase--->mmc_do_erase line 884
    3) mmc_blk_issue_secdiscard_rq--->mmc_erase--->mmc_do_erase line 904

    This applies to 1, 2 and 3 above.
    Since we return -EIO, mmc_blk_issue_discard_rq or
    mmc_blk_issue_secdiscard will do a mmc_blk_reset which will call
    mmc_hw_reset. If hardware reset is successfull, it will retry the
    command.  If the hardware reset is unsuccessfull, it will call
    blk_end_request and will return 0 if there is
    an err and will return to the mmc_queue_thread function which does
    not check the return code.




