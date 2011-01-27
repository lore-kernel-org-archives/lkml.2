Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab1A0XxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:53:20 -0500
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:56278 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1A0XxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:53:19 -0500
Message-ID: <4D42056E.2050505@hardwarefreak.com>
Date: Thu, 27 Jan 2011 17:53:18 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: david@lang.hm
CC: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>,
        Mark Lord <kernel@teksavvy.com>
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>	<4D419765.4070805@teksavvy.com>	<4D41CA16.8070001@hardwarefreak.com> <alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1101271209370.17579@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm put forth on 1/27/2011 2:11 PM:

> how do I understand how to setup things on multi-disk systems? the documentation
> I've found online is not that helpful, and in some ways contradictory.

Visit http://xfs.org  There you will find:

Users guide:
http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/index.html

File system structure:
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/index.html

Training labs:
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Labs/tmp/en-US/html/index.html

> If there really are good rules for how to do this, it would be very helpful if
> you could just give mkfs.xfs the information about your system (this partition
> is on a 16 drive raid6 array) and have it do the right thing.

If your disk array is built upon Linux mdraid, recent versions of mkfs.xfs will
read the parameters and automatically make the filesystem accordingly, properly.

mxfs.fxs will not do this for PCIe/x hardware RAID arrays or external FC/iSCSI
based SAN arrays as there is no standard place to acquire the RAID configuration
information for such systems.  For these you will need to configure mkfs.xfs
manually.

At minimum you will want to specify stripe width (sw) which needs to match the
hardware stripe width.  For RAID0 sw=[#of_disks].  For RAID 10, sw=[#disks/2].
For RAID5 sw=[#disks-1].  For RAID6 sw=[#disks-2].

You'll want at minimum agcount=16 for striped hardware arrays.  Depending on the
number and spindle speed of the disks, the total size of the array, the
characteristics of the RAID controller (big or small cache), you may want to
increase agcount.  Experimentation may be required to find the optimum
parameters for a given hardware RAID array.  Typically all other parameters may
be left at defaults.

Picking the perfect mkfs.xfs parameters for a hardware RAID array can be
somewhat of a black art, mainly because no two vendor arrays act or perform
identically.

Systems of a caliber requiring XFS should be thoroughly tested before going into
production.  Testing _with your workload_ of multiple parameters should be
performed to identify those yielding best performance.

-- 
Stan
