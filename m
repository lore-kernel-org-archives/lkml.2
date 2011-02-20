Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1BTLsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 06:48:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40021 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab1BTLsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 06:48:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.37.1 s2disk regression (TPM)
Date: Sun, 20 Feb 2011 12:48:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: stefanb@linux.vnet.ibm.com,
        "linux-pm" <linux-pm@lists.linux-foundation.org>,
        srajiv@linux.vnet.ibm.com, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <4D60E93D.1050205@gmail.com> <4D60F108.9000106@gmail.com> <201102201151.11635.rjw@sisk.pl>
In-Reply-To: <201102201151.11635.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201102201248.10779.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 20, 2011, Rafael J. Wysocki wrote:
> On Sunday, February 20, 2011, Jiri Slaby wrote:
> > On 02/20/2011 11:44 AM, Rafael J. Wysocki wrote:
> > > On Sunday, February 20, 2011, Jiri Slaby wrote:
> > >> Hi,
> > >>
> > >> I'm unable to hibernate 2.6.37.1 unless I rmmod tpm_tis:
> > >> [10974.074587] Suspending console(s) (use no_console_suspend to debug)
> > >> [10974.103073] tpm_tis 00:0c: Operation Timed out
> > >> [10974.103089] legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -62
> > >> [10974.103095] PM: Device 00:0c failed to freeze: error -62
> > >>
> > >> 2.6.37 worked fine. Going to revert 9b29050f8f7 (tpm_tis: Use timeouts
> > >> returned from TPM) for testing.
> > > 
> > > Yes, this has been confirmed to cause suspend regressions to happen
> > 
> > OK, the revert works for me too... Are there any fixes?
> 
> No, and the author and maintainer have not been responding.  If that contiunes,
> I'll simply ask Linus to revert it.

BTW, the first hunk from that commit in drivers/char/tpm/tpm.c seems to be
completely broken:

@@ -577,9 +577,11 @@ duration:
        if (rc)
                return;
 
-       if (be32_to_cpu(tpm_cmd.header.out.return_code)
-           != 3 * sizeof(u32))
+       if (be32_to_cpu(tpm_cmd.header.out.return_code) != 0 ||
+           be32_to_cpu(tpm_cmd.header.out.length)
+           != sizeof(tpm_cmd.header.out) + sizeof(u32) + 3 * sizeof(u32))
                return;
+
        duration_cap = &tpm_cmd.params.getcap_out.cap.duration;
        chip->vendor.duration[TPM_SHORT] =
            usecs_to_jiffies(be32_to_cpu(duration_cap->tpm_short));

Namely, either the old code always returned as a result of the conditional
being removed, or the new code will always return as a result of
the (... != 0) check.  I wonder if there's supposed to be (... == 0) instead?
[And why not to simply use 4*sizeof(u32) FWIW?]

Anyway, it looks like a good revert candidate to me.

Thanks,
Rafael
