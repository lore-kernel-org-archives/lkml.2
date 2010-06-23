Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab0FWR6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0FWR57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:57:59 -0400
Date: Wed, 23 Jun 2010 19:56:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH v3 06/11] rlimits: do security check under task_lock
Message-ID: <20100623175602.GA14824@redhat.com>
References: <20100513155621.51ca77a4.akpm@linux-foundation.org> <1275855783-27316-1-git-send-email-jslaby@suse.cz> <20100607180855.GA6689@redhat.com> <4C222644.4040601@gmail.com> <20100623161254.GA10098@redhat.com> <4C224804.7030809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C224804.7030809@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Jiri Slaby wrote:
>
> On 06/23/2010 06:12 PM, Oleg Nesterov wrote:
> > On 06/23, Jiri Slaby wrote:
> >>
> >> BTW this capable() has the exactly same problem with being called with
> >> task_lock held. Is it OK to move it completely out of critical section?
> >> I'm asking because it sets a current->flags SU bit used for accounting.
> >> If I move it out of the section, it will set the bit always.
> >
> > Well, with all these delays I do not know what "exactly same problem"
> > means ;) Please explain?
>
> As I wrote: that the capable() is called with task_lock held.

Ah, got it, yes.

> > selinux_task_setrlimit()->current_has_perm()->current_sid()->current_cred()

I meant
selinux_task_setrlimit(p)->current_has_perm(p)->task_sid(p)->__task_cred(p)

> I still see no way how this is wrong. We want to check whether current
> thread has capabilities to change (someone else's) rlimits.

Yes. but what is "someone else" ?

IIRC, one of your patches (correctly) changes security_task_setrlimit()
to have the new argument, p == "someone else", correct?

Now, the result of security check depends on __task_cred(p) above, and
thus depends on which thread we choose to change rlimits.

I think it makes more sense to always pass ->group_leader as an argument
to security_task_setrlimit(p). But probably I missed something, I do not
remember what exactly other patches do.

Oleg.

