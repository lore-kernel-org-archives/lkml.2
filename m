Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab1GQWJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 18:09:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61675 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1GQWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 18:09:05 -0400
From: Naohiro Aota <naota@elisp.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@tuxera.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] hfsplus: Add additional range check to handle on-disk corruptions
References: <87mxgku044.fsf@elisp.net> <20110714145313.GA16776@infradead.org>
Date: Mon, 18 Jul 2011 07:08:40 +0900
In-Reply-To: <20110714145313.GA16776@infradead.org> (Christoph Hellwig's
	message of "Thu, 14 Jul 2011 10:53:13 -0400")
Message-ID: <871uxoimqf.fsf_-_@elisp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

>> 
>> diff --git a/fs/hfsplus/brec.c b/fs/hfsplus/brec.c
>> index 2312de3..5c51d04 100644
>> --- a/fs/hfsplus/brec.c
>> +++ b/fs/hfsplus/brec.c
>> @@ -43,6 +43,10 @@ u16 hfs_brec_keylen(struct hfs_bnode *node, u16 rec)
>>  			node->tree->node_size - (rec + 1) * 2);
>>  		if (!recoff)
>>  			return 0;
>> +		if (recoff >= node->tree->node_size) {
>> +			printk(KERN_ERR "hfs: recoff %d too large\n", recoff);
>> +			return 0;
>> +		}
>
> As non-obvious as it sounds 0 is indded the canonical error return from
> hfs_brec_keylen, so that patch looks good to me.  Can you resend it
> with a better title and description mentioning better validatation of
> the on-disk structures? 

I've revised the patch and description.

Change from v1:

Change the check from "recoff >= node->tree->node_size" to "recoff >
node->tree->node_size - 2": Check not only the first byte but also the
last byte to be read is in to be read is in node range.

>From 68382a218dac9ba4fe659aa77e350bce3a1c365a Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naota@elisp.net>
Date: Tue, 12 Jul 2011 02:54:13 +0900

'recoff' is read from disk and used for an argument to memcpy, so if
the value read from disk is larger than the page size, it result to
"general protection fault". This patch add additional range check for
the value, so that disk fuzz won't cause such fault.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/hfsplus/brec.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/hfsplus/brec.c b/fs/hfsplus/brec.c
index 2312de3..2a734cf 100644
--- a/fs/hfsplus/brec.c
+++ b/fs/hfsplus/brec.c
@@ -43,6 +43,10 @@ u16 hfs_brec_keylen(struct hfs_bnode *node, u16 rec)
 			node->tree->node_size - (rec + 1) * 2);
 		if (!recoff)
 			return 0;
+		if (recoff > node->tree->node_size - 2) {
+			printk(KERN_ERR "hfs: recoff %d too large\n", recoff);
+			return 0;
+		}
 
 		retval = hfs_bnode_read_u16(node, recoff) + 2;
 		if (retval > node->tree->max_key_len + 2) {
-- 
1.7.6

