Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1AXVk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:40:29 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59273 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1AXVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:40:28 -0500
Date: Mon, 24 Jan 2011 15:40:18 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Eric Paris <eparis@redhat.com>, "Serge E. Hallyn" <serge@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        sgrubb@redhat.com
Subject: Re: [PATCH] System Wide Capability Bounding Set
Message-ID: <20110124214018.GA8395@hallyn.com>
References: <1294266337.3237.45.camel@localhost.localdomain>
 <20110111220201.GA6446@localhost>
 <1295034658.2816.16.camel@localhost.localdomain>
 <AANLkTik07sOb8oQThFPLvAnQLXbyPJ+oqtqE2SMX2erk@mail.gmail.com>
 <1295645135.3403.31.camel@localhost.localdomain>
 <AANLkTinPGMijRFnn8T=fndnCCGAsNq_6qCOzKcuhZE8H@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinPGMijRFnn8T=fndnCCGAsNq_6qCOzKcuhZE8H@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> > But how can that leave us with an impotent root?  Root would be easily
> > able to craft a file with any caps it wants in fI and fP on any of the
> > plethora of helper programs the kernel calls and escalate away it's
> > impotence.
> 
> Again, assuming that you are really trying to limit the power of
> kernel auto-exec'd programs, then you can see how secure bits can make
> root-power harder to obtain. (Examples using libcap utilities.)
> 
> [root@pip foo]# whoami
> root
> [root@pip foo]# ls -l foo.sh
> -rwx------ 1 bin nobody 31 2011-01-22 19:07 foo.sh
> [root@pip foo]# /sbin/capsh --secbits=0x0 -- ./foo.sh
> Hello, Root
> [root@pip foo]# /sbin/capsh --secbits=0x2f -- ./foo.sh
> /bin/bash: ./foo.sh: Permission denied
> [root@pip foo]#
> 
> That is, the 0x2f value of the secure bits turns off root's privilege.
> This includes the privilege to add capabilities to files (run this
> from the progs subdirectory of the libcap source, after a build):
> 
> [root@pip progs]# /sbin/capsh --secbits=0 -- \
> -c "/sbin/setcap cap_setfcap=ep setcap"
> [root@pip progs]# /sbin/getcap -v setcap
> setcap = cap_setfcap+ep
> [root@pip progs]# /sbin/setcap -r setcap
> [root@pip progs]# /sbin/getcap -v setcap
> setcap
> [root@pip progs]# /sbin/capsh --secbits=0x2f -- \
> -c "/sbin/setcap cap_setfcap=ep setcap"
> unable to set CAP_SETFCAP effective capability: Operation not permitted
> [root@pip progs]#
> 
> So, my point is that if the kernel threads were launched with a
> user-space configurable set of secure bits, and the regular exec()
> rules were used by these kernel-launched processes to obtain
> privilege, you could block the kernel from getting any user-space
> privileges via secure bits.

That's not even necessary, is it?  In order to get capabilities
from fI into pP, you need those capabilities in pI to begin
with.  So as long as we make sure that removing a capability from
the root task's bounding set also removes it from it's inheritable
set, no task it execs can re-gain those capabilities.

-serge
