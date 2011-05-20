Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab1ETF7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:59:41 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:46067 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932907Ab1ETF7k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:59:40 -0400
X-ASG-Debug-ID: 1305869978-01c65a06b0169210001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
X-Barracuda-BWL-IP: 192.168.1.133
X-Barracuda-BBL-IP: 192.168.1.133
X-Barracuda-RBL-IP: 192.168.1.133
Mime-Version: 1.0 (Apple Message framework v1084)
X-ASG-Orig-Subj: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
Content-Type: text/plain; charset=us-ascii
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu>
Date: Fri, 20 May 2011 01:39:37 -0400
Cc: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>, "neilb@suse.de" <neilb@suse.de>,
        "hramrach@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp@gmail.com" <jordipujolp@gmail.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Transfer-Encoding: 8BIT
Message-Id: <D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu> <103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.1084)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1305869978
X-Barracuda-URL: http://130.245.126.20:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64256
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

I tried your overlayfs.v9 git repo w/ racer, using two separate ext3 filesystems (one for lowerdir and another for upperdir).  I got the WARN_ON in ovl_permission to trigger within about 10 minutes of testing.  Looking at the code, I see a problem in returning w/o cleaning up an dput-ing the alias dentry.  Simple patch enclosed below.

Cheers,
Erez.


diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3c15d54..6c70f57 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -80,7 +82,8 @@ int ovl_permission(struct inode *inode, int mask, unsigned int flags)
 	realinode = ACCESS_ONCE(realdentry->d_inode);
 	if (!realinode) {
 		WARN_ON(!(flags & IPERM_FLAG_RCU));
-		return -ENOENT;
+		err = -ENOENT;
+		goto out_dput;
 	}
 
 	if (mask & MAY_WRITE) {

