Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2JQCYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:24:13 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45136 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2JQCYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:24:11 -0400
Subject: [PATCH RFC V2 0/5] Separate consigned (expected steal) from steal
 time.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com,
        anthony@codemonkey.ws
Date: Tue, 16 Oct 2012 21:23:45 -0500
Message-ID: <20121017022249.16949.2775.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101702-3864-0000-0000-0000051926B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of where you have a system that is running in a
capped or overcommitted environment the user may see steal time
being reported in accounting tools such as top or vmstat.  This can
cause confusion for the end user.  To ease the confusion this patch set
adds the idea of consigned (expected steal) time.  The host will separate
the consigned time from the steal time.  The consignment limit passed to the
host will be the amount of steal time expected within a fixed period of
time.  Any other steal time accruing during that period will show as the
traditional steal time.

TODO:
* Change native_clock to take params and not return a value
* Change update_rq_clock_task

Changes from V1:
* Removed the steal time allowed percentage from the guest
* Moved the separation of consigned (expected steal) and steal time to the
  host.
* No longer include a sysctl interface.

---

Michael Wolf (5):
      Alter the amount of steal time reported by the guest.
      Expand the steal time msr to also contain the consigned time.
      Add the code to send the consigned time from the host to the guest
      Add a timer to allow the separation of consigned from steal time.
      Add an ioctl to communicate the consign limit to the host.


 arch/x86/include/asm/kvm_host.h |   11 +++++++++
 arch/x86/include/asm/kvm_para.h |    3 ++
 arch/x86/include/asm/paravirt.h |    4 ++-
 arch/x86/kernel/kvm.c           |    8 ++----
 arch/x86/kvm/x86.c              |   50 ++++++++++++++++++++++++++++++++++++++-
 fs/proc/stat.c                  |    9 +++++--
 include/linux/kernel_stat.h     |    2 ++
 include/linux/kvm.h             |    2 ++
 include/linux/kvm_host.h        |    2 ++
 kernel/sched/cputime.c          |   21 +++++++++++++++-
 kernel/sched/sched.h            |    2 ++
 virt/kvm/kvm_main.c             |    7 +++++
 12 files changed, 108 insertions(+), 13 deletions(-)

