Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0C2QVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:21:33 -0400
Received: from exhub016-3.exch016.msoutlookonline.net ([207.5.72.226]:53417
	"EHLO EXHUB016-3.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab0C2QVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:21:30 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2010 12:21:30 EDT
Message-ID: <4BB0D12B.6060701@cfl.rr.com>
Date: Mon, 29 Mar 2010 12:11:23 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Extended partition mapping wrong size
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been investigating a problem I ran into trying to create partitions
in sector mode and found that the first logical partition can not begin
on the very first sector of the extended partition, immediately
following the EBR.  This apparently is because the kernel creates a dev
node to represent the extended partition and sizes it to two sectors.  I
could have sworn that the kernel did not used to create a device for the
extended partition itself, but I wondered why it was 2 sectors long.  I
found this:

from fs/partitions/msdos.c:

            /* prevent someone doing mkfs or mkswap on an
               extended partition, but leave room for LILO */
            put_partition(state, slot, start, size == 1 ? 1 : 2);

This appears to set the size of the device to 2 sectors, unless the
extended partition is only 1 sector long.  Shouldn't the size be
whatever length there is between the start of the extended partition,
and the first logical partition it contains?  So if there are 63 sectors
there, as is the usual case when using cylinder alignment, then the
device node would expose all of those, but if there is no space, then
the device node should only be 1 sector for the EBR, otherwise it
overlays the first sector of the logical partition.
