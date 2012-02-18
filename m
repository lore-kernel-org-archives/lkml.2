Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2BRG2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 01:28:39 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16899 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751669Ab2BRG2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 01:28:37 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dI9371I1432N98dK4015Lzz1202hzz8275chz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZKSNH-01-5MY-02
X-M-MSG: 
Message-ID: <4F3F4509.4070003@amd.com>
Date: Sat, 18 Feb 2012 14:28:25 +0800
From: Andiry Xu <andiry.xu@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: "Alex,Shi" <alex.shi@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <stern@rowland.harvard.edu>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.de>, Takashi Iwai <tiwai@suse.de>,
        <trenn@suse.de>, <linux-pci@vger.kernel.org>,
        Michal Marek <MMarek@suse.com>
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>  <4F311233.9070404@intel.com> <20120207144204.GA7214@kroah.com>  <20120207172743.GA4780@xanatos> <20120207221317.GA6103@xanatos>  <1328664392.12669.233.camel@debian> <1328682430.12669.443.camel@debian>  <1328692300.12669.593.camel@debian>  <20120214002030.GA10364@xanatos>  <1329359801.12669.2872.camel@debian> <1329461087.12669.2911.camel@debian>  <4F3E0C3D.4030307@ladisch.de> <1329468418.12669.2988.camel@debian> <4F3E28D1.1030509@ladisch.de>
In-Reply-To: <4F3E28D1.1030509@ladisch.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2012 06:28:25.0415 (UTC) FILETIME=[84EB9D70:01CCEE06]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 06:15 PM, Clemens Ladisch wrote:
> Alex,Shi wrote:
>>> The controller driver will need to know which of the multiple MSI-X
>>> interrupts has been raised:
>>>
>>> irqreturn_t (*msix_irq)(struct usb_hcd *hcd, unsigned int nr_or_index);
>>
>> Actually, hcd has 2 object for msix, msix_count and msix_entries.
>>
>> Do you mean msix_count maybe smaller than we decide in hcd_setup_msix()?
> 
> No.  But when msic_count > 1, we have multiple interrupts.
> 
>> Which situation will make this?
> 
> Assume that an XHCI controller has two rings, and that each one gets its
> own MSI-X interrupt.  How should the driver decide which of the rings
> needs to be handled?
> 
> irqreturn_t xhci_msix_irq(struct usb_hcd *hcd)
> {
> 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
> 
> 	if (...)
> 		handle(xhci->ring[0]);
> 	else
> 		handle(xhci->ring[1]);
> }
> 
> I.e., what should go into the if()?
> 
> 

Currently xHCI driver only support one ERST event ring. If we need to
support multiple event rings in the future, it's simple: in
usb_hcd_request_msi_msix_irqs, change the last parameter of
request_irq() to xhci->erst[i], and we can get the corresponding erst[i]
in xhci_msi_irq() like this:

irqreturn_t xhci_msi_irq(int irq, void *dev_id)
{
	struct xhci_erst *erst = dev_id;
	...
	/* Handle corresponding event ring pointed by erst */
}

See Matthew Wilcox's patchset below for reference:

www.spinics.net/lists/linux-usb/msg47353.html

Thanks,
Andiry
Andiry





