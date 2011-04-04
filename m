Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1DDXpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:45:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37659 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1DDXo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:44:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-message-flag
         :x-operating-system:x-editor:x-disclaimer:user-agent;
        b=N1YB7LLWduoGtGIcSSnQ0uuQPXBGEuGasFKP5fb9PVEBSl4ecP9Gwq4llzNTvbJ7/b
         CHxtNHVNyOpjIf41/g86qk3aDX/s3RoTcjTNCOaLEBHDCcGsAAyZesFAs42/sZsn5upQ
         r7c4t+TJkVM0ADH62mKos7y0wTn6SC3i7yvh0=
Date: Tue, 5 Apr 2011 08:44:49 +0900
From: Mattia Dongili <malattia@linux.it>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, anssi.hannula@iki.fi,
        linux-acpi@vger.kernel.org, axel.lin@gmail.com, trenn@suse.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: sony-laptop: fix early NULL pointer dereference
Message-ID: <20110404234448.GA24957@kamineko.org>
References: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com>
 <20110401172241.GA26851@srcf.ucam.org>
 <BANLkTikPjwowBge82viT+Ma5UnP0fA-pew@mail.gmail.com>
 <20110402100043.GA5890@kamineko.org>
 <BANLkTikVGWM3T1y2XvwkHB+Yub5EhG1RPA@mail.gmail.com>
 <20110402155549.GA6724@kamineko.org>
 <BANLkTimJa3CSWouTMJD5V0ZuMa67YXy88Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimJa3CSWouTMJD5V0ZuMa67YXy88Q@mail.gmail.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.39-rc1+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Mattia Dongili <malattia@linux.it>
Date:   Fri Apr 1 10:01:41 2011 +0900

    sony-laptop: fix early NULL pointer dereference
    
    The SNC acpi driver could get early notifications before it fully
    initializes and that could lead to dereferencing the sony_nc_handles
    structure pointer that is still NULL at that stage.
    Make sure we return early from the handle lookup function in these
    cases.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>
---

Hi Matthew,
if it's not too late, can you pick this one up instead of the previous
one (89ec2feafaedd759e53346d641f60863a14cfb9e)?
If it's too late I'll try and do a round of return value fixes later.

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index b2ce172..de79c18 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -810,6 +810,11 @@ static int sony_nc_handles_cleanup(struct platform_device *pd)
 static int sony_find_snc_handle(int handle)
 {
 	int i;
+
+	/* not initialized yet, return early */
+	if (!handles)
+		return -EINVAL;
+
 	for (i = 0; i < 0x10; i++) {
 		if (handles->cap[i] == handle) {
 			dprintk("found handle 0x%.4x (offset: 0x%.2x)\n",
-- 
mattia
:wq!
