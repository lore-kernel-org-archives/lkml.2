Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2IDM1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:27:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab2IDM1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:27:49 -0400
Date: Tue, 4 Sep 2012 14:27:43 +0200
From: Jan Kara <jack@suse.cz>
To: Li Wang <liwang@nudt.edu.cn>
Cc: viro@zeniv.linux.org.uk, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] VFS: File System Mount Wide O_DIRECT Support
Message-ID: <20120904122743.GA8656@quack.suse.cz>
References: <000001cd8a86$89df83b0$9d9e8b10$@edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cd8a86$89df83b0$9d9e8b10$@edu.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-09-12 18:17:47, Li Wang wrote:
> For file system created on file-backed loop device, there will be two-levels of 
> page cache present, which typically doubles the memory consumption. 
> In many cases, it is beneficial to turn on the O_DIRECT option while performing 
> the upper file system file IO, to bypass the upper page cache, which not only reduces half
> of the memory consumption, but also improves the performance due to shorter copy path.
> 
> For example, the following iozone REREAD test with O_DIRECT turned on over the one without
> enjoys 10x speedup due to redundant cache elimination, consequently, avoiding page cache thrashing
> on a 2GB memory machine running 3.2.9 kernel.
> 
> losetup /dev/loop0 dummy // dummy is a ext4 file with a size of 1.1GB
> mkfs -t ext2 /dev/loop0
> mount /dev/loop0 /dsk
> cd /dsk
> iozone -t 1 -s 1G -r 4M -i 0 -+n -w // produce a 1GB test file
> iozone -t 1 -s 1G -r 4M -i 1 -w // REREAD test without O_DIRECT
> echo 1 > /proc/sys/vm/drop_caches // cleanup the page cache
> iozone -t 1 -s 1G -r 4M -i 1 -w -I // REREAD test with O_DIRECT
> 
> This feature is also expected to be useful for virtualization situation, the file systems inside 
> the guest operation system will use much less of guest memory, which, potencially results in less of 
> host memory use. Especially, it may be more useful if multiple guests are running based 
> on a same disk image file.  
> 
> The idea is simple, leave the desicion for the file system user to enable file system mount 
> wide O_DIRECT support with a new mount option, for example,
  I believe a better approach to your problem is actually to enable
loopback device driver to use direct IO. Someone was actually working on
this but I'm not sure where this ended up.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
