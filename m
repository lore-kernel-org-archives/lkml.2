Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0JBXSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 19:18:22 -0400
Received: from fisica.ufpr.br ([200.17.209.129]:54886 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab0JBXSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 19:18:20 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Oct 2010 19:18:20 EDT
From: Carlos Carvalho <carlos@fisica.ufpr.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19623.48074.873182.970865@fisica.ufpr.br>
Date: Sat, 2 Oct 2010 20:10:02 -0300
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/17] fs: Inode cache scalability
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have serious problems with 34.6 in a machine with ~11TiB xfs, with
a lot of simultaneous IO, particularly hundreds of rm and a sync
afterwards. Maybe they're related to these issues.

The machine is a file server (almost all via http/apache) and has
several thousand connections all the time. It behaves quite well for
at most 4 days; from then on kswapd's start appearing on the display
of top consuming ever increasing percentages of cpu. This is no
problem, the machine has 16 nearly idle cores. However, after about
5-7 days there's an abrupt transition: in about 30s the load goes to
several thousand, apache shows up consuming all possible cpu and
downloads nearly stop. I have to reboot the machine to get service
back. It manages to unmount the filesystems and reboot properly.

Stopping/restarting apache restores the situation but only for
a short while; after about 2-3h the problem reappears. That's why I
have to reboot.

With 35.6 the behaviour seems to have changed: now often
CONFIG_DETECT_HUNG_TASK produces this kind of call trace in the log:

[<ffffffff81098578>] ? igrab+0x10/0x30
[<ffffffff811160fe>] ? xfs_sync_inode_valid+0x4c/0x76
[<ffffffff81116241>] ? xfs_sync_inode_data+0x1b/0xa8
[<ffffffff811163e0>] ? xfs_inode_ag_walk+0x96/0xe4
[<ffffffff811163dd>] ? xfs_inode_ag_walk+0x93/0xe4
[<ffffffff81116226>] ? xfs_sync_inode_data+0x0/0xa8
[<ffffffff81116495>] ? xfs_inode_ag_iterator+0x67/0xc4
[<ffffffff81116226>] ? xfs_sync_inode_data+0x0/0xa8
[<ffffffff810a48dd>] ? sync_one_sb+0x0/0x1e
[<ffffffff81116712>] ? xfs_sync_data+0x22/0x42
[<ffffffff810a48dd>] ? sync_one_sb+0x0/0x1e
[<ffffffff8111678b>] ? xfs_quiesce_data+0x2b/0x94
[<ffffffff81113f03>] ? xfs_fs_sync_fs+0x2d/0xd7
[<ffffffff810a48dd>] ? sync_one_sb+0x0/0x1e
[<ffffffff810a48c4>] ? __sync_filesystem+0x62/0x7b
[<ffffffff8108993e>] ? iterate_supers+0x60/0x9d
[<ffffffff810a493a>] ? sys_sync+0x3f/0x53
[<ffffffff81001dab>] ? system_call_fastpath+0x16/0x1b

It doesn't seem to cause service disruption (at least the flux graphs
don't show drops). I didn't see it happen while I was watching so it
may be that service degrades for short intervals. Uptime with 35.6 is
only 3d8h so it's still not sure that the breakdown of 34.6 is gone
but kswapd's cpu usages are very small, less than with 34.6 for a
similar uptime. There are only 2 filesystems, and the big one has 256
AGs. They're not mounted with delaylog.
