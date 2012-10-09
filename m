Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2JIVmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:42:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985Ab2JIVma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:42:30 -0400
Date: Tue, 9 Oct 2012 23:42:27 +0200
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Subject: Re: PRJQUOTA case not handled in need_print_warning()
Message-ID: <20121009214227.GC27882@quack.suse.cz>
References: <alpine.LNX.2.00.1210050032220.3873@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1210050032220.3873@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri 05-10-12 00:34:29, Jiri Kosina wrote:
> Hi,
> 
> commit e8a3e4719b7ec19288c56f22623f537cb78885c1
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Sun Sep 16 01:11:45 2012 -0700
> 
>     userns: Implement struct kqid
> 
> causes this warning:
> 
> fs/quota/dquot.c: In function ‘need_print_warning’:
> fs/quota/dquot.c:1158: warning: enumeration value ‘PRJQUOTA’ not handled in switch
> 
> and it seems to be a valid one -- the switch in need_print_warning() 
> contains neither 'default' nor PRJQUOTA case handler.
  Hum, since Eric didn't seem to care, I've fixed this up myself with the
attached patch. Actually, PRJQUOTA should never get to that function so it
shouldn't cause any problems in practice. Thanks for the report.

								Honza

--IJpNTDwzlM2Ie8A6
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-quota-Silence-warning-about-PRJQUOTA-not-being-handl.patch"

>From 6c29c50fda25c2ac2ce45a9b042ff7e424aa8eac Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 9 Oct 2012 23:30:17 +0200
Subject: [PATCH] quota: Silence warning about PRJQUOTA not being handled in need_print_warning()

PRJQUOTA value of quota type should never reach need_print_warning() since XFS
(which is the only fs which uses that type) doesn't use generic functions
calling this function. Anyway, add PRJQUOTA case to the switch to make gcc
happy.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 557a9c2..05ae3c9 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1160,6 +1160,8 @@ static int need_print_warning(struct dquot_warn *warn)
 			return uid_eq(current_fsuid(), warn->w_dq_id.uid);
 		case GRPQUOTA:
 			return in_group_p(warn->w_dq_id.gid);
+		case PRJQUOTA:	/* Never taken... Just make gcc happy */
+			return 0;
 	}
 	return 0;
 }
-- 
1.7.1


--IJpNTDwzlM2Ie8A6--
