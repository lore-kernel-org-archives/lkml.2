Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1DERcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 13:32:00 -0400
Received: from mail4.comsite.net ([205.238.176.238]:5349 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab1DERb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 13:31:58 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [08/34] initramfs: Use KBUILD_BUILD_TIMESTAMP for generated entries
Message-Id: <gen-initramfs-timestamp@mdm.bga.com>
In-Reply-To: <1302015561-21047-9-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-9-git-send-email-mmarek@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Tue, 05 Apr 2011 12:31:57 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 about 14:58:55 -0000, Michal Marek wrote:
> 
> gen_init_cpio uses the current time for symlinks, special files and
> directories. 

gen_init_cpio gets the current time and uses it for each symlink,
special file, and directory.

Grab the current time once, and ...

> Make it possible to override this with the
(s/this/it/)
> KBUILD_BUILD_TIMESTAMP variable for reproducible builds.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> ---
> scripts/gen_initramfs_list.sh |    4 ++++
>  usr/gen_init_cpio.c           |   17 +++++++++++------
>  2 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
snip
> diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
> index 7f06884..11f604d 100644
> --- a/usr/gen_init_cpio.c
> +++ b/usr/gen_init_cpio.c
snip
> @@ -529,6 +527,7 @@ int main (int argc, char *argv[])
>  	char *args, *type;
>  	int ec = 0;
>  	int line_nr = 0;
> +	const char *env;
>  
>  	if (2 != argc) {
>  		usage(argv[0]);
> @@ -544,6 +543,12 @@ int main (int argc, char *argv[])
>  		exit(1);
>  	}
>  
> +	env = getenv("CPIO_TIMESTAMP");
> +	if (env)
> +		default_mtime = atol(env);
> +	if (!default_mtime)
> +		default_mtime = time(NULL);
> +

Please pass it via an explicit flag in argv instead of magic env variables.

The other current use of the environment (the expansion of variables
in the location name) is via explicit reference in the input file.

Also, please use strol and check that the whole string is consumed.

milton
