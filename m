Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2DXCYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:24:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57761 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab2DXCYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:24:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<1333862139-31737-30-git-send-email-ebiederm@xmission.com>
	<20120418190927.GK5186@mail.hallyn.com>
Date: Mon, 23 Apr 2012 19:28:36 -0700
In-Reply-To: <20120418190927.GK5186@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 18 Apr 2012 19:09:27 +0000")
Message-ID: <m1ehrdrhgr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18wD5Y+iOSiGmKqcHmNhfY9sNLCdxe3TZY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 30/43] userns: Fail exec for suid and sgid binaries with ids outside our user namespace.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Beiderman (ebiederm@xmission.com):
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>
> Oh, perhaps this is the right place in the thread to discuss the issue of
> what to do with file capabilities?  I'm ok waiting until the next iteration
> to even discuss it, so long as we start by refusing setting of fcaps by
> any task not in init_user_ns.

For now we do refuse all callers in the init_user_ns because that path
is protected by a capable and not an ns_capable call.

And as a general policy I have pushed all of the changes from capable to
ns_capable out till after we get these other user namespace bits so we
can get the patches reviewed so hopefully don't enable something that is
not safe.

Let's just note here that when we ever get a filesystem mounted in
something other than the init_user_ns or otherwise allow file
capabilities that do not belong to the init_user_ns we need to an
additional exec check to avoid a security issue for processes in the
init_user_ns using those credentials.

The other direction the init_user_ns setting file caps on a file and use
using them in a child namespace seems safe, and practical because of the
way we handle capabilities.  Aka if you have a capability in an outer
user namespace you also have it in a child user namespace.  Which means
a file cap exec today will give you just the capabilities in the child
user namespace.

Something else to think about when we reach filesystems mounted in
different user namespaces (aka unprivileged mounts) are security
labels on files in different user namespaces.  Not any kind of immediate
concern but something we may have to handle eventually.

Eric
