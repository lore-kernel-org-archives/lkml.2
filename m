Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2BMRpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:45:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340Ab2BMRpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:45:38 -0500
Message-ID: <4F394C35.1020908@redhat.com>
Date: Mon, 13 Feb 2012 18:45:25 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] block: avoid false positive warnings on ioctl to partition
References: <1329153206-31355-1-git-send-email-pbonzini@redhat.com> <20120213172527.40ac390b@pyramind.ukuu.org.uk>
In-Reply-To: <20120213172527.40ac390b@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 06:25 PM, Alan Cox wrote:
> Firstly blocking CAP_SYS_RAWIO access by any means to a partition is
> itself nonsense as the process has enough privilege to go poke the
> controller I/O registers by hand.

What if a process has dropped all capabilities except CAP_SYS_RAWIO, and 
has permission to access to /dev/sdb1 and /dev/sda?  If ioctls are 
protected correctly, it will not be able to poke the I/O registers for 
/dev/sdb.  That's pretty much the point of this.

> Secondly SG_IO allows users to read and write blocks outside their partition as
> far as I can see from the verify logic.

Sure, I do not do any attempt to block anything for CAP_SYS_RAWIO, 
including reads/writes outside partitions.  As far as I undertsood Linus 
agreed to block SG_IO completely, except with a grace period during 
which CAP_SYS_RAWIO will still be able to use SG_IO arbitrarily.  During 
this time they'll get warnings but no change in SG_IO behavior.

> What were the SG_IO command blocks that were caught ? It's going to be
> pretty trivial to add a filter->partition_ok to some of them if need be.

INQUIRY and SYNCHRONIZE CACHE.  We certainly do not want to break the 
former right away; but given that the cause was a mistake in udev 
configuration, we can expect people to fix their rule files in 2012. 
But the latter was pointless because they should have just typed 
"apropos synchronize" and used fdatasync.

Sure, we can add something like filter->partition_ok and erect a 
security vulnerability to the status of feature.  It doesn't mean that's 
the right thing to do.

> Anyway it fails both by stopping valid stuff and not stopping insecure and
> unsafe stuff.

It is not "valid", it's at best "not harmful".

Paolo
