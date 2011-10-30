Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1J3UQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 16:16:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1J3UQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 16:16:25 -0400
Date: Sun, 30 Oct 2011 13:16:18 -0700
From: Tejun Heo <tj@kernel.org>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: Re: hiberante hangs TCP Re: [EXAMPLE CODE] Parasite thread
 injection and TCP connection hijacking
Message-ID: <20111030201618.GA7696@google.com>
References: <20110806121247.GC23937@htj.dyndns.org>
 <20111030044821.GA23741@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111030044821.GA23741@spacedout.fries.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Rafael and linux-pm)

On Sat, Oct 29, 2011 at 11:48:21PM -0500, David Fries wrote:
> I saw the write up on this on lwn.net, pretty creative by the way, and
> it got me thinking about a different checkpoint/restart problem I've
> been running into.  Specifically in hibernating to disk.  In the
> hibernate case active TCP connections hang after resuming, while an
> idle TCP connection will continue after the system is back up.  My
> observation is the kernel checkpoints itself to memory, enables
> devices, writes out that checkpoint image to storage, then powers off.
> The problem is if TCP packets are received while writing to storage,
> the kernel will continue to queue and ack those TCP packets, but the
> running kernel and it's network state is shortly lost.  When the
> computer resumes, those TCP byte sequences hang the TCP connection for
> an extended period of time while the resumed computer refuses to
> acknowledge the data that was received after checkpointing and the now
> running kernel knew nothing about, and the other computer tries in
> vain to resend any data that hadn't yet been acknowledged, which is
> always after the data that was lost, until one of them eventually
> gives up.
> 
> I've been wondering if it was safe or possible to leave any network
> interfaces down after the checkpoint, or what the right solution would
> be.  I didn't think marking every TCP connection with a ZOMBIE_KERNEL
> bit just after the kernel checkpoint (for the kernel is walking dead
> and won't remember anything that happens), and then prevent any TCP
> acks from being sent for those connections would be the right
> solution.  I've taken to unplugging the physical lan cable,
> hibernating to disk, and plugging it back in after the system is down,
> to avoid the problem.  Any ideas?

Hmmm... sounds like taking down network interfaces before starting
hibernation sequence should be enough, which shouldn't be too
difficult to implement from userland.  Rafael, what do you think?

Thanks.

-- 
tejun
