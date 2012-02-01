Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab2BAUgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:36:11 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53612 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2BAUfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:35:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jK-4DaUVofwy3aqKnQTbyQGsLVmNNfAc1pjkJHt2Kfwww@mail.gmail.com>
References: <cover.1327858005.git.luto@amacapital.net> <9a520b74ad5dc14a3d6950b6d63a64714adbdd7d.1327858005.git.luto@amacapital.net>
 <CAGXu5jK-4DaUVofwy3aqKnQTbyQGsLVmNNfAc1pjkJHt2Kfwww@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 Feb 2012 12:35:33 -0800
Message-ID: <CALCETrV6eMYGsw-AS+ZwLpTfdzbinJT_3or0hN+R=7PKmai4mg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] Allow unprivileged CLONE_NEWUTS and CLONE_NEWIPC
 with no_new_privs
To: Kees Cook <keescook@chromium.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 11:02 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jan 30, 2012 at 8:17 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> They are normally disallowed because they could be used to subvert
>> setuid programs.  But if setuid is disabled, then they are safe.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  kernel/nsproxy.c |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
>> index b576f7f..47cf873 100644
>> --- a/kernel/nsproxy.c
>> +++ b/kernel/nsproxy.c
>> @@ -191,7 +191,13 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
>>                               CLONE_NEWNET)))
>>                return 0;
>>
>> -       if (!capable(CAP_SYS_ADMIN))
>> +       /* We require either no_new_privs or CAP_SYS_ADMIN for all modes */
>> +       if (!current->no_new_privs && !capable(CAP_SYS_ADMIN))
>> +               return -EPERM;
>> +
>> +       /* NEWNS and NEWNET always require CAP_SYS_ADMIN. */
>> +       if ((unshare_flags & (CLONE_NEWNS | CLONE_NEWNET)) &&
>> +           !capable(CAP_SYS_ADMIN))
>>                return -EPERM;
>>
>>        *new_nsp = create_new_namespaces(unshare_flags, current,
>
> While I think it's unlikely that the list handled by
> unshare_nsproxy_namespaces() is going to change, I'd still prefer that
> the logic of this test be reversed so that the nnp-allowed flags are
> listed instead of the CAP_SYS_ADMIN-required ones so that it will
> default to disallowing new flags. It's a little less readable, but
> maybe something like this (untested):
>
> unsigned long handled_mask = (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
>                                 CLONE_NEWNET);
> unsigned long npp_mask = (CLONE_NEWUTS | CLONE_NEWIPC);
>
> if (!(unshare_flags & handled_mask))
>        return 0;
>
> if (  !(current->no_new_privs &&
>        !(unshare_flags & (handled_mask ^ npp_mask))) &&
>      !capable(CAP_SYS_ADMIN))
>        return -EPERM;
> ...
>
> This also has the side-effect of removing the double-check of
> capable() in some cases.

Agreed -- will fix.

This patch is also missing the corresponding change for clone.  I'll add that.

I'm tempted to add CLONE_NEWPID as well (it's _useful_), but there's
an unresolved issue with SCM_CREDENTIALS.

--Andy
