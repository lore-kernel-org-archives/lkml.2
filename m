Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0DFLrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab0DFLrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:47:13 -0400
Date: Tue, 6 Apr 2010 13:47:07 +0200
From: Karel Zak <kzak@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Extended partition mapping wrong size
Message-ID: <20100406114706.GA30340@nb.net.home>
References: <4BB0D12B.6060701@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB0D12B.6060701@cfl.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 12:11:23PM -0400, Phillip Susi wrote:
> I've been investigating a problem I ran into trying to create partitions
> in sector mode and found that the first logical partition can not begin
> on the very first sector of the extended partition, immediately
> following the EBR.  This apparently is because the kernel creates a dev
> node to represent the extended partition and sizes it to two sectors.

This is probably kernel bug. It's really insane that the extended
pseudo partition overflows to the next logical partition.

> could have sworn that the kernel did not used to create a device for the
> extended partition itself, but I wondered why it was 2 sectors long.  I
> found this:
> 
> from fs/partitions/msdos.c:
> 
>             /* prevent someone doing mkfs or mkswap on an
>                extended partition, but leave room for LILO */
>             put_partition(state, slot, start, size == 1 ? 1 : 2);
>
> This appears to set the size of the device to 2 sectors, unless the
> extended partition is only 1 sector long.  Shouldn't the size be
> whatever length there is between the start of the extended partition,
> and the first logical partition it contains?  So if there are 63 sectors
> there, as is the usual case when using cylinder alignment, then the

 Please no. I think the size should not be more than 2 sectors (1024
 bytes). The current concept works for years and we have in userspace 
 /etc/partitions parsers that use "if (blocks <= 1)" to detect
 extended partitions.

 The other problem are mkfs programs, the space used for alignment
 could be 1MiB (or more) -- it's enough many mkfs programs.


 BTW, Linux does not use this policy for the others nested partition
 tables (e.g. Solaris, BSD, Minix, ...). The extended dos partition
 table is exception. The primary partitions for the others nested PT
 are exported to the system with its real size :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
