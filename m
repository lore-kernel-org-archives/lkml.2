Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1BWXyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:54:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52754 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1BWXyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:54:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
References: <m1lj16ih0n.fsf@fess.ebiederm.org>
	<20110217150257.GA26395@mail.hallyn.com>
	<20110217150224.GA26334@mail.hallyn.com> <3139.1298481393@redhat.com>
	<8559.1298503148@redhat.com>
Date: Wed, 23 Feb 2011 15:54:12 -0800
In-Reply-To: <8559.1298503148@redhat.com> (David Howells's message of "Wed, 23
	Feb 2011 23:19:08 +0000")
Message-ID: <m162sagvdn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ch1LWNmp9uAoXVsUQLVD6+PMt7mtuRVc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Howells <dhowells@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/9] Add a user_namespace as creator/owner of uts_namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> > Which means that unless the uts_namespace belongs to our user_namespace, we
>> > cannot change it.  Is that correct?
>> 
>> No.  If you are root in a parent namespace you can also change it.
>
> But surely, by definition, if you're a user in this namespace, you can't also
> be root in a parent namespace...

To be clear the case you looked at was:

> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
> 
> what is it you're actually asking?  I presume it's 'does this user have
> CAP_SYS_ADMIN capability over objects belonging to the uts_namespace's
> user_namespace?'

Here "current->nsproxy->uts_ns->user_ns" (the target_ns value) is only
refers to the uts_ns we are talking about.

The user itself comes from current_user().

> For the case I worked through current_user() is a member of current_user_ns()
> and can't also be a member of its parent, grandparent, etc. - or can
> it?

Right now if you are looking at current_user() because of limitations in
the creation ordering I think you are correct. 

However in the near term pile of changes to merge, are the syscalls for
joining an existing namespace.  At which point there is no reason in
general to suppose the current limitations of creation apply.

Although it is conceivable that unshare of namespaces can also get you
to someplace similar to joining prexisting namespaces.

Eric
