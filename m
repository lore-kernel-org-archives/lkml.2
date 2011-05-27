Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab1E0UTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:19:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39376 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1E0UTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=xtfx.me; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type:content-transfer-encoding;
        b=cm4bVG8WRs5Svk35g5hMtjJ7Yi5DpA9vo7lB5R6Oxjvk0g4IniHKnVuFlcuvDaBWrI
         1iAvpf/BQ8019now3Be4M0PEhkAQXEpXGVbUVJObvpahtF9M4ui4UX96JyD+WYKUGol1
         VfOq9bjWsUdV6LF3ek7RiSRWo17Q7xriZo0F8=
MIME-Version: 1.0
X-Originating-IP: [98.103.195.251]
In-Reply-To: <m17h9e1h9e.fsf@fess.ebiederm.org>
References: <m1wrhh3z62.fsf@fess.ebiederm.org> <BANLkTikW4vJbC8kcLSKuemUBbu36SO6hwg@mail.gmail.com>
 <20110525213806.GA4590@mail.hallyn.com> <BANLkTinbw6pZjhMscfXFMArd=XU=VC=+eQ@mail.gmail.com>
 <m17h9e1h9e.fsf@fess.ebiederm.org>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Fri, 27 May 2011 15:18:45 -0500
Message-ID: <BANLkTimXMaYe9OYNhqPCiNnG2CqaQOt-yw@mail.gmail.com>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 6:40 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> C Anthony Risinger <anthony@xtfx.me> writes:
>
>> On Wed, May 25, 2011 at 4:38 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>>> Quoting C Anthony Risinger (anthony@xtfx.me):
>>>> On Mon, May 23, 2011 at 4:05 PM, Eric W. Biederman
>>>> <ebiederm@xmission.com> wrote:
>>>> >
>>>> > This tree adds the files /proc/<pid>/ns/net, /proc/<pid>/ns/ipc,
>>>> > /proc/<pid>/ns/uts that can be opened to refer to the namespaces of a
>>>> > process at the time those files are opened, and can be bind mounted to
>>>> > keep the specified namespace alive without a process.
>>>> >
>>>> > This tree adds the setns system call that can be used to change the
>>>> > specified namespace of a process to the namespace specified by a system
>>>> > call.
>>>>
>>>> i just have a quick question regarding these, apologies if wrong place
>>>> to respond -- i trimmed to lists only.
>>>>
>>>> if i understand correctly, mount namespaces (for example), allow one
>>>> to build such constructs as "private /tmp" and similar that even
>>>> `root` cannot access ... and there are many reasons `root` does not
>>>> deserve to completely know/interact with user processes (FUSE makes a
>>>> good example ... just because i [user] have SSH access to a machine,
>>>> why should `root`?)
>>>>
>>>> would these /proc additions break such guarantees?  IOW, would it now
>>>> become possible for `root` to inject stuff into my private namespaces,
>>>> and/or has these guarantees never existed and i am mistaken?  is there
>>>> any kind of ACL mechanism that endows the origin process (or similar)
>>>> with the ability to dictate who can hold and/or interact with these
>>>> references?
>>>
>>> If for instance you have a file open in your private /tmp, then root
>>> in another mounts ns can open the file through /proc/$$/fd/N anyway.
>>> If it's a directory, he can now traverse the whole fs.
>>
>> aaah right :-( ... there's always another way isn't there ... curse
>> you Linux for being so flexible! (just kidding baby i love you)
>
> Even more significant the access to the new files is guarded by the
> ptrace access checks.  And if root can ptrace your process root
> can remote control your process.
>
>> this seems like a more fundamental issue then?  or should i not expect
>> to be able to achieve separation like this?  i ask in the context of
>> OS virt via cgroups + namespaces, eg. LXC et al, because i'm about to
>> perform a massive overhaul to our crusty sub-2.6.18 infrastructure and
>> i've used/followed these technologies for couple years now ... and
>> it's starting to feel like "the right time".
>
> I don't think anything really new is allowed, but we haven't designed
> anything that radically reduces the power of root either.
>
> At some point we may have the user namespace done and that should
> give you a root like user with vastly reduced powers, but we aren't
> there yet.

ok -- i knew there was some user namespace work still left for a
namespaced root -- i was specifically thinking of the root user in the
host.  i was under the impression that namespaces could achieve
separation even from the host (save the kernel itself) ... but it
seems i was mistaken ... still much to learn about Linux i suppose,
even though i use it everyday for years and years :-)  it kind of
makes sense i guess, since maybe the host needs supervisory powers
over the guests?  could be some merit for real separation in the
future (not only malevolent root host user, but say an attacker/script
that manages to break thru container?), though how possible i dont
know.  i wouldnt expect the root user to be prevented from killing/etc
the container, but maybe only prevented from snooping, eg. the
container looks like a black box that he may only resource control or
kill completely.  either way, what we have is just fine for my (and
likely many other's) uses.

anyways, thanks for all the answers and all the work on
namespacing/cgroups ... very useful constructs for a wide array of
problems.

-- 

C Anthony
