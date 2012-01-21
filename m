Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2AURCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 12:02:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51941 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2AURCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 12:02:07 -0500
Date: Sat, 21 Jan 2012 11:01:57 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: John Hughes <john@atlantech.com>, Jeff Layton <jlayton@poochiereds.net>,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>
Subject: [Sony Vaio TX3] TPM chip prevents machine from suspending a second
 time
Message-ID: <20120121170157.GA18053@burratino>
References: <20110328100846.0ba2e039@tlielax.poochiereds.net>
 <4D90C472.3090908@linux.vnet.ibm.com>
 <20110328141241.06a435f8@tlielax.poochiereds.net>
 <20110328154543.1bb979fd@tlielax.poochiereds.net>
 <4D91157F.2020502@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D91157F.2020502@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan et al,

John Hughes wrote[1]:

> On a sony vaio tx3 when tpm_tis is loaded suspend only works once. 
[...]
> dmesg shows
>
> [ 1859.244142] legacy_suspend(): pnp_bus_suspend+0x0/0x57 returns 38
> [ 1859.244150] PM: Device 00:07 failed to suspend: error 38
> [ 1859.456685] PM: Some devices failed to suspend

Stefan Berger wrote, in response to a similar report[2]:

> Ok, so this error code means TPM_INVALID_POSTINIT  (not a posix
> code) and means that this command was received in the wrong sequence
> relative to a TPM_Startup command. Well, what's supposed to be
> happening is this:
>
> When the machines (S3) suspends then the OS needs to send a
> TPM_SaveState() to the TPM. This is done by the Linux driver. Once
> the VM resumes, the BIOS is supposed to send a TPM_Startup(ST_STATE)
> to the TPM.
>
> Now the fun starts when a BIOS isn't doing that (even though the
> spec says it's supposed to)
[...]
>                                                        I could try
> to send you a small tool that you would have to run from user space
> upon resume so that we can see that this error goes away. If that's
> verified we could subsequently write a patch for the TPM driver to
> also send the TPM_Startup(ST_STATE) to the TPM, which then in the
> case of most BIOSes would be the 2nd time that the TPM receives such
> a command. I think TPMs should be able to digest this 2nd
> TPM_Startup() well, but I'd have to check -- but really we would
> ill-fix it just because of one (possibly) buggy BIOS.

The tool is at [3].  John verified that the tool gets suspend working
reliably on his machine.

[...]
> Well, we now could (once) probe the TPM after the resume and send a test 
> command to it and see whether it returns error code 38 and if so send 
> the TPM_Startup() from the driver -- as a work-around for your broken BIOS.

Versions tested and found to exhibit the problem:

 - Debian 2.6.35~rc6-1~experimental.1 (close to v2.6.35-rc6)
 - Debian 2.6.36-1~experimental.1 (close to v2.6.36)
 - Debian 2.6.37~rc5-1~experimental.3 (close to v2.6.37-rc5)
 - Debian 2.6.37-1 (close to v2.6.37)
 - v3.2-rc2 + Vaio keyboard fixes
 - Debian 3.2.1-1 (close to v3.2.1)
 - v3.3-rc1 + Vaio keyboard fixes

Known problem?  Any hints for getting this to work out of the box?  (If
there's no generic fix, maybe it would be possible to use a quirks
table of some kind?)

Thanks,
Jonathan

[1] http://bugs.debian.org/591031
[2] http://thread.gmane.org/gmane.linux.kernel/1119143/focus=1119476
[3] http://thread.gmane.org/gmane.linux.kernel/1119143/focus=1119495
