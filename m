Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2AES67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2AES65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:58:57 -0500
Message-ID: <4F05F2EA.5030502@redhat.com>
Date: Thu, 05 Jan 2012 13:58:50 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/pciback: Support pci_reset_function,
 aka FLR or D3 support.
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>	 <1325724403-29642-3-git-send-email-konrad.wilk@oracle.com> <1325759051.25206.361.camel@zakaz.uk.xensource.com>
In-Reply-To: <1325759051.25206.361.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 05:24 AM, Ian Campbell wrote:
> On Thu, 2012-01-05 at 00:46 +0000, Konrad Rzeszutek Wilk wrote:
>> We use the __pci_reset_function_locked to perform the action.
>> Also on attaching ("bind") and detaching ("unbind") we save and
>> restore the configuration states. When the device is disconnected
>> from a guest we use the "pci_reset_function" to also reset the
>> device before being passed to another guest.
>
> Currently I thought the toolstack was supposed to do the reset (by
> writing to the reset node in sysfs) as it was (de)assigning devices
> to/from guests. That's not to say that there isn't an argument for
> preferring to do it kernels side but it would be interesting to make
> that argument explicitly.
>
> I guess the toolstack doesn't currently save/restore the configuration
> state, could it though? I guess the state is all available in sysfs. On
pci_reset_function() saves the config state before doing a fcn-level reset.

the libvirt toolstack handles the unbind/reset/bind functionality
and is used by kvm for it's device assignment.

> the other hand the kernel provides us with a very handy function which
> Just Does It...
>
> Ian.
>
>>
>> Signed-off-by: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
>> ---
>>   drivers/xen/xen-pciback/pci_stub.c |   41 +++++++++++++++++++++++++++++++++--
>>   drivers/xen/xen-pciback/pciback.h  |    1 +
>>   2 files changed, 39 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
>> index 8f06e1e..0ce0dc6 100644
>> --- a/drivers/xen/xen-pciback/pci_stub.c
>> +++ b/drivers/xen/xen-pciback/pci_stub.c
>> @@ -85,19 +85,34 @@ static struct pcistub_device *pcistub_device_alloc(struct pci_dev *dev)
>>   static void pcistub_device_release(struct kref *kref)
>>   {
>>   	struct pcistub_device *psdev;
>> +	struct xen_pcibk_dev_data *dev_data;
>>
>>   	psdev = container_of(kref, struct pcistub_device, kref);
>> +	dev_data = pci_get_drvdata(psdev->dev);
>>
>>   	dev_dbg(&psdev->dev->dev, "pcistub_device_release\n");
>>
>>   	xen_unregister_device_domain_owner(psdev->dev);
>>
>> -	/* Clean-up the device */
>> +	/* Call the reset function which does not take lock as this
>> +	 * is called from "unbind" which takes a device_lock mutex.
>> +	 */
>> +	__pci_reset_function_locked(psdev->dev);
>> +	if (pci_load_and_free_saved_state(psdev->dev,
>> +					&dev_data->pci_saved_state)) {
>> +		dev_dbg(&psdev->dev->dev, "Could not reload PCI state\n");
>> +	} else
>> +		pci_restore_state(psdev->dev);
>> +
>> +	/* Disable the device */
>>   	xen_pcibk_reset_device(psdev->dev);
>> +
>> +	kfree(dev_data);
>> +	pci_set_drvdata(psdev->dev, NULL);
>> +
>> +	/* Clean-up the device */
>>   	xen_pcibk_config_free_dyn_fields(psdev->dev);
>>   	xen_pcibk_config_free_dev(psdev->dev);
>> -	kfree(pci_get_drvdata(psdev->dev));
>> -	pci_set_drvdata(psdev->dev, NULL);
>>
>>   	pci_dev_put(psdev->dev);
>>
>> @@ -230,7 +245,17 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>>   	/* Cleanup our device
>>   	 * (so it's ready for the next domain)
>>   	 */
>> +
>> +	/* This is OK - we are running from workqueue context
>> +	 * and want to inhibit the user from fiddling with 'reset'
>> +	 */
>> +	pci_reset_function(dev);
>> +	pci_restore_state(psdev->dev);
>> +
>> +	/* This disables the device. */
>>   	xen_pcibk_reset_device(found_psdev->dev);
>> +
>> +	/* And cleanup up our emulated fields. */
>>   	xen_pcibk_config_free_dyn_fields(found_psdev->dev);
>>   	xen_pcibk_config_reset_dev(found_psdev->dev);
>>
>> @@ -325,6 +350,16 @@ static int __devinit pcistub_init_device(struct pci_dev *dev)
>>   	if (err)
>>   		goto config_release;
>>
>> +	dev_dbg(&dev->dev, "reseting (FLR, D3, etc) the device\n");
>> +	__pci_reset_function_locked(dev);
>> +
>> +	/* We need the device active to save the state. */
>> +	dev_dbg(&dev->dev, "save state of device\n");
>> +	pci_save_state(dev);
>> +	dev_data->pci_saved_state = pci_store_saved_state(dev);
>> +	if (!dev_data->pci_saved_state)
>> +		dev_err(&dev->dev, "Could not store PCI conf saved state!\n");
>> +
>>   	/* Now disable the device (this also ensures some private device
>>   	 * data is setup before we export)
>>   	 */
>> diff --git a/drivers/xen/xen-pciback/pciback.h b/drivers/xen/xen-pciback/pciback.h
>> index e9b4011..a7def01 100644
>> --- a/drivers/xen/xen-pciback/pciback.h
>> +++ b/drivers/xen/xen-pciback/pciback.h
>> @@ -41,6 +41,7 @@ struct xen_pcibk_device {
>>
>>   struct xen_pcibk_dev_data {
>>   	struct list_head config_fields;
>> +	struct pci_saved_state *pci_saved_state;
>>   	unsigned int permissive:1;
>>   	unsigned int warned_on_write:1;
>>   	unsigned int enable_intx:1;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

