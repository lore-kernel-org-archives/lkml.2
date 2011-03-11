Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab1CKODl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:03:41 -0500
Received: from www.tglx.de ([62.245.132.106]:51501 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab1CKODj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:03:39 -0500
Date: Fri, 11 Mar 2011 15:02:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Slaby <jslaby@suse.cz>
cc: Len Brown <lenb@kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Why is max_cstate=1 still needed?
In-Reply-To: <4D7A1322.4050706@suse.cz>
Message-ID: <alpine.LFD.2.00.1103111445520.2787@localhost6.localdomain6>
References: <4D7A1322.4050706@suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Jiri Slaby wrote:
> there are still reports against the latest kernels, that people need to
> pass processor/intel_idle.max_cstate=1 to successfully boot the kernel.
> The symptoms are always the same, until the parameter is specified OR
> until the user presses a key, the system won't boot up.
> 
> This started to appear between 2.6.31 and 2.6.34 (possibly a 2.6.33
> regression) and continues to be reported against the latest stable
> 2.6.37.3. For example:
> https://bugzilla.kernel.org/show_bug.cgi?id=15289
> https://bugzilla.novell.com/show_bug.cgi?id=579932
> https://bugzilla.novell.com/show_bug.cgi?id=673589
> https://bugzilla.novell.com/show_bug.cgi?id=675161
> 
> I see that there were some fixes in .38-rc in this bug report (they look
> unrelated):
> https://bugzilla.kernel.org/show_bug.cgi?id=29992
> 
> Should they give .38-rc a try?

Trying does no damage :(
 
> Any help would be appreciated.

I went through the bug reports briefly. While they all report the same
symptoms (hangs until key pressed) the root cause varies.

   - SMM C1E handler broken (affects AMD only)
   - HPET issues (mostly AMD)
   - The usual ACPI/BIOS madness

On most of those systems nohz=off hides the problem as well as it
prevents deeper power states, so the local apic timer just keeps
ticking and the broadcast via PIT/HPET is not activated. hpet=disable
is another way to work around it.

To be honest we have no real handle on all of this as much of the
wreckage is hidden deep in that black hole of ACPI/BIOS. We grew some
quirks and detection mechanisms over time, but there seems to be a
never ending source of trouble especially as HW vendors seem to add
more power related features into the BIOS. We've seen perf wreckage as
well as some of those abuse performance counters :(

Of course those "features" are only tested against that other OS, some
of them even require a driver counterpart for the other OS. Of course
we have no information about that at all and the HW vendors are
helpful as ever.

Yes, it's sad, but reality.

Thanks,

	tglx
