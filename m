Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0I0OQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:16:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0I0OQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:16:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Petr Vandrovec <petr@vandrovec.name>
Subject: Re: [PATCH] Remove BKL usage from ncpfs
Date: Mon, 27 Sep 2010 16:16:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, aia21@cam.ac.uk,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20100926234733.GA31884@vana.vc.cvut.cz>
In-Reply-To: <20100926234733.GA31884@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009271616.42190.arnd@arndb.de>
X-Provags-ID: V02:K0:BqYS83Ibp663l7rvCEC1dLRB4jo/Prd/mQ5MwqxU50F
 6HDm5EK16HBFCsQK6xM8rkTpT4jUXeJE05Fn21vpHf8fmiFIDM
 LehIFDHhpTJ+qtGu/yeJZF/j2DB/7b4JjFE4HP4YPaTyH6Qc2I
 94T7CCnF50GMcqqp1NwbW5DF1CTYVkkYkI3OIeeFXsSaCegZoU
 45H/XJ2Eh14FUv1tUOxcQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 September 2010, Petr Vandrovec wrote:
> commit 92498b5267aa58e85e20c7b2cbd84d1ed86df47d
> Author: Petr Vandrovec <petr@vandrovec.name>
> Date:   Sun Sep 26 16:19:12 2010 -0700
> 
>     Remove BKL from ncpfs

Hi Petr,

Thanks for taking care of this.

Would you like me to take this patch into my bkl/vfs tree? I think
that would make it easier for me because I'm adding another instance
of the BKL there, in the ncp_fill_super function. As far as I can tell
that change (see below) becomes pointless with your patch.

I could either just revert my change or replace it with your patch,
whichever you prefer.

	Arnd

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index b4de38c..cdf0fce 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -445,10 +445,14 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 #endif
        struct ncp_entry_info finfo;
 
+       lock_kernel();
+
        data.wdog_pid = NULL;
        server = kzalloc(sizeof(struct ncp_server), GFP_KERNEL);
-       if (!server)
+       if (!server) {
+               unlock_kernel();
                return -ENOMEM;
+       }
        sb->s_fs_info = server;
 
        error = -EFAULT;
@@ -700,6 +704,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
         if (!sb->s_root)
                goto out_no_root;
        sb->s_root->d_op = &ncp_root_dentry_operations;
+       unlock_kernel();
        return 0;
 
 out_no_root:
@@ -736,6 +741,7 @@ out:
        put_pid(data.wdog_pid);
        sb->s_fs_info = NULL;
        kfree(server);
+       unlock_kernel();
        return error;
 }
 

