Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2ITI1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:27:44 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38577 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2ITI1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:27:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pm@vger.kernel.org,
        linux-pci@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
	<1347872076-5260-2-git-send-email-ying.huang@intel.com>
	<CAErSpo5fVbN2vD5Omc7dGJFWUccYZoCOVRF4YmXPe2Oxm81u5g@mail.gmail.com>
	<877grpywhy.fsf@xmission.com> <1348129173.8212.218.camel@yhuang-dev>
Date: Thu, 20 Sep 2012 01:27:33 -0700
In-Reply-To: <1348129173.8212.218.camel@yhuang-dev> (Huang Ying's message of
	"Thu, 20 Sep 2012 16:19:33 +0800")
Message-ID: <87fw6dxfnu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Jw9YLj0s5pLBg2fTFVjaOGL5iViMxTRQ=
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
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Huang Ying <ying.huang@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC 1/3] PCI/PM: Fix kexec for D3cold and bridge suspending
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:

> On Thu, 2012-09-20 at 00:38 -0700, Eric W. Biederman wrote:
>> Bjorn Helgaas <bhelgaas@google.com> writes:
>> 
>> > +cc Eric and kexec list
>> >
>> > On Mon, Sep 17, 2012 at 2:54 AM, Huang Ying <ying.huang@intel.com> wrote:
>> >> If PCI devices are put into D3cold before kexec, because the
>> >> configuration registers of PCI devices in D3cold are not accessible.
>> >>
>> >> And if PCI bridges are put into low power state before kexec,
>> >> configuration registers of PCI devices underneath the PCI bridges are
>> >> not accessible too.
>> >>
>> >> These will make some PCI devices can not be scanned after kexec, so
>> >> resume the PCI devices in D3cold or PCI bridges in low power state
>> >> before kexec.
>> >
>> > Don't we need to resume the device even without the kexec issue?  And
>> > even if it's in D1 or D2?
>> 
>> The basic requirement is that the device needs to be visible so we can
>> auto discover it.  As I recall most sleep states don't make the device
>> invisible and we can handle the rest in the device initializatoin code.
>
> PCI devices in D3cold or under a bridge in D3hot will not be visible, so
> we must fix that for kexec to run properly.

That seems reasonable to me.

>> > It looks to me like pci_msi_shutdown() (and probably drv->shutdown())
>> > depend on the device being in D0.
>> 
>> There is certainly a depenency on the config registers being visible.
>> Although I don't know if much will go wrong if they aren't.
>> 
>> Ceratinly pci_msi_shutdown doesn't have anything to do if the device has
>> had so much power removed that the device is not even exectuing.
>
> Don't know which power state device should be in for pci_msi_shutdown
> etc.  But it appears that normal shutdown/reboot and kexec works at most
> times so far.  D3cold and bridge in D3hot works for normal
> shutdown/reboot, but not for kexec.  So I write some fix.

To be clear.  Has someone picked up this patch yet?

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

As for reboot it tends to always work because frequently the firmware
code triggers a soft reset of the entire machine, which puts devices in
their power on reset state, which is not a suspended state.  Although
that behavior is not required for a software reboot.

Eric



> Best Regards,
> Huang Ying
>
>> >> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> >> ---
>> >>  drivers/pci/pci-driver.c |    4 ++++
>> >>  1 file changed, 4 insertions(+)
>> >>
>> >> --- a/drivers/pci/pci-driver.c
>> >> +++ b/drivers/pci/pci-driver.c
>> >> @@ -421,6 +421,10 @@ static void pci_device_shutdown(struct d
>> >>         struct pci_dev *pci_dev = to_pci_dev(dev);
>> >>         struct pci_driver *drv = pci_dev->driver;
>> >>
>> >> +       /* Resume bridges and devices in D3cold for kexec to work properly */
>> >> +       if (pci_dev->current_state == PCI_D3cold || pci_dev->subordinate)
>> >> +               pm_runtime_resume(dev);
>> >> +
>> >>         if (drv && drv->shutdown)
>> >>                 drv->shutdown(pci_dev);
>> >>         pci_msi_shutdown(pci_dev);
>> >
>> > _______________________________________________
>> > kexec mailing list
>> > kexec@lists.infradead.org
>> > http://lists.infradead.org/mailman/listinfo/kexec
