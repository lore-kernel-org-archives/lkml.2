Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1HSJN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 05:13:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44093 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1HSJNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 05:13:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: device-mapper development <dm-devel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "David S. Miller" <davem@davemloft.net>
References: <4E4CDF44.5080109@redhat.com>
Date: Fri, 19 Aug 2011 02:13:48 -0700
In-Reply-To: <4E4CDF44.5080109@redhat.com> (Milan Broz's message of "Thu, 18
	Aug 2011 11:45:40 +0200")
Message-ID: <m17h69sr03.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+9twVEzyF4Cz1nwFQXMr/NHYqgnf7846k=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;device-mapper development <dm-devel@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [dm-devel] clone() with CLONE_NEWNET breaks kobject_uevent_env()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz <mbroz@redhat.com> writes:

> Hi,
>
> after analysing very strange report (with running chromium
> some device-mapper ioctl functions started to fail) I found
> interesting problem:
>
> If you run clone() with CLONE_NEWNET (which is chromium using
> for sanboxing), udev namespace is cloned too (newly registered
> in uevent_sock_list) and netlink send (except the first in list)
> fails with -ESRCH.
>
> This causes that _every_ call of kobject_uevent_env() return failure.
>
> Most of users silently ignores  kobject_uevent() return value,
> so the problem was invisible for long time.
>
> Unfortunately dm checks return value and reports failure,
> taking the wrong error path.
>
> How is this supposed to work?
>
> Why cloning net namespace breaks the udev netlink subsystem?

The netlink subsystem is not broken.  The netlink subsystem
just happens to be reporting in a very obnoxious manner
that there were no listening sockets in one of the network
namespaces.

> Is it bug or we need to do something differently?
> (I do not think ignoring return value is the proper way...)

>From my quick look at this problem this looks like a doozy.

That netlink_ broadcast chooses to treat failure to deliver a packet to
anyone as an error and return -ESRCH is a little peculiar.  In general
we don't see that error because when you are testing there is at least
one listener on the netlink socket.  So as a practical matter I think
we should be ignoring return values of -ESRCH from netlink_broadcast,
in kobject_uevent_env.

What puzzles me is why kobject_uevent_env bothers with a return code.
As far as I understand the semantics kobject_uevent_env attempts to
send an event and there really isn't anything anyone can do if the
attempt to send the event fails.

I can see complaining if kobject_uevent_env is given invalid input
but that seems better as a WARN_ON so you get a backtrace and someone
can change their code.

I don't think kobject_uevent_env has any cases where it can return
an error that is useful for anything.  What can caller do with
an error code of -ENOMEM? 

I think the proper fix is to remove the error return from
kobject_uevent_env and kobject_uevent, and make it harder to get calling
of this function wrong.  Possibly in conjunction with that tag all of
the memory allocations of kobject_uevent_env with GFP_NOFAIL or
something so the memory allocator knows that this path is totally
not able to deal with failure.

Is kobject_uevent_env anything except an asynchronous best effort
notification to user-space that a device has come or gone?

Eric
