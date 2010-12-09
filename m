Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab0LINtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:49:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45807 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0LINtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:49:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n69Y9La8gS59kl+IGNqasaNX0b9oUElqzcOg2Xc/loHRAik+O6ShJuuWN5sU0E/XPX
         aItxTpOuRuk5aV6fXPmSDirPqz8rks8PbAbXrMA1JVhpccU1HOWz82NActP/ljQQZBks
         FQK0kjuU1JjSmFGEtJ009Wnl4fG4Hh9B+qbKI=
MIME-Version: 1.0
In-Reply-To: <20101110151823.GC18258@parisc-linux.org>
References: <AANLkTikbkhHmsVAdGrY0OTnH=gUZW5igjsWSF9y=Ub1u@mail.gmail.com>
	<20101110151823.GC18258@parisc-linux.org>
Date: Thu, 9 Dec 2010 21:49:00 +0800
Message-ID: <AANLkTikT3NUv5gqr2f9UXORPVbUaHCYbL5ejFCSBiz8X@mail.gmail.com>
Subject: Re: [PATCH] fix vulnerability of the release method of file
 operations in Block layer SCSI generic driver
From: Hillf Danton <dhillf@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Zou, Yi" <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:18 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Nov 10, 2010 at 10:08:37PM +0800, Hillf Danton wrote:
>> The computation context setup by previous opening the bsg file could
>> not survive following open/release operations upon the same file
>> object.
>
> Umm .. release is called on final close of a file, not on every close
> of a file.

Thanks for sharing the knowledge about the release callback.

But I am still wondering, if the operations in the release is safe, how the
increments, pumped up by open operations on cmdline, of the ref_count
of bsg device then get decreased, which could trigger mm leakage.

And both vulnerability and leakage, if possible, could be fixed by replacing
the only line we concerned with printk, see below please.

Cheers
Hillf
---

--- a/block/bsg.c	2010-11-01 19:54:12.000000000 +0800
+++ b/block/bsg.c	2010-12-09 21:38:32.000000000 +0800
@@ -855,7 +855,10 @@ static int bsg_release(struct inode *ino
 {
 	struct bsg_device *bd = file->private_data;

-	file->private_data = NULL;
+	if (atomic_read(&bd->ref_count) != 1)
+		printk(KERN_WARNING "bsg: ref count of %s is %d\n",
+			bd->name, atomic_read(&bd->ref_count));
+
 	return bsg_put_device(bd);
 }
