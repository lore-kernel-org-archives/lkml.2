Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2FTNSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:18:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:46721 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2FTNSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:18:37 -0400
Date: Wed, 20 Jun 2012 15:18:35 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620131835.GB11404@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619232857.GH5996@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 01:28:57AM +0200, Borislav Petkov wrote:
> But you're right, reordering the registration could simplify the code.
> I'll take a look at it tomorrow.

Actually, IINM, the code doesn't become simpler - just different because
if sysfs_create_group() fails, then you have to do microcode_dev_exit().
Pasting here the whole snippet:

...
        error = microcode_dev_init();
        if (error)
                goto out_driver;

        error = sysfs_create_group(&cpu_subsys.dev_root->kobj,
                                   &cpu_root_microcode_group);

        if (error) {
                pr_err("Error creating microcode group!\n");
                goto out_dev_misc;				<--- we need to undo what microcode_dev_init() did here...
        }

        register_syscore_ops(&mc_syscore_ops);
        register_hotcpu_notifier(&mc_cpu_notifier);

        pr_info("Microcode Update Driver: v" MICROCODE_VERSION
                " <tigran@aivazian.fsnet.co.uk>, Peter Oruba\n");

        return 0;

 out_dev_misc:
        microcode_dev_exit();					<--- and we do it here

 out_driver:
...

Now, if we get to remove the crappy misc dev interface, then we can
simplify the whole thing. But for that I need a statement from Intel
people how they want to load ucode and whether they want to split the
firmware blob or keep it together and load the whole 1.2MB at once.

So I'll keep the error unwind as it was in the original patch.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
