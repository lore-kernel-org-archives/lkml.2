Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908Ab1EDEAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 00:00:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:44378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab1EDEAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 00:00:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,312,1301900400"; 
   d="sh'?scan'208";a="637555074"
Date: Wed, 4 May 2011 12:00:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC][PATCH] mm: cut down __GFP_NORETRY page allocation
 failures
Message-ID: <20110504040018.GB6500@localhost>
References: <BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
 <BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
 <20110426062535.GB19717@localhost>
 <BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
 <20110426063421.GC19717@localhost>
 <BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
 <20110426092029.GA27053@localhost>
 <20110426124743.e58d9746.akpm@linux-foundation.org>
 <20110428133644.GA12400@localhost>
 <BANLkTimpT-N5--3QjcNg8CyNNwfEWxFyKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimpT-N5--3QjcNg8CyNNwfEWxFyKA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

> > CAL:     220449     220246     220372     220558     220251     219740     220043     219968   Function call interrupts
> >
> > LOC:     536274     532529     531734     536801     536510     533676     534853     532038   Local timer interrupts
> > RES:       3032       2128       1792       1765       2184       1703       1754       1865   Rescheduling interrupts
> > TLB:        189         15         13         17         64        294         97         63   TLB shootdowns
> 
> Could you tell how to get above info?

It's /proc/interrupts.

I have two lines at the end of the attached script to collect the
information, and another script to call getdelays on every 10s. The
posted reclaim delays are the last successful getdelays output. 

I've automated the test process, so that with one single command line
a new kernel will be built and the test box will rerun tests on the
new kernel :)

Thanks,
Fengguang

--qMm9M+Fa2AknHoGS
Content-Type: application/x-sh
Content-Disposition: attachment; filename="test-alloc-fails.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0Aver=3D`date +'%F-%T'`=0A=0Aln -fs alloc-fails-$ver /log/allo=
c-fails=0Aln -fs alloc-delays-$ver /log/alloc-delays=0A=0A/home/wfg/test-dd=
-sparse.sh > /log/alloc-fails-$ver &=0A=0Asleep 10=0A=0A(=0Awhile /usr/loca=
l/bin/getdelays -dip `pidof dd`;=0Ado=0A	sleep 10;=0Adone=0A) > /log/alloc-=
delays-$ver=0A
--qMm9M+Fa2AknHoGS
Content-Type: application/x-sh
Content-Disposition: attachment; filename="test-dd-sparse.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0Amount /dev/sda7 /fs=0A=0A# echo 80000 > /proc/sys/vm/min_fre=
e_kbytes=0A=0Atic=3D$(date +'%s')=0A=0Afor i in `seq 1000`=0Ado=0A	truncate=
 -s 1G /fs/sparse-$i=0A	dd if=3D/fs/sparse-$i of=3D/dev/null &>/dev/null &=
=0Adone=0A=0Atac=3D$(date +'%s')=0Aecho start time: $((tac-tic))=0A=0Await=
=0A=0Atac=3D$(date +'%s')=0Aecho total time: $((tac-tic))=0A=0Aegrep '(nr_a=
lloc_fail|allocstall)' /proc/vmstat=0Aegrep '(CAL|RES|LOC|TLB)' /proc/inter=
rupts=0A
--qMm9M+Fa2AknHoGS--
