Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1HEWwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:52:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54992 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1HEWwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:52:11 -0400
Date: Sat, 6 Aug 2011 00:52:07 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3.2 3/3] x86, AMD: Move BSP code to cpu_dev helper
Message-ID: <20110805225207.GA27866@aftab>
References: <1312550110-24160-1-git-send-email-bp@amd64.org>
 <4E3C2405.8090309@zytor.com>
 <20110805175522.GA26217@aftab>
 <20110805180409.GC26217@aftab>
 <4E3C4D8C.1010709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3C4D8C.1010709@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 04:07:40PM -0400, H. Peter Anvin wrote:
> On 08/05/2011 11:04 AM, Borislav Petkov wrote:
> > Move code which is run once on the BSP during boot into the cpu_dev
> > helper.
> > +static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
> > +{
> > +	if (static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> > +
> 
> You can't use static_cpu_has() here, since this code runs before
> alternatives -- it will always be false.  Furthermore, for code that
> only runs once, it is never a win to do patching.

Oh crap, this is a leftover from when run_on_bsp was struct
x86_cpuinit_ops member with no args. And I f*cked it up even then
although I went and got myself a pointer to boot_cpu_data:

+static void __cpuinit amd_run_on_bsp(void)
+{
+       struct cpuinfo_x86 *c = &boot_cpu_data;
+
+       if (static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {

but forgot to use it. Good catch, will fix it tomorrow.

> Arguably bsp_init should be __init and not __cpuinit, but I don't know
> how to make that work with the machinery, and is something that can be
> fixed anyway.

Yeah, how do we do that? struct cpu_dev is __cpuinitconst,
x86_cpuinit_ops is __cpuinitdata.

We could add it to identify_boot_cpu() - there's already some per-vendor
stuff like init_amd_e400_c1e_mask() which wouldn't hurt to be behind a
vendor check. early_identify_cpu() does already the vendor check with
get_cpu_vendor() so later, in identify_cpu() we could add a run_on_bsp()
which is __init and switch/case on the ->x86_vendor inside.

Then we can collect all the run-once-on-the-BSP code in there.

Hmmm..

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
