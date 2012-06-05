Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2FEM5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:57:36 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36037 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2FEM5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:57:34 -0400
Date: Tue, 5 Jun 2012 14:57:58 +0200
From: Borislav Petkov <bp@amd64.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
Message-ID: <20120605125758.GD13495@aftab.osrc.amd.com>
References: <20120524174943.989990966@linutronix.de>
 <20120524175056.478167482@linutronix.de>
 <4FCC1F7C.5000008@linux.intel.com>
 <alpine.LFD.2.02.1206042158200.3086@ionos>
 <4FCDF1C8.9020007@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCDF1C8.9020007@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 07:47:20PM +0800, Chen Gong wrote:
> >  static void intel_threshold_interrupt(void)
> >  {
> > +	if (cmci_storm_detect())
> > +		return;
> >  	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
> >  	mce_notify_irq();
> >  }
> 
> I think cmci_storm_detect should be placed in the machine_check_poll,
> not out of it. Because machine_check_poll it the core execution logic
> for CMCI handling, in the meanwhile, poll timer and mce-inject module
> call machine_check_poll at any time.

Are you saying you need CMCI throttling for when you inject MCEs?

> If poll timer or mce-inject run too quickly, the CMCI handler has
> trouble. Whereas, if cmci_storm_detect is in the machine_check_poll,
> this kind of possibility can be avoid.

In any case, cmci_storm_detect() cannot be in machine_check_poll because
last one is generic MCE code and not Intel-only. Unless you do something
like what Thomas proposed for mce_adjust_timer where the default
function does nothing and Intel only overwrites that pointer with the
needed functionality.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
