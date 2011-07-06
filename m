Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab1GFDt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:49:26 -0400
Received: from mail.f5.com ([208.85.210.139]:43163 "EHLO mail.f5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282Ab1GFDtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:49:24 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jul 2011 23:49:23 EDT
X-IronPort-AV: E=Sophos;i="4.65,484,1304294400"; 
   d="scan'208";a="29296949"
From: Jonathan Hawthorne <j.hawthorne@f5.com>
To: "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Vasiliy Kulikov <segoon@openwall.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [kernel-hardening] Re: [RFC v1] implement SL*B and stack
 usercopy runtime checks
Thread-Topic: [kernel-hardening] Re: [RFC v1] implement SL*B and stack
 usercopy runtime checks
Thread-Index: AQHMO45ZOVJ7+e+nCkChDObDhoOn4w==
Date: Wed, 6 Jul 2011 03:39:45 +0000
Message-ID: <CA39234A.70E01%j.hawthorne@f5.com>
In-Reply-To: <CA+55aFzXEoTyK0Sm-y=6xGmLMWzQiSQ7ELJ2-WL_PrP3r44MSg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.12.0.110505
x-originating-ip: [192.168.16.250]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E2B9FF4591BA846A472B5844CF127E2@F5.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus is correct to push back on system call auditing in the general case.
 There should be a trust boundary that contains where we optimize speed at
the cost of security.  Small pockets of trust will best compromise between
speed and security.

In the case of FreeBSD or Solaris, these can be smaller than a single
machine; in fact they may scale from a single process, a process group, to
a physical machine.  Scripted environments can go smaller, giving as
little as a 64KB environment.

Between those pockets of trust, isolated (preferably air-gap) auditors are
a must have.  Auditors from independent vendors are ideal; these minimize
herd failure.

Network auditors are a clear first foundation, but after they do the heavy
lifting at the transaction boundary, statistical auditors between
subsystems would be strategically valuable at a minimal incident cost.
These systems can integrate well with self-balancing health monitors.

But in the tight loops, performance should be king.  If the trust fails to
that point, well, trust can always fail somewhere.  The granularity of the
trust bubbles makes a best effort to contain exploitation or failure in
compromise for throughput and latency.

Systems like MAC (Manditory Access Control) are a good compromise in UNIX
systems.  These audit cross-process communication on an access-list basis
and often benefit from a control plane that merges pattern-plus-remedy
rule sets into a single inspection dictionary and exception handler.

Imagine a coloring system.  Each piece of data is marked with a color.
When two colors of data are used together, the result is tainted by both
colors.  Rules exist that limit the colors that may be mixed on a
case-by-case basis using scenario-oriented configuration scripts.

__
Jonathan Hawthorne | Software Architect
t: +1.206.272.6624 | e: j.hawthorne@f5.com






On 7/3/11 11:27 AM, "Linus Torvalds" <torvalds@linux-foundation.org> wrote:

>That patch is entirely insane. No way in hell will that ever get merged.
>
>copy_to/from_user() is some of the most performance-critical code, and
>runs a *lot*, often for fairly small structures (ie 'fstat()' etc).
>
>Adding random ad-hoc tests to it is entirely inappropriate. Doing so
>unconditionally is insane.
>
>So NAK, NAK, NAK.
>
>If you seriously clean it up (that at a minimum includes things like
>making it configurable using some pretty helper function that just
>compiles away for all the normal cases, and not writing out
>
>   if (!slab_access_ok(to, n) || !stack_access_ok(to, n))
>
>multiple times, for chrissake) it _might_ be acceptable.
>
>But in its current form it's just total crap. It's exactly the kind of
>"crazy security people who don't care about anything BUT security"
>crap that I refuse to see.
>
>Some balance and sanity.
>
>                      Linus

