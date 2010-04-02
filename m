Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0DBPZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:25:10 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44240 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab0DBPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:25:03 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2010 11:25:03 EDT
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@redhat.com>
Subject: unhelpful and somewhat scary r8169 boot message in 2.6.33.2 regarding a security fix
From: Nix <nix@esperi.org.uk>
Emacs: a compelling argument for pencil and paper.
Date: Fri, 02 Apr 2010 16:19:13 +0100
Message-ID: <87iq89q3v2.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-x.dcc-servers-Metrics: spindle 104; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I was doing a test-boot of 2.6.33.2 to see if my hang-on-suspend
Radeon DRM regression (fdo bug 26872) was cured (it wasn't), when a
new message appeared at bootup, the second of those below:

[    8.766768] r8169: fastnet: link up
[    8.791231] WARNING! Changing of MTU on this NICMay lead to frame reception errors!

(which appeared when I set the MTU on my r8169 to 7200.)

Not only is this message plainly misformatted :) but it does not explain
*why* changing the MTU is suddenly so bad, when it's worked forever
before now without flaw, with no sign of any sort of corruption. Why
should we be confined to non-jumbo frames? What are the effects if we
do change MTU?

The guilty patch appears to be a security fix, which strongly suggests
that 'frame reception errors' are not the only problem:

commit 8c96206544955131f6d7cef09371950f34ebca5a
Author: Neil Horman <nhorman@redhat.com>
Date:   Mon Mar 29 13:16:02 2010 -0700

Now the warning message above does *not* say 'if you change the MTU you
bring a security problem back'. The commit message includes this
statement (here wrapped for column width):

  2) This patch only disables frame filtering initially (i.e., during
  the NIC open), changing the MTU results in ring buffer allocation of a
  size in relation to the new mtu (along with a warning indicating that
  this is dangerous).

  Because of item (2), individuals who can't cope with the performance
  hit (or can otherwise filter frames to prevent the bug), or who have
  hardware they are sure is unaffected by this issue, can manually lower
  the copybreak and reset the mtu such that performance is restored
  easily.

Now this really should be in some documentation more easily accessible
than a git changelog, but even failing this... what performance hit? Are
we allocating 16K on every packet received, even if the packet is
smaller? If so, that doesn't strike me as being a *performance* problem
as much as a *reliability* problem, at least if this hardware requires
the pages to be contiguous; and the bigger your MTU, the smaller the
problem, so it's rather odd that it complains only when you change your
MTU (which would make this problem less likely).

Secondly, 'who can otherwise filter frames to prevent the bug' is all
very well to say, but... how? The comments say that 'some subset' of
r8169 hardware suffers from this problem: which subset? Does anyone
know? The security PDF referred to in the commit log references (on page
80) a problem in rev 10 adapters (and only them? what about earlier
ones? later ones?) which *appears* to be problematic only if attackers
can inject Ethernet frames larger than your MTU directly into your LAN:
i.e., if you have a non-malicious router in the way and your local
subnet is trusted, you are safe, because you can't get frames larger
than your MTU. Anyone using domestic ADSL in e.g. the UK's BT network is
probably safe, because Ethernet frames on this network are constructed
ex nihilo by the ADSL router (which is presumably trusted). (I don't
know enough about ADSL networks using PPPoE to know if the same is true
of them, but I suspect it is: PPP doesn't carry raw Ethernet frames,
after all, only IP.)


So, the message should probably point to some documentation somewhere
which should at least mention that this is only a problem on untrusted
subnets (i.e. not for the vast majority of uses). Failing that, it
should probably mention that this is allowing not just 'frame reception
errors' but an outright security hole (as I understand it).

(I'd be happy to write this documentation if I had any confidence that
anything I'd written above was correct. Security patches which lead to
vaguely disturbing messages being printed when you've changed nothing
but your kernel are probably a bad idea from a don't-frighten-the-
userbase perspective.)
