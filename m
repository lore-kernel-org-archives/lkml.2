Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1KVNA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:00:56 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51219 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab1KVNAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:00:54 -0500
Date: Tue, 22 Nov 2011 14:00:48 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Daniel Drake <dsd@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Geode LX boot fails after x86 microcode revision change
Message-ID: <20111122130048.GB11020@aftab>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
 <20111108203116.GF25083@aftab>
 <4EB9A6BC.7050600@zytor.com>
 <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
 <4EB9AAF1.4040103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB9AAF1.4040103@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 02:19:29PM -0800, H. Peter Anvin wrote:
> > If so, then a family check is unavoidable.
> 
> Either that, or make changes so that we can handle exceptions earlier.
> That would be useful for other reasons.

Well, I did some experimenting with this by forcing a guest to #GP on a
rdmsr in kvm. What I got was the early_idt_handler's panic message:

"PANIC: early exception %02lx rip %lx:%lx error %lx cr2 %lx\n"

because of the following boot code flow:

x86_64_start_kernel
|-> ... set_intr_gate           /* register early_idt_handler */
|-> x86_64_start_reservations
    |-> start_kernel
        |-> setup_arch
        |-> early_cpu_init()    /*
				 * this is where we need the extable for
				 * rdmsr_safe
				 */
...
    |-> trap_init()             /* switch to default #GP handler */

and do_general_protection does the actual exception fixup. Now, the
whole setup_arch() is running with the initial traps and only after we
finish it and a bunch of other stuff, we switch to the #GP handler in
trap_init().

>From where I stand, maybe I could try to teach the early_idt_handler in
head_64.S to do fixup_exception() ?

Also, we might need the patches which sort extable at build time too,
which are floating around lkml currently.

Hmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
