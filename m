Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1GQVIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 17:08:47 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:40048 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1GQVIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 17:08:45 -0400
Subject: Re: [PATCH][Resend] SCSI, target, loopback: Fix memory leak in
	tcm_loop_make_scsi_hba()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, James Bottomley <jbottomley@parallels.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <20110628062235.GB14591@shale.localdomain>
References: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net>
	 <20110627222526.GA14591@shale.localdomain>
	 <alpine.LNX.2.00.1106280029150.30245@swampdragon.chaosbits.net>
	 <20110628062235.GB14591@shale.localdomain>
Content-Type: text/plain
Date: Sun, 17 Jul 2011 13:59:34 -0700
Message-Id: <1310936374.26130.75.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 09:22 +0300, Dan Carpenter wrote:
> On Tue, Jun 28, 2011 at 12:30:17AM +0200, Jesper Juhl wrote:
> > 
> > You mean like this - right?
> 
> Yeah.
> 
> Acked-by: Dan Carpenter <error27@gmail.com>
> 

Hi Guys,

Following up on some items that where missed over my summer holiday.

Committed and pushed this patch into lio-core-2.6.git/master recently as
the following.

Thanks JesperJ and DanC!

--nab

--------------------------------------------------------------------

commit 90e104e39aa30437a8ac4572e4499e7c3a914458
Author: Jesper Juhl <jj@chaosbits.net>
Date:   Tue Jun 28 00:30:17 2011 +0200

    loopback: Fix memory leak in tcm_loop_make_scsi_hba()
    
    There is a memory leak in tcm_loop_make_scsi_hba().
    
    If all the strstr() calls return NULL and we end up at return ERR_PTR(-EINVAL);
    then we'll be leaking the memory previously allocated to tl_hba as
    that variable goes out of scope.
    
    This patch should fix the leak.
    
    Signed-off-by: Jesper Juhl <jj@chaosbits.net>
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 5075e9b..f603698 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1288,22 +1288,21 @@ struct se_wwn *tcm_loop_make_scsi_hba(
                goto check_len;
        }
        ptr = strstr(name, "iqn.");
-       if (ptr) {
-               tl_hba->tl_proto_id = SCSI_PROTOCOL_ISCSI;
-               goto check_len;
+       if (!ptr) {
+               printk(KERN_ERR "Unable to locate prefix for emulated Target "
+                               "Port: %s\n", name);
+               ret = -EINVAL;
+               goto out;
        }
-
-       printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
-                       " %s\n", name);
-       return ERR_PTR(-EINVAL);
+       tl_hba->tl_proto_id = SCSI_PROTOCOL_ISCSI;
 
 check_len:
        if (strlen(name) >= TL_WWN_ADDR_LEN) {
                printk(KERN_ERR "Emulated NAA %s Address: %s, exceeds"
                        " max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
                        TL_WWN_ADDR_LEN);
-               kfree(tl_hba);
-               return ERR_PTR(-EINVAL);
+               ret = -EINVAL;
+               goto out;
        }
        snprintf(&tl_hba->tl_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off]);





