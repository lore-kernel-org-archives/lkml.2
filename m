Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031481Ab2K3SmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:42:18 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:60409 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab2K3SmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:42:17 -0500
MIME-Version: 1.0
In-Reply-To: <20121019125919.GC26830@phenom.dumpdata.com>
References: <507FD39F.4060601@citrix.com> <1350554618-14582-3-git-send-email-david.vrabel@citrix.com>
 <20121019125919.GC26830@phenom.dumpdata.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 Nov 2012 11:41:53 -0700
Message-ID: <CAErSpo6jBTGQYdPK==u7zjDuhV+U5iUfUp_KZnxkhvZCU4difQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] xen-pcifront: handle backend CLOSED without CLOSING
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 6:59 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Thu, Oct 18, 2012 at 11:03:36AM +0100, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> Backend drivers shouldn't transistion to CLOSED unless the frontend is
>> CLOSED.  If a backend does transition to CLOSED too soon then the
>> frontend may not see the CLOSING state and will not properly shutdown.
>>
>> So, treat an unexpected backend CLOSED state the same as CLOSING.
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>> Cc: linux-pci@vger.kernel.org
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>
> Bjorn, do you want me to prep a git pull with this patch
> or can I have your Ack to put it my tree and have it part of my
> git pull to Linus?

Sorry, I missed this.  I can put it in my -next branch for the v3.8
merge window.  Would that work for you?

>> ---
>>  drivers/pci/xen-pcifront.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
>> index 0aab85a..a0c7312 100644
>> --- a/drivers/pci/xen-pcifront.c
>> +++ b/drivers/pci/xen-pcifront.c
>> @@ -1068,13 +1068,16 @@ static void __init_refok pcifront_backend_changed(struct xenbus_device *xdev,
>>       case XenbusStateInitialising:
>>       case XenbusStateInitWait:
>>       case XenbusStateInitialised:
>> -     case XenbusStateClosed:
>>               break;
>>
>>       case XenbusStateConnected:
>>               pcifront_try_connect(pdev);
>>               break;
>>
>> +     case XenbusStateClosed:
>> +             if (xdev->state == XenbusStateClosed)
>> +                     break;
>> +             /* Missed the backend's CLOSING state -- fallthrough */
>>       case XenbusStateClosing:
>>               dev_warn(&xdev->dev, "backend going away!\n");
>>               pcifront_try_disconnect(pdev);
>> --
>> 1.7.2.5
