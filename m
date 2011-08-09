Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1HINFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:05:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:34949 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1HINFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:05:38 -0400
Date: Tue, 9 Aug 2011 15:05:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] x86, cpu, amd: Add a per-vendor BSP function
Message-ID: <20110809130531.GA26196@aftab>
References: <1312829872-20260-1-git-send-email-bp@amd64.org>
 <1312829872-20260-3-git-send-email-bp@amd64.org>
 <4E404D68.5060507@zytor.com>
 <20110808215713.GB22088@liondog.tnic>
 <4E405F7D.9000701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E405F7D.9000701@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 06:13:17PM -0400, H. Peter Anvin wrote:
> On 08/08/2011 04:57 PM, Borislav Petkov wrote:
> >>
> >> This is totally going backwards.  We *should* be using struct cpu_dev
> >> rather than switch statements for this.
> > 
> > Right, but all the cpu_dev things are annotated with __cpuinitconst
> > because they're used in CONFIG_HOTPLUG_CPU. __init, OTOH, will be
> > discarded once we're done booting. So, we can't convert cpu_dev
> > to __initdata because we need it for cpu hotplug and we want the
> > run_on_bsp() functionality to be __init since it runs once on boot.
> > 
> > Maybe leave cpu_dev in __cpuinit let it have an __init member which is
> > the ->run_on_bsp()? Does that even work?
> > 
> 
> I don't think so, which is a fundamental shortcoming of our way of
> handling these kinds of pointers.  One way to deal with it would be to
> make struct cpu_dev __initconst and copy it into a __cpuinit variable at
> init time.

How about we shut up modpost by allowing __cpuinitconst to reference
__init functions - I mean, __cpuinitconst stays while __init gets
discarded and if we take a special care to not call the ->bsp_on_init()
pointer after boot, I don't see why not. I.e., mimick something like the
__initdata_refok semantics but for __cpuinitconst sections referencing
__init functions.

I.e., something like the clumsy proof-of-concept below:


diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b6e3e87..dc2a411 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -410,7 +410,7 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
+static void __init bsp_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 413c536..f288756 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -865,6 +865,7 @@ static const char *init_exit_sections[] =
 
 /* data section */
 static const char *data_sections[] = { DATA_SECTIONS, NULL };
+static const char *cpuinit_sections[] = { CPU_INIT_SECTIONS, NULL };
 
 
 /* symbols in .data that may refer to init/exit sections */
@@ -943,7 +944,7 @@ const struct sectioncheck sectioncheck[] = {
 	.fromsec = { ALL_XXXINIT_SECTIONS, NULL },
 	.tosec   = { INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_SOME_INIT,
-	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, "*_cpu_dev", NULL },
 },
 /* Do not reference cpuinit code/data from meminit code/data */
 {
@@ -1081,9 +1082,11 @@ static int secref_whitelist(const struct sectioncheck *mismatch,
 
 	/* Check for pattern 2 */
 	if (match(tosec, init_exit_sections) &&
-	    match(fromsec, data_sections) &&
-	    match(fromsym, mismatch->symbol_white_list))
+	    (match(fromsec, data_sections) ||
+	     match(fromsec, cpuinit_sections)) &&
+	    match(fromsym, mismatch->symbol_white_list)) {
 		return 0;
+	}
 
 	/* Check for pattern 3 */
 	if (match(fromsec, head_sections) &&



Hmmm..?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
