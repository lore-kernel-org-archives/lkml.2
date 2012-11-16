Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab2KPIbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:31:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1739 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2KPIbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:31:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 16 Nov 2012 00:31:06 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: "srinivas.kandagatla@st.com" <srinivas.kandagatla@st.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v8 1/3] Runtime Interpreted Power Sequences
Date: Fri, 16 Nov 2012 17:31:04 +0900
Message-ID: <4423025.WvVzNKlS3r@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50A5F225.6000200@st.com>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com> <1353047903-14363-2-git-send-email-acourbot@nvidia.com> <50A5F225.6000200@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas,

On Friday 16 November 2012 15:58:29 Srinivas KANDAGATLA wrote:
> Hi Alex,
> I am looking forward for this feature to be mainlined,

*cough* Ack *cough* :)

> but I have
> comment on the way the types are tied up to power seq infrastructure.
> I know your use case are limited to using type "delay", "pwm" and "gpio"
> and "regulator", However there are instances where the devices can be
> powered up or reset by writing to special registers or sysconfs or
> something else.
> So My suggestion would be to make these type register them selfs
> dynamically with the power_seq infrastructure so that in future this can
> be extended to other types as-well.
> This trivial change can make a lot of difference for the future chips
> which do thing bit differently.
> ST Microelectronics chips fit it in these category and I guess other
> Vendors have this similar chips.

The current implementation is (purposedly) minimal and will certainly be 
extended. There are other aspects of regulators for instance that should also 
be controllable (voltage comes to mind). And I am totally open to supporting 
new kinds of resources as usage broadens. For this first version I just wanted 
to introduce the feature and minimize the impact should anything (DT 
bindings?) need to change.

I am a little bit skeptical about the purpose of directly accessing registers 
(or any part of the address space) from power sequences. It should at least be 
possible to involve some kind of abstraction. Not necessarily one of the 
currently supported types - but at least something.

The reason is that I'd like to try and avoid direct references to resources 
within sequences as much as possible to make them reusable. If your system has 
two identical devices, you should not need to duplicate their sequences just 
to change a register range from the few steps that make use of it. If you can 
do the same job with, say, a regulator, you can just give it a name, get it at 
runtime using regulator_get() and define it outside of the sequence, in our 
device node.

Of course there might be scenarios where you really need to access a register 
and there is no way to do otherwise, in this case I am open to discussion. But 
before resorting to this I'd like to make that the existing abstraction cannot 
cover the case already.

Alex.

