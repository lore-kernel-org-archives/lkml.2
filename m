Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0LMBnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 20:43:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53582 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab0LMBnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:43:51 -0500
Message-ID: <4D057A6A.8060000@cn.fujitsu.com>
Date: Mon, 13 Dec 2010 09:44:10 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
CC: Corrado Zoccolo <czoccolo@gmail.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8 v2] Introduce CFQ group hierarchical scheduling and "use_hierarchy"
 interface
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk>
In-Reply-To: <4CE2718C.6010406@kernel.dk>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:43:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-13 09:43:50
Content-Type: multipart/mixed;
 boundary="------------070707050009070603030706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------070707050009070603030706
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

Hi

Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
in the way that it puts all CFQ queues in a hidden group and schedules with other 
CFQ group under their parent. The patchset is available here,
http://lkml.org/lkml/2010/8/30/30

Vivek think this approach isn't so instinct that we should treat CFQ queues
and groups at the same level. Here is the new approach for hierarchical 
scheduling based on Vivek's suggestion. The most big change of CFQ is that
it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
queue scheduling just like CFQ group does. But I still give cfqq some jump 
in vdisktime based on ioprio, thanks for Vivek to point out this. Now CFQ 
queue and CFQ group uses the same scheduling algorithm. 

"use_hierarchy" interface is now added to switch between hierarchical mode
and flat mode. For this time being, this interface only appears in Root Cgroup.

V1 -> V2 Changes:
- Raname "struct io_sched_entity" to "struct cfq_entity" and don't differentiate
  queue_entity and group_entity, just use cfqe instead. 
- Give newly added cfqq a small vdisktime jump accord to its ioprio.
- Make flat mode as default CFQ group scheduling mode.
- Introduce "use_hierarchy" interface.
- Update blkio cgroup documents

[PATCH 1/8 v2] cfq-iosched: Introduce cfq_entity for CFQ queue
[PATCH 2/8 v2] cfq-iosched: Introduce cfq_entity for CFQ group
[PATCH 3/8 v2] cfq-iosched: Introduce vdisktime and io weight for CFQ queue
[PATCH 4/8 v2] cfq-iosched: Extract some common code of service tree handling for CFQ queue and CFQ group
[PATCH 5/8 v2] cfq-iosched: Introduce hierarchical scheduling with CFQ queue and group at the same level
[PATCH 6/8] blkio-cgroup: "use_hierarchy" interface without any functionality
[PATCH 7/8] cfq-iosched: Add flat mode and switch between two modes by "use_hierarchy"
[PATCH 8/8] blkio-cgroup: Document for blkio.use_hierarchy.

Benchmarks:
I made use of Vivek's iostest to perform some benchmarks on my box. I tested different workloads, and
didn't see any performance drop comparing to vanilla kernel. The attached files are some performance
numbers on vanilla Kernel, patched kernel with flat mode and patched kernel with hierarchical mode.





--------------070707050009070603030706
Content-Type: text/plain;
 name="patched-flat.log"
Content-Disposition: inline;
 filename="patched-flat.log"
Content-Transfer-Encoding: quoted-printable

Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbrr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Abrr     1   1   294    692    1101   1526   =
3613   =0Abrr     1   2   176    420    755    1281   2632   =0Abrr     1  =
 4   160    323    583    1253   2319   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Dbrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Abrr     1   1   380    738    1092   1439   3649   =0Abrr     1   2   1=
71    413    733    1242   2559   =0Abrr     1   4   188    350    665    1=
193   2396   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Dbsr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D0    group=5Fidle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Absr     1   1   68=
56   11480  17644  22647  58627  =0Absr     1   2   2592   5409   8464   13=
300  29765  =0Absr     1   4   2502   4635   7640   12909  27686  =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbsr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Absr     1   1   6913   11643  17843  22909  =
59308  =0Absr     1   2   6682   11234  15527  19410  52853  =0Absr     1  =
 4   5209   10882  15002  18167  49260  =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Ddrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[drr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Adrr     1   1   298    701    1117   1538   3654   =0Adrr     1   2   1=
90    372    731    1244   2537   =0Adrr     1   4   147    322    563    1=
143   2175   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Ddrr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Adrr     1   1   37=
0    713    1050   1416   3549   =0Adrr     1   2   192    434    755    12=
65   2646   =0Adrr     1   4   157    333    677    1159   2326   =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Ddrw      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drw]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Adrw     1   1   595    1272   2007   2737   =
6611   =0Adrw     1   2   269    690    1407   1953   4319   =0Adrw     1  =
 4   145    396    978    1752   3271   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Ddrw      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[drw]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Adrw     1   1   604    1310   1827   2778   6519   =0Adrw     1   2   2=
87    723    1368   1887   4265   =0Adrw     1   4   170    407    979    1=
575   3131   =0A=0A=0A=

--------------070707050009070603030706
Content-Type: text/plain;
 name="patched-hier.log"
Content-Disposition: inline;
 filename="patched-hier.log"
Content-Transfer-Encoding: quoted-printable

Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbrr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Abrr     1   1   287    690    1096   1506   =
3579   =0Abrr     1   2   189    404    800    1283   2676   =0Abrr     1  =
 4   141    317    557    1106   2121   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Dbrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Abrr     1   1   386    715    1071   1437   3609   =0Abrr     1   2   1=
87    401    717    1258   2563   =0Abrr     1   4   296    767    1553   3=
2     2648   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Dbsr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D0    group=5Fidle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Absr     1   1   69=
71   11459  17789  23158  59377  =0Absr     1   2   2592   5536   8679   13=
389  30196  =0Absr     1   4   2194   4635   7820   13984  28633  =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbsr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Absr     1   1   6851   11588  17459  22297  =
58195  =0Absr     1   2   6814   11534  16141  20426  54915  =0Absr     1  =
 4   5118   10741  13994  17661  47514  =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Ddrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[drr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Adrr     1   1   297    689    1097   1522   3605   =0Adrr     1   2   1=
75    426    757    1277   2635   =0Adrr     1   4   150    330    604    1=
100   2184   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Ddrr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Adrr     1   1   37=
9    735    1077   1436   3627   =0Adrr     1   2   190    404    760    12=
47   2601   =0Adrr     1   4   155    333    692    1044   2224   =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Ddrw      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drw]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Adrw     1   1   566    1293   2001   2686   =
6546   =0Adrw     1   2   225    662    1233   1902   4022   =0Adrw     1  =
 4   147    379    922    1761   3209   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Ddrw      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[drw]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Adrw     1   1   579    1226   2020   2823   6648   =0Adrw     1   2   2=
76    689    1288   2068   4321   =0Adrw     1   4   183    399    798    2=
113   3493   =0A=0A=0A=

--------------070707050009070603030706
Content-Type: text/plain;
 name="vanilla.log"
Content-Disposition: inline;
 filename="vanilla.log"
Content-Transfer-Encoding: quoted-printable

Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbrr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Abrr     1   1   289    684    1098   1508   =
3579   =0Abrr     1   2   178    421    765    1228   2592   =0Abrr     1  =
 4   144    301    585    1094   2124   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Dbrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Abrr     1   1   375    734    1081   1434   3624   =0Abrr     1   2   1=
72    397    700    1201   2470   =0Abrr     1   4   154    316    573    1=
087   2130   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Dbsr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D0    group=5Fidle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Absr     1   1   68=
18   11510  17820  23239  59387  =0Absr     1   2   2643   5502   8728   13=
329  30202  =0Absr     1   4   2166   4785   7344   12954  27249  =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbsr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Absr     1   1   6979   11629  17782  23064  =
59454  =0Absr     1   2   6803   11274  15865  20024  53966  =0Absr     1  =
 4   5292   10674  14504  17674  48144  =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Ddrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[drr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Adrr     1   1   298    694    1116   1540   3648   =0Adrr     1   2   1=
83    405    721    1197   2506   =0Adrr     1   4   151    296    553    1=
119   2119   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Ddrr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Adrr     1   1   36=
7    724    1078   1433   3602   =0Adrr     1   2   184    418    744    12=
45   2591   =0Adrr     1   4   157    295    562    1122   2136   =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Ddrw      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drw]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Adrw     1   1   582    1271   1948   2754   =
6555   =0Adrw     1   2   277    700    1294   1970   4241   =0Adrw     1  =
 4   172    345    928    1585   3030   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Ddrw      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[drw]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Adrw     1   1   586    1296   1888   2739   6509   =0Adrw     1   2   2=
94    749    1360   1931   4334   =0Adrw     1   4   156    337    814    1=
806   3113   =0A=0A=0A=

--------------070707050009070603030706--
