Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2JPRdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:33:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:57225 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2JPRdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:33:45 -0400
Message-ID: <507D9A21.2070703@parallels.com>
Date: Tue, 16 Oct 2012 21:32:17 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: "miklos@szeredi.hu" <miklos@szeredi.hu>
CC: "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v2 00/11] fuse: optimize scatter-gather direct IO
References: <20120919161559.29482.55120.stgit@maximpc.sw.ru>
In-Reply-To: <20120919161559.29482.55120.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

09/19/2012 08:31 PM, Maxim Patlasov пишет:
> Hi,
>
> Existing fuse implementation processes scatter-gather direct IO in suboptimal
> way: fuse_direct_IO passes iovec[] to fuse_loop_dio and the latter calls
> fuse_direct_read/write for each iovec from iovec[] array. Thus we have as many
> submitted fuse-requests as the number of elements in iovec[] array. This is
> pure waste of resources and affects performance negatively especially for the
> case of many small chunks (e.g. page-size) packed in one iovec[] array.
>
> The patch-set amends situation in a natural way: let's simply pack as
> many iovec[] segments to every fuse-request as possible.
>
> To estimate performance improvement I used slightly modified fusexmp over
> tmpfs (clearing O_DIRECT bit from fi->flags in xmp_open). The test opened
> a file with O_DIRECT, then called readv/writev in a loop. An iovec[] for
> readv/writev consisted of 32 segments of 4K each. The throughput on some
> commodity (rather feeble) server was (in MB/sec):
>
>          original / patched
> writev: ~107     / ~480
> readv:  ~114     / ~569
>
> We're exploring possibility to use fuse for our own distributed storage
> implementation and big iovec[] arrays of many page-size chunks is typical
> use-case for device virtualization thread performing i/o on behalf of
> virtual-machine it serves.
>
> Changed in v2:
>   - inline array of page pointers req->pages[] is replaced with dynamically
>     allocated one; the number of elements is calculated a bit more
>     intelligently than being equal to FUSE_MAX_PAGES_PER_REQ; this is done
>     for the sake of memory economy.
>   - a dynamically allocated array of so-called 'page descriptors' - an offset
>     in page plus the length of fragment - is added to fuse_req; this is done
>     to simplify processing fuse requests covering several iov-s.
>
> Thanks,
> Maxim
>
> ---
>
> Maxim Patlasov (11):
>        fuse: general infrastructure for pages[] of variable size
>        fuse: categorize fuse_get_req()
>        fuse: rework fuse_retrieve()
>        fuse: rework fuse_readpages()
>        fuse: rework fuse_perform_write()
>        fuse: rework fuse_do_ioctl()
>        fuse: add per-page descriptor <offset, length> to fuse_req
>        fuse: use req->page_descs[] for argpages cases
>        fuse: pass iov[] to fuse_get_user_pages()
>        fuse: optimize fuse_get_user_pages()
>        fuse: optimize __fuse_direct_io()
>
>
>   fs/fuse/cuse.c   |    3 -
>   fs/fuse/dev.c    |   96 ++++++++++++++-------
>   fs/fuse/dir.c    |   39 ++++----
>   fs/fuse/file.c   |  250 ++++++++++++++++++++++++++++++++++++------------------
>   fs/fuse/fuse_i.h |   47 ++++++++--
>   fs/fuse/inode.c  |    6 +
>   6 files changed, 296 insertions(+), 145 deletions(-)
>

Any feedback on this patch-set (v2) would be highly appreciated.

Thanks,
Maxim
