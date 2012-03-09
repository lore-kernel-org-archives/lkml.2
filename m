Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2CIHGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:06:13 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38497 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2CIHGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:06:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6jqr44JS4Cyfc0cR_TNbo_ETjPJUO=x2gj-Q_x4TckVA@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-8-git-send-email-yinghai@kernel.org>
	<CAErSpo6jqr44JS4Cyfc0cR_TNbo_ETjPJUO=x2gj-Q_x4TckVA@mail.gmail.com>
Date: Thu, 8 Mar 2012 23:06:10 -0800
X-Google-Sender-Auth: Dl4m-l0WlDTUOfiv2f4Sw1FwGH4
Message-ID: <CAE9FiQWPk-s5F5ofO=nU05tnRhmpav+f8Cs_mBG9A-MPuK9stw@mail.gmail.com>
Subject: Re: [PATCH 07/23] pci, dmar: Update dmar units devices list during hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 5:06 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> When do pci remove/rescan on system that have more iommus, got
>>
>> [  894.089745] Set context mapping for c4:00.0
>> [  894.110890] mpt2sas3: Allocated physical memory: size(4293 kB)
>> [  894.112556] mpt2sas3: Current Controller Queue Depth(1883), Max Controller Queue Depth(2144)
>> [  894.127278] mpt2sas3: Scatter Gather Elements per IO(128)
>> [  894.361295] DRHD: handling fault status reg 2
>> [  894.364053] DMAR:[DMA Read] Request device [c4:00.0] fault addr fffbe000
>> [  894.364056] DMAR:[fault reason 02] Present bit in context entry is cl
>>
>> it turns out when remove/rescan, pci dev will be freed and will get another new dev.
>> but drhd units still keep old one... so dmar_find_matched_drhd_unit will
>> return wrong drhd and iommu for the device that is not on first iommu.
>>
>> So need to update devices in drhd_units during pci remove/rescan.
>>
>> Could save domain/bus/device/function aside in the list and according that info
>> restore new dev to drhd_units later.
>> Then dmar_find_matched_drdh_unit and device_to_iommu could return right drhd and iommu.
>>
>> Add remove_dev_from_drhd/restore_dev_to_drhd functions to do the real work.
>> call them in device ADD_DEVICE and UNBOUND_DRIVER
>>
>> Need to do the samething to atsr.  (expose dmar_atsr_units and add atsru->segment)
>>
>> After patch, will right iommu for the new dev and will not get DMAR error any more.
>>
>> -v2: add pci_dev_put/pci_dev_get to make refcount consistent.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Vinod Koul <vinod.koul@intel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: iommu@lists.linux-foundation.org
>> ---
>>  drivers/iommu/intel-iommu.c |  187 ++++++++++++++++++++++++++++++++++++++++---
>>  include/linux/dmar.h        |    4 +
>>  2 files changed, 181 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index c9c6053..39ef2ce 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -665,6 +665,159 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
>>        return NULL;
>>  }
>>
>> +#ifdef CONFIG_HOTPLUG
>> +struct dev_dmaru {
>> +       struct list_head list;
>> +       void *dmaru;
>> +       int index;
>> +       int segment;
>> +       unsigned char bus;
>> +       unsigned int devfn;
>> +};
>> +
>> +static int
>> +save_dev_dmaru(int segment, unsigned char bus, unsigned int devfn,
>> +                void *dmaru, int index, struct list_head *lh)
>
> Follow the indentation style used elsewhere in the file: as much of
> the declaration on one line as will fit (here and below).
>
> I think the callers would read more naturally if you passed in the
> struct pci_dev * to save_dev_dmaru() and extracted the
> segment/bus/devfn here rather than in the callers.

Just want to keep save_dev_dmaru more consistent to get_dev_dmaru...

Anyway, will change to pass struct pci_dev *dev instead.

Yinghai
