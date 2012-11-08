Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2KHJ5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:57:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57133 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab2KHJ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:57:17 -0500
MIME-Version: 1.0
In-Reply-To: <1352373280.15558.1615.camel@cliu38-desktop-build>
References: <1352306744.15558.1608.camel@cliu38-desktop-build>
	<1352373280.15558.1615.camel@cliu38-desktop-build>
Date: Thu, 8 Nov 2012 17:57:15 +0800
Message-ID: <CACVXFVM-NB0CvihhVMf3ravop2CQNApzrD0uZ9OwQCV0WQzYBA@mail.gmail.com>
Subject: Re: [PATCH V3] firmware loader: Fix the race FW_STATUS_DONE is
 followed by class_timeout
From: Ming Lei <ming.lei@canonical.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 7:14 PM, Chuansheng Liu <chuansheng.liu@intel.com> wrote:
>
> There is a race as below when calling request_firmware():
> CPU1                                   CPU2
> write 0 > loading
> mutex_lock(&fw_lock)
> ...
> set_bit FW_STATUS_DONE                 class_timeout is coming
>                                        set_bit FW_STATUS_ABORT
> complete_all &completion
> ...
> mutex_unlock(&fw_lock)
>
> In this time, the bit FW_STATUS_DONE and FW_STATUS_ABORT are set,
> and request_firmware() will return failure due to condition in
> _request_firmware_load():
>         if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
>                 retval = -ENOENT;
>
> But from the above scenerio, it should be a successful requesting.
> So we need judge if the bit FW_STATUS_DONE is already set before
> calling fw_load_abort() in timeout function.
>
> As Ming's proposal, we need change the timer into sched_work to
> benefit from using &fw_lock mutex also.
>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

Acked-by: Ming Lei <ming.lei@canonical.com>

Thanks,
--
Ming Lei
