Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0GWLrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:47:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53911 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0GWLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=j3UCBkfWWksFV7AIhF8iqto8XJRhSMR8VsDAOVwBUYuuVvvKfxE3Pzmza1X/1N7BSz
         VLlKxEMhlYQpjqM8f6lQuaJsWZZUR9d6jNacQ/3AIWvhszyKsfZLbhDemwSD7yWh5Rrn
         lEGFdIB9hZxH9405Zuv8QcfD7FQ6k3Ogmqffs=
Date: Fri, 23 Jul 2010 13:47:06 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org, Markus.Lidel@shadowconnect.com
Cc: kernel-janitors@vger.kernel.org
Subject: [patch] message/i2o: add sanity check
Message-ID: <20100723114706.GH26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, Markus.Lidel@shadowconnect.com,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use "reply_size" to determine the size of the "reply" buffer.  These
days the "reply" buffer is just some context information, an error code,
and a bunch of zeroes.  We stopped using it for useful information four
years ago in dcceafe25a5f47 "[PATCH] I2O: Bugfixes"

This patch ensures that "reply" is large enough to hold the context
information.   In the current code if "reply_size" is zero that would
cause memory corruption when we save the error code:
	reply[4] = ((u32) rcode) << 24;

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index c4b117f..8b1d55e 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -817,6 +817,11 @@ static int i2o_cfg_passthru(unsigned long arg)
 	reply_size >>= 16;
 	reply_size <<= 2;
 
+	if (reply_size < 5 * sizeof(u32)) {
+		rcode = -EINVAL;
+		goto out;
+	}
+
 	reply = kzalloc(reply_size, GFP_KERNEL);
 	if (!reply) {
 		printk(KERN_WARNING "%s: Could not allocate reply buffer\n",
