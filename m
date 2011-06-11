Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab1FKUmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 16:42:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48663 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1FKUkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 16:40:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Greg Kroah-Hartman" <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>
Subject: [PATCH 0/8] PM / Domains: Support for generic I/O PM domains (v5)
Date: Sat, 11 Jun 2011 22:23:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106112223.04972.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the 4th update of the patchset adding support for generic I/O PM
domains.  The patches have been reworked quite a bit to take feedback into
account, but I left the Greg's ACK in [4/8] in the hope it still applies
(Greg, please let me know in case it doesn't :-)).

The model here is that a bunch of devices share a common power resource
that can be turned on and off by software.  In addition to that, there
are means to start and stop the activity of each device, for example
by manipulating their clocks.  Moreover, there may be hierarchy of
such things, for example power resource A may be necessary for devices
a, b, c, which don't rely on any other power resources, and for devices
x, y, z that also rely on power resource X.  In that case there one PM
domain object representing devices a, b, c and power resource A, and 
another PM domain object will represent devices x, y, z with power
resource X, plus the first object will be the second one's parent.

Note to Kevin: I know you'd like each PM domain to be able to go into several
different states, but the situation will always be that in some of those
states the devices' registers will remain intact, while in the rest of those
states they will be reset.  Say, there are states 1, 2, 3, 4 and states
1-3 preserve device registers.  Then it is not necessary to save device
registers for "domain" states 1-3 and it only is necessary to save them
when going to state 4.  In that case, .power_off() may map to the "go to
state 4" operation (and analogously .power_on()), while the rest may be
done by .stop_device() and .start_device().  IOW, .power_is_off == true
means "the devices' registers have to be restored", so it need not map to
any particular physical state of a (hardware) power domain.

Note to Magnus and Paul: I didn't use a global lock as suggested, because
I think it may lead to completely unnecessary congestion in situations in
which there are no hierarchies of PM domains.  It is quite easy to show that
the code doesn't deadlock, because (1) no more than 2 locks are held by the
same thread at a time (parent lock and child lock) and (2) they are always
acquired in the same order (parent before the child).

Overall, I think I've taken all of the important dependencies into
consideration, but if you spot something suspicious, please let me know. :-)
Wakeup is not covered at this point, because it's not necessary for the
SH7372's A4LC power domain that's the first user of the new code, but it
is quite clear how add the support for it.  Also, for more complicated
cases it is necessary to take QoS requirements (latencies) into account,
which is in the works (kind of).

[1/8] - Update documentation to reflect the fact that struct dev_power_domain
        callbacks take precedence over subsystem PM callbacks.

[2/8] - Rename struct dev_power_domain to struct dev_pm_domain to reflect the
        fact that those objects need not correspond to hardware power domains
        directly.

[3/8] - Move subsys_data in struct dev_pm_info out of #ifdef CONFIG_PM_RUNTIME

[4/8] - Introduce runtime PM support for generic I/O PM domains.

[5/8] - Introduce generic "noirq" callbacks for system suspend/hibernation
        (that's necessary for the next patches).

[6/8] - Move some PM domains support code fro under #ifdef CONFIG_PM_RUNTIME

[7/8] - Add system-wide PM support for generic I/O PM domains.

[8/8] - Use the new code to represent the SH7372's A4MP power domain.

The patchset has been tested on SH7372 Mackerel board and appears to work
correctly.

I'd like to push [1/8] for 3.0 (it may be regarded as a fix), but I _think_
that it may be a good idea to push [2/8] for 3.0 too, to limit the time in
which people may possibly use the naming that's going to change in their new
code.  If you agree with that, please let me know, I'll need some serious
ACKs below that patch if it's to be pushed for 3.0. ;-)

Thanks,
Rafael

