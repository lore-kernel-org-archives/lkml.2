Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1GEUzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:55:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab1GEUzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:55:10 -0400
Date: Tue, 5 Jul 2011 13:53:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        Jens Axboe <jaxboe@fusionio.com>, Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH v3 1/2] init: add root=PARTUUID=UUID/PARTNROFF=%d
 support
Message-Id: <20110705135348.cb835073.akpm@linux-foundation.org>
In-Reply-To: <1309468207-24199-1-git-send-email-wad@chromium.org>
References: <1309468207-24199-1-git-send-email-wad@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011 16:10:06 -0500
Will Drewry <wad@chromium.org> wrote:

> Expand root=PARTUUID=UUID syntax to support selecting a root partition
> by integer offset from a known, unique partition.  This approach
> provides similar properties to specifying a device and partition number,
> but using the UUID as the unique path prior to evaluating the offset.
> 
> For example,
>   root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B/PARTNROFF=1
> selects the partition with UUID 99DE.. then select the next
> partition.
> 
> This change is motivated by a particular usecase in Chromium OS where
> the bootloader can easily determine what partition it is on (by UUID)
> but doesn't perform general partition table walking.
> 
> That said, support for this model provides a direct mechanism for the
> user to modify the root partition to boot without specifically needing
> to extract each UUID or update the bootloader explicitly when the root
> partition UUID is changed (if it is recreated to be larger, for
> instance).  Pinning to a /boot-style partition UUID allows the arbitrary
> root partition reconfiguration/modifications with slightly less
> ambiguity than just [dev][partition] and less stringency than the
> specific root partition UUID.
> 
> ...
>
>  static dev_t devt_from_partuuid(char *uuid_str)
> @@ -98,6 +101,22 @@ static dev_t devt_from_partuuid(char *uuid_str)
>  	dev_t res = 0;
>  	struct device *dev = NULL;
>  	u8 uuid[16];
> +	struct gendisk *disk;
> +	struct hd_struct *part;
> +	int offset = 0;
> +
> +	if (strlen(uuid_str) < 36)
> +		goto done;

I think this secretly changes behaviour?  Previously the code would have
accepted a less-than-36-byte UUID and would have done <something> with
it.  Now, it fails.

What was <something>, and what is the reason for this (undocumented!)
change?

> +	/* Check for optional partition number offset attributes. */
> +	if (uuid_str[36]) {
> +		/* Explicitly fail on poor PARTUUID syntax. */
> +		if (sscanf(&uuid_str[36], "/PARTNROFF=%d", &offset) != 1) {
> +			printk(KERN_ERR "VFS: PARTUUID= is invalid.\n"
> +			 "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");

The check isn't complete - afacit input of the form PARTNROFF=42foo
will be treated as PARTNROFF=42?

>
> ...
>
