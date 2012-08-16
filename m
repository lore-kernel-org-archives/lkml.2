Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2HPQ2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:28:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61577 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846Ab2HPQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:28:44 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hans de Goede <hdegoede@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
References: <Pine.LNX.4.44L0.1208161106350.24305-100000@netrider.rowland.org>
Date: Thu, 16 Aug 2012 18:29:45 +0200
In-Reply-To: <Pine.LNX.4.44L0.1208161106350.24305-100000@netrider.rowland.org>
	(Alan Stern's message of "Thu, 16 Aug 2012 11:13:33 -0400 (EDT)")
Message-ID: <87obmals06.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Thu, 16 Aug 2012, Hans de Goede wrote:
>
>> Ah right, these are bus_driver operations. That explains some things, so I've
>> done some more research asking myself: "Why does generic_ide_suspend(), which
>> is a *bus* op, call dev_get_drvdata?", the answer to that seems to be that
>> the ide subsystem is abusing (IMHO) drvdata to store per device bus_driver
>> data. Which I believe is not how drvdata is intended to be used.
>> 
>> With that said, the above knowledge has allowed me to write an (ugly) fix for
>> the regression Miklos is seeing. Miklos can you give the attached patch a
>> try please?
>> 
>> > It clearly should check if drive is not NULL before using that pointer.
>> 
>> I assume you mean drive*r*, yes I agree that generic_ide_remove should
>> check for that. So who is going to write a patch for that?
>
> The existing code could certainly be improved.  Your patch does:
>
>> +               /*
>> +                * device_register() will have cleared drvdata on
>> +                * device_attach failure, but we use drvdata to store per
>> +                * device bus info, rather then for driver info, so restore it.
>> +                */
>> +               dev_set_drvdata(dev, drive);
>
> But at this point, dev is defined by:
>
> 		struct device *dev = &drive->gendev;
>
> So why bother setting anything?  It seems to me that 
> generic_ide_suspend() and generic_ide_resume() could easily replace
>
> 	ide_drive_t *drive = dev_get_drvdata(dev);
>
> with
>
> 	ide_drive_t *drive = dev_to_ide_drive(dev);
>
> where dev_to_ide_drive is defined as "container_of(dev, ide_drive_t,
> gendev)" (if this isn't defined already).

Yes, this appears to work.  Following patch fixes the suspend oops.

Thanks,
Miklos

---
 drivers/ide/ide-pm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 9240609..8d1e32d 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -4,7 +4,7 @@
 
 int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
-	ide_drive_t *drive = dev_get_drvdata(dev);
+	ide_drive_t *drive = to_ide_device(dev);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
@@ -40,7 +40,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 
 int generic_ide_resume(struct device *dev)
 {
-	ide_drive_t *drive = dev_get_drvdata(dev);
+	ide_drive_t *drive = to_ide_device(dev);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
-- 
1.7.7

