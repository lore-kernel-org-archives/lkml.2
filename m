Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab0DAPy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:54:58 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46480 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab0DAPys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=MkXUWczcITwp4r1Vi6G4DfUZj9oiSooGZlMbvJheXD1Z8sC/PDSKH3rLRIkqn+bXwK
         ywBiWN5pjIO6WCrvXwMTn1AuWOLaeDGyE4WFuWxasK3z6Wo5yriFTEpZn6BoC1FV5Pk3
         Iv4tlbDR1anWfW2e2HKJCiRGy7jQfLPByYb9A=
Date: Thu, 1 Apr 2010 18:54:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dmitry Torokhov <dtor@mail.ru>,
       =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ir-keytable: avoid double lock
Message-ID: <20100401155438.GE5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dmitry Torokhov <dtor@mail.ru>,
	=?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Matthew Garrett <mjg@redhat.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible that we wanted to resize to a smaller size but we didn't
have enough memory to create the new table.  We need to test for that
here so we don't try to lock twice and dead lock.  Also we free the
"oldkeymap" on that path and that would be bad.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't know this code very well.  Maybe we should  just take the lock
earlier in the function for the resize case and the non resize case.
Can we add new keys while the resize is taking place?

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 0a3b4ed..51cd0f3 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -216,7 +216,7 @@ static void ir_delete_key(struct ir_scancode_table *rc_tab, int elem)
 		memcpy(&newkeymap[elem], &oldkeymap[elem + 1],
 		       (newsize - elem) * sizeof(*newkeymap));
 
-	if (resize) {
+	if (resize && newkeymap != oldkeymap) {
 		/*
 		 * As the copy happened to a temporary table, only here
 		 * it needs to lock while replacing the table pointers
