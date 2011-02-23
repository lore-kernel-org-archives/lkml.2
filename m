Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab1BWUzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:55:12 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46677 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1BWUzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:55:10 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        David Howells <dhowells@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
References: <20110223135814.GA1859@mail.hallyn.com>
	<20110217150224.GA26334@mail.hallyn.com> <29677.1298462729@redhat.com>
	<890.1298473574@redhat.com> <m162sasqj6.fsf@fess.ebiederm.org>
	<20110223155328.GA21266@peq.hallyn.com>
	<4D655EE4.6030707@schaufler-ca.com>
Date: Wed, 23 Feb 2011 12:55:01 -0800
In-Reply-To: <4D655EE4.6030707@schaufler-ca.com> (Casey Schaufler's message of
	"Wed, 23 Feb 2011 11:24:20 -0800")
Message-ID: <m1k4gqlbdm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+KKQ2LLkuQUHyjyVTzDmxzZ7ADzXfeneQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
Subject: Re: User namespaces and keys
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> I confess that I remain less well educated on namespaces than
> I probably should be, but with what I do know it seems that the
> relationships between user namespaces and LSMs are bound to be
> strained from the beginning. Some LSMs (SELinux and Smack) are
> providing similar sandbox capabilities to what you get from user
> namespaces, but from different directions and with different
> use cases.

Casey I won't argue about the possibility of things being strained, but
I think if we focus on the semantics and not on the end goal of exactly
how the pieces are to be used there can be some reasonable dialog.

>From 10,000 feet an user namespace represents one administrative domain.
uids, gids and other external tokens are all controlled by a single
group with a single security policy.  In that single administrative
domain things like nfs are expected to work without translating uids and
gids.  Before the implementation of user namespaces a single kernel
could not even express the ability of dealing with multiple user
namespaces simultaneously (nfs has usually punted and said despite being
multiple machines you still have to be in the same administrative domain
so the same user identifiers can be used throughout).

>From that principle we have the concept that use assigned/visible
identifiers uid, gid, capabilities, security keys?, security labels?
logically belong to the user namespace.

Which means in implementing there are two pieces of work in implementing
the user namespace.

- Find all of the interesting comparisons and change them from
  "if (id == id)" to "if (userns == userns) && (id == id)".

- Potentially define and handle what happens when you mix user
  namespaces. 

I think for the first round of this we simply want to define lsms
and the user namespace as not mixing or the lsm interfaces only being
visible if you are in the initial user namespace.  Thus reserving the
definition of what happens when you have lsms and multiple user
namespaces as something we can define later.  I expect the proper
definition is something that would allow nested lsm policy.

Regardless.  The namespaces are all about making the identifiers that
processes deal with local to the namespace, while the underlying object
manipulations should not care.

The big advantage of the user namespace is that it is the only way I can
see to get us out of the bind we are in with suid root executables,
where we can not enable new features to untrusted applications that can
change the environment for a suid root executable, because it might
confuse those suid root executables to misusing their power.  Once
inside a user namespace nothing has dangerous powers because even a
root owned process with a full set of capabilities is less powerful than
a guest user outside of the namespace.   No process having dangerous
powers allows us to enable unsharing of other namespaces and potentially
other things that today are restricted with capabilities only because
they can be used to confuse a privileged executable to do something
malicious.

Eric

