Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1LIMlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 07:41:21 -0500
Received: from bay0-omc3-s7.bay0.hotmail.com ([65.54.190.145]:23144 "EHLO
	bay0-omc3-s7.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189Ab1LIMlT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:41:19 -0500
Message-ID: <BAY163-W600D6D6A04D4BAE8278907FBB90@phx.gbl>
X-Originating-IP: [82.43.252.147]
From: Anand Kanaginhal <anand_dk@hotmail.com>
To: <bhelgaas@google.com>, <mjg59@srcf.ucam.org>, <greg@kroah.com>
CC: Linux PCI mailing <linux-pci@vger.kernel.org>,
        linux kernel mailing <linux-kernel@vger.kernel.org>,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>
Subject: RE: PCIe Hotplugging not working
Date: Fri, 9 Dec 2011 04:41:18 -0800
Importance: Normal
In-Reply-To: <CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>
References: <BAY163-W52E309F419E3588206D889FBB30@phx.gbl>
 <BAY163-W47DD39095DA3EB108AA3F2FBB30@phx.gbl>,<20111130154022.GA1411@srcf.ucam.org>
 <BAY163-W80F10350D24162EFC3699FBB00@phx.gbl>,<20111130182423.GA4831@srcf.ucam.org>,<CAErSpo5SvHSJrdkWituFq11hMt=jbiobnxHeddN9Xf4DmK640g@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 09 Dec 2011 12:41:18.0401 (UTC) FILETIME=[D8EE1B10:01CCB66F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am afraid this issue is not resolved, however to give 
complete picture and my understanding so far, I have the following description:
In the diagram:
---------------
p1, p8 p9 are downstream hotplug slots(ports) on switch 8533.  
c1, c2 are the custom designed pcie cards for which I have my driver.


    +----------+
    |          |
    |          |
    |  CPUS    |
    |          |
    |          |
    +----+-----+
         |
         |
         |
         |
    +----+-----+                    +-------------+               
    |          |                    |             | 
    |          |                    |  PEX 8533   |
    |  ROOT    |--------------------|  switch     |
    |  CMPLX   |                    | (10b5:8533) |
    |          |                    |             |
    +----------+                    +-------------+
                                      |    |    |
                                    p1|  p8|  p9|
                                      |    |    |
                                      c1   c2   |
                                                |
                                                |
                                                |
                                                |
                                       +-------------+               
                                       |             | 
                                       |   Another   |
                                       |   switch    |
                                       |   (chain)   |
                                       |             |
                                       +-------------+



I have built 2.6.38.13 linux kernel with following options set:
CONFIG_HOTPLUG=y
CONFIG_HOTPLUG_CPU=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_COMPAQ=m
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
CONFIG_HOTPLUG_PCI_IBM=m
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=y

--------------------------------------------------------------------------------
Please correct me if any of my understanding below is incorrect:
1. With the above setup, If I hotplug card c1 and/or c2, will my driver probe 
get invoked. 
2. I dont have to add any rules for in /etc/udev/rules.d/*.rules for my driver
 to work. 
3. The standard hotplug controller driver would get the hotplug event from the
 switch and handle it. 
4. The standard hotplug controller driver will be responsible for invoking 
.probe and .remove functions of my driver.
---
My simplified version of driver is pasted below, I understand that I create a char dev before any of the device is found, however my main concern is detection of card insertion and removal.
-----------



static struct pci_device_id my_pci_tbl[] = {
       { PCI_DEVICE (0x174a, 0x0701) },
       { PCI_DEVICE (0x174a, 0x0801) },
       { 0, }
       };


MODULE_DEVICE_TABLE(pci, my_pci_tbl);

static struct pci_driver my_pci_driver =
{
    .name       = DRV_NAME,
    .probe      = my_pci_device_init,
    .remove     = __devexit_p(my_pci_device_remove),
    .id_table   = my_pci_tbl,
};


/*******************************************************************************
    module init 
******************************************************************************/
static int __init my_pci_module_init(void)
{

#ifdef MODULE
    printk(version);
#endif
    major = register_chrdev(0, DRV_NAME, &pcie_fops);
    if (major <= 0) {
        return -1;
    }

    /* Now register the PCI drivers */
    return pci_register_driver(&my_pci_driver);

}
/*******************************************************************************
    module_cleanup
 ******************************************************************************/
static void __exit my_pci_module_cleanup(void)
{

    if (major) {
        unregister_chrdev(major, DRV_NAME);
    }

    /* delete IO memory allocated */
    /* unregister pci driver */
    pci_unregister_driver (&my_pci_driver);
}

/*******************************************************************************
probe 
******************************************************************************/
static int my_pci_device_init (struct          pci_dev       *pdev, 
                               const struct    pci_device_id *ent )
{
    /* probe and device inits */
} 

/*******************************************************************************
remove
 ******************************************************************************/
static void __devexit my_pci_device_remove (struct pci_dev *pdev)
{
    /* remove operation */
}

/*******************************************************************************
 ******************************************************************************/
module_init(my_pci_module_init);
module_exit(my_pci_module_cleanup);

Thanks 
Anand

----------------------------------------
> From: bhelgaas@google.com
> Date: Wed, 7 Dec 2011 10:23:26 -0700
> Subject: Re: PCIe Hotplugging not working
> To: mjg59@srcf.ucam.org
> CC: anand_dk@hotmail.com; greg@kroah.com; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; linux-hotplug@vger.kernel.org
>
> On Wed, Nov 30, 2011 at 11:24 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Wed, Nov 30, 2011 at 09:18:39AM -0800, Anand Kanaginhal wrote:
> >>
> >> Hi Mathew,
> >> I have following options set
> >>
> >> CONFIG_HOTPLUG_PCI_PCIE=y
> >> CONFIG_HOTPLUG_PCI_ACPI=m
> >
> > Please try with this built in, not as a module. What kind of board are
> > you using?
>
> Is this resolved? If not, a complete dmesg log would be interesting.
> You might also try current upstream in case there were relevant
> changes since 2.6.38.12.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
 		 	   		  