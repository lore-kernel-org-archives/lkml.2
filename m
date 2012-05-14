Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab2ENRXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:23:40 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45555 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2ENRXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:23:39 -0400
Date: Mon, 14 May 2012 19:23:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] x86/mce: Add instruction recovery signatures to
 mce-severity table
Message-ID: <20120514172323.GD21960@aftab.osrc.amd.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <0e89440bf6444635bde0b876eedd26e5c51f9ca3.1336674796.git.tony.luck@intel.com>
 <4FACC25B.80305@linux.intel.com>
 <3908561D78D1C84285E8C5FCA982C28F192ED617@ORSMSX104.amr.corp.intel.com>
 <20120513100532.GC28863@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192EED4A@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192EED4A@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 04:28:35PM +0000, Luck, Tony wrote:
> > > I'm trying to figure out a quirk for processors that do generate
> > > EIPV=RIPV=0 signature for IFU errors. There are some case where
> > > we can work around the lack of EIPV.
> >
> > __mcheck_cpu_apply_quirks?
> 
> The quirk is a bit more extensive than just setting some flag in there
> for "if (c->x86 == 6 && c->x86_model == 45)". Sometime EIPV isn't set
> because the regs->ip and regs->cs really aren't valid. So  I'll need
> to do something like:
> 
> 	if (we are on Intel family 6 model 45 AND
>           this is a UC=1, PCC=0, AR=1, S=1, ADDRV=1, MCACOD=0x150 error AND
> 	    (virtophys(regs->ip) >> PAGE_SHIFT) == (MC(bank)_ADDR >> PAGE_SHIFT)) {
> 		/* ok to trust CS & IP */
> 		m.mcgstatus |= MCG_STATUS_EIPV;
> 	}

Hmm, maybe add a flag to struct mce or whatever comes handy in that
codepath which says ->on_this_cpu_it_is_ok_to_set_MCG_STATUS_EIPV and
query it in the mce_severity() thing?

Btw, this severities deal could be much more helpful if it were a bunch
of per-vendor, per-bank or whatever function pointers so that you can do
arbitrary filtering there.

> before running through the mce_severity() table lookup.
> 
> x86 doesn't seem to have a "virtophys()" that I can find. Closest is lookup_address(vaddr, level)
> which gets a pte (which is almost all the work).
> 
> Sigh!

What does __pa() do actually?

Oh, that's only for kernel memory, it seems.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
