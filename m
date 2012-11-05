Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2KETpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:45:03 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33425 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab2KETpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:45:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>, Peter Jones <pjones@redhat.com>
References: <20121026023916.GA16762@srcf.ucam.org>
	<20121026170609.GB24687@redhat.com>
	<1351276649.18115.217.camel@falcor>
	<20121101131003.GA14573@redhat.com>
	<20121101135356.GA15659@redhat.com> <1351780159.15708.17.camel@falcor>
	<20121101144304.GA15821@redhat.com>
	<20121101145225.GB10269@srcf.ucam.org>
	<20121102132318.GA3300@redhat.com> <87boffd727.fsf@xmission.com>
	<20121105180353.GC28720@redhat.com>
Date: Mon, 05 Nov 2012 11:44:48 -0800
In-Reply-To: <20121105180353.GC28720@redhat.com> (Vivek Goyal's message of
	"Mon, 5 Nov 2012 13:03:53 -0500")
Message-ID: <87mwyv96mn.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/QV22LEvr+8gXGWSOo8BSU//IT11vksSw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Kdump with signed images
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, Nov 02, 2012 at 02:32:48PM -0700, Eric W. Biederman wrote:
>> 
>> It needs to be checked but /sbin/kexec should not use any functions that
>> trigger nss switch.  No user or password or host name lookup should be
>> happening.
>
> I also think that we don't call routines which trigger nss switch but
> be probably can't rely on that as somebody might introduce it in
> future. So we need more robust mechanism to prevent it than just code
> inspection.

The fact that we shouldn't use those routines is enough to let us
walk down a path where they are not used.  Either with a static glibc
linked told to use no nss modules (--enable-static-nss ?), or with
another more restricted libc.

>> This is one part in hardening /sbin/kexec to deal with hostile root
>> users.  We need to check crazy things like do the files we open on /proc
>> actually point to /proc after we have opened them.
>
> Can you please explain it more. How can one fiddle with /proc. Also
> what's the solution then.

The solution is to just fstat the files and verify the filesystem from
which they came after the files have been opened.

The issue is that an evil root user may have mounted something else on /proc.

>> I believe glibc has some code which triggers for suid root applications
>> that we should ensure gets triggered that avoid trusting things like
>> LD_LIBRARY_PATH and company.
>
> I guess linking statically with uClibc or klibc (as hpa said), might turn
> out to be better option to avoid all the issues w.r.t shared objects
> and all the tricky environment variables.

Linking with a more restricted libc will solve most if not all shared
object issues.

We still need to audit our environment variable issue.  How we interpret
them and how our restricted libc automatically interprets them.

Eric
