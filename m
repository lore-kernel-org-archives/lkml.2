Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2KDNAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:00:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2KDM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 07:59:56 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>
Subject: [PATCH 00/13] A simple hardware detector for latency as well as throughtput ver 0.10
Date: Sun,  4 Nov 2012 20:59:31 -0500
Message-Id: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back to July of this year, I sent the first round of the tool.
Now I've polished it a little bit.

The patch is the fist step to test some basic hardware functions like
TSC to help people understand if there is any hardware latency as well
as throughput problem exposed on bare metal or left behind by BIOS or
interfered by SMI. Currently the patch tests TSC, CPU Frequency, and
RDRAND, which is a new CPU instruction to get random number introudced
in new CPU like Intel Ivy Bridge, in stop_machine context.

Some test I did on a old P4 and a latest IvyBridge latpop: X230 as follows:

P4:
[root@p4 hw_latency_test]# modprobe hw_latency_test
[root@p4 hw_latency_test]# cd /sys/kernel/debug/hw_latency_test/
[root@p4 hw_latency_test]# ls
available  count  current  enable  max  sample  threshold  window
[root@p4 hw_latency_test]# cat available 
mem random_bytes freq tsc 
[root@p4 hw_latency_test]# echo mem > current
[root@p4 hw_latency_test]# echo 1 > enable 
[root@p4 hw_latency_test]# cat sample 
[0]1061813091.0918683721	176ns	[ffffffffc0001329]
[0]1061813092.0419683746	132ns	[ffffffffc0002750]
[0]1061813092.0920683770	194ns	[ffffffffc0003993]
[0]1061813093.0421683794	194ns	[ffffffffc0004bd6]
[0]1061813093.0922683818	175ns	[ffffffffc0005f51]
[0]1061813094.0423683843	177ns	[ffffffffc000722b]
[0]1061813094.0924683867	178ns	[ffffffffc00085a5]
[0]1061813095.0425683891	177ns	[ffffffffc0009920]
[0]1061813095.0926683915	179ns	[ffffffffc000ac9a]
[0]1061813096.0427683940	224ns	[ffffffffc000c013]
[0]1061813096.0928683964	179ns	[ffffffffc000d38d]
[0]1061813097.0429683988	175ns	[ffffffffc000e708]
[0]1061813097.0930684012	179ns	[ffffffffc000fa82]
[0]1061813098.0431684037	194ns	[ffffffffc0010dfc]
^C
[root@p4 hw_latency_test]# echo 0 > enable 
[root@p4 hw_latency_test]# echo random_bytes > current 
[root@p4 hw_latency_test]# echo 1 > enable 
[0]1061813148.0873686478	247us	[0]
[0]1061813149.0874686526	244us	[0]
[0]1061813150.0877686575	246us	[0]
[0]1061813151.0878686623	245us	[0]
^C
[root@p4 hw_latency_test]# echo 0 > enable 
[root@p4 hw_latency_test]# echo freq > current 
[root@p4 hw_latency_test]# echo 1 > enable 
[root@p4 hw_latency_test]# cat sample 
[0]1061813198.0701688889	245us	[0]
[0]1061813199.0713688938	273us	[0]
[0]1061813200.0725688987	232us	[0]
[0]1061813201.0736689036	265us	[0]
[0]1061813202.0747689085	257us	[0]
[0]1061813203.0758689134	265us	[0]
^C
[root@p4 hw_latency_test]# echo 0 > enable 
[root@p4 hw_latency_test]# echo tsc > current 
[root@p4 hw_latency_test]# echo 1 > enable 
[0]1061813225.0514690187	138ns	[0]
[0]1061813226.0015690211	139ns	[0]
[0]1061813226.0516690236	152ns	[0]
^C
[root@p4 hw_latency_test]# 

IvyBridge (thinkpad x230):
[root@ivb hw_latency_test]# echo mem > current
[root@ivb hw_latency_test]# echo 1 > enable 
[root@ivb hw_latency_test]# cat sample 
[0]1352079648.0152669920	190ns	[ffff880000002486]
[0]1352079648.0654669947	167ns	[ffff88000000490c]
[0]1352079649.0155669973	317ns	[ffff880000006d90]
[0]1352079649.0656669999	214ns	[ffff880000009215]
[0]1352079650.0157670025	163ns	[ffff88000000b72f]
[0]1352079650.0658670052	150ns	[ffff88000000dbb5]
[0]1352079651.0159670078	398ns	[ffff88000000ffa8]
[0]1352079651.0660670104	367ns	[ffff88000001242a]
[0]1352079652.0161670131	193ns	[ffff8800000148b0]
[root@ivb hw_latency_test]# echo 0 > enable 
[root@ivb hw_latency_test]# echo random_bytes > current
[root@ivb hw_latency_test]# echo 1 > threshold
[root@ivb hw_latency_test]# echo 1 > enable 
[root@ivb hw_latency_test]# cat sample 
[3]1352079707.0143673015	17us	[0]
[0]1352079708.0144673068	16us	[0]
[1]1352079708.0144673068	16us	[0]
[2]1352079708.0144673068	24us	[0]
[3]1352079708.0144673068	17us	[0]
[0]1352079709.0145673120	24us	[0]
[1]1352079709.0145673120	17us	[0]
[2]1352079709.0145673120	17us	[0]
[3]1352079709.0145673120	22us	[0]
^C


ot@ivb hw_latency_test]# echo 0 > enable 
[root@ivb hw_latency_test]# echo freq > current
[root@ivb hw_latency_test]# echo 10 > threshold
[root@ivb hw_latency_test]# echo 1 > enable 
[root@ivb hw_latency_test]# 
[root@ivb hw_latency_test]# cat sample 
[0]1352079763.0780675986	195us	[0]
[1]1352079764.0285676013	281us	[0]
[2]1352079764.0790676039	193us	[0]
[3]1352079765.0296676066	225us	[0]
[0]1352079766.0303676119	228us	[0]
[1]1352079766.0808676145	269us	[0]
[2]1352079767.0313676172	195us	[0]
[3]1352079767.0819676198	220us	[0]
^C
[root@ivb hw_latency_test]# echo 0 > enable 
[root@ivb hw_latency_test]# echo tsc > current
[root@ivb hw_latency_test]# echo 1 > enable 
[root@ivb hw_latency_test]# cat sample 

[0]1352079798.0116677788	76ns	[0]
[1]1352079798.0116677788	84ns	[0]
[2]1352079798.0116677788	52ns	[0]
[3]1352079798.0116677788	52ns	[0]
[0]1352079798.0617677814	89ns	[0]
[1]1352079798.0617677814	84ns	[0]
[2]1352079798.0617677814	74ns	[0]
[3]1352079798.0617677814	61ns	[0]
^C

Luming Yu (13):
  HW-latency: hardware latency test 0.10
  HW-latency: Fix a lockdep warnning
  HW-latency: Use get_random_bytes_arch
  HW-latency: Differentiate three modes to use CPU carry out testing
  HW-latency: Add CPU field in sample output
  HW-latency: cycle through all online cpus to re-test cpufreq
  HW-latency: delete too many "Fast TSC calibration using PIT" in
    cpufreq sampling
  HW-latency: A stupid memory scanner for raw memory latency test
  HW-latency: Fix unwanted crash caused by write to dummy debugfs
    interface
  HW-latency: add address range for x86-32
  HW-latency: fix a warnning in previous patch
  HW-latency: Add sample unit in sample data
  HW-latency: some sample data format change

 arch/x86/kernel/tsc.c          |   2 +-
 drivers/misc/Kconfig           |   7 +
 drivers/misc/Makefile          |   1 +
 drivers/misc/hw_latency_test.c | 922 +++++++++++++++++++++++++++++++++++++++++
 fs/libfs.c                     |   2 +-
 5 files changed, 932 insertions(+), 2 deletions(-)
 create mode 100644 drivers/misc/hw_latency_test.c

-- 
1.7.12.1

