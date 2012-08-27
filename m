Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2H0Osr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 10:48:47 -0400
Received: from mail.x86-64.org ([217.9.48.20]:59920 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab2H0Osn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 10:48:43 -0400
Date: Mon, 27 Aug 2012 16:48:29 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, andi@firstfloor.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/mce: Honour bios-set CMCI threshold
Message-ID: <20120827144829.GF27979@aftab.osrc.amd.com>
References: <20120827112503.10313.62594.stgit@localhost.localdomain>
 <20120827112512.10313.49176.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120827112512.10313.49176.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 04:55:12PM +0530, Naveen N. Rao wrote:
> The ACPI spec doesn't provide for a way for the bios to pass down
> recommended thresholds to the OS on a _per-bank_ basis. This patch adds
> a new boot option, which if passed, allows bios to initialize the CMCI
> threshold. In such a case, we simply skip programming any threshold
> value.
> 
> As fail-safe, we initialize threshold to 1 if some banks have not been
> initialized by the bios and warn the user.
> 
> Changes:
> - Use the mce_boot_flags structure.
> - Expose bios_cmci_threshold via sysfs.
> 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---

...

> @@ -119,6 +146,12 @@ static void cmci_discover(int banks, int boot)
>  	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
>  	if (hdr)
>  		printk(KERN_CONT "\n");
> +	if (boot && mce_boot_flags.bios_cmci_threshold && bios_wrong_thresh) {
> +		printk_once(KERN_INFO
> +			"bios_cmci_threshold: Some banks do not have valid thresholds set");
> +		printk_once(KERN_INFO
> +			"bios_cmci_threshold: Make sure your BIOS supports this boot option");
> +	}

All functional changes aside, why do you want to print this at all? Does
it bring anything to the user?

Because if BIOS is systematically b0rked and we keep issuing this every
time do do cmci_discover, then we have a lotsa users to explain to what
happens.

Why not do a printk_once saying something along the lines of "BIOS
hasn't setup thresholds properly, correcting..." and that's it?

Tony?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
