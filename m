Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1HPLin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 07:38:43 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:58882 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1HPLij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 07:38:39 -0400
Message-ID: <4E4A53F0.9040104@ce.jp.nec.com>
Date: Tue, 16 Aug 2011 20:26:40 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, roland@purestorage.com, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
References: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/12/11 00:16, Alan Stern wrote:
> On Thu, 11 Aug 2011, James Bottomley wrote:
>> However, much as I'd like to accept this rosy view, the original oops
>> that started all of this in 2.6.38 was someone caught something with a
>> reference to a SCSI queue after the device release function had been
>> called.
> 
> Not according to your commit log.  You wrote that the reference was
> taken after scsi_remove_device() had been called -- but the device
> release function is scsi_device_dev_release_usercontext().

The commit log of 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
("[SCSI] put stricter guards on queue dead checks") does not
explain about the move of scsi_free_queue().

But according to the discussion below, it seems
the move was motivated to solve the following self-deadlock:
https://lkml.org/lkml/2011/4/12/9

  [in the context of kblockd_workqueue]
  blk_delay_work
    __blk_run_queue
      scsi_request_fn
        put_device
          (puts final sdev refcount)
             scsi_device_dev_release
               execute_in_process_context(scsi_device_dev_release_usercontext)
                 [execute immediately because it's in process context]
                    scsi_device_dev_release_usercontext
                      scsi_free_queue
                        blk_cleanup_queue
                          blk_sync_queue
                            (wait for blk_delay_work to complete...)

James, is my understanding correct?

If so, isn't it possible to move the scsi_free_queue back to
the original place and solve the deadlock instead by
avoiding the wait in the same context?

@@ -338,8 +339,8 @@ static void scsi_device_dev_release_user
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	execute_in_process_context(scsi_device_dev_release_usercontext,
-				   &sdp->ew);
+	INIT_WORK(&sdp->ew.work, scsi_device_dev_release_usercontext);
+	schedule_work(&sdp->ew.work);
 }
 
 static struct class sdev_class = {

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
