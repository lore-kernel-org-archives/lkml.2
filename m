Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0L0Iu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 03:50:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56532 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab0L0Iu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 03:50:27 -0500
Message-ID: <4D185357.7090304@cn.fujitsu.com>
Date: Mon, 27 Dec 2010 16:50:31 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, jmoyer@redhat.com,
        Shaohua Li <shaohua.li@intel.com>, guijianfeng@cn.fujitsu.com
Subject: [PATCH 0/6 v3] Introduce CFQ group hierarchical scheduling and "use_hierarchy"
 interface
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-27 16:50:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-27 16:50:14
Content-Type: multipart/mixed;
 boundary="------------050509060807050506030007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--------------050509060807050506030007
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
queue and CFQ group use the same scheduling algorithm. 

"use_hierarchy" interface is now added to switch between hierarchical mode
and flat mode. It works as memcg.

--
V2 -> V3 Changes:
- Starting from cfqd->grp_service_tree for both hierarchical mode and flat mode
- Avoid recursion when allocating cfqg and force dispatch logic
- Fix a bug when boosting vdisktime
- Adjusting total_weight accordingly when changing weight
- Change group slice calculation into a hierarchical way
- Keep flat mode rather than deleting it first then adding it later
- kfree the parent cfqg if there nobody references to it
- Simplify select_queue logic by using some wrap function
- Make "use_hierarchy" interface work as memcg
- Make use of time_before() for vdisktime compare
- Update Document
- Fix some code style problems

--
V1 -> V2 Changes:
- Raname "struct io_sched_entity" to "struct cfq_entity" and don't differentiate
  queue_entity and group_entity, just use cfqe instead. 
- Give newly added cfqq a small vdisktime jump accord to its ioprio.
- Make flat mode as default CFQ group scheduling mode.
- Introduce "use_hierarchy" interface.
- Update blkio cgroup documents

Benchmarks:
I made use of Vivek's iostest to perform some benchmarks on my box. I tested different workloads with
idling on and off. I didn't see any performance drop comparing to vanilla kernel. The attached files
are some performance numbers on vanilla Kernel and patched Kernel.

[PATCH 1/6 v3] cfq-iosched: Introduce cfq_entity for CFQ queue
[PATCH 2/6 v3] cfq-iosched: Introduce cfq_entity for CFQ group
[PATCH 3/6 v3] cfq-iosched: Introduce vdisktime and io weight for CFQ queue
[PATCH 4/6 v3] cfq-iosched: Extract some common code of service tree handling for CFQ queue and CFQ group
[PATCH 5/6 v3] cfq-iosched: CFQ group hierarchical scheduling and use_hierarchy interface
[PATCH 6/6 v3] blkio-cgroup: Document for blkio.use_hierarchy interface






--------------050509060807050506030007
Content-Type: text/plain;
 name="Hier_v3.log"
Content-Disposition: inline;
 filename="Hier_v3.log"
Content-Transfer-Encoding: quoted-printable

Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbrr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D0    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Abrr     1   1   748    748    749    747    =
2992   =0Abrr     1   2   256    566    865    896    2583   =0Abrr     1  =
 4   154    318    560    1084   2116   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Dbrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Abrr     1   1   380    728    1074   1443   3625   =0Abrr     1   2   2=
01    427    713    1252   2593   =0Abrr     1   4   146    327    551    1=
111   2135   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Dbsr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D0    group=5Fidle=3D0    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Absr     1   1   77=
97   7799   7788   7805   31189  =0Absr     1   2   3026   6433   9643   99=
53   29055  =0Absr     1   4   2302   4582   7507   13557  27948  =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbsr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Absr     1   1   6288   10419  15332  20832  =
52871  =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-=
+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostest=
mnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Ddrr      iosch=
ed=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=
=3D0    group=5Fidle=3D0    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drr]    [bw in KB/s]  =
  =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---  =
   --- --  -----------------------------------=0Adrr     1   1   757    757=
    757    755    3026   =0Adrr     1   2   233    547    829    919    252=
8   =0Adrr     1   4   143    306    574    1071   2094   =0A=0A=0AHost=3Dl=
ocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1  =
        NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/de=
v/sdb2                 =0AWorkload=3Ddrr      iosched=3Dcfq     Filesz=3D51=
2M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8 =
   quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0AAVERAGE[drr]    [bw in KB/s]    =0A------- =0Ajob     Set=
 NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  ----------------=
-------------------=0Adrr     1   1   371    729    1080   1429   3609   =
=0Adrr     1   2   192    409    793    1260   2654   =0Adrr     1   4   15=
3    316    578    1066   2113   =0A=0A=0AHost=3Dlocalhost.localdomain     =
Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4        =
     =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2                 =
=0AWorkload=3Ddrw      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=
=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fidle=3D0    quantum=3D8    =0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVE=
RAGE[drw]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cg=
rp3  cgrp4  total  =0A---     --- --  -----------------------------------=
=0Adrw     1   1   1529   1530   1531   1532   6122   =0Adrw     1   2   52=
1    931    1185   1224   3861   =0Adrw     1   4   150    382    988    15=
88   3108   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-B=
lock-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/io=
stestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Ddrw      =
iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5F=
idle=3D8    group=5Fidle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drw]    [bw in KB/s=
]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A--=
-     --- --  -----------------------------------=0Adrw     1   1   529    =
1243   1887   2778   6437   =0Adrw     1   2   296    717    1259   1817   =
4089   =0Adrw     1   4   164    403    937    1662   3166   =0A=0A=0A=

--------------050509060807050506030007
Content-Type: text/plain;
 name="Vanilla.log"
Content-Disposition: inline;
 filename="Vanilla.log"
Content-Transfer-Encoding: quoted-printable

Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbrr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D0    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Abrr     1   1   759    759    760    758    =
3036   =0Abrr     1   2   224    549    849    903    2525   =0Abrr     1  =
 4   146    307    558    1090   2101   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Dbrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[brr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Abrr     1   1   375    734    1080   1426   3615   =0Abrr     1   2   1=
68    418    767    1233   2586   =0Abrr     1   4   151    333    581    1=
068   2133   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Dbsr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D0    group=5Fidle=3D0    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Absr     1   1   80=
00   8015   8027   8159   32201  =0Absr     1   2   3200   6302   9612   10=
018  29132  =0Absr     1   4   2153   4408   7857   13590  28008  =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Dbsr      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fi=
dle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[bsr]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Absr     1   1   6988   11575  17883  23389  =
59835  =0Absr     1   2   6808   11453  15979  19838  54078  =0Absr     1  =
 4   5352   10986  14529  18189  49056  =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Ddrr      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fidle=3D0    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[drr]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Adrr     1   1   736    737    737    735    2945   =0Adrr     1   2   2=
14    550    854    912    2530   =0Adrr     1   4   148    312    591    1=
069   2120   =0A=0A=0AHost=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-=
Block-+     =0AGROUPMODE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/i=
ostestmnt/fio        DEV=3D/dev/sdb2                 =0AWorkload=3Ddrr     =
 iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=
=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drr]    [bw in K=
B/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =
=0A---     --- --  -----------------------------------=0Adrr     1   1   37=
1    722    1059   1423   3575   =0Adrr     1   2   173    412    805    12=
58   2648   =0Adrr     1   4   155    305    555    1075   2090   =0A=0A=0A=
Host=3Dlocalhost.localdomain     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMO=
DE=3D1          NRGRP=3D4             =0ADIR=3D/mnt/iostestmnt/fio        D=
EV=3D/dev/sdb2                 =0AWorkload=3Ddrw      iosched=3Dcfq     Fil=
esz=3D512M bs=3D32k  =0Agroup=5Fisolation=3D1 slice=5Fidle=3D0    group=5Fi=
dle=3D0    quantum=3D8    =0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=0AAVERAGE[drw]    [bw in KB/s]    =0A------- =0Ajo=
b     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  =0A---     --- --  -------=
----------------------------=0Adrw     1   1   1491   1491   1491   1491   =
5964   =0Adrw     1   2   556    869    1082   1201   3708   =0Adrw     1  =
 4   160    335    830    1690   3015   =0A=0A=0AHost=3Dlocalhost.localdoma=
in     Kernel=3D2.6.37-rc2-Block-+     =0AGROUPMODE=3D1          NRGRP=3D4 =
            =0ADIR=3D/mnt/iostestmnt/fio        DEV=3D/dev/sdb2            =
     =0AWorkload=3Ddrw      iosched=3Dcfq     Filesz=3D512M bs=3D32k  =0Agr=
oup=5Fisolation=3D1 slice=5Fidle=3D8    group=5Fidle=3D8    quantum=3D8    =
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
AVERAGE[drw]    [bw in KB/s]    =0A------- =0Ajob     Set NR  cgrp1  cgrp2 =
 cgrp3  cgrp4  total  =0A---     --- --  ----------------------------------=
-=0Adrw     1   1   545    1343   2016   2743   6647   =0Adrw     1   2   2=
68    696    1361   1942   4267   =0Adrw     1   4   140    357    775    1=
880   3152   =0A=0A=0A=

--------------050509060807050506030007--
