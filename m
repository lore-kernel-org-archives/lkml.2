Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0FGKbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 06:31:04 -0400
Received: from smtp2pub.unibas.ch ([131.152.227.82]:57472 "EHLO
	smtp2pub.unibas.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0FGKbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 06:31:02 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jun 2010 06:31:02 EDT
X-IronPort-AV: E=Sophos;i="4.53,377,1272837600"; 
   d="scan'208";a="73005621"
Message-ID: <4C0CC810.7030501@unibas.ch>
Date: Mon, 07 Jun 2010 12:21:04 +0200
From: Christophe Jelger <Christophe.Jelger@unibas.ch>
Organization: University of Basel
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Virtual device and ARP table
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am currently "resurrecting" a Linux module (called LUNAR) which I 
co-developed in 2007 and I'm having a weird kernel crash. This code 
basically used to work fine up to 2.6.18 which was the latest version 
before we stopped our development. I quickly ported it to 2.6.{31,32}: 
it compiles fine and loads fine, but it crashes/hangs the kernel when 
it's really being used.

The module is a virtual device used for MANET routing: with the current 
version, it basically "captures" DNS requests sent to the virtual 
interface --> this triggers the sending of a fake DNS reply (see below) 
and the creation of an ARP table entry for the destination (the MANET 
route is built at the same time). Packets can then be sent to the 
destination.

The problem I'm having is that the kernel quickly hangs after I create a 
new ARP entry (actually only if it's being used). If the entry I create 
is set to NUD_PERMANENT, then everything works fine! I use 
__neigh_lookup_errno to lookup/create the entry and neigh_lookup to 
set/update the MAC address. Note that the ARP entry is created without 
problem, but typically even just doing a userspace "arp -a" command can 
crash the kernel (it also hangs the userspace command!). Doing "arp -na" 
usually does NOT crash the kernel!

I guess the problem comes from a combination of ARP + DNS 
lookups/replies. Note that my kernel module has its own internal fake 
DNS server which captures lookups and sends replies directly back to the 
stack. What is amazing: if the ARP entry I create is set to 
NUD_PERMANENT, then I don't get any crash (however I cannot develop my 
module with permanent ARP entries).

I'm wondering if there were any major changes to the neighbor and arp 
code (between 2.6.18 and 2.6.31) that are somehow causing this problem ?...

Any hint is very welcome.

thanks in advance,
Christophe

PS: I can easily reproduce the problem, and was trying to debug with 
qemu and gdb server but so fra no success to clearly identify the 
problem. Last point: it seems the kernel does not really "crash" but 
rather ends up in some unstable state and maybe in a loop.
