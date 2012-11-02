Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2KBVdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:33:05 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44173 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2KBVdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:33:01 -0400
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
References: <20121025185520.GA17995@redhat.com>
	<1351214158.18115.186.camel@falcor>
	<20121026023916.GA16762@srcf.ucam.org>
	<20121026170609.GB24687@redhat.com>
	<1351276649.18115.217.camel@falcor>
	<20121101131003.GA14573@redhat.com>
	<20121101135356.GA15659@redhat.com> <1351780159.15708.17.camel@falcor>
	<20121101144304.GA15821@redhat.com>
	<20121101145225.GB10269@srcf.ucam.org>
	<20121102132318.GA3300@redhat.com>
Date: Fri, 02 Nov 2012 14:32:48 -0700
In-Reply-To: <20121102132318.GA3300@redhat.com> (Vivek Goyal's message of
	"Fri, 2 Nov 2012 09:23:19 -0400")
Message-ID: <87boffd727.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18d9e1MJRTCc5Wv080FaESYHgU23+rdGvA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Kdump with signed images
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Nov 01, 2012 at 02:52:25PM +0000, Matthew Garrett wrote:
>> On Thu, Nov 01, 2012 at 10:43:04AM -0400, Vivek Goyal wrote:
>> 
>> > So I think this does satisfy the requirement matthew specified. Isn't it?
>> > Matthew, what do you think?
>> 
>> Sure, if you can ensure that. You'll need to figure out how to get the 
>> build system to sign the userspace binaries and you'll need to ensure 
>> that they're statically linked and don't dlopen anything (including the 
>> nsswitch modules), but otherwise that should work.
>> 
>
> [ CC peter jones ]
>
> Ok, so even if we build kexec-tools statically with glibc, we have the
> issue of name service switch modules. glibc will still do dlopen on
> these modules. So what are options now.
>
> - Sign glibc and associated shared libraries. Do not allow unsigned
>   shared library to dynamically link with signed executable.
>
> - Peter mentioned that work with uClibc for kexec-tools.
>
> I personally think that however hard it is but first option sounds like
> a long term solution. We might have more user space processes which
> we might have to trust a generic solution will help with that. For example,
> we might have to sign and trust qemu at some point of time.
>
> Are there other ways of handing glibc issue?

It needs to be checked but /sbin/kexec should not use any functions that
trigger nss switch.  No user or password or host name lookup should be
happening.

This is one part in hardening /sbin/kexec to deal with hostile root
users.  We need to check crazy things like do the files we open on /proc
actually point to /proc after we have opened them.

I believe glibc has some code which triggers for suid root applications
that we should ensure gets triggered that avoid trusting things like
LD_LIBRARY_PATH and company.

Eric
