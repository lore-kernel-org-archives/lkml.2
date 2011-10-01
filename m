Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1JAOCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 10:02:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44857 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1JAOCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 10:02:49 -0400
MIME-Version: 1.0
In-Reply-To: <20111001110357.GA10696@electric-eye.fr.zoreil.com>
References: <1317464057-18231-1-git-send-email-mark.einon@gmail.com>
 <1317464057-18231-4-git-send-email-mark.einon@gmail.com> <20111001110357.GA10696@electric-eye.fr.zoreil.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Sat, 1 Oct 2011 15:02:29 +0100
Message-ID: <CANK3SE3eHbBwzE5ZQJVoQEzw1QEE0bTp8Uf=CRpQEvNMiztPtg@mail.gmail.com>
Subject: Re: [PATCH 4/8] staging: et131x: Add pci suspend & resume functions
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 October 2011 12:03, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Mark Einon <mark.einon@gmail.com> :
>> Added basic suspend & resume functionality.
>> Tested on an et1310 device, and putting Fedora15 host in and out of
>> hibernation successfully.
---
>> +static int et131x_pci_resume(struct pci_dev *pdev)
>> +{
>> +     struct net_device *netdev = pci_get_drvdata(pdev);
>> +     int err = 0;
>> +
>> +     if (!netif_running(netdev))
>> +             return 0;
>> +
>> +     pci_set_power_state(pdev, PCI_D0);
>> +     pci_restore_state(pdev);
>> +
>> +     err = et131x_open(netdev);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "Can't resume interface!\n");
>> +             goto out;
>> +     }
>
> You can/should split et131x_{open/close} to remove this failure point.

Hi, thanks for the comments francois,
I'm not quite sure what you mean here. Can you expand on your comment please?

>
> [...]
>> @@ -884,8 +923,10 @@ static struct pci_driver et131x_driver = {
>>       .id_table       = et131x_pci_table,
>>       .probe          = et131x_pci_setup,
>>       .remove         = __devexit_p(et131x_pci_remove),
>> -     .suspend        = NULL,         /* et131x_pci_suspend */
>> -     .resume         = NULL,         /* et131x_pci_resume */
>> +#ifdef CONFIG_PM
>> +     .suspend        = et131x_pci_suspend,
>> +     .resume         = et131x_pci_resume,
>> +#endif
>
> There is not much driver specific there. It should probably go through
> pci_driver.driver.pm.

Ok, understood. I'll do this.

>
> --
> Ueimor
>
