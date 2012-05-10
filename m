Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710Ab2EJOyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:54:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:10574 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2EJOyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:54:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141424688"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] Xen physical cpus interface
Thread-Topic: [PATCH 3/3] Xen physical cpus interface
Thread-Index: AQHNHys61b8pDRiwSFiwkpXixs4X8JbDMq/Q
Date: Thu, 10 May 2012 14:54:07 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923351B5807@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
 <20120420192439.GA32170@phenom.dumpdata.com>
In-Reply-To: <20120420192439.GA32170@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

Thanks for help me review!
Update according to your suggestion. 
Add some comments below.

>> 
>> Manage physical cpus in dom0, get physical cpus info and provide sys
>> interface. 
> 
> Anything that exposes SysFS attributes needs documentation in
> Documentation/ABI

Yes, added.

> 
> Can you explain what this solves? And if there are any
> userland applications that use this?
> 

It provide cpu online/offline interface to user. User can use it for their own purpose, like power saving - by offlining some cpus when light workload it save power greatly.

> 
> 
>> +	switch (buf[0]) {
> 
> Use strict_strtoull pls.

kernel suggest:
WARNING: strict_strtoull is obsolete, use kstrtoull instead :)

> 
>> +	case '0':
>> +		ret = xen_pcpu_down(cpu->xen_id);
>> +		break;
>> +	case '1':
>> +		ret = xen_pcpu_up(cpu->xen_id);
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	if (ret >= 0)
>> +		ret = count;
>> +	return ret;
>> +}
>> +static DEVICE_ATTR(online, S_IRUGO | S_IWUSR, show_online,
>> store_online); 
> 
>> +
>> +static ssize_t show_apicid(struct device *dev,
>> +			   struct device_attribute *attr,
>> +			   char *buf)
>> +{
>> +	struct pcpu *cpu = container_of(dev, struct pcpu, dev); +
>> +	return sprintf(buf, "%u\n", cpu->apic_id);
>> +}
>> +
>> +static ssize_t show_acpiid(struct device *dev,
>> +			   struct device_attribute *attr,
>> +			   char *buf)
>> +{
>> +	struct pcpu *cpu = container_of(dev, struct pcpu, dev); +
>> +	return sprintf(buf, "%u\n", cpu->acpi_id);
>> +}
>> +static DEVICE_ATTR(apic_id, S_IRUGO, show_apicid, NULL);
>> +static DEVICE_ATTR(acpi_id, S_IRUGO, show_acpiid, NULL);
> 
> What benefit is there in exposing these values to the user?

Yes, no benefit so let's cancel exposing acpi_id and apic_id.

>> +
>> +static void pcpu_sys_remove(struct pcpu *pcpu)
>> +{
>> +	struct device *dev;
>> +
>> +	if (!pcpu)
>> +		return;
>> +
>> +	dev = &pcpu->dev;
>> +	if (dev->id)
>> +		device_remove_file(dev, &dev_attr_online);
>> +	device_remove_file(dev, &dev_attr_acpi_id);
>> +	device_remove_file(dev, &dev_attr_apic_id);
>> +	device_unregister(dev);
> 
> So .. if you are using that, can't you use the .release
> and define something like:
> 
> static void pcpu_release(struct device *dev)
> {
> 	struct pcpu *pcpu = container_of(dev, struct pcpu, dev);
> 
> 	list_del(&pcpu->pcpu_list);
> 	kfree(pcpu);
> }
>> +}
>> +
>> +static void free_pcpu(struct pcpu *pcpu)
>> +{
>> +	if (!pcpu)
>> +		return;
>> +
>> +	pcpu_sys_remove(pcpu);
> 
>> +	list_del(&pcpu->pcpu_list);
>> +	kfree(pcpu);
> 
> Those two shouldn't be there. They sould be part of the
> release function.
>> +}
>> +
>> +static int pcpu_sys_create(struct pcpu *pcpu)
>> +{
>> +	struct device *dev;
>> +	int err = -EINVAL;
>> +
>> +	if (!pcpu)
>> +		return err;
>> +
>> +	dev = &pcpu->dev;
>> +	dev->bus = &xen_pcpu_subsys;
>> +	dev->id = pcpu->xen_id;
> 
> And then here dev->release = &pcpu_release;
> 

Hmm, it's good if it's convenient to do it automatically via dev->release.
However, dev container (pcpu) would be free at some other error cases, so I prefer do it 'manually'.

> 
>> +	/* Not open pcpu0 online access to user */
> 
> Huh? You mean "Nobody can touch PCPU0" ?

Add comments:
        /*
         * Xen never offline cpu0 due to several restrictions
         * and assumptions. This basically doesn't add a sys control
         * to user, one cannot attempt to offline BSP.
         */

> 
> Why? Why can they touch the other ones? And better yet,
> what happens if one boots without "dom0_max_vcpus=X"
> and powers of some of the CPUs?
> 

Only those at cpu present map has its sys interface.

>> +static int __init xen_pcpu_init(void)
>> +{
>> +	int ret;
>> +
>> +	if (!xen_initial_domain())
>> +		return -ENODEV;
>> +
>> +	ret = subsys_system_register(&xen_pcpu_subsys, NULL); +	if (ret) {
>> +		pr_warning(XEN_PCPU "Failed to register pcpu subsys\n");
>> +		return ret; +	}
>> +
>> +	INIT_LIST_HEAD(&xen_pcpus.list);
>> +
>> +	ret = xen_sync_pcpus();
>> +	if (ret) {
>> +		pr_warning(XEN_PCPU "Failed to sync pcpu info\n"); +		return ret;
>> +	}
>> +
>> +	ret = bind_virq_to_irqhandler(VIRQ_PCPU_STATE, 0,
>> +				      xen_pcpu_interrupt, 0,
>> +				      "pcpu", NULL);
> 
> "xen-pcpu"
> 
>> +	if (ret < 0) {
>> +		pr_warning(XEN_PCPU "Failed to bind pcpu virq\n");
> 
> Shouldn't you delete what 'xen_sync_pcpus' did?

yes, add error handling.

> Or is it OK to still work without the interrupts? What is the purpose
> of that interrupt? How does it actually work - the hypervisor
> decides when/where to turn off CPUs?
> 

user online/offline cpu via sys interface --> xen implement --> inject virq back to dom0 --> sync cpu status.

Thanks,
Jinsong