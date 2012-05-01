Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2EAFvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 01:51:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42993 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2EAFvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 01:51:06 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1335778207-6511-1-git-send-email-jack@suse.cz>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 1 May 2012 17:50:44 +1200
Message-ID: <CAKgNAkixtqfppFdJAC9mnD5xCEFK1JZEHno1GhwmMHfoz6mGOQ@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

On Mon, Apr 30, 2012 at 9:30 PM, Jan Kara <jack@suse.cz> wrote:
> This is a long standing problem (or a surprising feature) in our implementation
> of get_user_pages() (used by direct IO). Since several attempts to fix it
> failed (e.g.
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg06542.html, or
> http://lkml.indiana.edu/hypermail/linux/kernel/0903.1/01498.html refused in
> http://comments.gmane.org/gmane.linux.kernel.mm/31569) and it's not completely
> clear whether we really want to fix it given the costs, let's at least document
> it.
>
> CC: mgorman@suse.de
> CC: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>
> --- a/man2/open.2       2012-04-27 00:07:51.736883092 +0200
> +++ b/man2/open.2       2012-04-27 00:29:59.489892980 +0200
> @@ -769,7 +769,12 @@
>  and the file offset must all be multiples of the logical block size
>  of the file system.
>  Under Linux 2.6, alignment to 512-byte boundaries
> -suffices.
> +suffices. However, if the user buffer is not page aligned and direct read
> +runs in parallel with a
> +.BR fork (2)
> +of the reader process, it may happen that the read data is split between
> +pages owned by the original process and its child. Thus effectively read
> +data is corrupted.
>  .LP
>  The
>  .B O_DIRECT

Thanks. I tweaked the patch slightly, and applied as below.

Cheers,

Michael

--- a/man2/open.2
+++ b/man2/open.2
@@ -49,7 +49,7 @@
 .\" FIXME Linux 2.6.33 has O_DSYNC, and a hidden __O_SYNC.
 .\" FIXME: Linux 2.6.39 added O_PATH
 .\"
-.TH OPEN 2 2012-02-27 "Linux" "Linux Programmer's Manual"
+.TH OPEN 2 2012-05-01 "Linux" "Linux Programmer's Manual"
 .SH NAME
 open, creat \- open and possibly create a file or device
 .SH SYNOPSIS
@@ -768,8 +768,13 @@ operation in
 Under Linux 2.4, transfer sizes, and the alignment of the user buffer
 and the file offset must all be multiples of the logical block size
 of the file system.
-Under Linux 2.6, alignment to 512-byte boundaries
-suffices.
+Under Linux 2.6, alignment to 512-byte boundaries suffices.
+However, if the user buffer is not page-aligned and the direct read
+runs in parallel with a
+.BR fork (2)
+of the reader process, it may happen that the read data is split between
+pages owned by the original process and its child.
+Thus the read data is effectively corrupted.
 .LP
 The
 .B O_DIRECT


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
