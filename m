Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2FSX3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:29:00 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43718 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab2FSX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:28:59 -0400
Date: Wed, 20 Jun 2012 01:28:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120619232857.GH5996@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 11:10:14PM +0000, Yu, Fenghua wrote:
> >  static int __init microcode_init(void)
> >  {
> >  	struct cpuinfo_x86 *c = &cpu_data(0);
> > @@ -559,9 +568,17 @@ static int __init microcode_init(void)
> >  	if (error)
> >  		goto out_pdev;
> > 
> > +	error = sysfs_create_group(&cpu_subsys.dev_root->kobj,
> > +				   &cpu_root_microcode_group);
> > +
> > +	if (error) {
> > +		pr_err("Error creating microcode group!\n");
> > +		goto out_driver;
> > +	}
> > +
> >  	error = microcode_dev_init();
> >  	if (error)
> > -		goto out_driver;
> > +		goto out_ucode_group;
> > 
> If you put sysfs_create_group() after microcode_dev_init(),
> out_ucode_group is unnecessary and code is a bit simpler.
> Microcode_dev_init() doesn't rely on sysfs_create_group() and it's a
> NULL function any way.

I don't think microcode_dev_init() is a NULL function since it depends
on CONFIG_MICROCODE_OLD_INTERFACE and we have it on by default:

config MICROCODE_OLD_INTERFACE
        def_bool y
        depends on MICROCODE

which makes me wonder whether we still need that OLD INTERFACE.
Henrique, any thoughts here?

But you're right, reordering the registration could simplify the code.
I'll take a look at it tomorrow.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
