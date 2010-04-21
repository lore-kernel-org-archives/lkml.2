Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab0DUXuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:50:07 -0400
Received: from mail-qy0-f195.google.com ([209.85.221.195]:43018 "EHLO
	mail-qy0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab0DUXuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:50:03 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 19:50:03 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=JwXuKh8o/QrisHKcjvA5+g4IbprSWKM5xnyGzAo3iwKek06j66nalxjXa35uogNwfW
         IEYS+XUgPqxmMlvEat2+neGT1R3VqszoN6/E/0VfhgNKm4thk/Z+cbZrClCqpaP/LWYW
         CU4UeqPaEjjPvTLBnOq+wFjZrWwdyyp19bosI=
References: <cover.1269610458.git.luto@mit.edu> <20100419172639.GA15800@us.ibm.com> <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com> <20100419213952.GA28494@hallyn.com> <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil> <v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com> <20100420143545.GA19513@us.ibm.com> <q2pcb0375e11004211415ge9371513n6fad211823aba2b3@mail.gmail.com> <20100421223059.GA20626@us.ibm.com>
Message-Id: <D0083BC1-E07B-4E43-8F3A-85688332397E@gmail.com>
From: Andy Lutomirski <amluto@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20100421223059.GA20626@us.ibm.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
Date: Wed, 21 Apr 2010 19:42:36 -0400
Cc: Andrew Lutomirski <luto@mit.edu>, Stephen Smalley <sds@tycho.nsa.gov>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Apr 21, 2010, at 6:30 PM, "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Andrew Lutomirski (luto@mit.edu):
>> So if we give up on changing nosuid, there are a couple of things we
>> might want to do:
>>
>> 1. A mode where execve acts like all filesystems are MNT_NOSUID.   
>> This
>> sounds like a bad idea (if nothing else, it will cause apps that use
>> selinux's exec_sid mechanism (runcon?) to silently malfunction).
>
> I think at this point we've lost track of exactly what we're trying
> to do.
>
> The goal, at least for myself and (I think) Eric, was to prevent
> certain changes in environment, initiated by an unprivileged user,
> from confusing setuid-root programs (initiated by the user).
>
> A concrete example was the proposed disablenet feature, with which
> an unprivileged task can remove its ability to open any new network
> connections.
>
> With that in mind, I think option 1 is actually the best option.

I think the show-stopper for number 1 is the fact that nosuid has  
really strange semantics, and I'm a bit scared of making them more  
widespread. For example, selinux-aware apps can request a type change  
on exec, and nosuid causes that request to be silently ignored.  This  
could silently break otherwise-working selinux sandboxes.  Stephen  
doesn't want to change it...


> I especially hate option 2 because of the resulting temptation to
> fudge with pE  :)  If you're going to fudge with pE, then IMO it
> MUST be done in a new securebits mode.

I'll fight that fight later.  (I wish the original rule had been pE' =  
pE except when setuid root, but it's way too late for that...)

>
> Now actually, re-reading my msg, given our original goal, I dare
> say that Andrew Morgan's approach of simply returning -EPERM for
> any app which tries to setuid or change privileges on exec just
> might be the sanest way, at least to start with.
>

Fair enough.  It'll annoy some selinux users, but maybe the selinux  
people will figure out how to fix it when enough users complain.

I'll hack up and submit a patch series to add PR_EXEC_DISALLOW_PRIVS  
and allow CLONE_NEWNET when it's set.  Then I'll argue with Alan Cox  
for a week or three, I suppose :)

I think I'll arrange it so that PR_EXEC_DISALLOW_PRIVS & uid==0 &&  
(pP != all) && !SECURE_ROOT will cause execve to always fail.  nonoot  
&& pP != 0 && !KEEPCAPS will fail as well, since it seems silly to add  
a special case (if you're nonroot and create an unprivileged  
container, drop the caps yourself).

--Andy

(My system has a setuid binary that does unshare(CLONE_NEWIPC), drops  
privs and execs it's argument.  I'll be happy to get rid of it.)
