Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2B0WIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:08:54 -0500
Received: from mx2.netapp.com ([216.240.18.37]:59036 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab2B0WIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:08:52 -0500
X-IronPort-AV: E=Sophos;i="4.73,493,1325491200"; 
   d="scan'208";a="628988115"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@zabbo.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 22/22] nfs: add support for read_iter, write_iter
Thread-Topic: [RFC PATCH 22/22] nfs: add support for read_iter, write_iter
Thread-Index: AQHM9ZWhvWFzos/n0EeozJmwFG1JYJZR07UA
Date: Mon, 27 Feb 2012 22:08:50 +0000
Message-ID: <1330380530.5541.87.camel@lade.trondhjem.org>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
	 <1330377576-3659-23-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1330377576-3659-23-git-send-email-dave.kleikamp@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED465B60B5CCDF4A965C0DD51A044988@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1RM92aN021351

On Mon, 2012-02-27 at 15:19 -0600, Dave Kleikamp wrote:
> This patch implements the read_iter and write_iter file operations which
> allow kernel code to initiate directIO. This allows the loop device to
> read and write directly to the server, bypassing the page cache.
> 
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Zach Brown <zab@zabbo.net>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: linux-nfs@vger.kernel.org

Performance is going to be absolutely terrible for O_DIRECT bvecs if you
send just one page per RPC call. We are working on merging the O_DIRECT
and page cache code in order to give O_DIRECT the ability to coalesce
requests and do pNFS, and I'm hoping that code will be available soon.

In the meantime, wouldn't it be possible to add basic coalescing to
nfs_direct_read_schedule_bvec/nfs_direct_write_schedule_bvec more or
less in the same way that we do for multi-page iovec segments?
i.e. if the next bvec is contiguous with the previous, and the resulting
RPC read length < rsize / write length < wsize, then add it to the same
RPC call.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
