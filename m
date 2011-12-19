Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1LSXDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:03:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1LSXDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:03:51 -0500
Date: Mon, 19 Dec 2011 18:03:42 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, trenn@suse.de,
        kay.sievers@vrf.org, Andi Kleen <ak@linux.intel.com>,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 08/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111219230341.GA570@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	hpa@zytor.com, trenn@suse.de, kay.sievers@vrf.org,
	Andi Kleen <ak@linux.intel.com>, kay.sievers@vrfy.org
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org>
 <1324334865-30459-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324334865-30459-9-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:47:44PM -0800, Andi Kleen wrote:

 > diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
 > index ffe1f2c..05d0f7f 100644
 > --- a/drivers/cpufreq/gx-suspmod.c
 > +++ b/drivers/cpufreq/gx-suspmod.c
 > @@ -82,6 +82,7 @@
 >  #include <linux/errno.h>
 >  #include <linux/slab.h>
 >  
 > +#include <asm/cpu_device_id.h>
 >  #include <asm/processor-cyrix.h>
 >  
 >  /* PCI config registers, all at F0 */
 > @@ -171,12 +172,20 @@ static struct pci_device_id gx_chipset_tbl[] __initdata = {
 >  	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), },
 >  	{ 0, },
 >  };
 > +/* MODULE_DEVICE_TABLE here too? But the CPU should be enough. */
 >  
 >  static void gx_write_byte(int reg, int value)
 >  {
 >  	pci_write_config_byte(gx_params->cs55x0, reg, value);
 >  }
 >  
 > +static const struct x86_cpu_id gx_ids[] = {
 > +	{ X86_VENDOR_NSC, },
 > +	{ X86_VENDOR_CYRIX },
 > +	{}
 > +};
 > +MODULE_DEVICE_TABLE(x86cpu, gx_ids);
 > +
 >  /**
 >   * gx_detect_chipset:
 >   *
 > @@ -185,12 +194,8 @@ static __init struct pci_dev *gx_detect_chipset(void)
 >  {
 >  	struct pci_dev *gx_pci = NULL;
 >  
 > -	/* check if CPU is a MediaGX or a Geode. */
 > -	if ((boot_cpu_data.x86_vendor != X86_VENDOR_NSC) &&
 > -	    (boot_cpu_data.x86_vendor != X86_VENDOR_CYRIX)) {
 > -		pr_debug("error: no MediaGX/Geode processor found!\n");
 > +	if (!x86_match_cpu(gx_ids))
 >  		return NULL;
 > -	}
 >  
 >  	/* detect which companion chip is used */
 >  	for_each_pci_dev(gx_pci) {

Looking closer at this one, I think we could possibly just autoload based on the PCI IDs
in gx_chipset_tbl, and remove the cpu vendor checking entirely.
Pretty sure those Cyrix PCI devices won't show up anywhere else.

Otherwise, we could narrow the range this gets loaded on to Cyrix Fam 4 model 5, and
NatSemi Fam 5, model 4.  (afaik, that covers all the possible cpus this driver works on)

	Dave

