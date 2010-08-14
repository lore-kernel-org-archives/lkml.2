Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0HNCp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 22:45:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35495 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab0HNCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 22:45:27 -0400
Date: Fri, 13 Aug 2010 19:44:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, hch@lst.de,
        akpm@linux-foundation.org, yehuda@hq.newdream.net
Subject: Re: [PATCH 8/8] rbd: introduce rados block device (rbd), based on
 libceph
Message-Id: <20100813194410.9c608b38.randy.dunlap@oracle.com>
In-Reply-To: <1281721240-26130-9-git-send-email-sage@newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
	<1281721240-26130-9-git-send-email-sage@newdream.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 10:40:40 -0700 Sage Weil wrote:

> From: Yehuda Sadeh <yehuda@hq.newdream.net>
> 
> The rados block device (rbd), based on osdblk, creates a block device
> that is backed by objects stored in the Ceph distributed object storage
> cluster.  Each device consists of a single metadata object and data
> striped over many data objects.
> 
> The rbd driver supports read-only snapshots.
> 
> Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  MAINTAINERS               |    9 +
>  drivers/block/Kconfig     |   13 +
>  drivers/block/Makefile    |    1 +
>  drivers/block/rbd.c       | 1844 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/block/rbd_types.h |   73 ++
>  5 files changed, 1940 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/block/rbd.c
>  create mode 100644 drivers/block/rbd_types.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5102922..cb34b1b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4694,6 +4694,15 @@ F:	fs/qnx4/
>  F:	include/linux/qnx4_fs.h
>  F:	include/linux/qnxtypes.h
>  
> +RADOS BLOCK DEVICE (RBD)
> +F:	include/linux/qnxtypes.h
> +M:	Yehuda Sadeh <yehuda@hq.newdream.net>
> +M:	Sage Weil <sage@newdream.net>
> +M:	ceph-devel@vger.kernel.org
> +S:	Supported
> +F:	drivers/block/rbd.c
> +F:	drivers/block/rbd_types.h
> +
>  RADEON FRAMEBUFFER DISPLAY DRIVER
>  M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  L:	linux-fbdev@vger.kernel.org
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index de27768..708104b 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -488,4 +488,17 @@ config BLK_DEV_HD
>  
>  	  If unsure, say N.
>  
> +config BLK_DEV_RBD
> +	tristate "Rados block device (RBD)"
> +	select CEPH_LIB
> +	default n
> +	help
> +	  Say Y here if you want include the Rados block device, which stripes
> +	  a block device over objects stored in the Ceph distributed object
> +	  store.
> +
> +	  More information at http://ceph.newdream.net/.
> +
> +	  If unsure, say N.
> +
>  endif # BLK_DEV

In linux-next of 20100813, I get:

net/built-in.o: In function `read_partial_message_section':
messenger.c:(.text+0x6598b): undefined reference to `crc32c'
net/built-in.o: In function `read_partial_message_bio':
messenger.c:(.text+0x65a57): undefined reference to `crc32c'
net/built-in.o: In function `write_partial_msg_pages':
messenger.c:(.text+0x65e22): undefined reference to `crc32c'
net/built-in.o: In function `prepare_write_message':
messenger.c:(.text+0x66219): undefined reference to `crc32c'
messenger.c:(.text+0x66240): undefined reference to `crc32c'
net/built-in.o:messenger.c:(.text+0x66264): more undefined references to `crc32c' follow

when CONFIG_INET is not enabled.  It looks like BLK_DEV_RBD needs to depend on
INET and possibly on BLOCK (I sent a patch for depends on BLOCK on 2010-aug-04
due to other build errors).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
