Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab1LPA77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:59:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39282 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1LPA76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:59:58 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1112151821360.1644-100000@iolanthe.rowland.org>
References: <1323990310-11905-2-git-send-email-felipe.contreras@gmail.com>
	<Pine.LNX.4.44L0.1112151821360.1644-100000@iolanthe.rowland.org>
Date: Fri, 16 Dec 2011 02:59:57 +0200
Message-ID: <CAMP44s3eeTOBRiFwEL3FypDY_+-MReqYJJVO1URNrnFVFXzvDg@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: musb: fix pm_runtime mismatches
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 1:22 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 16 Dec 2011, Felipe Contreras wrote:
>
>> Properly call pm_runtime_put() afer pm_runttime_get() on errors.
>>
>> Untested.
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>  drivers/usb/musb/musb_gadget.c |    1 +
>>  drivers/usb/musb/omap2430.c    |    1 +
>>  2 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
>> index 922148f..95bfd2d 100644
>> --- a/drivers/usb/musb/musb_gadget.c
>> +++ b/drivers/usb/musb/musb_gadget.c
>> @@ -1960,6 +1960,7 @@ static int musb_gadget_start(struct usb_gadget *g,
>>  err2:
>>       if (!is_otg_enabled(musb))
>>               musb_stop(musb);
>> +     pm_runtime_put(musb->controller);
>>  err0:
>>       return retval;
>>  }
>> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
>> index ba85f27..4edfb91 100644
>> --- a/drivers/usb/musb/omap2430.c
>> +++ b/drivers/usb/musb/omap2430.c
>> @@ -385,6 +385,7 @@ static void omap2430_musb_disable(struct musb *musb)
>>
>>  static int omap2430_musb_exit(struct musb *musb)
>>  {
>> +     pm_runtime_put(musb->controller);
>>       del_timer_sync(&musb_idle_timer);
>>
>>       omap2430_low_level_exit(musb);
>
> Should these calls be pm_runtime_put_sync() instead of
> pm_runtime_put()?

I don't see why... The thing failed, it's not going to be used any
more so better let PM deactivate the device. But now that you point
this out, pm_runtime_put() on omap2430_musb_exit() should probably go
at the end of the function, after all the actions have been done.

I'll send an updated patch tomorrow, if there are no further comments.

Cheers.

-- 
Felipe Contreras
