Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab1HYQAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:00:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56895 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1HYQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:00:03 -0400
Date: Thu, 25 Aug 2011 17:59:57 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110825155957.GJ2803@mtj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-7-git-send-email-tj@kernel.org>
 <20110823155221.GB25808@redhat.com>
 <20110823194451.GH2803@mtj.dyndns.org>
 <20110824141431.GA8562@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824141431.GA8562@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Aug 24, 2011 at 04:14:31PM +0200, Oleg Nesterov wrote:
> > Hmmm... can it cause disk IOs after that point?  I skimmed through and
> > couldn't spot one
> 
> I am not sure. But, say, exit_files(). We can't know what f_op->flush()
> f_op->release() can do in general. Even without i/o the exiting task can
> do a lot of different things.

Yeah, what 'freeze' should do is a bit vague on the edges, I think.
The freezer can't really halt the whole system operation including
IOs.  Tasks aren't the only source which can kick those off.  There
are other asynchronous sources, timers, IRQs and bottom halves.  For
actual disk IOs to at least SCSI/IDE devices, freezing isn't even
necessary.  Queue processing is suspended via device suspend
mechanism.  There were several drivers which didn't have proper device
suspend mechanism implemented (maybe we should implement generic queue
quiescing in block layer) but I don't know whether they are still like
that.

Anyways, freezing has never been a full solution to quiescing the
system prior to entering hibernation.  It does make sense for userland
processes but depending on it for quiescing kernel activities
including IO can't be reliable.  It should really be achieved by
device suspend (and maybe some midlayer suspending too) and I think
we're already pretty close to that.  Rafael, can you please enlighten
us on the subject?

Another freezer user is the cgroup, for this, allowing killing to
finish is quite useful as it can be used for runaway cgroup control.

Thanks.

-- 
tejun
