Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1AJLVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:21:55 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:39436 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab1AJLVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:21:53 -0500
Message-ID: <4D2AEB84.6060804@st.com>
Date: Mon, 10 Jan 2011 16:50:36 +0530
From: pratyush <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Viresh KUMAR <viresh.kumar@st.com>, Greg KH <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Subject: Re: [PATCH V2] ST SPEAr: PCIE gadget suppport
References: <137dfad4a093ea0ac80396f5eb7fbf0c382be698.1294314772.git.viresh.kumar@st.com> <201101072332.16985.arnd@arndb.de>
In-Reply-To: <201101072332.16985.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

Thanks for the comments!!!

On 1/8/2011 4:02 AM, Arnd Bergmann wrote:
> On Thursday 06 January 2011, Viresh Kumar wrote:
>> From: Pratyush Anand <pratyush.anand@st.com>
>>
>> This is a configurable gadget. can be configured by sysfs interface. Any
>> IP available at PCIE bus can be programmed to be used by host
>> controller.It supoorts both INTX and MSI.
>> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
>> with size 0x1000
> 
> The code looks reasonably clean, but I don't yet understand how you would
> use this device for the interesting case of communicating with the host
> side. I've put a lot of thought into similar hardware designs before, but
> never got an implementation done myself.

This driver has been developed just to show spear's capability to work as dual
mode pcie controller.

> 
> Forwarding devices that don't need interrupts with your driver seems to
> be the only case that will easily work, but that is also rather limited
> in what you can use it for.
> 

Off-course, it will work best with non interrupting devices. One can use
INTA assertion/de-assertion by software, but it would be very slow.

> One concept that people have played with before is to export a virtio
> channel through PCI that you can use with e.g. virtio-net  or virtfs.
> This is very powerful and has  a lot of possible applications because
> we have support for virtio drivers across a number of operating systems
> and platforms already.
> 
>>  Documentation/misc-devices/spear-pcie-gadget.txt |  125 ++++
>>  drivers/misc/Kconfig                             |   10 +
>>  drivers/misc/Makefile                            |    1 +
>>  drivers/misc/spear13xx_pcie_gadget.c             |  856 ++++++++++++++++++++++
> 
> Why would you put this under drivers/misc?
> 
> I think drivers/pci/gadget/ would be a better place. I would also
> recommend splitting the user interface from the hardware dependent
> parts, so someone else can easily do another gadget driver for
> different hardware.
> 

Yes, can be done, if the interfaces which I have made is
acceptable to community. 

>> +/*wait till link is up*/
>> +# cat sys/devices/platform/pcie-gadget-spear.0/link
>> +wait till it returns UP.
> 
> A blocking sysfs read is not a nice interface. This is probably where
> the sysfs abstraction for your hardware stops making sense.
> 

This call is not blocking. User will have to recheck link status till he
finds it UP. He may put some delay between two successive read. I will
modify documentation to be more explicit.

>> +To assert INTA
>> +# echo 1 >> sys/devices/platform/pcie-gadget-spear.0/inta
>> +
>> +To de-assert INTA
>> +# echo 0 >> sys/devices/platform/pcie-gadget-spear.0/inta
> 
> And this looks somewhat impractical and slow. 
> 

Yes, it will be slow.

>> +to send msi vector 2
>> +# echo 2 >> sys/devices/platform/pcie-gadget-spear.0/send_msi
> 
> Using a sysfs file only for its side-effect is not very nice either.
> 
> The user interface for the interrupts looks to me like it should really
> be based around a character device and either read/write/poll or
> ioctl and poll. Using an eventfd might be cool here, because  then you
> can combine this with other devices by passing the event file to
> an interface that operates on eventfd. This would e.g. make it possible
> to combine a UIO device generating interrupts with a PCIe gadget
> sending the interrupts somewhere else, without leaving kernel
> space.
> 

I do not have much idea about eventfd mechanism. But if we decide to
split it in two layers (generic pcie gadget and HW specific) then I
might try to do it in this way.

Regards
Pratyush

> For setting up the basic parameters, sysfs (or configfs, as Greg suggested)
> is a reasonable choice, so there is no need to change that.
> 
> I don't know what the rules for configfs are though, i.e. if eventfd
> files or ioctls are ok or not.
> 
> 	Arnd
> 
> .
> 

