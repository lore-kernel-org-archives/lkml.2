Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0KCB34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 21:29:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34346 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab0KCB3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 21:29:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=HBgkcoyau/Hy7DqRDa7X0fIYc4GpPRvLnllUiEL1DVUdEhcOSXe4Azgr4COTdWNYb
	DuggPKaQEkVy3FMwizYyg==
Subject: [PATCH v1 00/12] netoops support
To: simon.kagstrom@netinsight.net, davem@davemloft.net
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Date: Tue, 02 Nov 2010 18:29:25 -0700
Message-ID: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies to v2.6.36.

The following series implements support for 'netoops', a simple driver that
will deliver kmsg logs together with machine specifics over the network.

This driver is based on code used in Google's production server environment.
We internally call the driver 'netdump', but are planning on changing the name
to 'netoops' to follow the convention set by both the mtdoops and ramoops
drivers.  We use these facilities to gather crash data from our entire fleet of
machines in a light-weight manner.  We things this way because it simply isn't
feasible to gather full crash data off of every machine in the wild that
decides it is time to die.

Currently, this driver only supports udp over ipv4.  When configured with an
IPv4 address, netoops will initiate an ARP and hold a reference to the
associated neighbor.  It uses this information when invoked via kmsg_dump() to
fire off UDP packets via the netpoll interface.

I'm posting these patches in an effort to eventually get this sort of
functionality mainlined.  I have tried to clean this code up internally, but
there are still several unresolved issues that would need to be worked out.  In
particular:

   * I am _NOT_ happy with the userland ABIs presented in this patchset.  They
     were cobbled together by a variety of engineers over the years, and they
     aren't very pretty.  I present them none-the-less to express the scope of
     the functionality that we would like to maintain.

   * I am _NOT_ happy with the data format of the transmitted packets.  It is
     very specific to our server environment and currently:

      * is hard-coded to support both userland provided information (that may
        not be applicable to others) and

      * only supports i386 and x86_64.

   * UDP Port numbers are currently hard-coded.

   * I am uncertain if the handling of the neighbor's validity is correct,

   * The netdev event handling is probably incomplete to handle reloading of
     the neighbor.

I'd like to resolve each of the above issues in subsequent versions of this
patchset.  I need help in identifying what the ABI should look like in
particular.


Patchset summary
================

1  - Pass pt_regs on to oops_exit()
2  - Let kmsg_dumpers get access to pt_regs if available
3  - Introduce KMSG_DUMP_SOFT
4  - Add a sysrq trigger that calls kmsg_dump(KMSG_DUMP_SOFT) (USER ABI)
5  - Netoops core driver. (USER ABI)
6  - Addition of x86 specific bits to the network packets (NETWORK ABI)
7  - Addition of userland specific bits to the network packets (USER AND
     NETWORK ABI)
8  - Support for "one-shot" dumping (USER ABI)
9  - An userland interface for triggering crashes (USER ABI)
10 - EXPORT_SYMBOL_GPL(kmsg_dump)
11 - EXPORT_SYMBOL_GPL(arp_bind_neighbor)
12 - Allow netoops to be compiled as a module
