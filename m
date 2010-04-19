Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab0DSWCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:02:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46814 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab0DSWCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=hWiCa/SCFfpESvw4er7yblMHdL/y/I+NDefj6GUz049pJZBlznXWsocRjyX6mRLHDv
         i3SZP/OWvoS1urRpbaF/bLUIB0OSjYDd+RS8RPQYuVJgBuoKVGbFy4FqdjFIF//rVX/W
         VKTS349kZOZS7B6mKxNAMynpS5321p3blQAmI=
MIME-Version: 1.0
In-Reply-To: <20100419213952.GA28494@hallyn.com>
References: <cover.1269610458.git.luto@mit.edu> <20100419172639.GA15800@us.ibm.com> 
	<n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com> 
	<20100419213952.GA28494@hallyn.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 19 Apr 2010 18:02:22 -0400
X-Google-Sender-Auth: 849cc5ed7571943c
Message-ID: <g2xcb0375e11004191502h7ab186d2nc692ff749a4a2c99@mail.gmail.com>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 5:39 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Andrew Lutomirski (luto@mit.edu):
>> >
>> > ( I did like using new securebits as in [2], but I prefer the
>> > automatic not-raising-privs of [1] to simply -EPERM on uid/gid
>> > change and lack kof checking for privs raising of [2]. )
>> >
>> > Really the trick will be finding a balance to satisfy those wanting
>> > this as a separate LSM, without traipsing into LSM stacking territory.
>>
>> I think that making this an LSM is absurd.  Containers (and anything
>> else people want to do with namespaces or with other new features that
>> interact badly with setuid) are features that people should be able to
>
> Yes, but that's a reason to aim for targeted caps.  Exec_nopriv or
> whatever is more a sandbox than a namespace feature.
>
>> use easily, and system's choice of LSM shouldn't have anything to do
>> with them.  Not to mention that we're trying to *add* rights (e.g.
>> unprivileged unshare), and LSM is about *removing* rights.

Is a targeted cap something like "process A can call setdomainname,
but only on one particular UTS namespace?"

>>
>> >
>> > I myself think this feature fits very nicely with established semantics,
>> > but not everyone agrees, so chances are my view is a bit tainted, and
>> > we should defer to those wanting this to be an LSM.
>> >
>> > Of course, another alternative is to skip this feature altogether and
>> > push toward targeted capabilties. ?The problem is that path amounts
>> > to playing whack-a-mole to catch all the places where privilege might
>> > leak to a parent namespace, whereas [1] simply, cleanly cuts them all
>> > off at the source.
>>
>> Agreed, that sounds painful.  My secret goal is real
>> userspace-controlled (by unprivileged users, no less) sandboxes, in
>> which case in-kernel target capabilities are probably impossible.
>
> Not sure what you mean by that last part - inside the sandbox, you won't
> get capabilities, targeted or otherwise, but certainly targeted capabilities
> and a sandbox are not mutually exclusive.

Agreed.

What I want is a syscall that says "make me a sandbox" and then for
that program to be able to intercept and modify most (all?) syscalls
issued from inside the sandbox.  But programs in the sandbox probably
need to call exec, and if the sandbox's owner can muck around with
exec'd programs, then exec had better have no security effect.  Hence
a need for  some kind of restricted exec.  The sandbox owner would
then make up own targeted capabilities if needed.

But yes, targeted capabilities for kernel containers are probably
orthogonal to sandboxes.

>
> Thanks for responding, I'll take another look at your patchset in detail.

Thanks!

--Andy
