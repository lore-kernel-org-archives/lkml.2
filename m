Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab2ICJRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:17:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2ICJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:17:22 -0400
Date: Mon, 3 Sep 2012 11:16:55 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH v2 -tip 0/5] x86, MSI, AHCI: Support multiple MSIs
Message-ID: <cover.1346653435.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This series is against the latest tip tree.

Currently multiple MSI mode is limited to a single vector per device (at
least on x86 and PPC). This series breathes life into pci_enable_msi_block()
and makes it possible to set interrupt affinity for multiple IRQs, similarly
to MSI-X. Yet, only for x86 and only when IOMMUs are present.

Although IRQ and PCI subsystems are modified, the current behaviour left
intact. The drivers could just start using multiple MSIs just by following
the existing documentation.

The AHCI device driver makes use of the new mode and a new function -
pci_enable_msi_block_auto() - patches 4,5.

Changes since v1:
  4/5:	based on Bjorn's review pci_enable_msi_block_auto() returns
	the number of interrupts allocated or error code

  5/5:	based on Jeff's comments:

	- AHCI specific code moved from libata-core.c to libahci.c;

	- the host-wide lock concern addressed - ahci_interrupt() handler
	  split in two parts: ahci_hw_interrupt() hardware context handler
	  and ahci_thread_fn() threaded handler;

	- host->lock statistics attached;

Host-wide lock statistics summary:

  Taken using command 'if=/dev/sd{a,b,c} of=/dev/null' running in parallel
  on three SATA HDDs:
	ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
	ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
	ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)

  ahci_interrupt()
  Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-

Test	holdtime-total	waittime-total	acquis.	holdtime-avg	waittime-avg
#
01.	22565801.27	93056.41	6377094	3.538571216	0.014592291
02.	20358324.12	60825.47	6411012	3.175524257	0.009487655
03.	21190730.38	63610.38	6384508	3.319085884	0.009963239
04.	22491064.54	80624.96	6398390	3.515113105	0.012600820
05.	21986193.10	78034.38	6379092	3.446602291	0.012232835
06.	20556437.70	62314.64	6287673	3.269323596	0.009910604
07.	20477137.55	66190.92	6388507	3.205308776	0.010360937
08.	21442240.03	69306.80	6402109	3.349246323	0.010825620
						-----------	-----------
avg						3.352346931	0.011246750

  ahci_hw_interrupt()
  Capabilities: [80] MSI: Enable+ Count=16/16 Maskable- 64bit-

Test	holdtime-total	waittime-total	acquis.	holdtime-avg	waittime-avg
#
09.	8936643.32	54559.79	6505606	1.373683454	0.008386581
10.	8579972.36	51496.56	6496233	1.320761180	0.007927142
11.	8138708.47	54061.46	6494647	1.253141005	0.008324003
12.	8322068.81	60427.51	6509975	1.278356493	0.009282295
13.	8527745.18	65978.83	6515589	1.308821839	0.010126303
14.	8662461.99	57291.39	6510702	1.330495850	0.008799572
15.	8054911.26	69186.41	6514262	1.236504037	0.010620759
16.	9618631.17	39726.37	6517385	1.475842101	0.006095446
						-----------	-----------
avg						1.322200745	0.008695263
Attached patches:
  1/5: x86, MSI: Support multiple MSIs in presense of IRQ remapping
  2/5: x86, MSI: Allocate as many multiple IRQs as requested
  3/5: x86, MSI: Minor readability fixes
  4/5: PCI, MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
  5/5: AHCI: Support multiple MSIs

 Documentation/PCI/MSI-HOWTO.txt |   37 ++++++-
 arch/x86/kernel/apic/io_apic.c  |  170 +++++++++++++++++++++++++++++--
 drivers/ata/ahci.c              |   14 ++-
 drivers/ata/ahci.h              |    5 +
 drivers/ata/libahci.c           |  211 +++++++++++++++++++++++++++++++++++++-
 drivers/pci/msi.c               |   36 ++++++-
 include/linux/irq.h             |    6 +
 include/linux/msi.h             |    1 +
 include/linux/pci.h             |    7 ++
 kernel/irq/chip.c               |   30 ++++--
 kernel/irq/irqdesc.c            |   31 ++++++
 11 files changed, 509 insertions(+), 39 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ahci_stats.txt"

	ahci_interrupt()
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-

Test	holdtime-total	waittime-total	acquis.	holdtime-avg	waittime-avg
#
01.	22565801.27	93056.41	6377094	3.538571216	0.014592291
02.	20358324.12	60825.47	6411012	3.175524257	0.009487655
03.	21190730.38	63610.38	6384508	3.319085884	0.009963239
04.	22491064.54	80624.96	6398390	3.515113105	0.012600820
05.	21986193.10	78034.38	6379092	3.446602291	0.012232835
06.	20556437.70	62314.64	6287673	3.269323596	0.009910604
07.	20477137.55	66190.92	6388507	3.205308776	0.010360937
08.	21442240.03	69306.80	6402109	3.349246323	0.010825620
						-----------	-----------
avg						3.352346931	0.011246750

	ahci_hw_interrupt()
	Capabilities: [80] MSI: Enable+ Count=16/16 Maskable- 64bit-

Test	holdtime-total	waittime-total	acquis.	holdtime-avg	waittime-avg
#
09.	8936643.32	54559.79	6505606	1.373683454	0.008386581
10.	8579972.36	51496.56	6496233	1.320761180	0.007927142
11.	8138708.47	54061.46	6494647	1.253141005	0.008324003
12.	8322068.81	60427.51	6509975	1.278356493	0.009282295
13.	8527745.18	65978.83	6515589	1.308821839	0.010126303
14.	8662461.99	57291.39	6510702	1.330495850	0.008799572
15.	8054911.26	69186.41	6514262	1.236504037	0.010620759
16.	9618631.17	39726.37	6517385	1.475842101	0.006095446
						-----------	-----------
avg						1.322200745	0.008695263

                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total

Test #1
                   &(&host->lock)->rlock:         41558          41558           0.13         126.84       93056.41        5141195        6377094           0.42         197.27    22565801.27
                   ---------------------
                   &(&host->lock)->rlock          36643          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock           4915          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
                   ---------------------
                   &(&host->lock)->rlock          25017          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock          16541          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
Test #2
                   &(&host->lock)->rlock:         30714          30714           0.14         104.50       60825.47        4398165        6411012           0.23         176.84    20358324.12
                   ---------------------
                   &(&host->lock)->rlock          25858          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock           4856          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
                   ---------------------
                   &(&host->lock)->rlock          18199          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock          12515          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120

Test #3
                   &(&host->lock)->rlock:         32869          32870           0.14         106.30       63610.38        4655399        6384508           0.43         214.18    21190730.38
                   ---------------------
                   &(&host->lock)->rlock          27494          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock           5376          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
                   ---------------------
                   &(&host->lock)->rlock          19632          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock          13238          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120

Test #4
                   &(&host->lock)->rlock:         37426          37426           0.13         104.95       80624.96        5009173        6398390           0.38         189.14    22491064.54
                   ---------------------
                   &(&host->lock)->rlock           6162          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
                   &(&host->lock)->rlock          31264          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   ---------------------
                   &(&host->lock)->rlock          22271          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock          15155          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
Test #5
                   &(&host->lock)->rlock:         38154          38154           0.14         119.50       78034.38        4923881        6379092           0.24         183.30    21986193.10
                   ---------------------
                   &(&host->lock)->rlock          32396          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock           5758          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
                   ---------------------
                   &(&host->lock)->rlock          23014          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock          15140          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120

Test #6
                   &(&host->lock)->rlock:         33812          33812           0.14          98.56       62314.64        4479447        6287673           0.33         183.96    20556437.70
                   ---------------------
                   &(&host->lock)->rlock          28301          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock           5511          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
                   ---------------------
                   &(&host->lock)->rlock          21378          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock          12434          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120

Test #7
                   &(&host->lock)->rlock:         35336          35336           0.14         105.05       66190.92        4642703        6388507           0.40         179.67    20477137.55
                   ---------------------
                   &(&host->lock)->rlock          30348          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock           4988          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
                   ---------------------
                   &(&host->lock)->rlock          21983          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock          13353          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120

Test #8
                   &(&host->lock)->rlock:         37715          37715           0.14         122.00       69306.80        4827790        6402109           0.42         192.10    21442240.03
                   ---------------------
                   &(&host->lock)->rlock          31913          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock           5802          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
                   ---------------------
                   &(&host->lock)->rlock          23613          [<ffffffff81416b03>] ata_scsi_queuecmd+0x33/0x290
                   &(&host->lock)->rlock          14102          [<ffffffff814283e4>] ahci_interrupt+0x64/0x120
Test #9
                   &(&host->lock)->rlock:         24517          24519           0.11         114.67       54559.79        5550859        6505606           0.06         153.24     8936643.32
                   ---------------------
                   &(&host->lock)->rlock          10797          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          13722          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   ---------------------
                   &(&host->lock)->rlock          18255          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   &(&host->lock)->rlock           6264          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
Test #10
                   &(&host->lock)->rlock:         27503          27505           0.13         143.29       51496.56        5659327        6496233           0.06         196.87     8579972.36
                   ---------------------
                   &(&host->lock)->rlock          10952          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          16553          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   ---------------------
                   &(&host->lock)->rlock           6553          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          20952          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130

Test #11
                   &(&host->lock)->rlock:         25655          25658           0.12         118.67       54061.46        5690296        6494647           0.07         210.10     8138708.47
                   ---------------------
                   &(&host->lock)->rlock          16681          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock           8977          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   ---------------------
                   &(&host->lock)->rlock          11899          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          13759          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130

Test #12
                   &(&host->lock)->rlock:         36741          36742           0.12         113.75       60427.51        5624197        6509975           0.06         226.06     8322068.81
                   ---------------------
                   &(&host->lock)->rlock          24149          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          12593          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   ---------------------
                   &(&host->lock)->rlock          18710          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          18032          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130

Test #13
                   &(&host->lock)->rlock:         25348          25350           0.16         129.52       65978.83        5632012        6515589           0.06         154.50     8527745.18
                   ---------------------
                   &(&host->lock)->rlock          10507          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          14843          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   ---------------------
                   &(&host->lock)->rlock          20301          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   &(&host->lock)->rlock           5049          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0

Test #14
                   &(&host->lock)->rlock:         33124          33125           0.11         117.73       57291.39        5621960        6510702           0.06         209.74     8662461.99
                   ---------------------
                   &(&host->lock)->rlock          14406          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          18719          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   ---------------------
                   &(&host->lock)->rlock           9999          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          23126          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130

Test #15
                   &(&host->lock)->rlock:         24801          24801           0.14         130.18       69186.41        5468958        6514262           0.07         160.17     8054911.26
                   ---------------------
                   &(&host->lock)->rlock          16013          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock           8788          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   ---------------------
                   &(&host->lock)->rlock          10132          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          14669          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130

Test #16
                   &(&host->lock)->rlock:         29420          29422           0.15         112.77       39726.37        5609359        6517385           0.06         160.30     9618631.17
                   ---------------------
                   &(&host->lock)->rlock          14040          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          15382          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130
                   ---------------------
                   &(&host->lock)->rlock          10237          [<ffffffff814280d8>] ahci_thread_fn+0x48/0xa0
                   &(&host->lock)->rlock          19185          [<ffffffff81428164>] ahci_hw_interrupt+0x34/0x130


--oyUTqETQ0mS9luUI--
