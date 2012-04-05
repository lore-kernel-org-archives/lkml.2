Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2DERcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:32:04 -0400
Received: from mx2.netapp.com ([216.240.18.37]:60423 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab2DERcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:32:01 -0400
X-IronPort-AV: E=Sophos;i="4.75,377,1330934400"; 
   d="scan'208";a="638932395"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] NFSv4: open(O_TRUNC) hangs
Thread-Topic: [REGRESSION] NFSv4: open(O_TRUNC) hangs
Thread-Index: AQHNEbZ7fNNbFQoJxUan0YtsOl2zeJaM9emA
Date: Thu, 5 Apr 2012 17:31:58 +0000
Message-ID: <1333647115.4573.3.camel@lade.trondhjem.org>
References: <87d37osrx2.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87d37osrx2.fsf@tucsk.pomaz.szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <956D35F37B90324B90F3A19C57E348D3@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q35HWueu028809

On Tue, 2012-04-03 at 18:26 +0200, Miklos Szeredi wrote:
> Now this test program hangs on latest git.
> 
> Thanks,
> Miklos
> ---
> 
> #include <stdio.h>
> #include <unistd.h>
> #include <fcntl.h>
> 
> int main(int argc, char *argv[])
> {
> 	int res;
> 	char *name = argv[1];
> 	int fd;
> 
> 	unlink(name);
> 	fd = creat(name, 0644);
> 	write(fd, "123", 3);
> 	close(fd);
> 	close(open(name, O_RDONLY | O_TRUNC));
> 
> 	return 0;
> }

Hi Miklos,

The following client patch fixes the regression for me.

Cheers
  Trond
8<----------------------------------------------------
>From 5ec0ed6cd88c65464092533787706d9ecfb85320 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 4 Apr 2012 10:51:33 -0700
Subject: [PATCH 1/2] NFSv4: Don't use open stateids that have the wrong open
 mode

If the client is doing an operation that needs a particular open
mode, then nfs4_select_rw_stateid() should only copy the
open stateid if the latter has the correct open mode.

Otherwise we should just use the zero stateid.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/nfs4state.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 0f43414..71dcfd4 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -932,6 +932,13 @@ void nfs4_select_rw_stateid(nfs4_stateid *dst, struct nfs4_state *state,
 {
 	if (nfs4_copy_delegation_stateid(dst, state->inode, fmode))
 		return;
+
+	fmode &= FMODE_READ|FMODE_WRITE;
+	if ((state->state & fmode) != fmode) {
+		nfs4_stateid_copy(dst, &zero_stateid);
+		return;
+	}
+
 	if (nfs4_copy_lock_stateid(dst, state, fl_owner, fl_pid))
 		return;
 	nfs4_copy_open_stateid(dst, state);
-- 
1.7.7.6


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
