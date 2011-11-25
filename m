Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1KYVq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 16:46:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50720 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1KYVq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 16:46:56 -0500
Message-ID: <4ED00CCB.80604@gmail.com>
Date: Fri, 25 Nov 2011 16:46:51 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>, Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <gregory.dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: [PATCH v3] comedi: integer overflow in do_insnlist_ioctl()
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com> <20111123061355.GA3295@mwanda> <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com> <20111123145020.GA3258@mwanda> <4ECD1A01.3060503@mev.co.uk> <4ECD6873.7080106@metafoo.de> <20111123215111.GD3258@mwanda> <97189E06-26D8-4CF9-B325-06403FB1C42C@gmail.com> <20111125072550.GK3195@mwanda>
In-Reply-To: <20111125072550.GK3195@mwanda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in do_insnlist_ioctl() if
userspace passes in a large insnlist.n_insns.  The call to kmalloc()
would allocate a small buffer, leading to a memory corruption.

The bug was reported by Dan Carpenter <dan.carpenter@oracle.com>
and Haogang Chen <haogangchen@gmail.com>.  The patch was suggested by
Ian Abbott <abbotti@mev.co.uk> and Lars-Peter Clausen <lars@metafoo.de>.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
  drivers/staging/comedi/comedi_fops.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c 
b/drivers/staging/comedi/comedi_fops.c
index 21d8c1c..7f7d79e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -671,7 +671,7 @@ static int do_insnlist_ioctl(struct comedi_device *dev,
  	}

  	insns =
-	    kmalloc(sizeof(struct comedi_insn) * insnlist.n_insns, GFP_KERNEL);
+	    kcalloc(insnlist.n_insns, sizeof(struct comedi_insn), GFP_KERNEL);
  	if (!insns) {
  		DPRINTK("kmalloc failed\n");
  		ret = -ENOMEM;
-- 
1.7.5.4

