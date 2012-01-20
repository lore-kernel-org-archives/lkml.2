Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2ATNzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:55:36 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:47059 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2ATNze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:55:34 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz9371I1447M542M1432Nzz1202hzz8275dhz2eic1bhc31hc1ah2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Dept_Infinipath <Dept_Infinipath@qlogic.com>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 20 Jan 2012 05:55:21 -0800
Subject: RE: races in ipathfs
Thread-Topic: races in ipathfs
Thread-Index: AczW58GIMKga+XemRPK1ISzbzp7iCgAk1IGg
Message-ID: <35AAF1E4A771E142979F27B51793A4888885B23067@AVEXMB1.qlogic.org>
References: <20120119202003.GZ23916@ZenIV.linux.org.uk>
In-Reply-To: <20120119202003.GZ23916@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are currently investigating this.

Thanks for the review on this issue!

Mike

> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Al Viro
> Sent: Thursday, January 19, 2012 3:20 PM
> To: Dept_Infinipath
> Cc: linux-rdma@vger.kernel.org; linux-kernel
> Subject: races in ipathfs
>
>       Use of qib_super is seriously racy.  qibfs_add() (and worse,
> qibfs_remove()) can happen during qibfs_mount() and qibfs_kill_super().
>
>       1) CPU1: qib_init_one().  The sucker is allocated and placed
> on the list.  CPU2: ipathfs is mounted, directory created.  CPU1:
> finally
> gets around to qibfs_add(); by now qib_super is non-NULL and off we go,
> trying to create it again.  The worst part is, that code doesn't even
> notice that dentry is there and positive; you silently leak the old
> inode.
>
>       2) CPU1: qib_init_one().  Allocated the sucker.  CPU2: ipathfs
> is getting mounted.  Picked the first device off the list, creating
> directory for it.  CPU1: inserted new device into the head of the list,
> continued working.  Got around to qibfs_add(); qib_super is NULL, so
> we do nothing.  CPU2: walked the rest of the list, creating directories
> for all devices.  Our device is missed, since we are past that point in
> the list.  Worse, shift the timing a bit and it doesn't matter whether
> you add to the head or to the tail of the list - if qibfs_add() happens
> just before we set qib_super, we are screwed again.
>
>       3) CPU1: qib_remove_one().  CPU2: mount ipathfs is walking that
> list and decides to try and create a directory for the device that is
> being freed.  Oops...
>
>       4) CPU1: qib_init_one() or qib_remove_one(), doesn't matter
> which.
> CPU2: final umount of ipathfs already got through setting sb->s_root to
> NULL but still hadn't set qib_super to the same.  Oops...  And no,
> moving that qib_super = NULL; up prior to kill_litter_super() won't
> fix the race either, of course.
>
> AFAICS, the older driver (in hw/ipath) has the same problems.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

