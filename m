Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3AIUOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:14:46 -0500
Received: from nm16.access.bullet.mail.sp2.yahoo.com ([98.139.44.143]:47365
	"EHLO nm16.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932488Ab3AIUOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:14:42 -0500
X-Yahoo-Newman-Id: 673118.31898.bm@smtp109.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5AkmwSUVM1lSYdt_r_8aKotRvqbmEP02nAl2FoUqQi1wJhD
 EQRW4YrBlEs3iqZIcDJW.Dr2dnxudB.g_Sjpc.JKPSiKKZDYbXtbnzAakQ_2
 fmAu9MIrWqRtZHA5S31.ZzllNtU68V6XInrUMaK8gIithHMi30eOV4hDLV2o
 NeIFrQ7sUR9UmGdB7DRE3nBiwwHJNUmDVJgA8RJGTxVUYYUAw_4ugpKRYwiX
 iD6oBaf5gz85d6DXNcXHS8hyxgHkkifrNKDmAQfghuPR3wLtoLPRiLrKiRgl
 neO4Pl.0JHi3CzgNid04I6q9h_zTxspkOSe15DniyijiHZiIiplDLXHqR4aC
 KBrrPVo.xVoitYJWHjlA2.aMaDRJcEYEvTF7LsmybOedwwe.S.C28ucxNe54
 s6yzlCJLDMuwBmUzju0cpihxsNnst6uCILpmZOykd7s1D7dH0j_esPFXiRAg
 xW_iOb.KTkFDcLkODcAZBzm6AJWhk1SFg
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EDCFC0.3010401@schaufler-ca.com>
Date: Wed, 09 Jan 2013 12:14:56 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, dwalsh@redhat.com,
        dmalcolm@redhat.com, sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Friendlier EPERM - Request for input
References: <1357747463.2593.28.camel@localhost> <1357760637.2593.55.camel@localhost>
In-Reply-To: <1357760637.2593.55.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2013 11:43 AM, Eric Paris wrote:
>> On Wed, 2013-01-09 at 11:04 -0500, Eric Paris wrote:
>>> Getting an EPERM/EACCES in userspace really kinda blows.  As a user you
>>> don't have any idea why you got it.  
> Stephen Smalley wrote:
>> What if the denial was due to lacking sufficient permission to stat
>> the file (in which case you shouldn't leak the file's attributes to the
>> caller)?
>>
>> Also, the present inability of (unprivileged) userspace to distinguish
>> DAC from MAC denials is relied upon to avoid any covert channel when
>> the DAC check happens before the MAC check, as otherwise you leak
>> information about the DAC attributes.  If you are going to indicate to
>> all of userspace whether it was DAC or MAC, you have to make sure that
>> the MAC check / LSM hook always comes first in every case.  Which then
>> leads to lots of unnecessary MAC audit messages that would have been
>> denied by DAC anyway.
> I'd have to fall back to my original thought about who to expose this
> information to:
>
>>> Another thought was that some people might want to turn off the ability
>>> to get this information.  I don't see a reason a sysctl couldn't be used
>>> to disable extended errno information if the admin so chose.
> On systems with a strict security policy worried about such things this
> would quite reasonably need to be disabled.  But most of the reason
> people turn off LSMs is because it gets in the way and they get pissed
> getting an EPERM, checking rwx bits, having no idea WTF happened, and
> then being REALLY pissed at the LSM when they figure out that was the
> problem.  I want to put it right there, out front, here is what went
> wrong for the common case.
>
> I mean, we sorta, kinda sometimes, poorly give this information.  Isn't
> DAC usually EPERM and LSMs usually EACCES.

It's supposed (from POSIX) to be that EACCES means the system
denied you access based on normal policy and EPERM means you tried
something that you could only do with privilege, and failed.

Opening a file with mode bits that deny access should get EACCES.
Changing the mode bits on a file you don't own should get EPERM.

> From a DAC PoV exposing the
> DAC info is completely reasonable.  You can't hide a stat(), even
> setting chmod 000.  So this is an LSM issue.  Not an issue for
> DAC/Capabilities/ACLs.  We can add an LSM hook on the /proc file to make
> sure nothing can get the data even if the global sysctl allows such
> access.
>
> We could if it was worth it make filling in the extended dial
> information an LSM hook where you can check on a per denial basis.  But
> I don't see the need.
>
>> Privileged userspace already has a way to identify when it was a MAC
>> denial, via the audit logs.  But those are considered
>> security-sensitive, and so exposing that same information to
>> unprivileged userspace will be a problem.
> The audit log is complete crap from a usability PoV.  If a web admin is
> trying to figure out why his web server isn't serving out web pages
> in /home he's going to look in the web server logs and see EPERM.
> That's it.  Now he has to start blindly guessing which of the many
> possible reasons for EPERM is his problem.  Wouldn't it be better if the
> information was actually available?  Using the audit log in real time is
> a bloody nightmare.  As the audit maintainer I know how to use ausearch,
> but then again, as the SELinux maintainer I know how to figure out which
> of the many possibilities from EPERM are the cause.  But I want to make
> it easier for a normal admin to figure that out.
>
> I know many people are worried about information leaks, so I'll right up
> front say lets add the sysctl to disable the interface for those who are
> concerned about the metadata information leak.  But for most of us I
> want that data right when it happens, where it happens, so It can be
> exposed, used, and acted upon by the admin trying to troubleshoot why
> the shit just hit the fan.

How on earth is your webadmin supposed to match the failure
of a system call with the content of /proc/8675309/whydiditfail
at the time of the failure? It's not like he's going to go into
the apache source and add code to look at what's there.

Unfortunately, what you probably need is an interface that gives
the program access to the audit records it has generated.

>
> -Eric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

