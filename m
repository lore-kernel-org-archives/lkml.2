Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1KSJJa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:09:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38216 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1KSJJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:09:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Paris <eparis@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, richard@nod.at,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, dhowells@redhat.com, akpm@linux-foundation.org
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
	<1320445482-8459-7-git-send-email-serge@hallyn.com>
	<1320694510.10093.23.camel@localhost>
	<20111108032902.GA29433@hallyn.com>
	<1320848342.10093.57.camel@localhost>
Date: Sat, 19 Nov 2011 01:10:29 -0800
In-Reply-To: <1320848342.10093.57.camel@localhost> (Eric Paris's message of
	"Wed, 09 Nov 2011 09:19:02 -0500")
Message-ID: <m11ut41nqy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Bv7/3CKOyl3LGHNU1B462+MlUup3VIf0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Paris <eparis@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 6/6] protect cap_netlink_recv from user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> On Tue, 2011-11-08 at 03:29 +0000, Serge E. Hallyn wrote:
>> Quoting Eric Paris (eparis@redhat.com):
>
>> But, regardless, your point is valid in that I'm not tightening down as
>> much as I could.  So how about I don't change the security_netlink_recv()
>> and callers yet, and instead I change cap_netlink_recv() to do:
>> 
>> 	if (!IN_ROOT_USER_NS && !cap_raised(current_cap(), cap))
>
> Actually better thought.  Remove the LSM hook altogether and just use
> capable() in the callers.  This hook, being used this way, was
> introduced in c7bdb545 back when we took the effective perms from the
> skb.  We don't use the skb any more since netlink is synchronous.  This
> is functionally equivalent except the capabilities code checks against
> the init_user_ns (something we want) and it will now set PF_PRIV (which
> also seems like a good thing) Something like:
>
> security: remove the security_netlink_recv hook as it is equivalent to capable()
>     
> Once upon a time netlink was not sync and we had to get the effective
> capabilities from the skb that was being received.  Today we instead get
> the capabilities from the current task.  This has rendered the entire
> purpose of the hook moot as it is now functionally equivalent to the
> capable() call.
>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Darn.  I missed this one went it went past the first time.  Let's do
this.

As Serge pointed out checking against the user namespace of the network
namespace happens to be safe because the subsystems that are brittle
really have problems don't support multiple network namespaces.

Still I like the idea of erring on the conservative side here and
making everything safe.  We can open relax the restrictions later
by using ns_capable.  I want to get to a point where it is safe
for an unprivileged user to create their own user namespace,
and most of that is just getting the capable calls correct.

Eric
