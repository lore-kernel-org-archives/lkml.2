Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2ISNJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:09:15 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:2665
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580Ab2ISNJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:09:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIzz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MALLUZ-02-4M8-02
X-M-MSG: 
Date: Wed, 19 Sep 2012 15:08:59 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shuah Khan <shuah.khan@hp.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Greg KH <greg@kroah.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <rob@landley.net>, <akpm@linux-foundation.org>, <bhelgaas@google.com>,
        <stern@rowland.harvard.edu>, LKML <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devel@linuxdriverproject.org>,
        <x86@kernel.org>, <shuahkhan@gmail.com>
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20120919130859.GR2505@amd.com>
References: <1347843171.4370.13.camel@lorien2>
 <20120917133937.GC11553@phenom.dumpdata.com>
 <1347897172.3227.61.camel@lorien2>
 <20120917172317.GB15783@phenom.dumpdata.com>
 <1347921915.3227.143.camel@lorien2>
 <20120918133414.GM2505@amd.com>
 <1347997369.2747.68.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347997369.2747.68.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 01:42:49PM -0600, Shuah Khan wrote:
> Are you ok with the system wide and per device error counts I added? Any
> comments on the overall approach?

The general approach of having error counters is fine. But the addresses
allocated/addresses checked thing should be done per allocation and not
with counter comparison for several reasons:

	1. When doing it per-allocation we know exactly which allocation
	   was not checked and can tell the driver developer. The code
	   saves stack-traces for that. This is much more useful than
	   telling the developer 'somewhere you do not check your
	   dma-handles'

	2. Checking this per-allocation gives you the per-device and
	   also the per-driver checking you want.

	3. You don't need to change 'struct device' for that.

There are more reasons, like that this approach fits a lot better to the
general idea of the DMA-API debugging code.

> The approach you suggested will cover the cases where drivers fail to
> check good map cases. We won't able to catch failed maps that get used
> without checks. Are you not concerned about these cases? These could
> cause a silent error with wild writes or could bring the system down. Or
> are you recommending changing the infrastructure to track failed maps as
> well?

It is fine to only check the good-map cases. Think about what
DMA-debugging is good for: It is a tool for driver developers to find
bugs in their code they wouldn't notice otherwise. An unchecked bad-map
case is a bug they would notice otherwise. So if we check only the
good-map cases and warn the driver developers about non-checked
addresses they fix it and make the drivers more robust against failed
allocations, fixing also the bad-map cases.

> I am still pursuing a way to track failed map cases. I combined the flag
> idea with one of the ideas I am looking into. Details below: (if this
> sounds like a reasonable approach, I can do v2 patch and we can discuss
> the code)

Why do you want to track the bad-map cases?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

