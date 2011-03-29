Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1C2MJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:09:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44416 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1C2MJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:09:01 -0400
Date: Tue, 29 Mar 2011 08:08:56 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: TPM chip prevents machine from suspending
Message-ID: <20110329080856.1726dfaa@tlielax.poochiereds.net>
In-Reply-To: <4D91157F.2020502@linux.vnet.ibm.com>
References: <20110328100846.0ba2e039@tlielax.poochiereds.net>
	<4D90C472.3090908@linux.vnet.ibm.com>
	<20110328141241.06a435f8@tlielax.poochiereds.net>
	<20110328154543.1bb979fd@tlielax.poochiereds.net>
	<4D91157F.2020502@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 19:10:55 -0400
Stefan Berger <stefanb@linux.vnet.ibm.com> wrote:

> Ok, so this error code means TPM_INVALID_POSTINIT  (not a posix code) 
> and means that this command was received in the wrong sequence relative 
> to a TPM_Startup command. Well, what's supposed to be happening is this:
> 
> When the machines (S3) suspends then the OS needs to send a 
> TPM_SaveState() to the TPM. This is done by the Linux driver. Once the 
> VM resumes, the BIOS is supposed to send a TPM_Startup(ST_STATE) to the TPM.
> 
> Now the fun starts when a BIOS isn't doing that (even though the spec 
> says it's supposed to), which could very well be the case in your case 
> (don't know what broken BIOSes are out there...  Did it ever work before 
> with the TPM driver in the kernel ?). I could try to send you a small 
> tool that you would have to run from user space upon resume so that we 
> can see that this error goes away. If that's verified we could 
> subsequently write a patch for the TPM driver to also send the 
> TPM_Startup(ST_STATE) to the TPM, which then in the case of most BIOSes 
> would be the 2nd time that the TPM receives such a command. I think TPMs 
> should be able to digest this 2nd TPM_Startup() well, but I'd have to 
> check -- but really we would ill-fix it just because of one (possibly) 
> buggy BIOS.
> 
> The failure of the 2nd suspend then likely stems from the TPM not 
> accepting the TPM_SaveState() anymore since it hasn't seen the 
> TPM_Startup(ST_STATE) that we expected the BIOS to send.
> 

Yep. That program fixed the problem. When I run it after a resume, I
can then cat the caps file and get output from it, and the machine will
successfully suspend again.

> Another possibility would be for you to check for BIOS updates from the 
> laptop manufacturer...
> 

This is actually a desktop machine and the BIOS for the motherboard is
at the latest version, though it is quite old -- 2007/09/01. For the
record this is a:

     Foxconn 6150BK8MC

I'm actually not using the TPM in this thing at all. I'd be just as
happy if there were some way to disable it. Unfortunately, the option
in the BIOS to do this doesn't seem to actually work. When I set "TPM
Control" in the BIOS to "Disable" it always ends up reset back to "No
Change". I'd report both problems to the mfr, but this thing is long
out of warranty and I'm pretty sure they won't care.

Is there some way short of recompiling with CONFIG_TCG_* turned off
to disable the TPM driver at boot time?

-- 
Jeff Layton <jlayton@poochiereds.net>
