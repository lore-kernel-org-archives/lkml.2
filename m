Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab1HFAHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:07:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab1HFAH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:07:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:50 2011
Message-Id: <20110806000250.683171317@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [18/55] staging: comedi: fix infoleak to userspace
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 819cbb120eaec7e014e5abd029260db1ca8c5735 upstream.

driver_name and board_name are pointers to strings, not buffers of size
COMEDI_NAMELEN.  Copying COMEDI_NAMELEN bytes of a string containing
less than COMEDI_NAMELEN-1 bytes would leak some unrelated bytes.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/comedi_fops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -367,8 +367,8 @@ static int do_devinfo_ioctl(struct comed
 	/* fill devinfo structure */
 	devinfo.version_code = COMEDI_VERSION_CODE;
 	devinfo.n_subdevs = dev->n_subdevices;
-	memcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
-	memcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
 
 	if (read_subdev)
 		devinfo.read_subdevice = read_subdev - dev->subdevices;


