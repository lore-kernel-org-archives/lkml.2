Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0IMHTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:19:50 -0400
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:20296 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752920Ab0IMHTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:19:48 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: a_Ym2TYVM1kN2OxQYKJ92mJ_oGxp6uzv_Ai3PYA0YgcihR7
 h4JSZB8oIU2.yQW1E.UJxZUTUvpf5clAPwwdibkalg4nJdL7PCsA8M9cfThC
 5LgG7Vsg2NPFgbeREzOboBgXazm5.10t1PRnvVMyZaPO16fQCbSNTTR3nEHO
 q0NS7Cqxq8vsSezGGHPRrfsZTim9VEzy6cJUzKf5LssKsUc.4q.p_20K5zJd
 gbK7qTFWXsBJYgQglhZN4oIU.o_LKI6xNZp0lx89H59F4jAzXpteDTjnFIs3
 n80j5wBK7BfKPCnh2M_6gYpCqTSOt_zyonVXSETL59gzD93Q5rj1BysPgHUj
 CuWSiXXaouJS0kFnJ6kyqY2.vDUxKqtUfgIpuBukgHhAnEI2_VEcGrrpu
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Florian Haas <florian.haas@linbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/2] lio-target: Add per iSCSI connection CPU scheduling affinity
Date: Mon, 13 Sep 2010 00:19:40 -0700
Message-Id: <1284362380-561-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Grettings all,

This patch series adds support for the automatic setting of CPU scheduling affinity
for iscsi_ttx and iscsi_trx kernel thread set pairs on a per iSCSI connection context
basis using a newly defined struct iscsi_conn->conn_cpumask.

This code was originally inspiried by a discussion last year at LinuxCon with
Philipp Reisner about how CPU affinity is determined for asender, worker, receiver
for each DRBD resource + underlying struct block_device.  This patch series for
LIO-Target follows a similar model for ensuring that each iSCSI connection's RX / TX
pair as scheduled to execute on the same CPU to take advantage of hot caching effects
for shared per iSCSI connection data structures.

The first patch adds support for a iscsi_global->ts_bitmap to handle the proper
atomic allocation of each thread_id using bitmap_find_free_region() and it's release
with bitmap_release_region().  The important item here is that the lowest available
thread_id in iscsi_allocate_thread_sets() with iscsi_global->ts_bitmap will always be used.

The second patch adds the primary iscsi_thread_get_cpumask() and
iscsi_thread_check_cpumask() callers, and updates the iSCSI login / connection setup
patch and the main RX / TX processing loops to check for a updated call set_cpus_allowed_ptr().
This patch also updates the per iSCSI connection release and exeception paths to call
free_cpumask_var() for struct iscsi_conn->conn_cpumask.

Many thanks again to Philip Reiser and the DRBD/Linbit team for insight into this
optimization for LIO-Target!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  lio-target: Convert to use bitmap for handling thread_id allocation
  lio-target: Add support for per iSCSI connection CPU scheduling
    affinity

 drivers/target/lio-target/iscsi_target.c       |   96 +++++++++++++++++++++++-
 drivers/target/lio-target/iscsi_target.h       |    1 +
 drivers/target/lio-target/iscsi_target_core.h  |   12 +++-
 drivers/target/lio-target/iscsi_target_login.c |   23 ++++++
 drivers/target/lio-target/iscsi_thread_queue.c |   58 +++++++++++++-
 drivers/target/lio-target/iscsi_thread_queue.h |    5 +
 6 files changed, 184 insertions(+), 11 deletions(-)
