Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1KWQxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:53:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64565 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1KWQxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:53:07 -0500
Subject: [PATCH v2] comedi: integer overflow in do_insnlist_ioctl()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <4ECD1A01.3060503@mev.co.uk>
Date: Wed, 23 Nov 2011 11:53:01 -0500
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <ian.abbott@mev.co.uk>,
        Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <6414679A-65C7-46EA-A4D7-3CFC02780D28@gmail.com>
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com> <20111123061355.GA3295@mwanda> <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com> <20111123145020.GA3258@mwanda> <4ECD1A01.3060503@mev.co.uk>
To: Ian Abbott <abbotti@mev.co.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in do_insnlist_ioctl() if
userspace passes in a large insnlist.n_insns. The call to kmalloc()
would allocate a small buffer, leading to a memory corruption.

Reported-by: Haogang Chen <haogangchen@gmail.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 21d8c1c..df86a9e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -670,8 +670,9 @@ static int do_insnlist_ioctl(struct comedi_device *dev,
 		goto error;
 	}
 
-	insns =
-	    kmalloc(sizeof(struct comedi_insn) * insnlist.n_insns, GFP_KERNEL);
+	if (insnlist.n_insns <= ULONG_MAX / sizeof(struct comedi_insn))
+		insns = kmalloc(sizeof(struct comedi_insn) * insnlist.n_insns,
+				GFP_KERNEL);
 	if (!insns) {
 		DPRINTK("kmalloc failed\n");
 		ret = -ENOMEM;
-- 
1.7.5.4


