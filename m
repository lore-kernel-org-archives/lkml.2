Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1JMHre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:47:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43732 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1JMHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:47:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>, David Miller <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>
Date: Thu, 13 Oct 2011 00:47:46 -0700
Message-ID: <m1hb3dbae5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/49iXACFqavhATM7gDy1CS7chTOsbsPN0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de> , David Miller
	<davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH 0/5] Better namespace handling for /sys/class/net/bonding_masters
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I was looking at another sysfs issue that Al pointed out (since
fixed) I realized that I had implemented a trivial code size but overly
clever way to handle /sys/class/net/bonding_masters.

This patchset removes the support for untagged entries in tagged
directories (that is currently used to support bonding_masters)
and replaces it with support for tagged sysfs attributes.

In the process this fixes a small misfeature in how bonding_masters
derives the network namespace we are dealing with.  This change
allows bonding_masters to derive the network namespace from the
copy of bonding_masters we open instead of magically from current.

The final patch of this patchset adds sanity checks to sysfs.  To
ensure that we don't accidentally mishandle tagged sysfs entities.

I have tested this code against 3.1-rc9 on my laptop with a mostly yes
config and I am not seeing any problems.  The loud screaming warnings I
have added in the last patch should catch any corner cases in how people
use sysfs that I might have overlooked.

Greg, Dave I'm don't know whose tree to merge this through as this code
is equally device-core and networking.  I am hoping that we can get this
improvement merged for 3.2.

Farther out the simplifications introduced in this patchset make it much
easier to implement sysfs directories that can scale when there are
enormous numbers of entries in them.

Eric W. Biederman (5):
      sysfs: Implement support for tagged files in sysfs.
      class: Implement support for class attrs in tagged sysfs directories.
      bonding: Use a per netns implementation of /sys/class/net/bonding_masters.
      sysfs: Remove support for tagged directories with untagged members.
      sysfs: Reject with a warning invalid uses of tagged directories.

---
 drivers/base/class.c             |   17 ++++++++++-
 drivers/net/bonding/bond_main.c  |    7 +---
 drivers/net/bonding/bond_sysfs.c |   45 +++++++++++++++++++++---------
 drivers/net/bonding/bonding.h    |    7 +++-
 fs/sysfs/dir.c                   |   20 +++++++++++--
 fs/sysfs/file.c                  |   56 ++++++++++++++++++++++++++++++++++---
 fs/sysfs/inode.c                 |    2 -
 include/linux/device.h           |    2 +
 include/linux/sysfs.h            |    1 +
 9 files changed, 124 insertions(+), 33 deletions(-)

Eric
