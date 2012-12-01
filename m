Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2LATbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 14:31:00 -0500
Received: from starfish.geekisp.com ([216.168.135.166]:17326 "HELO
	starfish.geekisp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751825Ab2LATa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 14:30:58 -0500
Message-ID: <50BA5AEF.3010109@balister.org>
Date: Sat, 01 Dec 2012 11:30:55 -0800
From: Philip Balister <philip@balister.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Eli Billauer <eli.billauer@gmail.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable
 logic)
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com> <1354117293-13632-2-git-send-email-eli.billauer@gmail.com> <201211301728.48008.arnd@arndb.de> <20121130173644.GA9841@kroah.com> <50B97734.3090207@balister.org> <20121201165612.GG3113@kroah.com>
In-Reply-To: <20121201165612.GG3113@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2012 08:56 AM, Greg KH wrote:
> On Fri, Nov 30, 2012 at 07:19:16PM -0800, Philip Balister wrote:
>> On 11/30/2012 09:36 AM, Greg KH wrote:
>>> On Fri, Nov 30, 2012 at 05:28:47PM +0000, Arnd Bergmann wrote:
>>>> On Wednesday 28 November 2012, Eli Billauer wrote:
>>>>>
>>>>> Xillybus is a general-purpose framework for communication between programmable
>>>>> logic (FPGA) and a host. It provides a simple connection between hardware FIFOs
>>>>> in the FPGA and their respective device files on the host. The user space
>>>>> programming model is like piping data from or to the FPGA.
>>>>>
>>>>> The underlying transport between the host and FPGA is either PCIe or AXI
>>>>> (AMBA bus by ARM).
>>>>>
>>>>> The Xillybus logic (IP core) is configurable in the number of pipes it presents
>>>>> and their nature. The driver autodetects these pipes, making it essentially
>>>>> forward-compatible to future configurations. The benefit of having this driver
>>>>> enabled in the kernel is that hardware vendors may release a new card, knowing
>>>>> that it will work out of the box on any future Linux machine, with the specific
>>>>> configuration defined for the FPGA part.
>>>>>
>>>>> This driver has been available for download for over a year, and has been
>>>>> actively used on a wide variety of kernels versions and configurations.
>>>>
>>>> I have a much higher-level comment on this driver: There seem to be a number
>>>> of parties that are interested in having reprogrammable logic available in
>>>> Linux and that will want to merge their drivers. I'm aware of these other
>>>> people that must have some interest (and one person I can't mention here
>>>> because of NDA):
>>>>
>>>> Philip Balister  <philip@balister.org> (OpenSDR)
>>>> Dinh Nguyen <dinguyen@altera.com> (ARM SOCFPGA maintainer)
>>>> Pavel Machek <pavel@denx.de> (SOCFPGA contributor)
>>>> John Linn <john.linn@xilinx.com> (Zynq maintainer)
>>>> Michal Simek <michal.simek@xilinx.com> (Zynq maintainer)
>>>> Ira W. Snyder <iws@ovro.caltech.edu> (Carma driver author)
>>>
>>> Yes, I know of at least one more device other than the ones listed above
>>> that wants this type of functionality as well, so defining it in a
>>> standard user/kernel api manner would be very good to do.
>>
>> I'm concerned that a standard driver for FPGA's will be a very
>> difficult problem.
>>
>> The Xillybus driver looks interesting on several levels, however my
>> first concern is depends on a FPGA IP block that is not open source.
>> This is not a bad thing, just a potential obstacle for some people.
>
> As long as that doesn't affect the kernel code, I don't see the obstacle
> here.  What am I missing?

Nothing. The Xillybus approach is valid. It just depends on their piece 
of fpga code. If you are not willing to license that, you will need to 
reverse engineer their fpga code, or sues a different (equally valid) 
method to communicate with the fpga. Think of their fpga blob as a 
specific implementation of a network card.  Not all network cards expose 
the same hardware interface.

The important thing to realize is that the fpga is user configurable. It 
is possible to create an infinite number of possible "devices" in it 
that can use any number of device drivers in Linux.

Think of it a a soc, with a large part that the end user can customize 
with his own IP. In the Xilly case, they have created a custom piece of 
hardware in the fpga that needs a driver with a specific interface to 
users space.

>
>> I've been engaged in design discussions today with my customer. Our
>> target is the Xilinx Zynq hardware. The first pass at a driver
>> focuses on creating the minimal amount of code in the kernel doing
>> most of the logic in user space. So the driver code allocates a
>> large chunk of RAM for the FPGA to read/write to, provides a mmap
>> function so user space can see this RAM, also mmaps in the address
>> space of an AXI slave so the user space can control the logic. This
>> approach has no dependencies on what is loaded into the fpga.
>
> Would a simple UIO driver work best for this type of arrangement?  Then
> those types of hardware wouldn't even need to mess with a fpga-type
> interface.
>

It is very close to a UIO approach. My key problem I am trying to solve 
is getting a "large" buffer space for the driver and a way to 
communicate the physical address and size of the buffer to the fpga. The 
fpga has several ports that allow it to directly read/write RAM, but it 
needs to know physical addresses.

>> This is a very different approach then the Xillybus driver, but
>> should also be useful to a large class of people. Hopefully, we can
>> converge on a set of useful drivers, and not end up with a million
>> drivers all based on custom fpga configuration :)
>
> Odds are, this should look something like the firmware interface in the
> end, right?  Userspace dumps a bunch of data to the device, and then
> needs the driver to toggle some bits somewhere to enable the device.
> Also, a few control calls like clearing the device, and other minor
> things should be all that is needed, right?
>

For zynq, there is an out of tree ( :) ) driver that handles the 
firmware loading. This is an independent problem.

> So, in the grand tradition of, "The first one there wins", why not base
> it all off of your driver, and how that works, and we can go from there :)
>

I do not think there will be any one driver that will work for all use 
cases due to the variety of devices that can be implemented in the fpga.

Philip


> thanks,
>
> greg k-h
>
>
