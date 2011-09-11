Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960Ab1IKDcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 23:32:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38228 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1IKDcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 23:32:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110908162303.GA18435@ubuntu-NB505>
References: <20110907175952.GC23829@thinkpad-t410> <1315451581.92826.YahooMailClassic@web29509.mail.ird.yahoo.com>
 <20110908162303.GA18435@ubuntu-NB505>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Sat, 10 Sep 2011 23:32:15 -0400
Message-ID: <CAG1a4rvfajX8BwbL39UP5PYcwMLi_GETS3psq7cZv48UvZv0Ng@mail.gmail.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Hin-Tak Leung <htl10@users.sourceforge.net>,
        Christoph Hellwig <hch@tuxera.com>, Pavel Ivanov <paivanof@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 12:23 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Thu, Sep 08, 2011 at 04:13:01AM +0100, Hin-Tak Leung wrote:
>> --- On Wed, 7/9/11, Seth Forshee <seth.forshee@canonical.com> wrote:
>>
>> > Yes, that was definitely just an oversight. Has anyone
>> > provided a patch
>> > yet? If not I've pasted a patch below. Seems like a fix
>> > should be
>> > applied ASAP.
>> >
>> >
>> > From d27825b880028e9a45ba640d86c9e8101db0606b Mon Sep 17
>> > 00:00:00 2001
>> > From: Seth Forshee <seth.forshee@canonical.com>
>> > Date: Wed, 7 Sep 2011 10:38:35 -0700
>> > Subject: [PATCH] hfsplus: Fix kfree of wrong pointers in
>> > hfsplus_fill_super() error path
>> >
>> > Commit 6596528 (hfsplus: ensure bio requests are not
>> > smaller than
>> > the hardware sectors) changed the pointers used for volume
>> > header
>> > allocations but failed to change the pointer freed in the
>> > error
>> > path of hfsplus_fill_super(). This patch fixes the
>> > problem.
>> >
>> > Reported-by: Pavel Ivanov <paivanof@gmail.com>
>> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>> > Cc: <stable@kernel.org>
>>
>> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>>
>> Please go ahead and submit the patch.
>
> That was my patch submission :)
>
> Christoph, does that work for you, or would you like me to send the
> patch in a separate email?

Seth, Christoph,

I've just found another wrong pointers freeing. The following patch
should fix it.



Subject: [PATCH] hfsplus: Fix kfree of wrong pointers in
hfsplus_read_wrapper() error path

Commit 6596528 (hfsplus: ensure bio requests are not smaller than
the hardware sectors) changed the pointers used for volume header
allocations but failed to change the pointer freed in the error
path of hfsplus_read_wrapper(). This patch fixes the problem.

Signed-off-by: Pavel Ivanov <paivanof@gmail.com>
Cc: <stable@kernel.org>
---

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 10e515a..7daf4b8 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -272,9 +272,9 @@ reread:
 	return 0;

 out_free_backup_vhdr:
-	kfree(sbi->s_backup_vhdr);
+	kfree(sbi->s_backup_vhdr_buf);
 out_free_vhdr:
-	kfree(sbi->s_vhdr);
+	kfree(sbi->s_vhdr_buf);
 out:
 	return error;
 }
--
