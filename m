Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423938Ab2LGTOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:14:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423923Ab2LGTOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:14:18 -0500
Date: Fri, 7 Dec 2012 15:49:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH -stable 1/1] freezer: PF_FREEZER_NOSIG should be
	cleared along with PF_NOFREEZE
Message-ID: <20121207144922.GB6478@redhat.com>
References: <50BF9CC2.7070705@canonical.com> <1354762294.17107.157.camel@deadeye.wl.decadent.org.uk> <20121206124201.GA30705@redhat.com> <50C10391.4040903@canonical.com> <20121207144901.GA6478@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207144901.GA6478@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is only for pre-v3.3 stable trees which backported
b40a7959 "freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD".
v3.3+ doesn't need this fix.

b40a7959 is the trivial bugfix, but unfortunately I forgot that
until 34b087e4 "freezer: kill unused set_freezable_with_signal()"
there were another only-for-kernel-threads flag, PF_FREEZER_NOSIG,
which should be cleared as well.

See https://bugs.launchpad.net/ubuntu/+source/v86d/+bug/1080530
The freezer fails because it expects that a PF_FREEZER_NOSIG task
doesn't need a signal. Before b40a7959 it wrongly succeeds leaving
the PF_NOFREEZE | PF_FREEZER_NOSIG task unfrozen.

Reported-and-tested-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: stable@vger.kernel.org # pre v3.3 if commit b40a7959 was taken
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1084,7 +1084,7 @@ int flush_old_exec(struct linux_binprm *
 
 	set_fs(USER_DS);
 	current->flags &=
-		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
+		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE | PF_FREEZER_NOSIG);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 

