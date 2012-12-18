Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2LROQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:16:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab2LROQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:16:44 -0500
Message-ID: <50D07A45.3080809@redhat.com>
Date: Tue, 18 Dec 2012 09:14:29 -0500
From: Brian Foster <bfoster@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Maxim V. Patlasov" <MPatlasov@parallels.com>
CC: miklos@szeredi.hu, dev@parallels.com, xemul@parallels.com,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: Re: [PATCH v2 0/6] fuse: process direct IO asynchronously
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
In-Reply-To: <20121214151424.27155.45971.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 10:20 AM, Maxim V. Patlasov wrote:
> Hi,
> 
...
> The throughput on some commodity (rather feeble) server was (in MB/sec):
> 
>              original / patched
> 
> dd reads:    ~322     / ~382
> dd writes:   ~277     / ~288
> 
> aio reads:   ~380     / ~459
> aio writes:  ~319     / ~353
> 
> Changed in v2 - cleanups suggested by Brian:
>  - Updated fuse_io_priv with an async field and file pointer to preserve
>    the current style of interface (i.e., use this instead of iocb).
>  - Trigger the type of request submission based on the async field.
>  - Pulled up the fuse_write_update_size() call out of __fuse_direct_write()
>    to make the separate paths more consistent.
> 

This version plus the updated "fuse: truncated file if async dio failed
- v2" patch address all the questions I had on the set, so consider it:

Reviewed-by: Brian Foster <bfoster@redhat.com>

I also ran some of your aio/dio performance tests on a basic gluster
volume (single client to server) and repeated positive results. The
results include rewrite numbers (file extending writes generally matched
original throughput). Results in MB/s:

		original / patched
1GigE
dd reads:	~74	/	~104
dd rewrites:	~67	/	~103
aio reads:	~53	/	~110
aio rewrites:	~52	/	~112

10GigE
dd reads:	~175	/	~437
dd rewrites:	~134	/	~390
aio reads:	~84	/	~417
aio rewrites:	~88	/	~401

Brian

> Thanks,
> Maxim
> 
> ---
> 
> Maxim V. Patlasov (6):
>       fuse: move fuse_release_user_pages() up
>       fuse: add support of async IO
>       fuse: make fuse_direct_io() aware about AIO
>       fuse: enable asynchronous processing direct IO
>       fuse: truncate file if async dio failed
>       fuse: optimize short direct reads
> 
> 
>  fs/fuse/cuse.c   |    6 +
>  fs/fuse/file.c   |  290 +++++++++++++++++++++++++++++++++++++++++++++++-------
>  fs/fuse/fuse_i.h |   19 +++-
>  3 files changed, 276 insertions(+), 39 deletions(-)
> 

