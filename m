Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab2EWQqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:46:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54089 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2EWQqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:46:43 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205231029520.1566-100000@iolanthe.rowland.org>
References: <1337671292-15583-5-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1205231029520.1566-100000@iolanthe.rowland.org>
Date: Thu, 24 May 2012 00:46:42 +0800
X-Google-Sender-Auth: YuPEBmPQQ9ZjHsPVqQ-t1GbF-hQ
Message-ID: <CAF1ivSbUHpo-ia+xZY0EZ9vQ41f6NTN-Y-+FaO=AMom0t+Xkjw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/4] [SCSI] sd: change to auto suspend mode
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:43 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 22 May 2012, Lin Ming wrote:
>
>> Uses block layer runtime pm helper functions in scsi_runtime_suspend/resume.
>> Remove scsi_autopm_* from sd open/release/remove path.
>
> Sorry I didn't have time to get to this yesterday...
>
>> --- a/drivers/scsi/scsi_pm.c
>> +++ b/drivers/scsi/scsi_pm.c
>
>> @@ -171,9 +183,10 @@ static int scsi_runtime_idle(struct device *dev)
>>
>>       /* Insert hooks here for targets, hosts, and transport classes */
>>
>> -     if (scsi_is_sdev_device(dev))
>> -             err = pm_schedule_suspend(dev, 100);
>> -     else
>> +     if (scsi_is_sdev_device(dev)) {
>> +             pm_runtime_mark_last_busy(dev);
>> +             err = pm_request_autosuspend(dev);
>
> This really should be pm_runtime_autosuspend(dev).  In practice there's
> very little difference; it's mostly a matter of style.
>
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>
>> @@ -2631,7 +2624,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>>
>>       sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
>>                 sdp->removable ? "removable " : "");
>> -     scsi_autopm_put_device(sdp);
>> +     pm_runtime_put_sync_autosuspend(&sdp->sdev_gendev);
>
> This should be left the way it was.  scsi_autopm_put_device() does
> pm_runtime_put_sync(), which will call scsi_runtime_idle(), which will
> now call pm_runtime_autosuspend().
>
>>       put_device(&sdkp->dev);
>>  }
>>
>> @@ -2755,7 +2748,6 @@ static int sd_remove(struct device *dev)
>>       struct scsi_disk *sdkp;
>>
>>       sdkp = dev_get_drvdata(dev);
>> -     scsi_autopm_get_device(sdkp->device);
>
> This line should be kept as is.  The SCSI core uses the incremented
> usage count to prevent driverless devices from being runtime-suspended.

Will update.

Thanks a lot, Alan!

>
> Alan Stern
