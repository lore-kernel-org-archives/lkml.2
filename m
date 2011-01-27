Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1A0Omm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:42:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab1A0Omi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:42:38 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH] System Wide Capability Bounding Set
Date: Thu, 27 Jan 2011 09:42:07 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.35.10-74.fc14.x86_64; KDE/4.5.5; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <1294266337.3237.45.camel@localhost.localdomain> <1296084856.2534.18.camel@localhost.localdomain> <20110127140255.GB2935@localhost>
In-Reply-To: <20110127140255.GB2935@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101270942.07689.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

On Thursday, January 27, 2011 09:02:55 am Serge E. Hallyn wrote:
> What is the attack vector you're actually envisioning?  Does some
> trojan come in and overwrite a program which which it hopes the
> kernel will execute?  Or is there just an existing vuln in such
> a program?  Are there other ways we can address these?  Can we find
> a way to classify the kernel-spawned userspace programs?  Perhaps
> based on the selinux context assigned to the program, we can assign
> some level of trust that noone could have modified the source?


I think that what is causing the confusion is that we are considering a different 
threat model than the normal, historic view. The way its normally viewed, if you have 
root, you can do anything you want to a machine. The threat model revolves around 
becoming root on a machine and defense rests on splitting root so a complete system 
compromise might not occur.

Today, people want to have multi-tenant hosting using virtual machines whereby they 
give away root control of the guest VM. If you were renting system space, you would 
expect root access. That would make a nice juicy hacking target because you don't know 
who else is sharing the physical machine with you and they might have something in 
their VM worth stealing.

So, the threat model becomes how do we prevent one guest from attacking another? We 
have sVirt which prevents resource based attacks from occurring. Its pretty effective 
for that. However, what if the bad guy wants to start attacking the hypervisor 
directly in effort to start attacking the host OS? 

They need to be able to run arbitrary code in ring 0 of the VM. That means the hosting 
provider might want to eliminate some capabilities from the whole kernel so that they 
have some assurance that a root user cannot get arbitrary code running in ring 0 
without knowing a kernel level exploit. Also assume that the root user has no control 
over the kernel or modules or initrd which are kept on a read only partition enforced 
by the hypervisor. And the hosting provider will make kernel updates as kernel 
security releases are made.

This kind of turns around some of the threat modeling that people have always made. 
There are not a whole lot of changes that need to be made. I think there was one other 
patch that we needed to prevent arbitrary code injection. Eric's initial patch was 
overly generous in my opinion. It allowed further modification of the global bounding 
set after boot had finished and could probably be used for mischief as pointed out. 
Perhaps the setting should be immutable after any change to it - which is really how 
its intended to be used. Or maybe even only a subset of the bounding set is modifiable.

Using a wrapper program is a NOGO because the admin renting the machine would be able 
to overwrite the wrapper and then they have arbitrary code running with full privs and 
we trust it will do the right thing. We need all modification to the running kernel out 
of reach from root in that VM.

-Steve
