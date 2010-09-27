Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab0I0LGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:06:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47095 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab0I0LGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:06:13 -0400
Date: Mon, 27 Sep 2010 13:06:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Doug Thompson <norsk5@yahoo.com>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac fix for 36-rc6
Message-ID: <20100927110656.GB2834@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following fix so that rmmod'ing the amd64_edac module
doesn't hang anymore, details in the commit message below.

Thanks.

--
amd64_edac: Fix driver module removal

f4347553b30ec66530bfe63c84530afea3803396 removed the edac polling
mechanism in favor of using a notifier chain for conveying MCE
information to edac. However, the module removal path didn't test
whether the driver had setup the polling function workqueue at all and
the rmmod process was hanging in the kernel at try_to_del_timer_sync()
in the cancel_delayed_work() path while trying to cancel an
uninitialized work struct.

Fix that by adding a balancing check to the workqueue removal path.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 3630308..6b21e25 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -339,6 +339,9 @@ static void edac_mc_workq_teardown(struct mem_ctl_info *mci)
 {
 	int status;

+	if (mci->op_state != OP_RUNNING_POLL)
+		return;
+
 	status = cancel_delayed_work(&mci->work);
 	if (status == 0) {
 		debugf0("%s() not canceled, flush the queue\n",

--

The following changes since commit b30a3f6257ed2105259b404d419b4964e363928c:

  Linux 2.6.36-rc5 (2010-09-20 16:56:53 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (1):
      amd64_edac: Fix driver module removal

 drivers/edac/edac_mc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
