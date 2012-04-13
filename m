Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab2DMEZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 00:25:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36238 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2DMEZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 00:25:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1204131414580.22039@tundra.namei.org>
References: <1334267284-19166-1-git-send-email-wad@chromium.org> <alpine.LRH.2.02.1204131414580.22039@tundra.namei.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Apr 2012 21:25:27 -0700
X-Google-Sender-Auth: wdZsbV_vYuOSOib6KU5R2CfU_EE
Message-ID: <CAObL_7ER32AesD6bHk591ss0hTFmp0bjVOKV9oEdhiFwCEVOBA@mail.gmail.com>
Subject: Re: [PATCH v18 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
 from granting privs
To: James Morris <jmorris@namei.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, "David S. Miller" <davem@davemloft.net>,
        hpa@zytor.com, mingo@redhat.com, Oleg Nesterov <oleg@redhat.com>,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, Eric Paris <eparis@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 9:16 PM, James Morris <jmorris@namei.org> wrote:
> On Thu, 12 Apr 2012, Will Drewry wrote:
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index d85b793..0b06685 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -2016,6 +2016,13 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
>>               new_tsec->sid = old_tsec->exec_sid;
>>               /* Reset exec SID on execve. */
>>               new_tsec->exec_sid = 0;
>> +
>> +             /*
>> +              * Minimize confusion: if no_new_privs and a transition is
>> +              * explicitly requested, then fail the exec.
>> +              */
>> +             if (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS)
>> +                     return -EPERM;
>>       } else {
>>               /* Check for a default transition on this program. */
>>               rc = security_transition_sid(old_tsec->sid, isec->sid,
>> @@ -2029,7 +2036,8 @@ static int selinux_bprm_set_creds(struct linux_binprm *bprm)
>>       ad.selinux_audit_data = &sad;
>>       ad.u.path = bprm->file->f_path;
>>
>> -     if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
>> +     if ((bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) ||
>> +         (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS))
>>               new_tsec->sid = old_tsec->sid;
>>
>>       if (new_tsec->sid == old_tsec->sid) {
>> --
>
> What about dynamic transitions in SELinux ?
>

What's a dynamic transition?

--Andy
