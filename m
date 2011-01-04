Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1ADQtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:49:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41597 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1ADQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZbCoyeAG1vTd1Lv9fI2LP65Lr6wQ7fGiapBoYfsuLhPs3s2Yejxh7bAw0pRFmnClOI
         bPrgJUIKajM4mDK7E1Z6J3xX59GAWlVKm9bp1CwrfahX0/BB8FPhnALRjq3SK7GtAEBX
         Z2C1BFbvXQwiwQU7FkfMHMq7TAjwFVN986ork=
Message-ID: <4D234F8E.7080102@gmail.com>
Date: Tue, 04 Jan 2011 17:49:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>, steiner@sgi.com
Subject: Re: suspend hangs at platform phase [was: mmotm 2010-12-23-16-58
 uploaded]
References: <201012240132.oBO1W8Ub022207@imap1.linux-foundation.org> <4D232352.2030809@gmail.com>
In-Reply-To: <4D232352.2030809@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 02:40 PM, Jiri Slaby wrote:
> On 12/24/2010 01:58 AM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2010-12-23-16-58 has been uploaded to
> 
> Hi, this kernel regresses with respect to suspend to ram in comparison
> with mmotm 2010-12-16-14-56.
> 
> This is OK:
> echo devices > /sys/power/pm_test
> pm-suspend
> This hangs at suspend phase:
> echo platform > /sys/power/pm_test
> pm-suspend
> 
> Note that this kernel is based on next-20101221. Should I try newer (and
> clean) -next?

Ok, bisected down to:
16dc39c98a6ca56a27f22f7ac6731d8223237a2e is first bad commit
commit 16dc39c98a6ca56a27f22f7ac6731d8223237a2e
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 16 23:12:23 2010 -0500

    ACPI: use ioremap_cache()

    Although the temporary boot-time ACPI table mappings
    were set up with CPU caching enabled, the permanent table
    mappings and AML run-time region memory accesses were
    set up with ioremap(), which on x86 is a synonym for
    ioremap_nocache().

    Changing this to ioremap_cache() improves performance as
    seen when accessing the tables via acpidump,
    or /sys/firmware/acpi/tables.  It should also improve
    AML run-time performance.

    No change on ia64.

    Reported-by: Jack Steiner <steiner@sgi.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

:040000 040000 be35c5e8f214f10f94688c1a27f33ecfb8505220
52581222d0edf190f160f3e5aa5d2c1af8e76988 M      arch
:040000 040000 ccdca0d41938b8312e946cde3c01c59b32d1c17c
96ccf2357f2ac4a31d19cc41f5728d9f87b6cac0 M      drivers

Revert of that patch fixes the problem.

regards,
-- 
js
