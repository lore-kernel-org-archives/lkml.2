Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab1GUHLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:11:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52080 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab1GUHLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:11:05 -0400
Date: Thu, 21 Jul 2011 09:10:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: PCI config space accessor functions should not
 ignore the segment argument
Message-ID: <20110721071021.GC9216@elte.hu>
References: <4E258BD6020000780004E3BE@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E258BD6020000780004E3BE@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The access method 1 accessor, as it can be used for extended accesses
> (on AMD systems) instead gets added checks for the passed in segment to
> be zero (returning an error just like out of range values of the other
> arguments would cause).

* Jan Beulich <JBeulich@novell.com> wrote:

> Without this change, the majority of the raw PCI config space access
> functions silently ignore a non-zero segment argument, which is
> certainly wrong.
> 
> Apart from pci_direct_conf1, all other non-MMCFG access methods get
> used only for non-extended accesses (i.e. assigned to raw_pci_ops
> only). Consequently, with the way raw_pci_{read,write}() work, it would
> be a coding error to call these functions with a non-zero segment (with
> the current call flow this cannot happen afaict).
> 
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/pci/ce4100.c   |    4 ++++
>  arch/x86/pci/direct.c   |    6 ++++--
>  arch/x86/pci/numaq_32.c |    2 ++
>  arch/x86/pci/olpc.c     |    4 ++++
>  arch/x86/pci/pcbios.c   |    2 ++
>  5 files changed, 16 insertions(+), 2 deletions(-)
> 
> --- 3.0-rc7/arch/x86/pci/ce4100.c
> +++ 3.0-rc7-x86-pci-access-seg/arch/x86/pci/ce4100.c
> @@ -257,6 +257,8 @@ static int ce4100_conf_read(unsigned int
>  {
>  	int i;
>  
> +	BUG_ON(seg);
> +
>  	if (bus == 1) {
>  		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
>  			if (bus1_fixups[i].dev_func == devfn &&
> @@ -282,6 +284,8 @@ static int ce4100_conf_write(unsigned in
>  {
>  	int i;
>  
> +	BUG_ON(seg);
> +
>  	if (bus == 1) {
>  		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
>  			if (bus1_fixups[i].dev_func == devfn &&
> --- 3.0-rc7/arch/x86/pci/direct.c
> +++ 3.0-rc7-x86-pci-access-seg/arch/x86/pci/direct.c
> @@ -22,7 +22,7 @@ static int pci_conf1_read(unsigned int s
>  {
>  	unsigned long flags;
>  
> -	if ((bus > 255) || (devfn > 255) || (reg > 4095)) {
> +	if (seg || (bus > 255) || (devfn > 255) || (reg > 4095)) {
>  		*value = -1;
>  		return -EINVAL;
>  	}
> @@ -53,7 +53,7 @@ static int pci_conf1_write(unsigned int
>  {
>  	unsigned long flags;
>  
> -	if ((bus > 255) || (devfn > 255) || (reg > 4095))
> +	if (seg || (bus > 255) || (devfn > 255) || (reg > 4095))
>  		return -EINVAL;
>  
>  	raw_spin_lock_irqsave(&pci_config_lock, flags);
> @@ -97,6 +97,7 @@ static int pci_conf2_read(unsigned int s
>  	unsigned long flags;
>  	int dev, fn;
>  
> +	BUG_ON(seg);
>  	if ((bus > 255) || (devfn > 255) || (reg > 255)) {
>  		*value = -1;
>  		return -EINVAL;
> @@ -138,6 +139,7 @@ static int pci_conf2_write(unsigned int
>  	unsigned long flags;
>  	int dev, fn;
>  
> +	BUG_ON(seg);
>  	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
>  		return -EINVAL;
>  
> --- 3.0-rc7/arch/x86/pci/numaq_32.c
> +++ 3.0-rc7-x86-pci-access-seg/arch/x86/pci/numaq_32.c
> @@ -34,6 +34,7 @@ static int pci_conf1_mq_read(unsigned in
>  	unsigned long flags;
>  	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
>  
> +	BUG_ON(seg);
>  	if (!value || (bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255))
>  		return -EINVAL;
>  
> @@ -73,6 +74,7 @@ static int pci_conf1_mq_write(unsigned i
>  	unsigned long flags;
>  	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
>  
> +	BUG_ON(seg);
>  	if ((bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255)) 
>  		return -EINVAL;
>  
> --- 3.0-rc7/arch/x86/pci/olpc.c
> +++ 3.0-rc7-x86-pci-access-seg/arch/x86/pci/olpc.c
> @@ -206,6 +206,8 @@ static int pci_olpc_read(unsigned int se
>  {
>  	uint32_t *addr;
>  
> +	BUG_ON(seg);
> +
>  	/* Use the hardware mechanism for non-simulated devices */
>  	if (!is_simulated(bus, devfn))
>  		return pci_direct_conf1.read(seg, bus, devfn, reg, len, value);
> @@ -264,6 +266,8 @@ static int pci_olpc_read(unsigned int se
>  static int pci_olpc_write(unsigned int seg, unsigned int bus,
>  		unsigned int devfn, int reg, int len, uint32_t value)
>  {
> +	BUG_ON(seg);
> +
>  	/* Use the hardware mechanism for non-simulated devices */
>  	if (!is_simulated(bus, devfn))
>  		return pci_direct_conf1.write(seg, bus, devfn, reg, len, value);
> --- 3.0-rc7/arch/x86/pci/pcbios.c
> +++ 3.0-rc7-x86-pci-access-seg/arch/x86/pci/pcbios.c
> @@ -181,6 +181,7 @@ static int pci_bios_read(unsigned int se
>  	unsigned long flags;
>  	unsigned long bx = (bus << 8) | devfn;
>  
> +	BUG_ON(seg);
>  	if (!value || (bus > 255) || (devfn > 255) || (reg > 255))
>  		return -EINVAL;
>  
> @@ -247,6 +248,7 @@ static int pci_bios_write(unsigned int s
>  	unsigned long flags;
>  	unsigned long bx = (bus << 8) | devfn;
>  
> +	BUG_ON(seg);
>  	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
>  		return -EINVAL;

Not sure we want a BUG_ON() which crashes the box - wouldn't a 
WARN_ON() suffice?

also, the analysis/explanation is a bit incomplete:

> The access method 1 accessor, as it can be used for extended accesses
> (on AMD systems) instead gets added checks for the passed in segment to
> be zero (returning an error just like out of range values of the other
> arguments would cause).

Under what circumstances can this trigger in practice, with the 
current code?

Thanks,

	Ingo
