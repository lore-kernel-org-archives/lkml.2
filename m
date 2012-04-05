Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2DETU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:20:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55425 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2DETU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:20:57 -0400
Message-ID: <1333664446.3538.12.camel@lappy>
Subject: net: kernel BUG() in net/netns/generic.h:45
From: Sasha Levin <levinsasha928@gmail.com>
To: davem <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        ebiederm <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date: Thu, 05 Apr 2012 18:20:46 -0400
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When an initialization of a network namespace in setup_net() fails, we
try to undo everything by executing each of the exit callbacks of every
namespace in the network.

The problem is, it might be possible that the net_generic array wasn't
initialized before we fail and try to undo everything. At that point,
some of the networks assume that since we're already calling the exit
callback, the net_generic structure is initialized and we hit the BUG()
in net/netns/generic.h:45 .

I'm not quite sure whether the right fix from the following three
options is, and would be happy to figure it out before fixing it:

 1. Don't assume net_generic was initialized in the exit callback, which
is a bit problematic since we can't query that nicely anyway (a
sub-option here would be adding an API to query whether the net_generic
structure is initialized.

 2. Remove the BUG(), switch it to a WARN() and let each subsystem
handle the case of NULL on it's own. While it sounds a bit wrong, it's
worth mentioning that that BUG() was initially added in an attempt to
fix an issue in CAIF, which was fixed in a completely different way
afterwards, so it's not strictly necessary here.

 3. Only call the exit callback for subsystems we have called the init
callback for.

Thanks!

-- 

Sasha.

