Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031191Ab2ERNvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:51:44 -0400
Received: from solo.fdn.fr ([80.67.169.19]:58363 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031117Ab2ERNvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:51:41 -0400
Date: Fri, 18 May 2012 15:51:37 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, qemu-devel@nongnu.org,
        dlaor@redhat.com
Cc: "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Dean Nelson <dnelson@redhat.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: e1000 rx emulation bug (Was: [PATCH] e1000: Reset rx ring index on
 receive overrun)
Message-ID: <20120518135136.GV683@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	qemu-devel@nongnu.org, dlaor@redhat.com,
	"Dave, Tushar N" <tushar.n.dave@intel.com>,
	"Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>,
	"Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
	"Skidmore, Donald C" <donald.c.skidmore@intel.com>,
	"Rose, Gregory V" <gregory.v.rose@intel.com>,
	"Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
	"Duyck, Alexander H" <alexander.h.duyck@intel.com>,
	"Ronciak, John" <john.ronciak@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jiri Pirko <jpirko@redhat.com>, Dean Nelson <dnelson@redhat.com>,
	"e1000-devel@lists.sourceforge.net" <e1000-devel@lists.sourceforge.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20120517230140.GZ683@type.famille.thibault.fr>
 <061C8A8601E8EE4CA8D8FD6990CEA891188439E0@ORSMSX102.amr.corp.intel.com>
 <20120517232821.GJ683@type.famille.thibault.fr>
 <20120517233124.GK683@type.famille.thibault.fr>
 <alpine.WNT.2.00.1205171702590.7900@jbrandeb-mobl2.amr.corp.intel.com>
 <20120518001202.GN683@type.famille.thibault.fr>
 <alpine.WNT.2.00.1205171718160.7900@jbrandeb-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.WNT.2.00.1205171718160.7900@jbrandeb-mobl2.amr.corp.intel.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There seems to be a bug in qemu in the e1000 emulation, which triggers
an issue with the Linux driver.

What happens in Linux is the following:

- e1000_open 
  - e1000_configure
    - e1000_setup_rctl
      - enables E1000_RCTL_EN
    - e1000_configure_rx
      - sets RDT/RDH to 0
    - alloc_rx_buf
      - pushes buffers to the ring

with bad luck, or on high traffic of small packets, what is observed is
that between setting RDT/RDH and pushing buffers, the ring fills up in
qemu. Here is what happens there on the qemu side:

- e1000_receive
  - e1000_has_rxbufs
    - total_size <= s->rxbuf_size (because it's small)
      return s->mac_reg[RDH] != s->mac_reg[RDT] || !s->check_rxov;

although RDH == RDT == 0, it returns 1, because since RDT/RDH have
just been set to 0, set_rdt has cleared check_rxov. e1000_receive
thus believes there is room, and proceeds with filling the ring.
Unfortunately, since no buffer was pushed, desc.buffer_addr is NULL, and
thus the do loop skips all these nul rx descriptors of the ring, but
marking each of them with E1000_RXD_STAT_DD, and eventually wrapping
around.  From then on, since check_rxov has been set by the do loop,
nothing more is pushed, until the linux driver pushes buffers to the
ring. qemu can then fill some descriptors, and Linux read them, but
since the whole ring was filled with E1000_RXD_STAT_DD, Linux goes on
reading, and thus gets completely desynchronized with the device.

That raises two questions:

- what is the role of the check_rxov flag?  Is hardware really allowed
  to push in some cases, even when RDH==RDT?  Removing it makes things
  work just fine.
- BTW, when skipping a descriptor because of NULL address, does
  E1000_RXD_STAT_DD have to be set?

Samuel
