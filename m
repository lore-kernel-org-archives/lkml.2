Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab2FSXiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:38:13 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43752 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab2FSXiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:38:12 -0400
Date: Wed, 20 Jun 2012 01:38:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] x86, microcode: Sanitize per-cpu microcode reloading
 interface
Message-ID: <20120619233810.GI5996@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-2-git-send-email-bp@amd64.org>
 <CANDHA0iu+QtQn=UxjpN34U=Ob4ABkZc4VWpPT5EidAgZm59JJQ@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C712200773763E@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C712200773763E@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 11:15:56PM +0000, Yu, Fenghua wrote:
> > diff --git a/arch/x86/kernel/microcode_core.c
> > b/arch/x86/kernel/microcode_core.c
> > index fbdfc6917180..24b852b61be3 100644
> > --- a/arch/x86/kernel/microcode_core.c
> > +++ b/arch/x86/kernel/microcode_core.c
> > @@ -298,19 +298,31 @@ static ssize_t reload_store(struct device *dev,
> >  			    const char *buf, size_t size)
> >  {
> >  	unsigned long val;
> > -	int cpu = dev->id;
> > -	ssize_t ret = 0;
> > +	int cpu;
> > +	ssize_t ret = 0, tmp_ret;
> > +
> > +	/* allow reload only from the BSP */
> > +	if (boot_cpu_data.cpu_index != dev->id)
> > +		return -EINVAL;
> 
> With the /sys/devices/system/cpu/microcode/reload interface in your
> patch 2/2, this will be broken, right?

Actually it works per chance and passed testing. And I think I know why:
now the reload sysfs node is not per-cpu, this dev->id is always 0 and
thus the check passes.

> With the new interface, reload_store() can be executed on any cpu or
> dev. I think you need to remove this check if working with the patch
> 2/2.

But you're right, will fix.

Thanks for the review.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
