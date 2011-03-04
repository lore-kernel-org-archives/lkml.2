Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab1CDPPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:15:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1CDPPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:15:47 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] block: fix mis-synchronisation in blkdev_issue_zeroout()
References: <1299231968-5730-1-git-send-email-lczerner@redhat.com>
	<x49zkpbhszn.fsf@segfault.boston.devel.redhat.com>
	<alpine.LFD.2.00.1103041552020.5003@dhcp-27-109.brq.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 04 Mar 2011 10:15:43 -0500
In-Reply-To: <alpine.LFD.2.00.1103041552020.5003@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Fri, 4 Mar 2011 16:04:16 +0100 (CET)")
Message-ID: <x49lj0uj4rk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

> On Fri, 4 Mar 2011, Jeff Moyer wrote:
>> It seems to me like it might be better to just not complete anything
>> until the count is zero.  Why issue a wakeup for every bio?
>> fs/direct-io does something similar, maybe take a look at the
>> dio_bio_end* routines and see if that would fit well here.  With your
>> scheme, I worry about missing a completion, maybe because the first bio
>> completes before you are done submitting bios.  Is that possible?
>
> I do not think it is possible. For every bio submitted there is
> wait_for_completion called. When bio complete()s completion->done is
> incremented (under the wait->lock). In wait_for_completion() we are
> waiting for single submitted bio to complete (completion->done > 0),
> then completion->done is decremented. It seems like simple
> synchronization.
>
> I am not sure what wakeup you have in mind, but thanks for the tip I'll
> look in fs/direct-io.

Let's say you have several bios to submit, and the first bio is errored
immediately in submit_bio.  Since you didn't add yourself to the
waitqueue yet, you might miss the wakeup and sleep forever.

Cheers,
Jeff
