Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1BWPp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:45:57 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54471 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab1BWPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:45:55 -0500
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
References: <20110223135814.GA1859@mail.hallyn.com>
	<20110217150224.GA26334@mail.hallyn.com> <29677.1298462729@redhat.com>
	<890.1298473574@redhat.com>
Date: Wed, 23 Feb 2011 07:45:49 -0800
In-Reply-To: <890.1298473574@redhat.com> (David Howells's message of "Wed, 23
	Feb 2011 15:06:14 +0000")
Message-ID: <m162sasqj6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+X/e12Pe8L6mK88Pphtu8z4hCHDSltnxo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Howells <dhowells@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: User namespaces and keys
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Serge E. Hallyn <serge@hallyn.com> wrote:
>
>> > I guess we need to look at how to mix keys and namespaces again.
>> 
>> From strictly kernel pov, at the moment, keys are strictly usable only
>> by the user in your own user namespace.
>
> I'm not sure that's currently completely true.  Key quota maintenance is
> namespaced, and the key's owner UID/GID belong to that namespace, so that's
> okay, but:
>
>  (*) key_task_permission() does not distinguish UIDs and GIDs from different
>      namespaces.
>
>  (*) A key can be referred to by its serial number, no matter whose namespace
>      it is in, and will yield up its given UID/GID, even if these aren't
>      actually meaningful in your namespace.
>
>      This means request_key() can successfully upcall at the moment.
>
> I wonder if I should make the following changes:
>
>  (1) If the key and the accessor are in different user namespaces, then skip
>      the UID and GID comparisons in key_task_permission().  That means that to
>      be able to access the key you'd have to possess the key and the key would
>      have to grant you Possessor access, or the key would have to grant you
>      Other access.
>
>  (2) If the key and someone viewing the key description are in different
>      namespaces, then indicate that the UID and the GID are -1, irrespective of
>      the actual values.
>
>  (3) When an upcall is attempting to instantiate a key, it is allowed to access
>      the keys of requestor using the requestor's credentials (UID, GID, groups,
>      security label).  Ensure that this will be done in the requestor's user
>      namespace.
>
>      Nothing should need to be done here, since search_process_keyrings()
>      switches to the requestor's creds.
>
> Oh, and are security labels user-namespaced?

Not at this time.  The user namespace as currently merged is little more
than a place holder for a proper implementation.  Serge is busily
fleshing out that proper implementation.

Until we reach the point where all checks that have historically been
"if (uid1 == uid2)" become "if ((uidns1 == uidns2) && (uid1 == uid2))"
there will be problems.

The security labels and probably lsm's in general need to be per user
namespace but we simply have not gotten that far.  For the short term I
will be happy when we get a minimally usable user namespace.

Eric
