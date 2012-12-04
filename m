Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2LDTuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 14:50:02 -0500
Received: from sanddollar.geekisp.com ([216.168.135.167]:6645 "HELO
	sanddollar.geekisp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752101Ab2LDTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 14:50:00 -0500
Message-ID: <50BE53E4.1040303@balister.org>
Date: Tue, 04 Dec 2012 11:49:56 -0800
From: Philip Balister <philip@balister.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Eli Billauer <eli.billauer@gmail.com>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@denx.de>, John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable
 logic)
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com> <20121130173644.GA9841@kroah.com> <50B97734.3090207@balister.org> <201212012048.51012.arnd@arndb.de>
In-Reply-To: <201212012048.51012.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2012 12:48 PM, Arnd Bergmann wrote:
> On Saturday 01 December 2012, Philip Balister wrote:
>> On 11/30/2012 09:36 AM, Greg KH wrote:
>>> Yes, I know of at least one more device other than the ones listed above
>>> that wants this type of functionality as well, so defining it in a
>>> standard user/kernel api manner would be very good to do.
>>
>> I'm concerned that a standard driver for FPGA's will be a very difficult
>> problem.
>>
>> The Xillybus driver looks interesting on several levels, however my
>> first concern is depends on a FPGA IP block that is not open source.
>> This is not a bad thing, just a potential obstacle for some people.
>
> I agree that is a concern, but for now, I'm mostly worried about
> the kernel-to-user interface. If we can agree on a driver interface
> that works for Xillybus as well as any of the others we know about,
> we can start using that as the generic kernel FPGA interface.
>
> Once we get a second FPGA driver, that can use the same user
> interface but talk to the hardware in a different way, and then
> we can reorganise the code to keep the user interface bits in a
> common driver, away from the hardware specific parts.

Actually, the user interface will depend on what "code" is loaded into 
the FPGA (side note, people argue over FPGA's being hardware or 
software). So it is entirely possible to load an FPGA with a XillyBus 
device, and ethernet interface, I2S, and the "UIO" appraoch I am working on.

We can use device tree to tell the kernel what drivers are needed, and 
Josh mentioned some ideas on managing device tree entries combined with 
the fpga image.

So it is very possible for one fpga to have several device drivers, each 
using different user interfaces. It is entirely possible to create a 
device in the fpga that uses an existing hardware interface so you could 
use the existing Linux driver to control it.

> If you see anything in the user interface that directly depends on
> the Xillybus IP block, then that would make the approach impossible
> and we should change that to be more generic.
>
>> I've been engaged in design discussions today with my customer. Our
>> target is the Xilinx Zynq hardware. The first pass at a driver focuses
>> on creating the minimal amount of code in the kernel doing most of the
>> logic in user space. So the driver code allocates a large chunk of RAM
>> for the FPGA to read/write to, provides a mmap function so user space
>> can see this RAM, also mmaps in the address space of an AXI slave so the
>> user space can control the logic. This approach has no dependencies on
>> what is loaded into the fpga.
>>
>> This is a very different approach then the Xillybus driver, but should
>> also be useful to a large class of people. Hopefully, we can converge on
>> a set of useful drivers, and not end up with a million drivers all based
>> on custom fpga configuration :)
>
> Agreed. If I understand you correctly though, your approach is specific
> to a particular hardware implementation (Zynq) on the user interface layer,
> which I think is exactly what we should avoid. Obviously, there is
> always a driver involved that is specific to the IP block you load into
> an FPGA at runtime, and that is ok. The two parts that I think we
> should agree on are:
>

The approach I am taking is not Zynq specific. The only Zynq specific 
bits will be range checking data from the device tree to make sure the 
user is mapping address space that is used by the FPGA and a similar 
validation of the IRQ numbers. I have not looked at the Altera part 
closely, but I suspect their fpga/processor interface may use similar 
concepts.

> a) How to get a payload into the FPGA
>

Just to be clear, what are you calling payload here? Is it the data that 
is used to configure the fpga, or actual data going back and forth? I'm 
a little concerned that not everyone understand how flexible the FPGA is.

Philip

> b) How to find a device driver that can make the payload interface to user
>     space.
>
> 	Arnd
>
>
