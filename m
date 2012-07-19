Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2GSND7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:03:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39585 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2GSND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:03:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120719125038.GC16291@mwanda>
References: <1342701001-5424-1-git-send-email-devendra.aaru@gmail.com>
	<20120719125038.GC16291@mwanda>
Date: Thu, 19 Jul 2012 18:33:56 +0530
Message-ID: <CAHdPZaPJKrm2MUjfk7Eo+fXfF6JJT7w++DAkMOPirz9bzZHD6w@mail.gmail.com>
Subject: Re: [PATCH] staging/sbe-2t3e3: error path cleanup in t3e3_init_channel
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, Jul 19, 2012 at 6:20 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Cleanup means there are no behavior changes.  This is a bug fix.
>
Thanks Dan, i will put a proper subject line in commit.
> On Thu, Jul 19, 2012 at 06:00:01PM +0530, Devendra Naga wrote:
>>     a) if alloc_hdlcdev fails, we are going into the free_regions,
>> and returning out the err (which is 0 by the prev call),
>>        return -ENOMEM if this function fail.
>>
>>     b) setup_device also can fail, as it calls around the register_hdlc_dev which
>> is again a macro of the register_netdev.
>>
>>        take the error from the setup_device and return it out in error condition
>>
>>     c) request_irq when fails, we are freeing requested mem regions and disabling
>> the pci device(?) and returning err which is agian 0 here.
>>
>>       take the error from request_irq and err path will take care of returning it.
>>
>> as if we return 0 , at the init function, t3e3_init_card, we have a success case
>> and if there are two channels we call this function again, having the result of
>> it completely unknown.
>>
>> This result in having the probe return 0, unloading the driver may (not) cause
>> ambigous result.
>
> These bugs were there before your patch, but we should also be doing
> an unregister_hdlc_device() and a free_netdev().
>
t3e3_remove_channel is called when channel init of channel2 fails, and
i think this cause the double
call to pci_release_region and pci_disable_device,

so i think its better to follow your approach and remove the call to
t3e3_remove_channel and clean all
the things we allocated at the init path itself, rather cleaning them
up when call and a subsequent call to the
t3e3_init_channel fails?

> regards,
> dan carpenter
>

Thanks,
Devendra
