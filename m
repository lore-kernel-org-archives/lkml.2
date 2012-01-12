Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2ALUfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:35:31 -0500
Received: from rs130.luxsci.com ([72.32.115.17]:55211 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab2ALUf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:35:28 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jan 2012 15:35:28 EST
Message-ID: <4F0F42AA.2030408@firmworks.com>
Date: Thu, 12 Jan 2012 10:29:30 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Michael Bohan <mbohan@codeaurora.org>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Representing SPMI bus in Device Tree
References: <4EE2A6F8.3010604@codeaurora.org>
In-Reply-To: <4EE2A6F8.3010604@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q0CKTS8i021343 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in responding; I just received the message today...

On 12/9/2011 2:25 PM, Michael Bohan wrote:
> Hi,
> 
> I am designing a bus driver for the System Power Management Interface, 
> which is also known as SPMI. Information about the bus can be found 
> through this website:
> 
> http://www.mipi.org/specifications/system-power-management-interface
> 
> In short, to make a transaction, you need two things: a 4 bit slave ID 
> and a 16 bit address offset.
> 
> One difference in our model is a requirement to instantiate multiple 
> devices on the same slave ID. That is to say, our 16 bit address space 
> is segmented. For this reason, I was thinking it would be nice to have 
> an optional second level in the tree under the bus driver. The first 
> level specifies the slave ID, and the optional second is reserved for 
> specifying any number of address ranges for carving out chunks in the 
> 16-bit address space.

If both the slave ID and the offset are necessary for selecting a device, that perfectly fits the normal device tree model for 2 address cells.  Here is your example using 2 address cells (I changed the addresses and sizes to something more plausible - having an address range starting at 0xcafe of size 0x4000 seemed unlikely) :

/ {
	spmi@abc123 {
		#address-cells = <2>;
		#size-cells = <1>;
		compatible = "qcom,spmi-platform";
		coincell@1,1000 {
			compatible = "qcom,coincell";
			/* Two response ranges: slave 1 offset 1000 size 100, slave 1 offset 2000 size 100 */
			reg = <0x1 0x1000 0x100 0x01 0x2000 0x100>;
			interrupts = <100>;
		};
		pon@1,4000 {
			compatible = "qcom,pon";
			/* One response range: slave 1 offset 4000 size 800 */
			reg = <0x1 0x4000 0x800>;
		};
		pon@2,0 {
			compatible = "qcom,pon";
			/* One response range: slave 2 offset 0 size 10000 (the full range of offsets) */
			reg = <0x2 0x0 0x10000>;
			interrupts = <51>;
		};
	};
}

I guess that your idea was to preserve the "usual" SPMI semantics of slave-id == device, but the fact that some hardware breaks that model means that it isn't really the correct model in practice.

The 2-address-cell model shown above is fully consistent with device tree theory and practice.  In fact, it's almost identical to SBus addressing - SBus was the first bus ever to be described with the device tree.

> 
> Here is a graphical representation on this model:
> 
> / {
> spmi@abc123 {
> #address-cells = <1>;
> #size-cells = <0>;
> compatible = "qcom,spmi-platform";
> pmic@1 {
> #address-cells = <1>;
> #size-cells = <1>;
> reg = <0x1>;
> spmi-dev-container;
> 
> coincell@beef {
> compatible = "qcom,coincell";
> reg = <0xbeef 0x4000>;
> interrupts = <100>;
> };
> pon@cafe {
> compatible = "qcom,pon";
> reg = <0xcafe 0x4000 0xf00 0x1000>;
> };
> };
> simple_dev@2 {
> compatible = "qcom,pon";
> reg = <0x2>;
> interrupts = <51>;
> };
> };
> };
> 
> For each node entry, the of layer checks for the spmi-dev-container flag 
> that instructs whether this node 'contains' another level of devices, of 
> which include and numbe1r of bus address ranges. I think this approach 
> does a good job of describing the hardware and respecting the Device 
> Tree conventions.
> 
> I can think of a couple other ways to portray this same information, but 
> each have what I consider huge problems. For example, we could treat the 
> first 'reg' tuple to mean slave ID, and any subsequent ones to be bus 
> addresses:
> 
> 
> spmi@abc123 {
> #address-cells = <1>;
> #size-cells = <1>;
> compatible = "qcom,spmi-platform";
> coincell@1 {
> compatible = "qcom,coincell";
> reg = <0x1 0x0 0xbeef1 0x4000>;
> interrupts = <100>;
> };
> pon@1 {
> compatible = "qcom,pon";
> reg = <0x1 0x0 0xcafe1 0x4000 0xf001 0x1000>;
> };
> simple_dev@2 {
> compatible = "qcom,pon";
> reg = <0x2>;
> interrupts = <51>;
> };
> };
> 
> But then we end up with duplicate devices on the same node address for 
> the same bus level, which I understand is not allowed in Device Tree. 
> Also, I don't like the notion that the address meaning is overloaded 
> here. We could establish a new binding to represent bus addresses (eg. 
> spmi-bus-addr = <0xcafe 0x4000>, but my understanding is there should be 
> only one address specifier per node level.
> 
> Another possibility is to have a single level that encapsulates both a 
> slave id and bus address within one address. For ex. the upper bits 
> represent the bus address and the least significant nibble is the slave 
> id. This seems somewhat convoluted, though. Since we require support for 
> multiple bus address ranges, then we have redundancy in the sense that 
> each address includes a separate declaration of the slave ID. Plus, we 
> have the same issue of an arbitrary structure imposed on an address.
> 
> I probably dislike this one the most.
> 
> Ex.
> 
> spmi@abc123 {
> #address-cells = <1>;
> #size-cells = <1>;
> compatible = "qcom,spmi-platform";
> coincell@beef1 {
> compatible = "qcom,coincell";
> reg = <0xbeef1 0x4000>;
> interrupts = <100>;
> };
> pon@cafe1 {
> compatible = "qcom,pon";
> reg = <0xcafe1 0x4000 0xf001 0x1000>;
> };
> simple_dev@2 {
> compatible = "qcom,pon";
> reg = <0x2>;
> interrupts = <51>;
> };
> };
> 
> To me the first example is the most consistent with what Device Tree 
> expects, but I certainly welcome any feedback or additional ideas.
> 
> A separate but related problem is how to convey these bus addresses and 
> interrupt values in a data structure. The of_platform code puts these in 
> a 'struct resource', which is almost exactly what we want here. But the 
> problem is that the semantics of a resource include addresses that are 
> translatable to cpu addresses, and SPMI addresses are not. For example, 
> of_address_to_resource() will fail on this model since it tries to 
> translate the addresses. I can always implement it using more primitive 
> APIs, but the fact that of_address_to_resource() is designed this way 
> makes me think that perhaps 'resources' are not the right mechanism to 
> be using. What is the best way to convey a variable amount of bus 
> addresses and interrupt numbers? Should we invent a new data structure?
> 
> Thanks in advance for any suggestions that people have.
> 
> Mike
> 
