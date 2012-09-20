Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2ITHit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:38:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58825 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2ITHir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:38:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-pm@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
	<1347872076-5260-2-git-send-email-ying.huang@intel.com>
	<CAErSpo5fVbN2vD5Omc7dGJFWUccYZoCOVRF4YmXPe2Oxm81u5g@mail.gmail.com>
Date: Thu, 20 Sep 2012 00:38:33 -0700
In-Reply-To: <CAErSpo5fVbN2vD5Omc7dGJFWUccYZoCOVRF4YmXPe2Oxm81u5g@mail.gmail.com>
	(Bjorn Helgaas's message of "Mon, 17 Sep 2012 14:54:16 -0600")
Message-ID: <877grpywhy.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+4S/W06aARsWl36j2Ib0hZgg66j6UfDQM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: infradead.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Bjorn Helgaas <bhelgaas@google.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC 1/3] PCI/PM: Fix kexec for D3cold and bridge suspending
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> +cc Eric and kexec list
>
> On Mon, Sep 17, 2012 at 2:54 AM, Huang Ying <ying.huang@intel.com> wrote:
>> If PCI devices are put into D3cold before kexec, because the
>> configuration registers of PCI devices in D3cold are not accessible.
>>
>> And if PCI bridges are put into low power state before kexec,
>> configuration registers of PCI devices underneath the PCI bridges are
>> not accessible too.
>>
>> These will make some PCI devices can not be scanned after kexec, so
>> resume the PCI devices in D3cold or PCI bridges in low power state
>> before kexec.
>
> Don't we need to resume the device even without the kexec issue?  And
> even if it's in D1 or D2?

The basic requirement is that the device needs to be visible so we can
auto discover it.  As I recall most sleep states don't make the device
invisible and we can handle the rest in the device initializatoin code.

> It looks to me like pci_msi_shutdown() (and probably drv->shutdown())
> depend on the device being in D0.

There is certainly a depenency on the config registers being visible.
Although I don't know if much will go wrong if they aren't.

Ceratinly pci_msi_shutdown doesn't have anything to do if the device has
had so much power removed that the device is not even exectuing.

Eric

>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> ---
>>  drivers/pci/pci-driver.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -421,6 +421,10 @@ static void pci_device_shutdown(struct d
>>         struct pci_dev *pci_dev = to_pci_dev(dev);
>>         struct pci_driver *drv = pci_dev->driver;
>>
>> +       /* Resume bridges and devices in D3cold for kexec to work properly */
>> +       if (pci_dev->current_state == PCI_D3cold || pci_dev->subordinate)
>> +               pm_runtime_resume(dev);
>> +
>>         if (drv && drv->shutdown)
>>                 drv->shutdown(pci_dev);
>>         pci_msi_shutdown(pci_dev);
>
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
