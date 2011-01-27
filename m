Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1A0O0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:26:20 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54881 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab1A0O0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:26:18 -0500
MIME-Version: 1.0
In-Reply-To: <1296084856.2534.18.camel@localhost.localdomain>
References: <1294266337.3237.45.camel@localhost.localdomain>
	<20110111220201.GA6446@localhost>
	<1295034658.2816.16.camel@localhost.localdomain>
	<AANLkTik07sOb8oQThFPLvAnQLXbyPJ+oqtqE2SMX2erk@mail.gmail.com>
	<1295645135.3403.31.camel@localhost.localdomain>
	<AANLkTinPGMijRFnn8T=fndnCCGAsNq_6qCOzKcuhZE8H@mail.gmail.com>
	<20110124214018.GA8395@hallyn.com>
	<1296084856.2534.18.camel@localhost.localdomain>
Date: Thu, 27 Jan 2011 06:26:17 -0800
X-Google-Sender-Auth: uWE66R0V_WnYm5brzgvWdEsh9uM
Message-ID: <AANLkTik=OT6jPwWEP7iE1mVfNmKhTD1gMrtEKwwA8oY_@mail.gmail.com>
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Eric Paris <eparis@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, sgrubb@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 3:34 PM, Eric Paris <eparis@redhat.com> wrote:
> Let me reboot the conversation just a little.  My goal is to be able to
> drop capabilities from a system such that they can never come back.  The
> two capabilities I am most interested in are CAP_SYS_MODULE and
> CAP_SYS_RAWIO.  I want to boot a machine in a manor I control, drop
> those caps, and then give root to an entity that I do not trust.  At the
> moment it is impossible to do this.  Absolutely impossible.  It is
> impossible because the earliest I can drop capabilities is
> in /sbin/init.  Lets assume I patch /sbin/init to drop those two caps
> from the bset, pE, pI, and pP.  One might think they are gone for good,
> but they aren't.
>
> The way that kernel helper programs get exec'ed is that a task or maybe
> an async event causes the kernel to queue some information on a list.
> That information is removed from the list by a special kthread and a
> userspace program is exec'ed.  The exec rules are going to apply to the
> capability sets associated with the kthread.  Those are compiled into
> the kernel.  I need a way to prevent capabilities from coming back.
>
> I proposed a global bset (much like we used to have, but without the
> ability for init to add stuff back) and was shot down.
>
> Andrew original proposed a prctl() which would cause the exec call to
> not automatically add capabilities to pE and would rely on filecaps.  I
> claim this is not reasonable since root is going to have control of the
> fcaps.  All that would be needed for root to regain either cap is to
> change the helper program to be an sshd server and add back these 2
> dropped caps in fcaps.

Which root are we talking about? A rogue all capable root that already
has full control of the system, or a root escalation that is caused by
some automated kernel initiated exec()?

Privilege is not inherited naively with the right secure bits enabled,
so I'm saying you can trust file-capable binaries even more with the
right prevailing secure bits. That is, the right capabilities on the
helper binaries.

Serge asks an excellent question: is the set of helper binaries
finite? You have already conceded that init is a helper binary you can
change to achieve your goals. Why not these others?

> At this point it seems to me like what I must do is add a way for a task
> with enough priv to force caps out of the bset and pI of the kthread
> which upcalls to run userspace programs.  Thus when the kthread runs a
> program it cannot give those privs....

I'm still claiming you can (or, should be made so, to) effectively do
this with a set of secure bits that govern the way this kthread's
exec() works. It then falls to the user-space binary to determine what
capabilities are needed and this whole issue becomes one of userspace
DAC/MAC policy. With the right secure bits, the exec()'d helper would
get pI=pP=pE=0 unless the binary had specific capabilities enabled on
it, and in such cases the binary itself could consult some userspace
system policy and force pB (aka X) to zero or at least 'minus' the
bits you want to suppress on your system.

> Does this seem reasonable?  What would such an interface look like?
> (This is scarily like the old meaning of CAP_SETPCAP....)

[No. Please don't bring that back.]

Cheers

Andrew
