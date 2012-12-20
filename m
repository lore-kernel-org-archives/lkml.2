Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2LTBVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:21:36 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60147 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2LTBVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:21:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        linux-mm@kvack.org
References: <20121210103913.020858db777e2f48c59713b6@mxc.nes.nec.co.jp>
	<20121219161856.e6aa984f.akpm@linux-foundation.org>
	<878v8ty200.fsf@xmission.com>
	<20121219170038.f7b260c3.akpm@linux-foundation.org>
Date: Wed, 19 Dec 2012 17:20:42 -0800
In-Reply-To: <20121219170038.f7b260c3.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 19 Dec 2012 17:00:38 -0800")
Message-ID: <87ip7xwmc5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+uTuB+loBUxYg/h9wmBemOru1GJg/SAj8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] Add the values related to buddy system for filtering free pages.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 19 Dec 2012 16:57:03 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> > Is there any way in which we can move some of this logic into the
>> > kernel?  In this case, add some kernel code which uses PageBuddy() on
>> > behalf of makedumpfile, rather than replicating the PageBuddy() logic
>> > in userspace?
>> 
>> All that exists when makedumpfile runs is a core file.  So it would have
>> to be something like a share library that builds with the kernel and
>> then makedumpfile loads.
>
> Can we omit free pages from that core file?
>
> And/or add a section to that core file which flags free pages?

Ommitting pages is what makedumpfile does.

Very loosely shortly after boot when things are running fine /sbin/kexec
runs.

/sbin/kexec constructs a set of elf headers that describe where the
memory is and load the crashdump kernel an initrd and those elf headers
into memory.

Years later when the running kernel calls panic.
panic calls machine_kexec
machine_kexec jmps to the preloaded crashdump kernel.

I think it is /proc/vmcore that reads the elf headers out of memory and
presents them to userspace.

Then we have options.
vmcore-to-dmesg will just read the dmesg ring buffer so we have that.

makedumpfile reads the kernel data structures and filters out the free
pages for people who don't want to write everything to disk.

So the basic interface is strongly kernel version agnostic.  The
challenge is how to filter out undesirable pages from the core dump
quickly and reliably.

Right now what we have are a set of ELF notes that describe struct page.

For my uses I have either had enough disk space that saving everything
didn't matter or so little disk space that all I could afford was
getting out the dmesg ring buffer.  So I don't know how robust the
solution adopted by makedumpfile is.

Eric
