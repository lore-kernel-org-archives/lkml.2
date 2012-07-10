Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab2GJSgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 14:36:41 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48839 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2GJSgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 14:36:38 -0400
Date: Tue, 10 Jul 2012 20:36:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] x86/mce: Need to let kill_proc() send signal to doomed
 process
Message-ID: <20120710183626.GA4419@aftab.osrc.amd.com>
References: <3908561D78D1C84285E8C5FCA982C28F19348DFF@ORSMSX104.amr.corp.intel.com>
 <f830ac24f491389b0246af0fb31d0546f3583380.1341866155.git.tony.luck@intel.com>
 <20120710154410.GA29892@aftab.osrc.amd.com>
 <CA+8MBbKU5AB5zpYQB6pHegA2V1=8q123fxyFERsHjWCLK5iCsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbKU5AB5zpYQB6pHegA2V1=8q123fxyFERsHjWCLK5iCsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:12:17AM -0700, Tony Luck wrote:
> On Tue, Jul 10, 2012 at 8:44 AM, Borislav Petkov <bp@amd64.org> wrote:
> > Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Thanks for the Ack.
> 
> +       doit = !!PageDirty(ppage) || !!(flags & MF_MUST_KILL);
> 
> Thinking about this some more, the "!!" are redundant
> and are an impediment to readability. We started with
> !!PageDirty(ppage) when we were passing an argument
> directly to kill_procs() and wanted to make sure we had a
> nice boolean value. But the result of the "||" is boolean,
> so we don't need to double negate.
> 
> I'm going to change it to:
>        doit = PageDirty(ppage) || (flags & MF_MUST_KILL);

Ok, so out of curiosity I took a look at compiler output and both
versions are identical:


> +       doit = !!PageDirty(ppage) || !!(flags & MF_MUST_KILL);

	.loc 1 974 0
	movl	$1, %edx	#, doit
	testb	$16, %al	#, D.28886
	jne	.L196	#,
	movl	-196(%rbp), %ecx	# %sfp,
	xorl	%edx, %edx	# doit
	testl	%ecx, %ecx	#
	setne	%dl	#, doit

>        doit = PageDirty(ppage) || (flags & MF_MUST_KILL);

	.loc 1 974 0
	movl	$1, %edx	#, doit
	testb	$16, %al	#, D.28886
	jne	.L196	#,
	movl	-196(%rbp), %ecx	# %sfp,
	xorl	%edx, %edx	# doit
	testl	%ecx, %ecx	#
	setne	%dl	#, doit

In both cases you get your standard shortcutting OR logic:

.loc 1 974 0
	movl	$1, %edx	#, doit		<--- preset doit
	testb	$16, %al	#, D.28886	<--- PG_dirty
	jne	.L196	#,			<--- ZF=0, shortcut out to kill_procs
	movl	-196(%rbp), %ecx	# %sfp, <--- get value of (flags & MF_MUST_KILL) which we computed earlier in the function and saved on stack
	xorl	%edx, %edx	# doit		<--- clear doit
	testl	%ecx, %ecx	#		<--- check above (flags & MF_MUST_KILL) is not 0
	setne	%dl	#, doit			<--- prep doit for kill_procs

so the compiler is pretty smart already.

You could go another step further by declaring

	bool doit;

and changing kill_procs() argument to bool too so that the booleanness
is really explicit.

This saves you the xor:

        .loc 1 975 0
        movl    $1, %edx        #, prephitmp.124
        testb   $16, %al        #, D.28891
        jne     .L196   #,
        movl    -196(%rbp), %ecx        # %sfp,
        testl   %ecx, %ecx      #
        setne   %dl     #, prephitmp.124

because we're using explicitly bools which are u8s, apparently, in this
case and we're reusing the 1 we wrote into edx at the beginning of the
block.

Oh well, enough fun.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
