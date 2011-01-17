Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1AQDQL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 22:16:11 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58643 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1AQDQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 22:16:08 -0500
MIME-Version: 1.0
In-Reply-To: <1295034658.2816.16.camel@localhost.localdomain>
References: <1294266337.3237.45.camel@localhost.localdomain>
	<20110111220201.GA6446@localhost>
	<1295034658.2816.16.camel@localhost.localdomain>
Date: Sun, 16 Jan 2011 19:16:07 -0800
X-Google-Sender-Auth: 3Q01PZD-klpvWDp5m-999Q19G10
Message-ID: <AANLkTik07sOb8oQThFPLvAnQLXbyPJ+oqtqE2SMX2erk@mail.gmail.com>
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Eric Paris <eparis@redhat.com>
Cc: "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, sgrubb@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being the someone else, I'll elaborate my previously offline:

   Nacked-by: Andrew G. Morgan <morgan@kernel.org>

further...

I'm not a supporter of system-wide security contexts changing under
running programs. Previous experience has taught me that tricking a
program into thinking it has one sort of privilege and then
withdrawing it without notice can be dangerous. Since privileged
programs include shells that invoke privileged commands to perform
system admin tasks, I consider a global bounding set to be trouble in
the making. I'm also concerned that an attacker tinkering with the
global bounding set can make remote administration of a machine
(rebooting say) impossible. We have 'kill' for 'sorry, you can't have
that privilege and preventing further damage', its nice and
synchronous and has auditable semantics.

Saying no, however, is not very constructive and I can't argue that
there isn't a privilege escalation issue with the kernel loading
modules and running helpers. If I can't support a global bounding set,
what can I suggest instead? This is why I've been quiet... I've been
thinking.

My first observation may seem odd, but I have to ask why init has a
special privilege enabling mechanism vs. that used for normal
binaries. Naively, I would think that since it is run as root, and
root is (by default) all-capable, the root-fixup code in the generic
exec path would cause init to run with pE=pP=~0 anyway. There was a
time when init was run with one capability suppressed from the pE set,
but the meaning of this capability has changed dramatically since then
so I'm not sure that suppression is needed any longer.

If we were to delete that special code what I think is missing from
the current kernel model, is not a global bounding set, but a 'kernel
auto-exec' securebits value. One that can be set by an admin at
runtime to suppress the root-is-all-capable behavior of the auto-exec
process, and defer the privilege escalation to carefully audited file
capabilities on the relevant helper binaries.

There is probably more detail needed for this idea, but from the
perspective of a root-is-impotent kernel configuration this seems much
more consistent to me.

Hope that clarifies my nack for this global-bounding set kernel change.

Cheers

Andrew

On Fri, Jan 14, 2011 at 11:50 AM, Eric Paris <eparis@redhat.com> wrote:
> On Tue, 2011-01-11 at 16:02 -0600, Serge E. Hallyn wrote:
>> Quoting Eric Paris (eparis@redhat.com):
>
>> > @@ -305,6 +310,8 @@ static inline int bprm_caps_from_vfs_caps(struct cpu_vfs_cap_data *caps,
>> >             new->cap_permitted.cap[i] =
>> >                     (new->cap_bset.cap[i] & permitted) |
>> >                     (new->cap_inheritable.cap[i] & inheritable);
>> > +           /* the global set is global damn it */
>> > +           new->cap_permitted.cap[i] &= global_cap_bset.cap[i];
>>
>> [ If I'm thinking right: ]
>>
>> Global may be global, but you're changing the formula (here, for a
>> non-root task executing a file with filecaps) from
>>
>>       pP' = (X & fP) | (pI & fI)
>>
>> to
>>
>>       A  = (X & FP) | (pI & fI)
>>       pP'= Z & A                    // Z == global bounding set
>>
>> In other words, you are not simply enforcing "the intersection of
>> the global and per-process bounding sets".
>>
>> Whereas,
>>
>> >             if (permitted & ~new->cap_permitted.cap[i])
>> >                     /* insufficient to execute correctly */
>> > @@ -438,6 +445,9 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
>> >             return ret;
>> >
>> >     if (!issecure(SECURE_NOROOT)) {
>> > +           kernel_cap_t bset = cap_intersect(old->cap_bset,
>> > +                                             global_cap_bset);
>> > +
>> >             /*
>> >              * If the legacy file capability is set, then don't set privs
>> >              * for a setuid root binary run by a non-root user.  Do set it
>> > @@ -456,8 +466,7 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
>> >              */
>> >             if (new->euid == 0 || new->uid == 0) {
>> >                     /* pP' = (cap_bset & ~0) | (pI & ~0) */
>> > -                   new->cap_permitted = cap_combine(old->cap_bset,
>> > -                                                    old->cap_inheritable);
>> > +                   new->cap_permitted = cap_combine(bset, old->cap_inheritable);
>>
>> here (for a root task) you are using
>>
>>       pP' = (Z & X) | pI
>>
>> So the inheritable tasks get masked with the global bounding set for
>> non-root tasks, but not for root tasks.
>
> I believe you are thinking correctly and I am wrong.  Someone else has
> some other issues with the patch but would prefer to keep that
> conversation offline.  I will certainly be back with changes and
> explanation of changes (hopefully shortly)
>
> Thanks Serge!
>
> -Eric
>
>
