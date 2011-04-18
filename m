Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1DRQsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:48:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48816 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1DRQr7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 18 Apr 2011 12:47:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] Provide infrastructure changes for backends (and blkback) for 2.6.40
Date: Mon, 18 Apr 2011 11:20:10 -0400
Message-Id: <1303140011-3623-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
References: <1302795014-13289-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DAC6B3D.0007:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:30:09AM -0400, Konrad Rzeszutek Wilk wrote:
> I've posted these patches in the past, and fixed some of the issues, and I think
> there were reviewed. These five pathches are proposed for 2.6.40 to to allow the
> Xen-pciback backend module to work.

And also the blkback backend. The attached patch allows the M2P override code
to deal with grants that do not have the GNTMAP_contains_pte flag set.

The change is pretty straightforward. The difficulty is more when we unmap the
grant and we need to call m2p_remove_override and pass the flag whether to clear
the PTE or not. On the map part it was quite easy to check the: 

map_ops[i].flags & GNTMAP_contains_pte

but that is not possible on the unmap (there are no .flags parameter on the unmap
grant). For simplicity and the use cases (the backends do not use those API
calss to setup grants, instead they use the m2p_* API calls directlly) we will
return -EOPNOTSUPP for !GNTMAP_contains_pte.

In the future we could keep track of the page and whether it had !GNTMAP_contains_pte
and make the decision whether to clear the PTE or not. One way to do this is to keep
an list of pages of the pages that have GNTMAP_contains_pte flag set (or vice-versa).

