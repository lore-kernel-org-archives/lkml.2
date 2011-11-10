Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab1KJQuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:50:40 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:43739
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343Ab1KJQui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:50:38 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4EBC00D2.2030208@freescale.com>
Date: Thu, 10 Nov 2011 10:50:26 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anatolij Gustschin <agust@denx.de>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 02/17] powerpc: Split up PHYS_64BIT config option
 to fix "select" issues
References: <4E42AB6F.1050900@freescale.com> <1320883635-17194-3-git-send-email-Kyle.D.Moffett@boeing.com> <4EBBD9DF.6080100@freescale.com> <501ACA94-491F-43A7-9DCF-485BEE824DD5@boeing.com>
In-Reply-To: <501ACA94-491F-43A7-9DCF-485BEE824DD5@boeing.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moffett, Kyle D wrote:

> Did you look at the existing code?  It's already that complicated:
> 
> config ARCH_PHYS_ADDR_T_64BIT
> 	def_bool PPC64 || PHYS_64BIT

I never understood why we have PHYS_64BIT and ARCH_PHYS_ADDR_T_64BIT, since they mean the same thing.  

> config ARCH_DMA_ADDR_T_64BIT
> 	def_bool ARCH_PHYS_ADDR_T_64BIT
> 
> config {P1022_DS,P2041_RDB,P3041_DS,P3060_QDS,P4080_DS,P5020_DS}
> 	select PHYS_64BIT

I posted a patch to remove the P1022_DS version of this.  I'm in favor of removing it from the other boards and letting the defconfig define it, but Kumar nak'd that idea.

> config PTE_64BIT
> 	bool
> 	depends on 44x || E500 || PPC_86xx
> 	default y if PHYS_64BIT

I think this one is about how our TLB registers look, and it's not related to anything else.

> Even worse, PHYS_64BIT is not set on 64-bit processors, but there is
> a lot of driver code that seems to assume PHYS_64BIT indicates the
> size of "phys_addr_t".

There's a Kconfig option somewhere that takes care of this.

> The big issue is that the Kconfig docs are very clear that "select"
> should not be used on user-visible options (AKA: PHYS_64BIT), and yet
> half the PPC_85xx boards have this tidbit:
> 	select PHYS_64BIT # The DTS has 36-bit addresses

I'm not sure that Kconfig rule is enforceable.  We use 'select' all the time to make sure that our boards enable the options that need to be enabled.  I'd rather see this:

config X
	select A

config Y
	select A

config Z
	select A

than this:

config A
	default y if X | Y | Z

The former is more maintainable and does not allow the option of disabling "A" if someone wants "X".

> I'm totally OK with removing that from all those boards, but to preserve
> the existing behavior (also used by the entire 44x platform) I added the
> new config symbol PHYS_64BIT_DT_REQUIRED, which is used to control
> whether or not the "PHYS_64BIT" option is even visible to the user.
> 
> I originally called it "PHYS_64BIT_REQUIRED", but since all of the
> board comments talked about 36-bit DTS addresses, I added the _DT_.

They're really 64-bit DTS addresses.  The 36 bit is just a hardware quirk of our SOCs.  From the kernel's perspective, there's no difference between 36-bit and 64-bit physical address.

>> There are only two reasons to create a 32-bit kernel:
>>
>> 1) A small performance improvement on systems with 2GB or less.
>> 2) Some SOC devices only support 32-bit physical addresses, so the
>> easiest way to ensure a compatible address is to prohibit memory above
>> 4GB.
> 
> If this is true, then why does PHYS_64BIT have that big ugly list of
> dependencies right now? 

Because Kumar doesn't want to allow 32-bit kernels on our high-end parts.  Like I said, I'm not a fan of that decision.

> I don't know about the other platforms well
> enough to tell what would break by enabling PHYS_64BIT, but I assume
> that something in the past caused that dependency list.

It's just an arbitrary decision.  We don't ship 32-bit DTs for the P4080-class parts, and we don't have a U-Boot configuration option for building a 32-bit compatible U-Boot.

-- 
Timur Tabi
Linux kernel developer at Freescale

