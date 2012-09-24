Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2IXCjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 22:39:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42201 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab2IXCjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 22:39:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Jeff Dike <jdike@addtoit.com>
In-Reply-To: <505F864C.2000103@nod.at> (Richard Weinberger's message of "Sun,
	23 Sep 2012 23:59:40 +0200")
References: <87k3vote43.fsf@xmission.com>
	<1348187330-6616-1-git-send-email-ebiederm@xmission.com>
	<1348187330-6616-5-git-send-email-ebiederm@xmission.com>
	<505F864C.2000103@nod.at>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Sun, 23 Sep 2012 19:39:02 -0700
Message-ID: <87obkwxhyx.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+MXa6BTSnoJtxP2w3Rcl13WXdCJzVOBLc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 05/14] userns: Convert hostfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 21.09.2012 02:28, schrieb Eric W. Biederman:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> Cc: Jeff Dike <jdike@addtoit.com>
>> Cc: Richard Weinberger <richard@nod.at>
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>
> Looks sane to me.
>
> Acked-by: Richard Weinberger <richard@nod.at>
>
> BTW: How you do test your user namespace patches?
> Is there a generic way to compare/verify uids within a namespace
> vs. the initial namespace?

I start with a well tested set of primites, and a simple design.

Ultimately the goal is to get the conversion functions make_kuid and
from_kuid inserted into the proper locations.

When user namespaces are enabled kuid_t and uid_t are not assignment
compatible so in most places where something needs to be done I get
a compile error.

If the other value is an internal kernel value I change it's type.
If the other value is a userspace or on disk value I insert a conversion
function.

So as a first approximation I can test just by enabling usernamespace
support and compiling the code.

My second line of defense is to keep my patches simple and easily
reviewable.

I impose upon myself the discipline of letting my patches set for a
while so that I review them with a fresh mind before sending them
out to the list.

I am careful when making my patches to actually read the code and
understand what is going on, so hopefully I catch the tricky cases.

With the user namespace support disabled the code performs the same with
except for the conversion functions so things like my conversion of the
core kernel in 3.5 continue to be tested for correctness in general.

Right now for filesystems I am converting them so they will work when
all of the user space interfaces have values coming to the filesystem in
kuid_t and kgid_t, but the values in the filesystem are stored in
the initial user namespace.  So it is trivial to know that I have
useful the correct conversions.

Since my big question is do I have the conversions in all of the
locations needed, compile errors and the discipline of pushing kuid_t
and kgid_t as deep as possible into the kernel data structures as
possible are my primary means of where conversions need to go.

Beyond that I actually run a kernel with all of my patches applied and I
do some spot testing, and I have had my development tree with everything
patched out for a while so that other people can play with it as well.

I also compile test each patch with allyesconfig and with as much
enabled as I can and still leave the usernamespace support enabled,
ensuring each patch is good and safe on it's own (at least compilewise).

So that is how I test.

As to a generic way to compare/verify uids within a namespace vs the
initial namespace hmm.  I don't know that there is a generic tool.  The
mappings are available in /proc/<pid>/uid_maps, and /proc/<pid>/gid_maps
so it isn't hard to look to see if the expected conversion is happening
by looking from outside the namespace. But there isn't a generic tool
that I know of at this point.

Eric
