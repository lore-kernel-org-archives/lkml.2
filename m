Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1FRIia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 04:38:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51545 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab1FRIi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 04:38:26 -0400
Date: Sat, 18 Jun 2011 10:38:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/8] x86, mce: rename bootparam parser
Message-ID: <20110618083820.GA27319@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB13E2.4080909@jp.fujitsu.com>
 <20110617154143.GC20010@aftab>
 <987664A83D2D224EAE907B061CE93D5301E8E3054B@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E8E3054B@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 03:25:51PM -0700, Luck, Tony wrote:
> > and leave this like this. "nomce" is the same as "mce=off" and frankly,
> > I'd like to remove this redundancy, thus no need to do the code
> > relocation. In addition, I don't think there are lots of systems running
> > with "nomce" so I really think we should drop it.
> >
> > So Ingo, hpa, what is the proper way to remove early setup params? Maybe
> > through Documentation/feature-removal-schedule.txt?
> 
> Though it seems odd to me that anyone would want to turn mce off,
> the fact that we have two ways to do so would indicate that people
> do (or at least did) want to do this.

Yeah, the only usecase I could think of for this is people doing their
own userspace DRAM ECC evaluation like google. But they'd still need to
have an #MC handler... or they could parse syslog for the output from
the default unexpected_machine_check().. hm.

> It seems like we'd need a long "deprecated" period (till all the
> major OSVs turn out a new release) to remove this without surprises.
> If the "nomce" option just disappears, then people using it will
> not realize that their boot time argument was ignored (until they
> see a reported error).

Yeah, we could do a grace period with a warning:

/*
 * Old style boot options parsing. Only for compatibility.
 */
static int __init mcheck_disable(char *str)
{
	pr_err("\"nomce\" boot param is deprecated. Please use \"mce=off\"\n");

	mce_disabled = 1;
	return 1;
}
__setup("nomce", mcheck_disable);

and then kill it.

-- 
Regards/Gruss,
    Boris.
