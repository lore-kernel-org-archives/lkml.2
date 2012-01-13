Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2AMGJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 01:09:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55081 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2AMGJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 01:09:08 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrVCv=v2Ria4u3xDQYcv881_-X1aZwH0y-rkZjhGRddKOg@mail.gmail.com>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
	<CAGXu5j+TwmsE9qEb0YLT6o8ZRs7OCWdFviiTW2Q_QdbodK==1Q@mail.gmail.com>
	<CALCETrVCv=v2Ria4u3xDQYcv881_-X1aZwH0y-rkZjhGRddKOg@mail.gmail.com>
Date: Thu, 12 Jan 2012 22:09:03 -0800
X-Google-Sender-Auth: h7Y7zTT1DYiAPa-m50q-gFYjmOU
Message-ID: <CAGXu5jJyBFX07XFOZJ5qgSwGu7KEz4ZK3whFk7RG3G=Pq6To1g@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:02 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Jan 12, 2012 at 9:58 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Jan 12, 2012 at 6:12 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> With this set, a lot of dangerous operations (chroot, unshare, etc)
>>> become a lot less dangerous because there is no possibility of
>>> subverting privileged binaries.
>>>
>>> This patch completely breaks apparmor.  Someone who understands (and
>>> uses) apparmor should fix it or at least give me a hint.
>>>
>>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>> [....]
>>> diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
>>> index c1e18ba..7f480b7 100644
>>> --- a/security/apparmor/domain.c
>>> +++ b/security/apparmor/domain.c
>>> @@ -360,6 +360,9 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
>>>        if (bprm->cred_prepared)
>>>                return 0;
>>>
>>> +       /* XXX: someone who understands apparmor needs to fix this. */
>>> +       BUG_ON(bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS);
>>> +
>>>        cxt = bprm->cred->security;
>>>        BUG_ON(!cxt);
>>>
>>
>> Since apparmor_bprm_set_creds() calls cap_bprm_set_creds() already[1],
>> I think AppArmor needs no changes at all, but John will know better.
>> :)
>
> I think that AppArmor determines what a program is allowed to do by
> looking at the path of the executable.  We don't want newly-executed
> programs to gain permissions because they're a different executable
> when we're in no_new_privs mode, so (if I'm right) something different
> needs to happen.

I'll have to go look more closely. I thought cap_bprm_set_creds() was
already evaluating the new privs and blocking any gained privs with
the changes you were making.

-Kees

-- 
Kees Cook
ChromeOS Security
