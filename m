Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946672Ab2ERXGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:06:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946658Ab2ERXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:06:22 -0400
Message-Id: <20120518212651.009900734@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 20/47] mtd: fix oops in dataflash driver
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Newton <will.newton@gmail.com>

commit 7a84477c4acebf6299b6a8bd6a1d5894eb838ffa upstream.

I'm seeing an oops in mtd_dataflash.c with Linux 3.3. What appears to
be happening is that otp_select_filemode calls mtd_read_fact_prot_reg
with -1 for offset and length and a NULL buffer to test if OTP
operations are supported. This finds its way down to otp_read in
mtd_dataflash.c and causes an oops when memcpying the returned data
into the NULL buf.

None of the checks in otp_read catches the negative length and offset.
Changing the length of the dummy read to 0 prevents the oops.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/mtdchar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -369,7 +369,7 @@ static int otp_select_filemode(struct mt
 	 * Make a fake call to mtd_read_fact_prot_reg() to check if OTP
 	 * operations are supported.
 	 */
-	if (mtd_read_fact_prot_reg(mtd, -1, -1, &retlen, NULL) == -EOPNOTSUPP)
+	if (mtd_read_fact_prot_reg(mtd, -1, 0, &retlen, NULL) == -EOPNOTSUPP)
 		return -EOPNOTSUPP;
 
 	switch (mode) {


