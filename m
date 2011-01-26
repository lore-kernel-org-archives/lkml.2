Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1AZXeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:34:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab1AZXe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:34:29 -0500
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: Eric Paris <eparis@redhat.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, sgrubb@redhat.com
Date: Wed, 26 Jan 2011 18:34:14 -0500
In-Reply-To: <20110124214018.GA8395@hallyn.com>
References: <1294266337.3237.45.camel@localhost.localdomain>
	 <20110111220201.GA6446@localhost>
	 <1295034658.2816.16.camel@localhost.localdomain>
	 <AANLkTik07sOb8oQThFPLvAnQLXbyPJ+oqtqE2SMX2erk@mail.gmail.com>
	 <1295645135.3403.31.camel@localhost.localdomain>
	 <AANLkTinPGMijRFnn8T=fndnCCGAsNq_6qCOzKcuhZE8H@mail.gmail.com>
	 <20110124214018.GA8395@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1296084856.2534.18.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me reboot the conversation just a little.  My goal is to be able to
drop capabilities from a system such that they can never come back.  The
two capabilities I am most interested in are CAP_SYS_MODULE and
CAP_SYS_RAWIO.  I want to boot a machine in a manor I control, drop
those caps, and then give root to an entity that I do not trust.  At the
moment it is impossible to do this.  Absolutely impossible.  It is
impossible because the earliest I can drop capabilities is
in /sbin/init.  Lets assume I patch /sbin/init to drop those two caps
from the bset, pE, pI, and pP.  One might think they are gone for good,
but they aren't.

The way that kernel helper programs get exec'ed is that a task or maybe
an async event causes the kernel to queue some information on a list.
That information is removed from the list by a special kthread and a
userspace program is exec'ed.  The exec rules are going to apply to the
capability sets associated with the kthread.  Those are compiled into
the kernel.  I need a way to prevent capabilities from coming back.

I proposed a global bset (much like we used to have, but without the
ability for init to add stuff back) and was shot down.

Andrew original proposed a prctl() which would cause the exec call to
not automatically add capabilities to pE and would rely on filecaps.  I
claim this is not reasonable since root is going to have control of the
fcaps.  All that would be needed for root to regain either cap is to
change the helper program to be an sshd server and add back these 2
dropped caps in fcaps.

At this point it seems to me like what I must do is add a way for a task
with enough priv to force caps out of the bset and pI of the kthread
which upcalls to run userspace programs.  Thus when the kthread runs a
program it cannot give those privs....

Does this seem reasonable?  What would such an interface look like?
(This is scarily like the old meaning of CAP_SETPCAP....)

