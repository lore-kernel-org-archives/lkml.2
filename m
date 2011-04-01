Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab1DASMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab1DASMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:12:42 -0400
Date: Fri, 1 Apr 2011 20:12:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com
Subject: [PATCH 2/4] signal: do_signal_stop: remove the unneeded
	task_clear_group_stop_pending()
Message-ID: <20110401181216.GC9010@redhat.com>
References: <20110329144603.GA29865@htj.dyndns.org> <20110329144648.GB29865@htj.dyndns.org> <20110329144710.GC29865@htj.dyndns.org> <20110330192918.GA14861@redhat.com> <20110331072942.GB3385@htj.dyndns.org> <20110331151549.GA8458@redhat.com> <20110331163441.GF3385@htj.dyndns.org> <20110331172946.GA14934@redhat.com> <20110401181123.GA9010@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401181123.GA9010@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PF_EXITING or TASK_STOPPED has already called task_participate_group_stop()
and cleared its ->group_stop. No need to do task_clear_group_stop_pending()
when we start the new group stop.

Add a small comment to explain the !task_is_stopped() check. Note that this
check is not exactly right and it can lead to unnecessary stop later if the
thread is TASK_PTRACED. What we need is task_participated_in_group_stop(),
this will be solved later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |    2 --
 1 file changed, 2 deletions(-)

--- ptrace/kernel/signal.c~2_dss_kill_tcgsp	2011-04-01 17:12:07.000000000 +0200
+++ ptrace/kernel/signal.c	2011-04-01 18:10:18.000000000 +0200
@@ -1866,7 +1866,8 @@ static int do_signal_stop(int signr)
 		 * still in effect and then receive a stop signal and
 		 * initiate another group stop.  This deviates from the
 		 * usual behavior as two consecutive stop signals can't
-		 * cause two group stops when !ptraced.
+		 * cause two group stops when !ptraced. That is why we
+		 * also check !task_is_stopped(t) below.
 		 *
 		 * The condition can be distinguished by testing whether
 		 * SIGNAL_STOP_STOPPED is already set.  Don't generate
@@ -1896,8 +1897,6 @@ static int do_signal_stop(int signr)
 				t->group_stop |= signr | gstop;
 				sig->group_stop_count++;
 				signal_wake_up(t, 0);
-			} else {
-				task_clear_group_stop_pending(t);
 			}
 		}
 	}

