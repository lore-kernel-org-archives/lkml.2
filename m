Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1BVQZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:25:53 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:39968 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1BVQZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:25:52 -0500
X-Auth-Info: eckJCJX0J5xZn+PN1pi6luAPeh5lFn8jIrvkn27YQnI=
Message-ID: <4D63E407.3010801@grandegger.com>
Date: Tue, 22 Feb 2011 17:27:51 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/13] mfd: pruss mfd driver.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-2-git-send-email-subhasish@mistralsolutions.com> <20110221163027.GF10686@sortiz-mobl> <37B3755C4AE64BAA805DFBAEBDC3D9E4@subhasishg> <20110222103127.GC30279@sortiz-mobl> <4D639493.1060601@grandegger.com> <20110222113310.GD30279@sortiz-mobl> <C73EA0C998A34C709A8130A50A1C443F@subhasishg>
In-Reply-To: <C73EA0C998A34C709A8130A50A1C443F@subhasishg>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 01:49 PM, Subhasish Ghosh wrote:
> I am not sure if I understood you correctly, but the current sizeof the
> structure da8xx_prusscore_regs  is 0x500.
> 
> Here is a link to the PRUSS memory map:
> http://processors.wiki.ti.com/index.php/PRUSS_Memory_Map
> 
> The offset 0x00007000 is the PRU0 reg offset and 0x00007800 is the PRU1
> reg offset.
> We cannot have a register file larger than this, but lot of space is
> left out, possibly for future development.

What do you mean with "larger than this"? You ioremap the whole space
and unsued space could be filled with padding bytes:

struct pruss_regs {
	u8 ram0[0x0200];
	u8 res0[0x1e00];
	u8 ram1[0x0200];
	u8 res1[0x1e00];
	struct pruss_intc_regs intc;
	struct pruss_core_regs core[2];
};

Then:

  pruss_dev->regs = ioremap(pruss_dev->res->start,
	   	    resource_size(pruss_dev->res));

  __raw_writel(DA8XX_PRUCORE_CONTROL_RESETVAL,
               &pruss_dev->regs.core[pruss_num].control);

That's simple, transparent and save without magic offset handling.

Wolfgang.
