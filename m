Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2FTQr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:47:28 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41502 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2FTQr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:47:26 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206201046020.1804-100000@iolanthe.rowland.org>
References: <1340158627-7586-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.44L0.1206201046020.1804-100000@iolanthe.rowland.org>
Date: Wed, 20 Jun 2012 09:47:24 -0700
Message-ID: <CANFubx1PLcWaMca5Se0g3zKJxWxqmJj5x_Y6aoH4zgVtQ2OruQ@mail.gmail.com>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous suspend after abort
From: Mandeep Baines <mandeep.baines@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mandeep Singh Baines <msb@chromium.org>, linux-pm@vger.kernel.org,
        stable@kernel.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin Hilman <khilman@ti.com>, Colin Cross <ccross@android.com>,
        Sameer Nanda <snanda@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 7:58 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 19 Jun 2012, Mandeep Singh Baines wrote:
>
>> __device_suspend() must always send a completion. Otherwise, parent
>> devices will wait forever.
>>
>> Commit 1e2ef05b, "PM: Limit race conditions between runtime PM and
>> system sleep (v2)", introduced a regression by short-circuiting the
>> complete_all() for certain error cases.
>>
>> This patch fixes the bug by always signalling a completion.
>>
>> Addresses http://crosbug.com/31972
>>
>> Tested by injecting an abort via the following patch:
>>
>> diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
>> index a004db3..e5a6fce 100644
>> --- a/drivers/usb/core/hcd-pci.c
>> +++ b/drivers/usb/core/hcd-pci.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/pci.h>
>>  #include <linux/usb.h>
>>  #include <linux/usb/hcd.h>
>> +#include <linux/string.h>
>>
>>  #include <asm/io.h>
>>  #include <asm/irq.h>
>> @@ -477,6 +478,8 @@ static int resume_common(struct device *dev, int event)
>>
>>  static int hcd_pci_suspend(struct device *dev)
>>  {
>> +       if (!strcmp("0000:00:1d.3", dev_name(dev)))
>> +               return -EBUSY;
>>         return suspend_common(dev, device_may_wakeup(dev));
>>  }
>
> When you include one patch in front of another like this, doesn't it
> confuse the automatic tools?  You might end up getting both changes
> include in the final commit.  :-)
>

Ah. Good point. Removed the test code and re-sent.

>>  drivers/base/power/main.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
>> index e0fb5b0..9cb845e 100644
>> --- a/drivers/base/power/main.c
>> +++ b/drivers/base/power/main.c
>> @@ -1031,7 +1031,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>>       dpm_wait_for_children(dev, async);
>>
>>       if (async_error)
>> -             return 0;
>> +             goto Complete;
>>
>>       pm_runtime_get_noresume(dev);
>>       if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
>> @@ -1040,7 +1040,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>>       if (pm_wakeup_pending()) {
>>               pm_runtime_put_sync(dev);
>>               async_error = -EBUSY;
>> -             return 0;
>> +             goto Complete;
>>       }
>>
>>       device_lock(dev);
>> @@ -1097,6 +1097,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>>       }
>>
>>       device_unlock(dev);
>> +
>> + Complete:
>>       complete_all(&dev->power.completion);
>>
>>       if (error) {
>
> Otherwise this looks right to me.
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>
