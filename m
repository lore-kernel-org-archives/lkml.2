Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2A0Emx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:42:53 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56315 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab2A0Emq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:42:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>
Subject: [Review][PATCH][0/29] sysctl rewrite for speed and clarity
Date: Thu, 26 Jan 2012 20:45:20 -0800
Message-ID: <m1pqe5ah3z.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+LZn/tSAn2f0Ki75Pdq4o6aGjETFAzwWI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The problem:

   The current implementation of sysctl has data structures and semantics
   that are hard to understand, and causes sysctl to run slowly.
   Sysctl running slowly is a scaling problem in general and the network
   stack in particular.

After some heavy testing and way way too much patch rewriting I believe I
have a patchset that seems sane and reasonable and gets to what looks to
my weary eyes a sane result.

My patchset was heavily inspired by the previous work done by Lucian
Grinjincu.  Lucian kept the need for this work alive, and did a much
better job than I ever though he did.  Unfortunately I missed a lot
of the good things Lucian did my rushed attempts at code review.

This code is also available at:
kernel.org/pub/scm/linux/kernel/git/ebiederm/sysctl.git

Eric W. Biederman (28):
      sysctl: Consolidate !CONFIG_SYSCTL handling
      sysctl: Register the base sysctl table like any other sysctl table.
      sysctl: Move the implementation into fs/proc/proc_sysctl.c
      sysctl: Make the directories have nlink == 1
      sysctl: Implement retire_sysctl_set
      sysctl: Remove the unnecessary sysctl_set parent concept.
      sysctl: Create local copies of directory names used in paths
      sysctl: Add support for register sysctl tables with a normal cstring path.
      sysctl: Add ctl_table chains into cstring paths
      sysctl: register only tables of sysctl files
      sysctl: Improve the sysctl sanity checks
      sysctl: Remove the now unused ctl_table parent field.
      sysctl: A more obvious version of grab_header.
      sysctl: Initial support for auto-unregistering sysctl tables.
      sysctl: Factor out init_header from __register_sysctl_paths
      sysctl: Factor out insert_header and erase_header
      sysctl: Normalize the root_table data structure.
      sysctl: Rewrite proc_sys_lookup introducing find_entry and lookup_entry.
      sysctl: Rewrite proc_sys_readdir in terms of first_entry and next_entry
      sysctl: Add a root pointer to ctl_table_set
      sysctl: Stop requiring explicit management of sysctl directories
      sysctl: Add sysctl_print_dir and use it in get_subdir
      sysctl: Replace root_list with links between sysctl_table_sets.
      sysctl: Modify __register_sysctl_paths to take a set instead of a root and an nsproxy
      sysctl: Move sysctl_check_dups into insert_header
      sysctl: Make the header lists per directory.
      sysctl: Index sysctl directories with rbtrees.
      sysctl: Add register_sysctl for normal sysctl users

Lucas De Marchi (1):
      sysctl: remove impossible condition check

 fs/proc/internal.h     |    3 +
 fs/proc/proc_sysctl.c  | 1240 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/sysctl.h |  106 +++--
 kernel/Makefile        |    1 -
 kernel/sysctl.c        |  501 +-------------------
 kernel/sysctl_check.c  |  160 -------
 lib/Kconfig.debug      |    8 -
 net/sysctl_net.c       |   24 +-
 8 files changed, 1247 insertions(+), 796 deletions(-)


Eric

