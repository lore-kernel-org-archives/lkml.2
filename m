Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab0D3SqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:46:05 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4523 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932916Ab0D3RQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:16:32 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression,bisected] Missing boot messages with VESAFB after VT initialization
Date: Thu, 29 Apr 2010 06:14:23 +0200
User-Agent: KMail/1.9.9
Cc: x86@kernel.org, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Ari Entlich <atrigent@ccs.neu.edu>
References: <201004171718.55867.elendil@planet.nl>
In-Reply-To: <201004171718.55867.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004290614.24016.elendil@planet.nl>
X-Length: 2723
X-OriginalArrivalTime: 30 Apr 2010 17:16:28.0549 (UTC) FILETIME=[DED9C350:01CAE888]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 April 2010, Frans Pop wrote:
> Initially all messages from init scripts are displayed correctly, but
> after the init script to set up the VT1-VT6 is run, messages from init
> scripts are no longer displayed. Instead the display is blank with only
> a cursor.
>
> However, if I switch back to VT1 from X.Org after the boot has
> completed, the missing messages are visible.
>
> System is x86_64 running Debian stable ("Lenny"). I'm using VESAFB
> (vga=791) and no KMS.

I've done a new bisection for this issue (with cold boots instead of 
reboots) and now end up in the following merge:
   commit 94468080220162f74dc6ce5c3e95e5fec8022902
   Merge: fb7b096 137ee2f
   Author: Linus Torvalds <torvalds@linux-foundation.org>
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6

Unfortunately I cannot bisect into that merge as I get a NULL pointer bug 
after typing the passphrase for my encrypted partition.

I suspect one of the following commits from that merge:
 * commit 638b9648ab51c9c549ff5735d3de519ef6199df3
   Author: Alan Cox <alan@linux.intel.com>
      tty: Fix the ldisc hangup race
 * commit 4165fe4ef7305609a96c7f248cefb9c414d0ede5
   Author: Alan Cox <alan@linux.intel.com>
      tty: Fix up char drivers request_room usage
 * commit d9661adfb8e53a7647360140af3b92284cbe52d4
   Author: Alan Cox <alan@linux.intel.com>
      tty: Keep the default buffering to sub-page units
 * commit eec9fe7d1ab4a0dfac4cb43047a7657fffd0002f
   Author: Ari Entlich <atrigent@ccs.neu.edu>
      tty: Add a new VT mode which is like VT_PROCESS but doesn't require a
           VT_RELDISP

The last one is probably the most likely as the issue occurs after an init 
script loops over all VTs to run 'consolechars' and/or 'charset'.

See http://lkml.org/lkml/2010/4/17/48 for my original mail with some 
additional details.

Cheers,
FJP
