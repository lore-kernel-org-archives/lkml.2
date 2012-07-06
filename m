Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2GFMy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:54:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42199 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2GFMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:54:26 -0400
Message-ID: <4FF6DFFE.10203@landley.net>
Date: Fri, 06 Jul 2012 07:54:22 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
CC: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 5/5] fuse: add documentation of sysfs parameter to
 limit maximum fuse request size
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp> <20120705105115.17812.93681.stgit@ltc137.sdl.hitachi.co.jp>
In-Reply-To: <20120705105115.17812.93681.stgit@ltc137.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 05:51 AM, Mitsuo Hayasaka wrote:
> Add an explantion about the sysfs parameter to the limit
> maximum read/write request size.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> ---
> 
>  Documentation/filesystems/fuse.txt |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/filesystems/fuse.txt b/Documentation/filesystems/fuse.txt
> index 13af4a4..e6ffba3 100644
> --- a/Documentation/filesystems/fuse.txt
> +++ b/Documentation/filesystems/fuse.txt
> @@ -108,13 +108,28 @@ Mount options
>  
>    With this option the maximum size of read operations can be set.
>    The default is infinite.  Note that the size of read requests is
> -  limited anyway to 32 pages (which is 128kbyte on i386).
> +  limited to 32 pages (which is 128kbyte on i386) if direct_io
> +  option is not specified. When direct_io option is specified,
> +  the request size is limited to max_pages_per_req sysfs parameter.

"Note that the maximum size of read requests defaults to 32 pages (128k
on i386), use max_pages_per_req to change this default."

And then describe max_page_per_req sufficiently thoroughly below, all in
one place.

(By the way, has anybody actually tested it with a single page as the
limit? Does that work?)

>  'blksize=N'
>  
>    Set the block size for the filesystem.  The default is 512.  This
>    option is only valid for 'fuseblk' type mounts.
>  
> +Sysfs parameter
> +~~~~~~~~~~~~~~~
> +
> +The sysfs parameter max_pages_per_req limits the maximum page size per
> +FUSE request.

No, it limits the maximum size of a data request and the units are
decimal number of pages. It doesn't change the size of memory pages in
the system.

Also, your first hunk implies this setting only takes effect if they
mounted with "-o direct_io", is that true?

> +	/sys/fs/fuse/max_pages_per_req
> +
> +The default is 32 pages. It can be changed from 32 to 256 pages, which
> +may improve the read/write throughput optimizing it. This change is
> +effective per mount. Therefore, the re-mounting of FUSE filesystem
> +is required after changing it.

I'd say "Changing it to 256 pages may improve read/write throguhput on
systems with enough memory. Existing FUSE mounts must be remounted for
this change to take effect."

I.E. don't imply 32 and 256 are the only options unless they are. (Is
there some requirement that it be a power of 2, or just a good idea?)

And per-mount sounds like you're setting it for a specific mount point,
so if I have three mounts there would be three entries under
/sys/fs/fuse, which does not seem to be the case. (Which is odd, because
you'd think there would be an "-o max_pages_per_req=128" that _would_
set this per-mount if the value actually used is cached in the
superblock, but I'm not seeing one...)

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
