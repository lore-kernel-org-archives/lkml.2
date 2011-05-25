Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1EYXkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:40:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49688 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1EYXkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:40:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: C Anthony Risinger <anthony@xtfx.me>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <m1wrhh3z62.fsf@fess.ebiederm.org>
	<BANLkTikW4vJbC8kcLSKuemUBbu36SO6hwg@mail.gmail.com>
	<20110525213806.GA4590@mail.hallyn.com>
	<BANLkTinbw6pZjhMscfXFMArd=XU=VC=+eQ@mail.gmail.com>
Date: Wed, 25 May 2011 16:40:13 -0700
In-Reply-To: <BANLkTinbw6pZjhMscfXFMArd=XU=VC=+eQ@mail.gmail.com> (C. Anthony
	Risinger's message of "Wed, 25 May 2011 16:55:02 -0500")
Message-ID: <m17h9e1h9e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18eJHvTQ2x3nu5WydqfbAhUruUfMgY58nQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;C Anthony Risinger <anthony@xtfx.me>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C Anthony Risinger <anthony@xtfx.me> writes:

> On Wed, May 25, 2011 at 4:38 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>> Quoting C Anthony Risinger (anthony@xtfx.me):
>>> On Mon, May 23, 2011 at 4:05 PM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>> >
>>> > This tree adds the files /proc/<pid>/ns/net, /proc/<pid>/ns/ipc,
>>> > /proc/<pid>/ns/uts that can be opened to refer to the namespaces of a
>>> > process at the time those files are opened, and can be bind mounted to
>>> > keep the specified namespace alive without a process.
>>> >
>>> > This tree adds the setns system call that can be used to change the
>>> > specified namespace of a process to the namespace specified by a system
>>> > call.
>>>
>>> i just have a quick question regarding these, apologies if wrong place
>>> to respond -- i trimmed to lists only.
>>>
>>> if i understand correctly, mount namespaces (for example), allow one
>>> to build such constructs as "private /tmp" and similar that even
>>> `root` cannot access ... and there are many reasons `root` does not
>>> deserve to completely know/interact with user processes (FUSE makes a
>>> good example ... just because i [user] have SSH access to a machine,
>>> why should `root`?)
>>>
>>> would these /proc additions break such guarantees?  IOW, would it now
>>> become possible for `root` to inject stuff into my private namespaces,
>>> and/or has these guarantees never existed and i am mistaken?  is there
>>> any kind of ACL mechanism that endows the origin process (or similar)
>>> with the ability to dictate who can hold and/or interact with these
>>> references?
>>
>> If for instance you have a file open in your private /tmp, then root
>> in another mounts ns can open the file through /proc/$$/fd/N anyway.
>> If it's a directory, he can now traverse the whole fs.
>
> aaah right :-( ... there's always another way isn't there ... curse
> you Linux for being so flexible! (just kidding baby i love you)

Even more significant the access to the new files is guarded by the
ptrace access checks.  And if root can ptrace your process root
can remote control your process.

> this seems like a more fundamental issue then?  or should i not expect
> to be able to achieve separation like this?  i ask in the context of
> OS virt via cgroups + namespaces, eg. LXC et al, because i'm about to
> perform a massive overhaul to our crusty sub-2.6.18 infrastructure and
> i've used/followed these technologies for couple years now ... and
> it's starting to feel like "the right time".

I don't think anything really new is allowed, but we haven't designed
anything that radically reduces the power of root either.

At some point we may have the user namespace done and that should
give you a root like user with vastly reduced powers, but we aren't
there yet.

Eric

