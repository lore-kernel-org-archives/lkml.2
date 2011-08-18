Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1HRJMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:12:38 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47344 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1HRJMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:12:33 -0400
X-Greylist: delayed 164037 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Aug 2011 05:12:32 EDT
Message-ID: <4E4CD737.4020402@ce.jp.nec.com>
Date: Thu, 18 Aug 2011 18:11:19 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Tejun Heo <tj@kernel.org>
CC: Alan Stern <stern@rowland.harvard.edu>, jaxboe@fusionio.com,
        roland@purestorage.com, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [BUG] Oops when SCSI device under multipath is removed
References: <Pine.LNX.4.44L0.1108111112280.1958-100000@iolanthe.rowland.org> <4E4A53F0.9040104@ce.jp.nec.com>
In-Reply-To: <4E4A53F0.9040104@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On 08/16/11 20:26, Jun'ichi Nomura wrote:
> The commit log of 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
> ("[SCSI] put stricter guards on queue dead checks") does not
> explain about the move of scsi_free_queue().
> 
> But according to the discussion below, it seems
> the move was motivated to solve the following self-deadlock:
> https://lkml.org/lkml/2011/4/12/9
> 
>   [in the context of kblockd_workqueue]
>   blk_delay_work
>     __blk_run_queue
>       scsi_request_fn
>         put_device
>           (puts final sdev refcount)
>              scsi_device_dev_release
>                execute_in_process_context(scsi_device_dev_release_usercontext)
>                  [execute immediately because it's in process context]
>                     scsi_device_dev_release_usercontext
>                       scsi_free_queue
>                         blk_cleanup_queue
>                           blk_sync_queue
>                             (wait for blk_delay_work to complete...)
> 
> James, is my understanding correct?
> 
> If so, isn't it possible to move the scsi_free_queue back to
> the original place and solve the deadlock instead by
> avoiding the wait in the same context?

Actually, Tejun has posted a patch to replace
execute_in_process_context() with queue_work()
and asking your review:

  [PATCH RESEND] scsi: don't use execute_in_process_context()
  https://lkml.org/lkml/2011/4/30/87

Do you think you can take the patch and revert the move
of scsi_free_queue()?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
