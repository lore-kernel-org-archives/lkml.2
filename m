Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2BGHHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:07:47 -0500
Received: from rs130.luxsci.com ([72.32.115.17]:54303 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2BGHHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 02:07:46 -0500
Message-ID: <4F30CDA2.7010008@firmworks.com>
Date: Mon, 06 Feb 2012 21:07:14 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com> <4F302474.1020701@firmworks.com> <4F30B79C.4030404@nvidia.com>
In-Reply-To: <4F30B79C.4030404@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q1777Cei012379 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/2012 7:33 PM, Stephen Warren wrote:
> On 02/06/2012 11:05 AM, Mitch Bradley wrote:
>> I like the general approach of simplifying the pinctrl thing, as the
>> previous approach did not appear to be converging.
>>
>> One possible name would be "gpconfig" - for general purpose configuration.
>
> Sounds reasonable
>
>> The register access model in the strawman proposal is probably too
>> simple.  32-bit memory mapped registers are certainly the most common
>> subcase on ARM, but there are many other cases that occur in practice:
>>
>> * Registers that must be accessed with 8, 16, or 64-bit cycles.
>> * Registers that have side effects on read, so read-mask-write must be
>> avoided
>> * Registers accessed via an index/data cycle pair, thus having locking
>> requirements
>> * Registers that must be read after being written, or otherwise
>> requiring some sort of memory-ordering enforcement.
>> * Time delays between pairs of writes
>> * PCI configuration registers, which often have some combination of the
>> above
>> * Registers behind serial buses like I2C
>>
>> Both Open Firmware and ACPI have addressed this general problem.  In
>> addition to a numeric identifier for the register, you need to specify
>> the access semantics.  It's difficult to finitely enumerate all possible
>> cases, but you can get to 99.9% with a modest number of access models,
>> and then add new models as needed.
>
> My thinking was that each driver that permitted execution of these
> register write sequences on its registers would provide an extremely
> simple driver to support this. Perhaps just one "op" function that
> implemented each write, and took care of details such as timing delays
> for the IO, indexed addressing, using I2C instead of memory-mapped,
> perhaps register access width, etc.
>
> Some of the items in the list above could be solved by explicit flags in
> the data instead (register access width comes to mind for memory-mapped
> devices at least).
>
> Do you have any direct pointers to how OF and ACPI solved this kind of
> thing; it'd be good background.

In ACPI, you declare an "OperationRegion" with a given "region space" 
(an enumeration from SystemMemory, SystemIO, PCIConfig, SMBus, 
EmbeddedControl, CMOS, PCIBARTarget) - ACPI spec section 17.5.89. 
Inside that operation region, you declare various fields, further 
specifying the subordinate access type from a region-dependent list. 
Those access types include ByteAcc, WordAcc, DWordAcc, QWordAcc, and 
BufferAcc.  The field declaration further specifies whether or not a 
mutex must be acquired, and a rule for what to do about unmodified bits 
within the larger object containing the field.  ACPI Spec 17.5.44

In OFW, each parent bus has a set of methods for performing 
memory-mapped I/O operations on its addressable regions.  The child 
devices invoke a "map-in" method in the parent to acquire an address 
token, then pass that token to access methods in the parent node.  For 
the common case, there are a set of fetch and store methods for the 
usual sizes (8, 16, 32), and for more complex cases, the parent can define
whatever methods make sense for its needs.  The methods are implemented 
by byte code associated with the parent driver.



