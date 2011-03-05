Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1CEJnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 04:43:05 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55031 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1CEJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 04:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MWZzD24OFjdqn0o3t/HPjgNH3NYsYC0Z3cVXG0J3tSO//9vzqONdV8F72N+RsVBWyu
         UpORqz7olm5rAU/Ozy9uXasNXKF0rAHxgq2m3aYAa77/9eRBk6zQr6dbKDs/m6NAq2t7
         iEkHpU3lTV0Npq/U50qJdHHGAR1zc3Mq8so5I=
Message-ID: <4D720469.1010101@gmail.com>
Date: Sat, 05 Mar 2011 10:37:45 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v3] Check for immutable/append flag in fallocate path
References: <4D6221B8.9040303@gmail.com> <4D6F5473.2070709@gmail.com>
In-Reply-To: <4D6F5473.2070709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
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
Patch is against 2.6.38-rc7

ChangeLog:
v3: Modified do_fallocate instead of every single fs
v2: Added the check for append-only file for XFS
v1: First draft

--- open.c.orig	2011-03-01 22:55:12.000000000 +0100
+++ open.c	2011-03-04 15:28:43.000000000 +0100
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

