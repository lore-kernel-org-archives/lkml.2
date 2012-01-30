Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2A3QKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:10:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64430 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab2A3QKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:10:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/3] arch: fix ioport mapping on mips,sh
Date: Mon, 30 Jan 2012 16:09:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael Witten <mfwitten@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <cover.1327877053.git.mst@redhat.com>
In-Reply-To: <cover.1327877053.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201301609.56105.arnd@arndb.de>
X-Provags-ID: V02:K0:YRmjaTYJpZu6S8WxSZdsxdgrZ4yBP5TfISB8Z6OHH/Z
 CO+Ztb/1clhmgzcjEejOSB8X08T+EYcfPe2yyWQYRhwYVc5CDl
 JQj3RbhTCyCU3OOY/EWMH9w9rxOgaP81SVJQWKxCpJzZU9hoO/
 od6lhFDtsstc9ZF9Fy1xxo0E9vXsQHiS21D//bqkfadjYpAz00
 MT7bH/MtHT8FyGPv9lWvfn/VugcY2zTm1HG7NWGSGrjJoPL21G
 0fEtc5l2MV72qevHUPa73HEpXWiqN6wq88WIunZImUhr2hQNbH
 K/nMw9WrRcpjRa3lJKProgmUFgqscMRrm1iLU7KrH3xjyPLNLB
 Y8bU3210GHolkMOpzDpU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 January 2012, Michael S. Tsirkin wrote:
> Kevin Cernekee reported that recent cleanup
> that replaced pci_iomap with a generic function
> failed to take into account the differences
> in io port handling on mips and sh architectures.
> 
> Rather than revert the changes reintroducing the
> code duplication, this patchset fixes this
> by adding ability for architectures to override
> ioport mapping for pci devices.
> 
> I put this in my tree that feeds into linux-next
> and intend to ask Linus to pull this fix if this
> doesn't cause any issues and there are no objections.
> 
> The patches were tested on x86 and compiled on mips and sh.
> Would appreciate reviews/acks/testing reports.

Looks good to me, except for the one detail I've commented
on in the third patch.

Acked-by: Arnd Bergmann <arnd@arndb.de>

I do wonder if the sh and mips implementations are robust enough however
(independent of your work): It seems that an ioport number is treated
differently in pci_iomap than it is using ioport_map and inb/outb,
the assumption being that the port number is a local index per PCI domain.
This would mean that any port access other than pci_iomap would only
work on the primary PCI domain. There are two IMHO better solutions that
I've seen on other architectures:

1. create a larger (e.g. 1MB) io port mapping range in virtual memory
that is split into 64kb per domain, and use the domain number to
find the per domain range when setting the resources. Port numbers will
be larger than 65535 this way, but PCI will ignore the upper address
bits for any access so it works fine.

2. split the 64kb io port range into subsections per domain (on page
granularity, e.g. 2 domains with 32kb or at most 16 domains with 4kb)
and map them virtually contiguous, then reassign all io port resources
so that only the correct region for each domain is used.

	Arnd
