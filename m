Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1EAP2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:28:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44854 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1EAP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:28:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Date: Sun, 01 May 2011 08:28:07 -0700
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
	(Lucian Adrian Grijincu's message of "Sun, 1 May 2011 03:35:30 +0200")
Message-ID: <m1zkn68mpk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/yG/iJaW0Uz5ibBGvLb2DmJPdEV7vuKpM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

After having read through some of your patches this looks like a good
overall direction.  At a more detailed level there are a lot of pieces
to your patch series that appear to need some more attention.

> The first patches remove the .child field of ctl_table. This is a
> requirement for the new algorithm. These patches are scattered all
> over the tree :(

Only registering sysctl leaves seems very reasonable, the code has
been slowly moving in that direction for quite a while.

We need to make it a firm rule that directories are created before
they are used. (aka normal filesystem semantics) before we churn
through and change everything.

This also addresses a question you asked in patch 60.

> This can be fixed in two ways:
> 
> - A) by making sure to never register a netns specific directory and
>   after that register that directory as a common one. From what I can
>   tell there isn't such a problem in the kernel at the moment, but I
>   did not study the source in detail.

Currently it is a requirement that if you are going to have a netns
component and a non nents component the non-netns directory must
be created first.  However that requirement is not currently enforced.

It is a bit too easy to get that wrong.  So we need enforcement of that
rule and enforcement of duplicate checks.  The sysctl_check code should
become mandatory at this point, or at least the duplicate checks.

Since we are touching most if not all of the sysctl registrations this
would also be a good time to pass a path string instead of the weird
ctl_path data structure.  We needed ctl_path when we had both binary
and proc paths to worry about but we no longer have that concern.

We may also want to add a special sysctl directory creation and removal
operations.

> People interested in the core sysctl changes/networking should read:
>
>    [PATCH 60/69] sysctl: faster tree-based sysctl implementation
>
> which introduces the new algorithm (commit message and comments have
> more details), and the next few patches which add some further (simple
> and effective) optimisations for networking (and not only).

Patch 60 does too many things all in one patch.  It would be very good
if it could be split up some more, so it could be more easily verified.

Eric
