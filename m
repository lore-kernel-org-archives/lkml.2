Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1CEKPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:15:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65362 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1CEKPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:15:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hGThmoNRq84mJKM/11A/R349ZcUTTNs51crvTVaSbF0sYtqQgiWK3kc2XN+gWdQvyc
         B6WcaoUXVKoiHtS0rhGmK4lWUUq44xwodql2S3yiAD7zyONZDyoJPkFRGL6Oc+PgK4mk
         sNcCCruRN39VJfRTIrkY3O7hLSeUkSiHaO9qE=
Message-ID: <4D720C0B.1050300@gmail.com>
Date: Sat, 05 Mar 2011 11:10:19 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v3][RESEND] Check for immutable/append flag in fallocate path
References: <4D6221B8.9040303@gmail.com>	<4D6F5473.2070709@gmail.com>	<4D720469.1010101@gmail.com> <AANLkTinyK0G=tfZob4u7XBj7Gna3FbZnLrqswz2oajwn@mail.gmail.com>
In-Reply-To: <AANLkTinyK0G=tfZob4u7XBj7Gna3FbZnLrqswz2oajwn@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

In the fallocate path the kernel doesn't check for the immutable/append
flag. It's possible to have a race condition in this scenario: an
application open a file in read/write and it does something, meanwhile
root set the immutable flag on the file, the application at that point
can call fallocate with success. In addition, we don't allow to do any
unreserve operation on an append only file but only the reserve one.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
ChangeLog:
v3: Modified do_fallocate instead of every single fs
v2: Added the check for append-only file for XFS
v1: First draft

--- linux-2.6.38-rc7/fs/open.c.orig	2011-03-01 22:55:12.000000000 +0100
+++ linux-2.6.38-rc7/fs/open.c	2011-03-04 15:28:43.000000000 +0100
@@ -233,6 +233,14 @@ int do_fallocate(struct file *file, int
 
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
+
+	/* It's not possible punch hole on append only file */
+	if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
+		return -EPERM;
+
+	if (IS_IMMUTABLE(inode))
+		return -EPERM;
+
 	/*
 	 * Revalidate the write permissions, in case security policy has
 	 * changed since the files were opened.

